# Red Hat Enterprise Linux 8.0 新特性

> 本章节主要介绍了Red Hat Enterprise Linux 8.0的部分新特性，如果想要查看更多的变化，可以在红帽官网中进行浏览。

## Author

```
Name:Shinefire
Blog:https://github.com/shine-fire/Ops_Notes
E-mail:shine_fire@qq.com
```

## 变化内容大纲

- Content is available through the **BaseOS** and Application Stream (**AppStream**) repositories. 

  需要配置BaseOS和AppStream

  ```bash
  [root@rhel8 ~]# cat /etc/yum.repos.d/rhel8.repo 
  [rhel8-BaseOS]
  name=rhel8-BaseOS
  baseurl=http://192.168.31.100/rhel8/BaseOS
  enabled=1
  gpgcheck=0
  
  [rhel8-AppStream]
  name=rhel8-AppStream
  baseurl=http://192.168.31.100/rhel8/AppStream
  enabled=1
  gpgcheck=0
  ```

- YUM --> DNF 

  ```bash
  [root@rhel8 ~]# yum --version
  4.0.9
    Installed: dnf-0:4.0.9.2-5.el8.noarch at Fri 13 Dec 2019 07:38:32 AM GMT
    Built    : Red Hat, Inc. <http://bugzilla.redhat.com/bugzilla> at Thu 14 Feb 2019 12:04:07 PM GMT
  [root@rhel8 ~]# ll /usr/bin/yum
  lrwxrwxrwx. 1 root root 5 Feb 14  2019 /usr/bin/yum -> dnf-3
  ```

- Python3.6

  默认不安装任何Python，系统提供的包为3.6版本

-  The following **database servers** are distributed with RHEL 8: `MariaDB 10.3`, `MySQL 8.0`, `PostgreSQL 10`, `PostgreSQL 9.6`, and `Redis 5`. 

- iptables --> nftables, firewalld使用nftables作为默认后端

- 生命周期

- 新增Golang工具组，对于基于golang开发这方面会更加方便

## 详细介绍

### 工具版本对比

| iteams     | RHEL7           | RHEL8               |
| ---------- | --------------- | ------------------- |
| kernel     | kernel 3.10.x-x | kernel 4.18.x-x     |
| Python     | python2.7       | python2.7+python3.6 |
| php        | php5.4          | php7.2              |
| ruby       | ruby 2.0.0      | ruby 2.5            |
| golang     | N/A             | golang 1.11         |
| nodejs     | N/A             | nodejs 10           |
| httpd      | httpd 2.4.6     | httpd 2.4.37        |
| nginx      | N/A             | nginx 1.14          |
| mysql      | N/A             | mysql8.0            |
| MariaDB    | MariaDB 5.5     | MariaDB 10.3        |
| PostgreSQL | PostgreSQL 9.2  | PostgreSQL 10       |
| Redis      | N/A             | Redis 5             |
|            |                 |                     |
| gcc        | gcc 4.8         | gcc 8.2             |
| glibc      |                 |                     |
| git        |                 |                     |
|            | yum             | dnf                 |
|            |                 |                     |

### kernel

3.10.x-x  -->  4.18.x-x

With this update, support for 52-bit physical addressing (PA) for the 64-bit ARM architecture is available. This provides larger address space than previous 48-bit PA. 

Intel Omni-Path Architecture (OPA) host software is fully supported in Red Hat Enterprise Linux 8. 

### 软件包管理

YUM --> DNF

DNF并不是横空出世，早在Fedora 18中已经出现，并在Fedora 22中使用dnf替代yum，旨在克服YUM软件包管理器的一些瓶颈，使用C语言库hawkey进行软件包依赖关系解析，从而大幅度提升包管理操作效率，同时也降低了内存消耗，从而提升用户体验。DNF较YUM最大的优点在于如果配置和启用的库没有响应，dnf将跳过它并使用可用的repos继续事务，而不像YUM，如果配置库不可用，yum将立即停止工作。 

DNF优势：

- 兼容yum的命令
- 性能提升，内存消耗更低
- 支持模块化
- 支持API调用

 [Changes in DNF CLI compared to YUM](http://dnf.readthedocs.io/en/latest/cli_vs_yum.html). 

### Repositories

BaseOS

AppStream

优势：

RHEL6、7 repo文件

```bash
[root@rhel8 ~]# cat /etc/yum.repos.d/rhel7.repo 
[rhel-7-server-rpms]
name=rhel-7-server-rpms
baseurl=http://192.168.31.100/rpms/rhel-7-server-rpms
enabled=1
gpgcheck=0
```

RHEL8 repo文件

```bash
[root@rhel8 ~]# cat /etc/yum.repos.d/rhel8.repo 
[rhel8-BaseOS]
name=rhel8-BaseOS
baseurl=http://192.168.31.100/rhel8/BaseOS
enabled=1
gpgcheck=0

[rhel8-AppStream]
name=rhel8-AppStream
baseurl=http://192.168.31.100/rhel8/AppStream
enabled=1
gpgcheck=0
```

### 时间管理

ntp软件被移除，只支持chrony

### Python

为了改善用户体验，从 RHEL 8 Beta 开始不再强调“系统 Python”，不再默认一个 Python 版本。他们使用模块化的 Application Streams 设计，结合 Python 可多版本同时安装的特点，将为用户提供多个版本 Python 的选项，并且可以从标准存储库轻松安装到标准位置，用户可以选择他们想要在任何给定用户空间中运行的 Python 版本。 

 Application Streams 是在 RHEL 8 中引入的一类存储库，它提供用户可能希望在给定用户空间中运行的所有应用程序，它是在物理存储库中创建的多个虚拟存储库。 

这种变化之后，用户想要使用 Python，需要直接指定 Python3 或者 Python2，而不是直接 Python。同时 yum install python 将返回 404，因为它同样需要指定安装版本。建议使用 yum install @python36 或 yum install @python27 安装推荐软件包，而如果只需要 Python 二进制文件，则可以使用 yum install python3 或 yum install python2。此外，pip 等工具也有变化，比如 Python3 将安装在 pip3 路径下，而不是没有版本指定的 pip 路径。 

2020 年 1 月 1 日 停止继续支持

### Networking

iptables --> nftables，可以主要侧重于描述nftables的区别和优势

- lookup tables instead of linear processing
- a single framework for both the `IPv4` and `IPv6` protocols
- rules all applied atomically instead of fetching, updating, and storing a complete rule set
- support for debugging and tracing in the rule set (`nftrace`) and monitoring trace events (in the `nft` tool)
- more consistent and compact syntax, no protocol-specific extensions
- a Netlink API for third-party applications

### Anaconda 

官方文档： https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/8.0_release_notes/rhel-8_0_0_release#installation-composer 

### 文件系统和存储

文件系统

- btrfs文件系统被移除， You can no longer create, mount, or install on Btrfs file systems in Red Hat Enterprise Linux 8. 
- XFS now supports shared copy-on-write data extents
- The ext4 file system now supports metadata checksums
- The /etc/sysconfig/nfs file and legacy NFS service names are no longer available

存储

- Stratis is now available， [Managing layered local storage with Stratis](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_file_systems/managing-layered-local-storage-with-stratis_managing-file-systems). 
  - Manage snapshots and thin provisioning
  - Automatically grow file system sizes as needed
  - Maintain file systems
- LUKS2 is now the default format for encrypting volumes
- Virtual Data Optimizer (VDO) is now available on all of the architectures supported by RHEL 8. 

### Shells and command-line tools

The nobody user replaces nfsnobody, In RHEL 8, both of these pair have been merged into the `nobody` user and group pair, which uses the ID of 65534. The `nfsnobody` pair is not created in RHEL 8. 

### web server

httpd2.4.6-->httpd2.4.37，新增了一些功能，模块变动等...

Tomcat has been removed

新增 Varnish Cache  , a high-performance HTTP reverse proxy, is provided for the first time in RHEL . RHEL 8.0 is distributed with `Varnish Cache 6.0`. 

squid 3.5 --> squid 4.4,Notable changes include:

- Configurable helper queue size
- Changes to helper concurrency channels
- Changes to the helper binary
- Secure Internet Content Adaptation Protocol (ICAP)
- Improved support for Symmetric Multi Processing (SMP)
- Improved process management
- Removed support for SSL
- Removed Edge Side Includes (ESI) custom parser
- Multiple configuration changes

### Datebase Server

MariaDB 5.5-->MariaDB 10.3

`MariaDB 10.3` provides numerous new features over the version 5.5 distributed in RHEL 7, such as:

- Common table expressions
- System-versioned tables
- `FOR` loops
- Invisible columns
- Sequences
- Instant `ADD COLUMN` for `InnoDB`
- Storage-engine independent column compression
- Parallel replication
- Multi-source replication

### 图形桌面

​	

### container

docker has been removed.

docker --> podman.



### 生命周期

 https://access.redhat.com/support/policy/updates/errata/ 

## All New features

> 以下为官方列出的所有新特性，详情可以去官网中查看

- The web console
- Installer and image creation
- Kernel
- Software management
- Infrastructure services
- Shells and command-line tools
- Dynamic programming languages, web and database servers
- Desktop
- Hardware enablement
- Identity Management
- Compilers and development tools
- File systems and storage
- High availability and clusters
- Networking
- Security
- Virtualization
- Supportability

## 疑问

**The `nosmt` boot option is now available in the RHEL 8 installation options**

The `nosmt` boot option is available in the installation options that are passed to a newly-installed RHEL 8 system.

这个nosmt是什么东西？

## 参考文献

