#!/bin/sh

puppet apply /var/tmp/install.pp

# NOTE: to force the binding on tcp4 see
# https://tickets.puppetlabs.com/browse/PDB-180
# -Djava.net.preferIPv4Stack=true

sudo -u puppetdb /usr/lib/jvm/java-7-openjdk-amd64/bin/java -XX:OnOutOfMemoryError="kill -9 %p" -Xmx192m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/log/puppetdb/puppetdb-oom.hprof -Djava.net.preferIPv4Stack=true -Djava.security.egd=file:/dev/urandom -cp /usr/share/puppetdb/puppetdb.jar clojure.main -m com.puppetlabs.puppetdb.core services -c /etc/puppetdb/conf.d
