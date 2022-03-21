# Foreman 规划与实施注意事项





主要关注的一些事项如下：

[TOC]



## 操作系统

Foreman Server 所部署在的环境，是需要重点考虑的一个因素。

不过一般在条件允许的情况下，直接部署在最新发行版本的操作系统即可，一些旧版本的操作系统后面会慢慢的取消兼容性测试等，在版本的迭代过程中慢慢会失去支持。

例如官方在 2021/08 的时候就宣布了在不久后会考虑启用 EL7 版本的系统了。

[原话如下](https://community.theforeman.org/t/deprecation-plans-for-foreman-on-el7-debian-10-and-ubuntu-18-04/25008)：

Then we should also consider that EL9 is on the horizon. It’s expected that CentOS Stream 9 should be on the mirror network in a matter of weeks ([source 2](https://lists.centos.org/pipermail/centos-devel/2021-August/077263.html)). This brings us to some CI limitations. We don’t have enough resources to do our pipeline testing on all OSes. Dropping EL7 will free up those resources.

For that I’m proposing that we start announcing with Foreman 3.0 that we’re deprecating EL7 support. Actual removal can happen later. This isn’t based on a lot, but I’m thinking about 3.2 or 3.3.



## 节点考虑

需要根据当前或者未来规划的组织资源环境，来考虑是单节点还是多节点之类。

对于大型组织，存在多个数据中心的情况下，是有必要去考虑部署Proxy节点的。



## 插件扩展考虑

首次部署的话，最好是先多看一下官方文档再进行操作，Foreman有些功能是不支持部署后进行拓展的，所以最好是先结合文档与自己的需求来考虑有哪些插件是自己必需的。

例如安装的过程中，是需要额外指定才能添加 Ansible 插件的。



## 安装 katello

根据官方的提示 https://www.theforeman.org/manuals/3.1/index.html#Availablepackages ：

> If you want to manage content (for example, RPMs, Kickstart trees, ISO and KVM images, OSTree content, and more) with Foreman please follow the [Katello](https://theforeman.org/plugins/katello/) installation instructions. If you are a new user, ensure that you familiarize yourself with [Katello](https://theforeman.org/plugins/katello/) and decide whether you want to use its features because installing Katello on top of an existing Foreman is unsupported. Note that you cannot install Katello on Debian systems.

如果想要用来管理 PRMs 这些，必须是要安装 Katello 的，这个需要在使用 Foreman 之前就进行评估，否则在使用中是无法再继续加装 Foreman。



## 主机名命名问题

主机名不符合要求也会影响正常使用。

主机名可以包含小写字母、数字、点 (.) 和连字符 (-)

主机名不能使用大写字母，客户端也不能用大写字母作为主机名，不然可能会因为主机名大写问题无法加入到Foreman中去。

解析的时候也要写fqdn，而不能只写short hostname



## 系统专用要求

安装 Foreman 的系统，需要一台新安装的专门用于跑 Foreman 的系统，不要把其他的业务也跑在 Foreman 的服务器上，不然可能会引发一些冲突导致出问题。



## 用户要求

Foreman 所在的操作系统不能包含外部身份提供者应用提供以下的用户，否则会和 Foreman 后续部署产生的用户有冲突：

- apache
- foreman
- foreman-proxy
- postgres
- pulp
- puppet
- puppetserver
- qdrouterd
- qpidd
- tomcat



## 文件系统要求

如果将 /tmp 目录挂载为单独的文件系统，则必须使用 /etc/fstab 文件中的 exec 挂载选项。如果 /tmp 已使用 noexec 选项挂载，则必须将选项更改为 exec 并重新挂载文件系统。这是 puppetserver 服务工作的必要条件。

由于大多数 Foreman 服务器数据都存储在 /var 目录中，因此在 LVM 存储上挂载 /var 可以帮助系统扩展。

不要使用 GFS2 文件系统，输入输出的延迟太高了。



## SELinux 与 NFS 挂载

SELinux Considerations for NFS Mount

When the `/var/lib/pulp` directory is mounted using an NFS share, SELinux blocks the synchronization process. To avoid this, specify the SELinux context of the `/var/lib/pulp` directory in the file system table by adding the following lines to `/etc/fstab`:

```
nfs.example.com:/nfsshare  /var/lib/pulp  nfs  context="system_u:object_r:var_lib_t:s0"  1 2
```

If NFS share is already mounted, remount it using the above configuration and enter the following command:

```
# restorecon -R /var/lib/pulp
```



## SELinux 必须启用

SELinux 必须启用，不管是 enforcing 或者 permissive 都可以，但是不支持在 disable 模式上进行安装。

SELinux must be enabled, either in enforcing or permissive mode. Installation with disabled SELinux is not supported.



## 域名配置问题

通常是建议 foreman 的系统配置主机名时，应该要配置 fqdn 的，但是如果实在不愿意配置 fqdn ，也至少需要在 /etc/hosts 中写一个域名，因为后面安装完成后，需要一个正常用来访问的域名来访问 foreman web 端。