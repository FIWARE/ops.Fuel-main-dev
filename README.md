# OPS-Deploy

This is the code repository for the OPS-Deploy, the management and
deployment tool for FIWARE Lab nodes.

This project is part of [FIWARE] [1].

OPS-Deploy is an open source project, based on Fuel by Mirantis[2]
and closely developed to the OpenStack community. It provides a web UI
through that a cloud administrator can intuitively deploy and manage
an OpenStack environment.

OPS-Deploy is used in FIWARE project in order to deploy a more
coherent and tested installation within the FIWARE Lab federation
guaranteeing as well as a better deployment and a more manageable
issues resolution.

For any feedbacks or bug reports, please use the the github issues
tool.

## Description

OPS-Deploy is a complex software composed by a set of Puppet[3]
scripts, a task orchestrator (Nailgun[4]), a task executor (Astute[5])
and a UI. Its goal is to provide a user friendly tool for deploying a
new FIWARE Lab node based on OpenStack. The tool has a double
advantage: support a cloud infrastructure owner to set up a new node
more quickly than a manual installation and as well as building a more
coherent and tested node within the FIWARE Lab federation.  As said
previously, OPS-Deploy is based on Fuel by Mirantis and obviously its
architecture reflects the original structure. An high level
architecture diagram is provided below. For any detailed information,
please refer to the [Fuel official documentation][6].

![OPD-Deploy Architecture](https://github.com/SmartInfrastructures/fuel-main-dev/blob/si/4.0/doc/source/_static/OPS-Deploy_Architecture_3.0.jpg)

In OPS-Deploy several third-party components like Cobbler, Puppet,
Mcollective live together to Fuel specific components (e.g. Astute)
and FIWARE’s elements (e.g. monitoring GEs ).  The original project
has required some customizations or enhancements as adapt the GUI to
FIWARE style guide or create the UI elements for enabling the
monitoring components installation as well as to develop the
installation scripts for each FIWARE component integrated.

Starting with release 3.0, OPS-Deploy supports a pluggable
architecture, inherited solution from Fuel version 6.1. It enables
users to install and configure additional capabilities for their
environments in a flexible, repeatable and reliable manner. According
to this new architecture approach, all the components previously
developed, have been re-developed as a plugin.

A plugin is composed by:

- deployment_script directory: it contains a set of bash or puppet
  scripts;
- environment_config.yaml: through it, can be defined the plugin UI
  fields. They will be shown into OPS-Deploy web UI (settings tab);
- metadata.yaml: it contains name, version and compatibility
  definition for the plugin;
- repositories directory: it contains the list of CentOS and Ubuntu
  public repositories;
- task.yaml: it specifies when, where and how to run the installation
  scripts.

As shown in the Architecture diagram, through the Plugin framework,
the plugin is integrated into UI and it is activated by
Nailgun. Furthermore, properly setting the task.yaml file, it is
possible to coordinate the workflow of concurrent plugin
installations.

Finally, in this release each plugin can only be installed before
configuring and deploying the environment. Otherwise, the users should
redeploy the environment to enable the plugin.

In the same manner of the relase 2.x, the users are able to interact
with OPS-Deploy using both GUI and CLI. They interact with Nailgun
which implements REST API as well as deployment data management. It
manages disk volumes configuration data, networks configuration data
and any other environment specific data which are needed for finalize
a deployment. Astute can be viewed as composed by Nailgun's
workers. Each of them runs certain actions according to the
instructions provided from Nailgun. Nailgun uses SQL database to store
its data and AMQP service to interact with workers whereas Cobbler is
used as operating system provisioning service and DHCP service
provider.

Finally, Puppet is the deployment service and through MCollective
agents are performed specific tasks like hard drives clearing, network
connectivity probing on the discovered nodes.

## Features Implemented

The version 4.0 of OPS-Deploy is based on the stable branch of
[Fuel by Mirantis version 7.0][7]. It installs OpenStack Kilo release
2015.1.0-7.0 on Ubuntu 14.04.

The previous monitoring components are now installed by plugins.
Currently are available the following plugins:

- [Calamari](https://github.com/SmartInfrastructures/fuel-plugin-calamari)
- [Nova-Docker](https://github.com/SmartInfrastructures/fuel-plugin-novadocker)
- [Openstack Data Collector](https://github.com/SmartInfrastructures/fuel-plugin-openstack-data-collector)
- [NGSI Adapter 1.1.1](https://github.com/SmartInfrastructures/fuel-plugin-ngsi-adapter)
- [Context Broker 0.13](https://github.com/SmartInfrastructures/fuel-plugin-context-broker)

For any further information, please refer to the Fuel release plan [8].

## Installation Manual 

The installation process is the same of the previous releases. The
OPS-Deploy installer is available at
[github page](https://github.com/SmartInfrastructures/fuel-main-dev/releases). It
is distributed as an ISO image, that can be installed using a
virtualization software package, such as VirtualBox, or on a
bare-metal server.  The first option is suggested only for testing
scopes, whereas the second one is suggested for production
environment.  When installation is completed the system will be
booted. Please pay attention to remove the installation media from the
master node. Finally, by the browser you can visit the page
<http://10.20.0.2:8000> and log in using the admin credentials (by
default they are admin/admin), whereas the default admin credentials
for logging in the master node are root/r00tme. It is highly
recommended to change the password after you log in (using the passwd
command).

For any further information about the installation procedure, please
refer to the [Fuel User Guide][9].

### Prerequisites 

For testing scope, the suggested minimum hardware requirements are:

- Dual-core CPU
- 4+ GB RAM
- 1 gigabit network port
- HDD 80 GB with dynamic disk expansion

For a production environment, the suggested minimum hardware requirements are:

- Quad-core CPU
- 8+ GB RAM
- 1 gigabit network port
- HDD 512+ GB

### Network setup

On the OPS-Deploy node (also named master node), the eth0 network
interface is configured to reply to PXE requests. The default network
is 10.20.0.2/24 and the gateway 10.20.0.1.  After the OPS-Deploy
Master Node is installed and booted, the user can power on all slave
nodes (where the user is going to install OpenStack). First of all,
ensure that slave nodes are physically installed in the same network
as the Master. After that, the user can boot each node in PXE boot
mode (the user should enable it, modifying the BIOS boot order).

Each node sends out DHCP discovery requests and gets the response from
the OPS-Deploy node that runs the DHCP server (provided by Cobbler).

When a node receives the response from the OPS-Deploy node, it fetches
the pxelinux bootloader and then the bootstrap image (CentOS based
Linux in memory) from the OPS-Deploy node's TFTP server and boots into
it.

When this image is loaded, it reports the node's readiness and
configuration to the master node. This could take a few minutes.

## Installation Verification 

In order to verify the correct installation of the OPS-Deploy, the
user can use the following command: *fuel release*

The answer should be as follows:

    id | name                 | state       | operating_system |  version
    ---|----------------------|-------------|------------------|-------------
    2  | Kilo on Ubuntu 14.04 | available   | Ubuntu           | 2015.1.0-7.0
    1  | Kilo on CentOS 6.5   | unavailable | CentOS           | 2015.1.0-7.0


## User manual

The user manual is available in the doc folder at
<https://github.com/SmartInfrastructures/fuel-main-dev/tree/si/4.0/doc>.

## API Documentation

Not applicable in this case.

## Known issues

OPS-Deploy inherits some issues from Fuel 7.0. See, the fuel resolved
and known issues:

<https://docs.mirantis.com/openstack/fuel/fuel-7.0/release-notes.html#fuel-resolved-and-known-issues>

## License

Apache License, Version 2.0, January 2004


[1]: <http://www.fiware.org/> "FIWARE"

[2]: <http//fuel.mirantis.com/> "Fuel by Mirantis"

[3]: <https//puppetlabs.com/> "Puppet"

[4]: <https//docs.fuel-infra.org/fuel-dev/develop/env.html#nailgun> "Nailgun"

[5]: <https//docs.fuel-infra.org/fuel-dev/develop/env.html#astute> "Astute"

[6]: <https//docs.fuel-infra.org/fuel-dev/develop/architecture.html> "Fuel Architecture"

[7]: <https//docs.mirantis.com/openstack/fuel/fuel-7.0/> "Fuel by Mirantis 7.0"

[8]: <https//docs.mirantis.com/openstack/fuel/fuel-7.0/release-notes.html#release-notes> "Fuel 7.0 release notes"

[9]: <https//docs.mirantis.com/openstack/fuel/fuel-7.0/release-notes.html#release-notes> "Fuel 7.0 User guide"
