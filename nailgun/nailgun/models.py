import ipaddr
import celery
import importlib
from django.db import models
from django.contrib.auth.models import User
from django.core.exceptions import ObjectDoesNotExist
from jsonfield import JSONField
from api.fields import RecipeField


class Attribute(models.Model):
    cookbook = models.CharField(max_length=100)
    version = models.CharField(max_length=30)
    attribute = JSONField()


class Recipe(models.Model):
    recipe = RecipeField(max_length=100)
    attribute = models.ForeignKey(Attribute, null=True, blank=True)
    depends = models.ManyToManyField("Recipe",
        related_name="recipe_deps",
    )


class Role(models.Model):
    name = models.CharField(max_length=50)
    recipes = models.ManyToManyField(Recipe, related_name="roles")


class Release(models.Model):
    name = models.CharField(max_length=100)
    version = models.CharField(max_length=30)
    description = models.TextField(null=True, blank=True)
    networks_metadata = JSONField()
    roles = models.ManyToManyField(Role, related_name='releases')

    class Meta:
        unique_together = ("name", "version")


class Task(models.Model):
    id = models.CharField(max_length=36, primary_key=True)
    cluster = models.OneToOneField('Cluster', related_name='+')
    task_name = models.CharField(max_length=100)

    def _get_celery_task(self):
        tasks = importlib.import_module('nailgun.tasks')
        return getattr(tasks, self.task_name)

    @property
    def name(self):
        return self._get_celery_task().name

    def run(self, *args):
        task_result = self._get_celery_task().delay(*args)
        self.id = task_result.task_id
        self.save()
        return task_result

    @property
    def celery_task_result(self):
        return celery.result.AsyncResult(self.id)

    def _flatten_celery_subtasks(self, task=None):
        if task is None:
            task = self.celery_task_result
        result = [task]
        if isinstance(task.result, celery.result.ResultSet):
            result += reduce(list.__add__, \
                map(self._flatten_celery_subtasks, task.result.results))
        elif isinstance(task.result, celery.result.AsyncResult):
            result += self._flatten_celery_subtasks(task.result)
        return result

    @property
    def ready(self):
        tasks = self._flatten_celery_subtasks()
        return all(map(lambda t: t.ready(), tasks))

    @property
    def errors(self):
        tasks = self._flatten_celery_subtasks()
        errors = []
        for task in tasks:
            if isinstance(task.result, Exception):
                errors.append(task.result)
        return errors


class Cluster(models.Model):
    name = models.CharField(max_length=100)
    release = models.ForeignKey(Release, related_name='clusters')

    # working around Django issue #10227
    @property
    def task(self):
        try:
            return Task.objects.get(cluster=self)
        except ObjectDoesNotExist:
            return None


class Node(models.Model):
    NODE_STATUSES = (
        ('offline', 'offline'),
        ('ready', 'ready'),
        ('deploying', 'deploying'),
        ('error', 'error'),
    )
    id = models.CharField(max_length=12, primary_key=True)
    cluster = models.ForeignKey(Cluster, related_name='nodes',
        null=True, blank=True, on_delete=models.SET_NULL)
    name = models.CharField(max_length=100, blank=True)
    status = models.CharField(max_length=30, choices=NODE_STATUSES,
            default='online')
    metadata = JSONField()
    node_attrs = JSONField()
    mac = models.CharField(max_length=17)
    ip = models.CharField(max_length=15)
    fqdn = models.CharField(max_length=255)
    manufacturer = models.CharField(max_length=50, blank=True)
    platform_name = models.CharField(max_length=150, blank=True)

    roles = models.ManyToManyField(Role, related_name='nodes')
    new_roles = models.ManyToManyField(Role, related_name='+')
    redeployment_needed = models.BooleanField(default=False)


class IPAddr(models.Model):
    network = models.ForeignKey('Network')
    node = models.ForeignKey(Node)
    ip_addr = models.CharField(max_length=25)


class Network(models.Model):
    release = models.ForeignKey(Release, related_name="networks")
    name = models.CharField(max_length=20)
    access = models.CharField(max_length=20)
    vlan_id = models.PositiveIntegerField()
    network = models.CharField(max_length=25)
    range_l = models.CharField(max_length=25)
    range_h = models.CharField(max_length=25)
    gateway = models.CharField(max_length=25)
    nodes = models.ManyToManyField(Node, through=IPAddr, null=True, blank=True)

    @property
    def netmask(self):
        return str(ipaddr.IPv4Network(self.network).netmask)

    @property
    def broadcast(self):
        return str(ipaddr.IPv4Network(self.network).broadcast)

    def update_node_network_info(self, node):
        nw = ipaddr.IPv4Network(self.network)
        range_l = ipaddr.IPv4Address(self.range_l)
        range_h = ipaddr.IPv4Address(self.range_h)
        new_ip = None
        for host in nw.iterhosts():
            if range_l <= ipaddr.IPv4Address(host) <= range_h:
                try:
                    IPAddr.objects.get(network=self, ip_addr=host)
                except IPAddr.DoesNotExist:
                    new_ip = host
                    break

        if not new_ip:
            raise Exception("There is no free IP for node %s" % node.id)

        new_ip_obj = IPAddr(network=self, ip_addr=new_ip, node=node)
        new_ip_obj.save()

        if not "networks" in node.metadata:
            node.metadata["networks"] = {}

        # FIXME: populate real value
        if 'default_interface' in node.metadata['interfaces']:
            device = node.metadata['interfaces']['default_interface']
        else:
            device = 'eth0'

        node.metadata["networks"][self.name] = {
            "access": self.access,
            "device": device,
            "vlan_id": self.vlan_id,
            "address": str(new_ip),
            "netmask": self.netmask,
            # FIXME: do we need those?
            # "broascast": self.broadcast,
            # "gateway": self.gateway,
        }

        node.save()
