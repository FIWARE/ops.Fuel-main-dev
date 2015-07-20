# OPS-Deploy

This is the code repository for the OPS-Deploy, the management and deployment tool for FIWARE Lab nodes.
This project is part of FIWARE [1]. 

OPS-Deploy is an open source deployment and management tool for OpenStack. It is based on Fuel by Mirantis [2] and it is developed within the OpenStack community. It provides a web UI thorught that a cloud administrator can intuitively deploy and manage an OpenStack environment. 

OPS-Deploy is used in FIWARE project in order to deploy a more coherent and tested installation within the FIWARE Lab  federation guaranteeing as well as a better deployment and a more manageable issues resolution.

For any feedbacks or bug reports, please use the the github issues tool.

## Overall description
OPS-Deploy is a complex software composed by a set of Puppet [3] scripts, a task orchestrator (Astute [4]) and a UI. Its goal is to provide a deployment tool for deploying a new FIWARE Lab node based on OpenStack. The tool has a double advantage: support a cloud infrastructure owner to set up a new node more quickly than a manual installation and as well building a more coherent and tested node within the FIWARE Lab federation.

### Features available
The version 2.0 of OPS-Deploy is based on the stable branch of Fuel by Mirantis version 5.1 [5]. It installs the Icehouse 2014.1.3 release of OpenStack  on Ubuntu 12.04.4.
The main features included are:
- The minimum number of controllers for highly available architecture has been eliminated.
- A number of improvements for the HA have been done (they affect Corosync, Galera, Neutron).
- The UI Fuel is now protected by access control.

Furthermore, the following FIWARE monitoring modules are installed:
- Nagios 3.5.1
- Context Broker 0.13
- NGSI Adapter 1.1.1
- Event Broker 1.3.1
- OpenStack Data Collector

The monitoring node is installed whether in Multi-Node mode or in HA mode on a separate node.

For any further information, please refer to the Fuel release plan [6].

## Installation
You can download the OPS-Deploy installer from the "Releases" tab. It is distributed as an ISO image, that can be installed  using a virtualization software package, such as VirtualBox, or on a bare-metal server.
The first option is suggested only for testing scopes, whereas the second one is suggested for production environment.
When installation is completed the system will be booted. Please pay attention to remove the installation media from the master node. Finally, by the browser you can visit the page http://10.20.0.2:8000 and log in using the admin credentials (by default they are admin/admin, whereas the default admin credentials for logging in the master node are root/r00tme. It is highly recommended to change the password after you log in (using the passwd command). 

For any further information about the installation procedure,  please refer to the Fuel User Guide [7].

### Prerequisites 

For testing scope, the suggested minimum hardware requirements are:
- Dual-core CPU
- 2+ GB RAM
- 1 gigabit network port
- HDD 80 GB with dynamic disk expansion

For a production environment, the suggested minimum hardware requirements are:
- Quad-core CPU
- 4+ GB RAM
- 1 gigabit network port
- HDD 256+ GB

### Network setup
On the OPS-Deploy node (also named master node), the eth0 network interface is configured to reply to PXE requests. The default network is 10.20.0.2/24 and the gateway 10.20.0.1.

### Checking status

In order to verify the correct installation of the ITBox, the user can use the following command:
fuel --os-username admin --os-password admin release

The answer should be as follows:

id | name                       | state     | operating_system | version
---|----------------------------|-----------|------------------|-------------
1  | Icehouse on CentOS 6.5     | available | CentOS           | 2014.1.1-5.1
2  | Icehouse on Ubuntu 12.04.4 | available | Ubuntu           | 2014.1.1-5.1


## Known issues
### OPS-Deploy requires a pingable default gateway in order to deploy
OPS-Deploy must be able to ping the default gateway in order to deploy the environment. If your configuration does not
include a pingable default gateway, you can work around it by specifying the Fuel Master node (or any other
pingable host) as the default gateway.
Alternatively, you can apply  [Patch 138448](https://review.openstack.org/#/c/138448) to disable the requirement to ping the default gateway. After applying this patch, you need to enable it with following sequence of steps [6].

## User manual
## License
Apache License, Version 2.0, January 2004


[1] FIWARE: http://www.fiware.org/

[2] Fuel by Mirantis: http://fuel.mirantis.com/

[3] Puppet: https://puppetlabs.com/

[4] Astute: https://docs.fuel-infra.org/fuel-dev/develop/env.html#astute

[5] Fuel by Mirantis 5.1: https://docs.mirantis.com/openstack/fuel/fuel-5.1/

[6] Fuel 5.1.1 release notes: https://docs.mirantis.com/openstack/fuel/fuel-5.1/release-notes.html#release-notes

[7] Fuel 5.1.1 User guide: https://docs.mirantis.com/openstack/fuel/fuel-5.1/user-guide.html

