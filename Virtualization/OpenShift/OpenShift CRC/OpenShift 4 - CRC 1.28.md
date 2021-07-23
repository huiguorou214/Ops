# OpenShift 4 - CRC（Codeready Container）1.28

> 本章主要介绍如何在RHEL7上面部署一个单节点OpenShift 4
>
> This guide shows how to get up to speed using CodeReady Containers. Included instructions and examples guide through first steps developing containerized applications using Red Hat OpenShift Container Platform 4 from a host workstation (Microsoft Windows, macOS, or Red Hat Enterprise Linux).



## Author

```
Name: Shinefire
Blog: https://github.com/shine-fire/Ops_Notes
E-mail: shine_fire@outlook.com
```



## Installation

### 安装要求

#### 硬件要求

- 4 physical CPU cores
- 9 GB of free memory
- 35 GB of storage space



#### 操作系统要求

- On Linux, CodeReady Containers is only supported on Red Hat Enterprise Linux/CentOS 7.5 or newer (including 8.x versions) and on the latest two stable Fedora releases.
- When using Red Hat Enterprise Linux, the machine running CodeReady Containers must be [registered with the Red Hat Customer Portal](https://access.redhat.com/solutions/253273).
- Ubuntu 18.04 LTS or newer and Debian 10 or newer are not officially supported and may require manual set up of the host machine.
- See [Required software packages](https://access.redhat.com/documentation/en-us/red_hat_codeready_containers/1.28/html-single/getting_started_guide/#required-software-packages_gsg) to install the required packages for your Linux distribution.



### 基础环境准备

#### DNS服务器准备

因为安装crc启动openshift之后，会需要借助dns解析来连接进去，如果无法成功解析的话，会导致后面失败



#### HAProxy准备

HAProxy的主要目的是为了在安装好crc之后，在win中直接通过浏览器访问宿主机时做个跳转直接访问到crc虚拟机提供的console里面去。



### Install CodeReady Containers

对于crc的运行，官方是说要使用非root用户来运行的，所以我是使用了apt用户来运行这个crc。

1. Download the [latest release of CodeReady Containers](https://cloud.redhat.com/openshift/create/local) for your platform.

2. 解压下载的压缩包

   ```bash
   # mkdir -p /root/Downloads/ocp4_single
   # cd /root/Downloads/ocp4_single
   # tar xvf crc-linux-amd64.tar.xz
   ```

3. 添加环境变量
   添加环境变量的方法有两种，一种是直接把解压后的bin文件所在目录添加到`PATH`中，另外一种是直接把bin文件移动到当前的环境变量路径中，我这里使用的是后面一种方法：

   ```bash
   # cp crc-linux-1.28.0-amd64/crc /usr/local/bin/
   ```

4. Setting up CodeReady Containers
   会自动做一些运行前的配置，交互式直接yes确认就行了，上面的步骤我用root用户准备好环境之后，这里开始改用apt用户来进行配置了

   ```bash
   $ crc setup
   ```

5. Starting the virtual machine

   运行启动命令后，需要交互式的输入你在红帽的`pull secret`，因为虚拟机会自动联网在官方去下载一些启动openshift需要的资源，然后等个十来分钟即可。

   在启动完毕之后，会列出集群环境登录地址与的登录用户信息等。

   ```bash
   $ crc start
   INFO Checking if running as non-root
   INFO Checking if running inside WSL2
   INFO Checking if crc-admin-helper executable is cached
   INFO Checking for obsolete admin-helper executable
   INFO Checking if running on a supported CPU architecture
   INFO Checking minimum RAM requirements
   INFO Checking if Virtualization is enabled
   INFO Checking if KVM is enabled
   INFO Checking if libvirt is installed
   INFO Checking if user is part of libvirt group
   INFO Checking if active user/process is currently part of the libvirt group
   INFO Checking if libvirt daemon is running
   INFO Checking if a supported libvirt version is installed
   INFO Checking if crc-driver-libvirt is installed
   INFO Checking if systemd-networkd is running
   INFO Checking if NetworkManager is installed
   INFO Checking if NetworkManager service is running
   INFO Checking if /etc/NetworkManager/conf.d/crc-nm-dnsmasq.conf exists
   INFO Checking if /etc/NetworkManager/dnsmasq.d/crc.conf exists
   INFO Checking if libvirt 'crc' network is available
   INFO Checking if libvirt 'crc' network is active
   CodeReady Containers requires a pull secret to download content from Red Hat.
   You can copy it from the Pull Secret section of https://cloud.redhat.com/openshift/create/local.
   ? Please enter the pull secret ***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
   ...
   INFO Adding crc-admin and crc-developer contexts to kubeconfig...
   Started the OpenShift cluster.
   
   The server is accessible via web console at:
     https://console-openshift-console.apps-crc.testing
   
   Log in as administrator:
     Username: kubeadmin
     Password: 4cTvq-uC5yR-Z7cFG-6uwc2
   
   Log in as user:
     Username: developer
     Password: developer
   
   Use the 'oc' command line interface:
     $ eval $(crc oc-env)
     $ oc login -u developer https://api.crc.testing:6443
   [apt@nuc ~]$ oc login -u kubeadmin https://api.crc.testing:6443
   Logged into "https://api.crc.testing:6443" as "kubeadmin" using existing credentials.
   
   You have access to 61 projects, the list has been suppressed. You can list all projects with 'oc projects'
   
   Using project "default".
   ```

6. 安装完毕





## 连接OpenShift

### CLI登录到OpenShift

命令行登录

```bash
[apt@nuc ~]$ oc login -u kubeadmin https://api.crc.testing:6443
Logged into "https://api.crc.testing:6443" as "kubeadmin" using existing credentials.

You have access to 61 projects, the list has been suppressed. You can list all projects with 'oc projects'

Using project "default".
```

### Web界面登录OpenShift

宿主机上可以直接使用firefox来访问`https://console-openshift-console.apps-crc.testing`即可



### 登录到运行的crc虚拟机

运行CRC的虚拟机IP地址统一是192.168.130.11，我们可以用虚拟机对应的私钥登录这个虚拟机，虚拟机对应的私钥在安装的时候会自动生成在用户家目录的.crc里面。

```bash
[apt@nuc ~]$ ssh -i .crc/machines/crc/id_ecdsa core@192.168.130.11
Red Hat Enterprise Linux CoreOS 47.83.202105220305-0
  Part of OpenShift 4.7, RHCOS is a Kubernetes native operating system
  managed by the Machine Config Operator (`clusteroperator/machine-config`).

WARNING: Direct SSH access to machines is not recommended; instead,
make configuration changes via `machineconfig` objects:
  https://docs.openshift.com/container-platform/4.7/architecture/architecture-rhcos.html

---
[core@crc-pkjt4-master-0 ~]$
```

提示：登录成功后，有提示说不推荐直接使用ssh的方式来进行连接，而是给了一个参考的方法通过配置`machineconfig`来进行的，这个后续视情况补充。



## 如何保存crc数据

Q：

crc理论上是个一次性使用的虚拟机，使用`crc delete`命令删掉kvm虚拟机之后，数据就伴随机器一起被删掉了，那么官方有不有提供什么想要长期使用的解决方案呢？

A：

（待补充）





## Troubleshooting

Q1：

```bash
[apt@nuc ~]$ crc start
...
INFO Updating authorized keys...
INFO Check internal and public DNS query...
INFO Check DNS query from host...
WARN foo.apps-crc.testing resolved to [3.223.115.185] but 192.168.130.11 was expected
Failed to query DNS from host: Invalid IP for foo.apps-crc.testing
```

A1：

原因是因为DNS解析失败了，无法解析到foo.apps-crc.testing到本地的这个`192.168.130.11`虚拟机去，而是解析到了外网的机器，所以不符合预期导致了失败。

检查了一下官方文档中提到的`/etc/hosts`文件和`/etc/NetworkManager/dnsmasq.d/crc.conf`文件中，也是符合预期的自动添加了解析条目的，但是实际上并不能符合预期的完成解析功能，另外这个`/etc/NetworkManager/dnsmasq.d/crc.conf`的具体应用我也是第一次见，暂时也不深究了

因为我宿主机中本身是有部署一个dnsmasq的，所以我就直接在dnsmasq中增加了这个解析条目，最终解决了这个问题

```bash
[root@nuc ~]# tail -n 3 /etc/dnsmasq.d/myhome.conf
# openshift crc
server=/crc.testing/192.168.130.11
server=/apps-crc.testing/192.168.130.11
```



## References

- https://access.redhat.com/documentation/en-us/red_hat_codeready_containers/1.28/html/getting_started_guide/index















