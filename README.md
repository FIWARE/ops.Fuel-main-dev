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
•	The minimum number of controllers for highly available architecture has been eliminated.
•	A number of improvements for the HA have been done (they affect Corosync, Galera, Neutron).
•	The UI Fuel is now protected by access control.

Furthermore, the following FIWARE monitoring modules are installed:
•	Nagios 3.5.1
•	Context Broker 0.13
•	NGSI Adapter 1.1.1
•	Event Broker 1.3.1
•	OpenStack Data Collector
The monitoring node is installed whether in Multi-Node mode or in HA mode on a separate node.

For any further information, please refer to the Fuel release plan [6].
## Download and install OPS-Deploy
### Prerequisites 
### Network setup
### Upgrading from a previous version
### Checking status

## Known issues
## User manual
## License
Apache License, Version 2.0, January 2004


[1] FIWARE: http://www.fiware.org/

[2] Fuel by Mirantis: http://fuel.mirantis.com/

[3] Puppet: https://puppetlabs.com/

[4] Astute: https://docs.fuel-infra.org/fuel-dev/develop/env.html#astute

[5] Fuel by Mirantis 5.1: https://docs.mirantis.com/openstack/fuel/fuel-5.1/

[6] Fuel 5.1.1 release notes: https://docs.mirantis.com/openstack/fuel/fuel-5.1/release-notes.html#release-notes
