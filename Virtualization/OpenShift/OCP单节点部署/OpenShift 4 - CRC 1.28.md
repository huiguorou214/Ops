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



## Introduction





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







### 登录到crc





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



## References

- https://access.redhat.com/documentation/en-us/red_hat_codeready_containers/1.28/html/getting_started_guide/index















