User Guide
==========
- Intro
When the user has completed the master node installation, he can access ITBox UI, visiting the default url http://10.20.0.2:8000/ and after inserting the credentials (default: admin/admin) the screen appears like in Fig. 1.

.. image:: _static/OPS-Deploy-1.png
     :alt: OPS-Deploy homepage
     :scale: 90%
     
The user sets bare-metal servers to boot from network via PXE and power them on. They will start automatically with a bootstrap operating system, based on Centos. The ITBox will notify discovered nodes on ITBox UI (see Fig. 3 in the upper right corner). At this moment, the user could create a new environment.

.. image:: _static/OPS-Deploy-2.png
     :alt: Creation of a new environment
     :scale: 90%
     
The first step that involves the user is the “New Openstack Environment” creation (Fig. 4), where the user inserts such basic information about the environment as name, operating system, deployment mode (multi-node or multi-node with High Availability), hypervisor and network manager (Nova-Network, Neutron with GRE, Neutron with VLAN).

Now the environment is ready for deployment (Fig. 3).

.. image:: _static/OPS-Deploy-3.png
     :alt: The page of the created environment
     :scale: 90%
     
  In environment creation process the user should define the architecture of his cloud infrastructure. The user assigns the role to every server, configures the network, defines the space allocated to hard disks and settings other Openstack options (Fig.64).
  
.. image:: _static/OPS-Deploy-4.png
     :alt: The page of the created environment
     :scale: 90%
     
- Giving roles to servers

In “Nodes” tab, the user can view the state of his environment, where the nodes are ordered by Roles. Thus, the user can view the node's details and configure them appropriately.
By clicking on “Add Nodes” button, the ITBox shows users the list of available roles and the list of unallocated nodes. After selecting a role, other incompatible roles are automatically disabled. For example, a controller node cannot be together with a compute node simultaneously, and so on.
Finally the user applies changes (Fig. 5).     

.. image:: _static/OPS-Deploy-5.png
     :alt: The page of the created environment
     :scale: 90%

