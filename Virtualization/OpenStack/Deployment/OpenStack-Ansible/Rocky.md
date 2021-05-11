# OpenStack-Ansible Rocky

> 本章主要介绍如何使用OpenStack-Ansible来部署 OpenStack Rocky 版本。

## Author

```
Name:Shinefire
Blog:https://github.com/shine-fire/Ops_Notes
E-mail:shine_fire@outlook.com
```

## Introduction

> OpenStack-Ansible provides Ansible playbooks and roles for the deployment and configuration of an OpenStack environment.
>
> OpenStack-Ansible’s Rocky series was first released with the 18.0.0 tag on 16 October 2018.

## Machines Planning





## OpenStack-Ansible Deployment Guide

### Prepare the deployment host

#### Configuring the operating system

1. Upgrade the system packages and kernel

   ```bash
   # yum upgrade
   ```

2. Reboot the host.

3. Install additional software packages if they were not installed during the operating system installation:

   ```bash
   # yum install https://rdoproject.org/repos/openstack-rocky/rdo-release-rocky.rpm
   # yum install git ntp ntpdate openssh-server python-devel sudo '@Development Tools'
   ```

4. Configure NTP to synchronize with a suitable time source

5. The `firewalld` service is enabled on most CentOS systems by default and its default ruleset prevents OpenStack components from communicating properly. Stop the `firewalld` service and mask it to prevent it from starting:

   ```bash
   # systemctl stop firewalld
   # systemctl disable firewalld
   ```

#### Configure SSH keys

Ansible uses SSH with public key authentication to connect the deployment host and target hosts. To reduce user interaction during Ansible operations, do not include passphrases with key pairs. However, if a passphrase is required, consider using the `ssh-agent` and `ssh-add` commands to temporarily store the passphrase before performing Ansible operations.

(generate ssh key pairs .)?

#### Configure the network

#### Install the source and dependencies

1. Clone the latest stable release of the OpenStack-Ansible Git repository in the `/opt/openstack-ansible` directory:

   ```bash
   # git clone -b 18.1.9 https://git.openstack.org/openstack/openstack-ansible /opt/openstack-ansible
   ```

   If git.openstack.org can not be accessed to run git clone, github.com can be used as an alternative repo:

   ```bash
   # git clone -b 18.1.9 https://github.com/openstack/openstack-ansible.git /opt/openstack-ansible
   ```

2. Change to the `/opt/openstack-ansible` directory, and run the Ansible bootstrap script:

   ```bash
   # scripts/bootstrap-ansible.sh
   ```




### Prepare the target hosts

#### Configuring the operating system

1. Upgrade the system packages and kernel:

   ```bash
   # yum upgrade
   ```

2. Disable SELinux. Edit `/etc/sysconfig/selinux`, make sure that `SELINUX=enforcing` is changed to `SELINUX=disabled`.

3. Reboot the host.

4. Ensure that the kernel version is `3.10` or later

5. Install additional software packages:

   ```bash
   # yum install bridge-utils iputils lsof lvm2 chrony openssh-server sudo tcpdump python
   ```

6. Add the appropriate kernel modules to the `/etc/modules-load.d` file to enable VLAN and bond interfaces:

   ```bash
   # echo 'bonding' >> /etc/modules-load.d/openstack-ansible.conf
   # echo '8021q' >> /etc/modules-load.d/openstack-ansible.conf
   ```

7. Configure Network Time Protocol (NTP) in `/etc/chrony.conf` to synchronize with a suitable time source and start the service

   ```bash
   # systemctl enable chronyd.service
   # systemctl start chronyd.service
   ```

8. (Optional) Reduce the kernel log level by changing the printk value in your sysctls:

   ```bash
   # echo "kernel.printk='4 1 7 4'" >> /etc/sysctl.conf
   ```

9. Reboot the host to activate the changes and use the new kernel

#### Configure SSH keys

Ansible uses SSH to connect the deployment host and target hosts.

1. Copy the contents of the public key file on the deployment host to the `/root/.ssh/authorized_keys` file on each target host.
2. Test public key authentication from the deployment host to each target host by using SSH to connect to the target host from the deployment host. If you can connect and get the shell without authenticating, it is working. SSH provides a shell without asking for a password.

#### Configuring the storage

[Logical Volume Manager (LVM)](https://en.wikipedia.org/wiki/Logical_Volume_Manager_(Linux)) enables a single device to be split into multiple logical volumes that appear as a physical storage device to the operating system. The Block Storage (cinder) service, and LXC containers that optionally run the OpenStack infrastructure, can optionally use LVM for their data storage.

1. To use the optional Block Storage (cinder) service, create an LVM volume group named `cinder-volumes` on the storage host. Specify a metadata size of 2048 when creating the physical volume. For example:

   ```bash
   # pvcreate --metadatasize 2048 physical_volume_device_path
   # vgcreate cinder-volumes physical_volume_device_path
   ```

2. Optionally, create an LVM volume group named `lxc` for container file systems if you want to use LXC with LVM. If the `lxc` volume group does not exist, containers are automatically installed on the file system under `/var/lib/lxc` by default.

#### Configuring the network



### Configure the deployment

Ansible references some files that contain mandatory and optional configuration directives. Before you can run the Ansible playbooks, modify these files to define the target environment. Configuration tasks include:

- Target host networking to define bridge interfaces and networks.
- A list of target hosts on which to install the software.
- Virtual and physical network relationships for OpenStack Networking (neutron).
- Passwords for all services.

#### Initial environment configuration

OpenStack-Ansible (OSA) depends on various files that are used to build an inventory for Ansible. Perform the following configuration on the deployment host.

1. Copy the contents of the `/opt/openstack-ansible/etc/openstack_deploy` directory to the `/etc/openstack_deploy` directory.

2. Change to the `/etc/openstack_deploy` directory.

3. Copy the `openstack_user_config.yml.example` file to `/etc/openstack_deploy/openstack_user_config.yml`.

4. Review the `openstack_user_config.yml` file and make changes to the deployment of your OpenStack environment.

   > This file is heavily commented with details about the various options. See our [User Guide](http://docs.openstack.org/openstack-ansible/rocky/user/index.html) and [Reference Guide](http://docs.openstack.org/openstack-ansible/rocky/reference/index.html) for more details.

5. Review the `user_variables.yml` file to configure global and role specific deployment options. The file contains some example variables and comments but you can get the full list of variables in each role’s specific documentation.

   > One imporant variable is the `install_method` which configures the installation method for the OpenStack services. The services can either be deployed from source (default) or from distribution packages. Source based deployments are closer to a vanilla OpenStack installation and allow for more tweaking and customizations. On the other hand, distro based deployments generally provide a package combination which has been verified by the distributions themselves. However, this means that updates are being released less often and with a potential delay. Moreover, this method might offer fewer opportunities for deployment customizations. The `install_method` variable is set during the initial deployment and you **must not** change it as OpenStack-Ansible is not able to convert itself from one installation method to the other. As such, it’s important to judge your needs against the pros and cons of each method before making a decision. Please note that the `distro` installation method was introduced during the Rocky cycle, and as a result of which, Ubuntu 16.04 is not supported due to the fact that there are no Rocky packages for it.

   The configuration in the `openstack_user_config.yml` file defines which hosts run the containers and services deployed by OpenStack-Ansible. For example, hosts listed in the `shared-infra_hosts` section run containers for many of the shared services that your OpenStack environment requires. Some of these services include databases, Memcached, and RabbitMQ. Several other host types contain other types of containers, and all of these are listed in the `openstack_user_config.yml` file.

   Some services, such as glance, heat, horizon and nova-infra, are not listed individually in the example file as they are contained in the os-infra hosts. You can specify image-hosts or dashboard-hosts if you want to scale out in a specific manner.

   For examples, please see our [User Guides](http://docs.openstack.org/openstack-ansible/rocky/user/index.html)

   For details about how the inventory is generated, from the environment configuration and the variable precedence, see our [Reference Guide](http://docs.openstack.org/openstack-ansible/rocky/reference/index.html) under the inventory section.



## OpenStack-Ansible Operations Guide

## OpenStack-Ansible User Guide

## OpenStack-Ansible Developer Documentation

## OpenStack-Ansible OpenStack-Ansible Reference



## References

- OpenStack-Ansible Deployment Guide https://docs.openstack.org/project-deploy-guide/openstack-ansible/rocky/