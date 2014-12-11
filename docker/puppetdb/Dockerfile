# TODO: run with -p58533:58533 to expose the port
#docker run -P -h fuel.domain.tld ptest

# TODO: separate nginx to a proper container
# TODO: setup a volume/data contanier
# http://juggernaut.github.io/docker/nginx/python/2014/12/07/docker-nginx-flask.html
# TODO: https://docs.docker.com/userguide/dockerlinks/
# docker run --name nginx-flask --link flaskapp:flaskapp -v -d -p 8080:80 nginx-flask

FROM ubuntu:precise

MAINTAINER Daniele Pizzolli daniele.pizzolli@create-net.org

VOLUME /var/lib/postgresql

VOLUME /usr/share/puppetdb/db/

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 4BD6EC30

RUN printf "deb http://apt.puppetlabs.com/ precise main\ndeb-src http://apt.puppetlabs.com/ precise main" > /etc/apt/sources.list.d/puppet.list

RUN apt-get update

RUN apt-get install --yes ca-certificates puppet sudo iptables

RUN puppet module install puppetlabs/puppetdb

RUN puppet module install jfryman-nginx

RUN puppet module install camptocamp/openssl

ADD install.pp /var/tmp/install.pp

ADD run.sh /var/tmp/run.sh
RUN chmod 750 /var/tmp/run.sh

EXPOSE 58080
EXPOSE 58443

# Let's see:

RUN puppet apply /var/tmp/install.pp

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

CMD /var/tmp/run.sh

