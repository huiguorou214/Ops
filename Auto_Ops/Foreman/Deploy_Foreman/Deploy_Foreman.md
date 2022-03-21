# Foreman Deployment

> 本章主要介绍如何快速的部署一个Foreman上手使用，适用于个人或者公司平时的补丁管理。



**Author**

```
Name:Shinefire
Blog:https://github.com/shine-fire/Ops_Notes
E-mail:shine_fire@outlook.com
```

[TOC]

## 介绍

Foreman-katello  是一个All in one的开源项目，整合了很多其他开源模块用于实现服务器的集中管理，他从上游repo获取内容后，部署到各种平台上，可以支持虚拟化，物理机，公有云上的操作系统的统一管理。



## 环境规划

### 版本说明

| Items           | Var                                     |
| --------------- | --------------------------------------- |
| OS Version      | CentOS Stream 8（7版本马上要被抛弃...） |
| Foreman Version | 3.1（当前的稳定版本）                   |



### 硬件要求

默认安装的需求：

- 20GB RAM + 4G swap（这是官方建议的最小值，不过最小值也可能会存在无法正常运行的可能性，所以最好配置更大一些）
- 300G disk

另外需要根据实际环境来确定当前具体的资源需求，可以参考以下：

| profile           | 受控机器数量范围 | 建议最小内存 | 建议最小CPU |
| ----------------- | ---------------- | ------------ | ----------- |
| default           | up-to 5000       | 20G          | 4           |
| medium            | 5000 to 10000    | 32G          | 8           |
| large             | 10000 to 20000   | 64G          | 16          |
| extra-large       | 20000 to 40000   | 128G         | 32          |
| extra-extra-large | 40000 to 60000   | 256G         | 48          |



### 文件系统要求

| Directory       | Installation Size | Runtime Size   |
| :-------------- | :---------------- | :------------- |
| /var/log/       | 10 MB             | 10 GB          |
| /var/lib/pgsql  | 100 MB            | 20 GB          |
| /usr            | 3 GB              | Not Applicable |
| /opt/puppetlabs | 500 MB            | Not Applicable |
| /var/lib/pulp/  | 1 MB              | 300 GB         |
| /var/lib/qpidd/ | 25 MB             | Not Applicable |



### 浏览器版本推荐

- Google Chrome 54 or higher
- Microsoft Edge
- Microsoft Internet Explorer 10 or higher
- Mozilla Firefox 49 or higher

> 其他版本的浏览器官方未进行测试，不保证都能正常运行



### 防火墙

Protect your Foreman environment by blocking all unnecessary and unused ports.

| Port        | Protocol  | Required For                                                 |
| :---------- | :-------- | :----------------------------------------------------------- |
| 53          | TCP & UDP | DNS Server                                                   |
| 67, 68      | UDP       | DHCP Server                                                  |
| 69          | UDP       | TFTP Server                                                  |
| 80, 443     | TCP       | ***** HTTP & HTTPS access to Foreman web UI / provisioning templates - using Apache + Passenger |
| 3000        | TCP       | HTTP access to Foreman web UI / provisioning templates - using standalone WEBrick service |
| 5910 - 5930 | TCP       | Server VNC Consoles                                          |
| 5432        | TCP       | Separate PostgreSQL database                                 |
| 8140        | TCP       | ***** Puppet server                                          |
| 8443        | TCP       | Smart Proxy, open only to Foreman                            |

> Ports indicated with ***** are running by default on a Foreman all-in-one installation and should be open.



### YUM源

对于 CentOS Stream 8，安装Foreman平台之前需要准备好以下YUM源：

- CentOS Stream 8 - AppStream
- CentOS Stream 8 - BaseOS
- CentOS Stream 8 - Extras
- EPEL
- epel-modular
- Foreman 3.2
- Foreman plugins 3.2
- Puppet 7 Repository el 8 - x86_64
- katello 4.4 
- katello-candlepin
- pulpcore
- centos-ansible-29



## 系统环境准备



### 关闭firewalld

关闭 firewalld

```bash
~]# systemctl disable firewalld.service --now
Removed /etc/systemd/system/multi-user.target.wants/firewalld.service.
Removed /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service.
```

检查结果

```bash
[root@foreman-server ~]# systemctl status firewalld.service
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; disabled; vendor preset: enable>
   Active: inactive (dead)
     Docs: man:firewalld(1)
...
```



### 开启 SELinux

```bash
~]# vim /etc/selinux/config
SELINUX=enforcing
~]# reboot
```



### 配置FQDN

```bash
~]# hostnamectl set-hostname foreman-server.shinefire.com
```



### 配置 hosts

```bash
~]# vi /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.31.111  foreman-server.shinefire.com  foreman-server
```



### 配置DNS

略过，网络配置的时候通常会进行配置DNS了。



### 检查域名解析

检查域名解析是否能够符合预期得到相应的 IP 地址和 fqdn

```bash
~]# ping -c1 localhost
~]# ping -c1 `hostname -f` # my_system.domain.com
```



### 配置时间同步

安装 chrony

```bash
~]# dnf -y install chrony
```

配置时钟服务器

```bash
vim /etc/chrony.conf
server xx.xx.xx.xx
```

启用服务

```bash
~]# systemctl enable chronyd --now
Created symlink /etc/systemd/system/multi-user.target.wants/chronyd.service → /usr/lib/systemd/system/chronyd.service.
```

配置时区

```bash
~]# timedatectl set-timezone Asia/Shanghai
```





## 部署 Foreman



### 配置在线YUM源

#### 配置最新的基础源

略过基础源的配置，用系统默认的或者配置国内的镜像源即可。

- BaseOS
- AppStream
- Extras（镜像不自带）



#### 安装在线repos（适用于可以连通外网的环境）

清理缓存

```bash
~]# dnf clean all
```



配置 epel 源

```bash
~]# dnf localinstall -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
```

> 虽然官方文档没写要配置epel，但是实际上如果没有的话，就会遇到很多报错...



配置 Foreman 仓库

```bash
~]# dnf localinstall -y https://yum.theforeman.org/releases/3.2/el8/x86_64/foreman-release.rpm
```



配置 Katello 仓库

```bash
~]# dnf -y localinstall https://yum.theforeman.org/katello/4.4/katello/el8/x86_64/katello-repos-latest.rpm
```



配置 Ansible 仓库（来自extras源）

```bash
~]# dnf install -y centos-release-ansible-29
```



配置 puppet7 仓库

``` bash
~]# dnf localinstall -y https://yum.puppet.com/puppet7-release-el-8.noarch.rpm
```



### 配置内网离线YUM源

如果企业环境无法联网的时候，则无法使用在线yum源，只能根据实际环境来配置内网yum源（此处略过）





### 检查repos

```bash
~]# dnf repolist
repo id               repo name
appstream             CentOS Stream 8 - AppStream
baseos                CentOS Stream 8 - BaseOS
centos-ansible-29     CentOS Configmanagement SIG - ansible-29
epel                  Extra Packages for Enterprise Linux 8 - x86_64
epel-modular          Extra Packages for Enterprise Linux Modular 8 - x86_64
extras                CentOS Stream 8 - Extras
foreman               Foreman 3.2
foreman-plugins       Foreman plugins 3.2
katello               Katello 4.4
katello-candlepin     Candlepin: an open source entitlement management system.
powertools            CentOS Stream 8 - PowerTools
pulpcore              pulpcore: Fetch, Upload, Organize, and Distribute Software Packages.
puppet7               Puppet 7 Repository el 8 - x86_64
```



### 安装必需软件包

#### 更新所有rpm包

更新补丁

```bash
~]# dnf update --refresh -y
~]# reboot
```



#### 安装需要的软件包

开启 Ruby 2.7 module

```bash
~]# dnf module reset ruby -y
~]# dnf module enable ruby:2.7 -y
```

启用 pki-core module

``` bash
~]# dnf module enable pki-core -y
```

启用 katello module

```bash
~]# dnf module enable katello -y
```

启用 pulpcore module

```bash
~]# dnf module enable pulpcore -y
```

启用 foreman module

```bash
~]# dnf module enable foreman -y
```



安装 foreman-installer

```bash
~]# dnf -y install foreman-installer
```

安装 foreman-installer-katello

```bash
~]# dnf -y install foreman-installer-katello
```

安装 rubygem-foreman_maintain

```bash
~]# dnf -y install rubygem-foreman_maintain
```

安装 selinux 相关

```bash
~]# dnf -y install foreman-selinux katello-selinux candlepin-selinux pulpcore-selinux
```



### 使用foreman-installer进行安装



#### 启动instller安装

##### 安装选项说明

如下：

| 选项                                               | 说明                                                 |
| -------------------------------------------------- | ---------------------------------------------------- |
| --[no-]enable-foreman-cli-openscap                 | 启用openscap相关                                     |
| --[no-]enable-foreman-plugin-openscap              | 启用openscap相关                                     |
| --[no-]enable-foreman-proxy-plugin-openscap        | 启用openscap相关                                     |
| --foreman-initial-organization                     | 指定组织名称                                         |
| --tuning medium                                    | 根据规模进行相应的优化，主要是优化了postgresql的参数 |
| --enable-foreman-plugin-remote-execution           |                                                      |
| --enable-foreman-proxy-plugin-remote-execution-ssh |                                                      |
| --enable-foreman-compute-vmware                    | vmware相关的支持                                     |
| --enable-foreman-compute-ovirt                     | ovirt相关的支持                                      |
|                                                    |                                                      |
|                                                    |                                                      |
|                                                    |                                                      |



##### 安装 katello

foreman-installer 安装

```bash
~]# foreman-installer --scenario katello \
--foreman-initial-organization "Shine-Fire" \
--foreman-initial-location "China" \
--foreman-initial-admin-username admin \
--foreman-initial-admin-password password \
--foreman-initial-admin-timezone Asia/Shanghai
```

安装输出结果如下：

```bash
[root@foreman-server ~]# foreman-installer --scenario katello \
> --foreman-initial-organization "Shine-Fire" \
> --foreman-initial-location "China" \
> --foreman-initial-admin-username admin \
> --foreman-initial-admin-password password \
> --foreman-initial-admin-timezone Asia/Shanghai
2022-03-18 01:13:26 [NOTICE] [root] Loading installer configuration. This will take some time.
2022-03-18 01:13:31 [NOTICE] [root] Running installer with log based terminal output at level NOTICE.
2022-03-18 01:13:31 [NOTICE] [root] Use -l to set the terminal output log level to ERROR, WARN, NOTICE, INFO, or DEBUG. See --full-help for definitions.
2022-03-18 01:18:44 [NOTICE] [configure] Starting system configuration.
2022-03-18 01:20:40 [NOTICE] [configure] 250 configuration steps out of 1700 steps complete.
2022-03-18 01:21:36 [NOTICE] [configure] 500 configuration steps out of 1700 steps complete.
2022-03-18 01:21:36 [NOTICE] [configure] 750 configuration steps out of 1704 steps complete.
2022-03-18 01:22:47 [NOTICE] [configure] 1000 configuration steps out of 1711 steps complete.
2022-03-18 01:22:54 [NOTICE] [configure] 1250 configuration steps out of 1731 steps complete.
2022-03-18 01:28:04 [NOTICE] [configure] 1500 configuration steps out of 1731 steps complete.
2022-03-18 01:33:21 [NOTICE] [configure] System configuration has finished.
Executing: foreman-rake upgrade:run
=============================================
Upgrade Step 1/8: katello:correct_repositories. This may take a long while.
=============================================
Upgrade Step 2/8: katello:clean_backend_objects. This may take a long while.
0 orphaned consumer id(s) found in candlepin.
Candlepin orphaned consumers: []
=============================================
Upgrade Step 3/8: katello:upgrades:4.0:remove_ostree_puppet_content. =============================================
Upgrade Step 4/8: katello:upgrades:4.1:sync_noarch_content. =============================================
Upgrade Step 5/8: katello:upgrades:4.1:fix_invalid_pools. I, [2022-03-18T01:33:37.046834 #26243]  INFO -- : Corrected 0 invalid pools
I, [2022-03-18T01:33:37.046893 #26243]  INFO -- : Removed 0 orphaned pools
=============================================
Upgrade Step 6/8: katello:upgrades:4.1:reupdate_content_import_export_perms. =============================================
Upgrade Step 7/8: katello:upgrades:4.2:remove_checksum_values. =============================================
Upgrade Step 8/8: katello:upgrades:4.4:publish_import_cvvs.   Success!
  * Foreman is running at https://foreman-server.shinefire.com
      Initial credentials are admin / password
  * To install an additional Foreman proxy on separate machine continue by running:

      foreman-proxy-certs-generate --foreman-proxy-fqdn "$FOREMAN_PROXY" --certs-tar "/root/$FOREMAN_PROXY-certs.tar"
  * Foreman Proxy is running at https://foreman-server.shinefire.com:9090

  The full log is at /var/log/foreman-installer/katello.log
```





##### 后续待安装

```bash
~]# foreman-installer --scenario katello \
--enable-foreman-plugin-openscap  \
--enable-foreman-proxy-plugin-openscap  \
--enable-foreman-cli-openscap  \
--enable-foreman-compute-vmware  \
--enable-foreman-compute-ovirt \
--enable-foreman-plugin-ansible  \
--enable-foreman-proxy-plugin-ansible \
--enable-foreman-plugin-remote-execution  \
--enable-foreman-proxy-plugin-remote-execution-ssh  \
--enable-foreman-plugin-templates  \
--foreman-proxy-plugin-ansible-install-runner=false \
--foreman-initial-organization "Shine-Fire" \
--foreman-initial-location "China-SZ" \
--foreman-initial-admin-username admin \
--foreman-initial-admin-password password \
--foreman-initial-admin-timezone Asia/Shanghai \
--tuning medium
```



临时测试用 ↓

```bash
~]# foreman-installer --scenario katello \
--foreman-initial-organization "Shine-Fire" \
--foreman-initial-location "China" \
--foreman-initial-admin-username admin \
--foreman-initial-admin-password password \
--foreman-initial-admin-timezone Asia/Shanghai

--enable-foreman-plugin-remote-execution  \
--enable-foreman-proxy-plugin-remote-execution-ssh  \
--enable-foreman-plugin-openscap \
--enable-foreman-proxy-plugin-openscap \
--enable-foreman-cli-openscap \

```



```bash
~]# foreman-installer
2022-03-04 23:47:44 [NOTICE] [root] Loading installer configuration. This will take some time.
2022-03-04 23:47:48 [NOTICE] [root] Running installer with log based terminal output at level NOTICE.
2022-03-04 23:47:48 [NOTICE] [root] Use -l to set the terminal output log level to ERROR, WARN, NOTICE, INFO, or DEBUG. See --full-help for definitions.
2022-03-04 23:47:50 [NOTICE] [configure] Starting system configuration.
2022-03-04 23:51:20 [NOTICE] [configure] 250 configuration steps out of 1357 steps complete.
2022-03-04 23:52:05 [NOTICE] [configure] 500 configuration steps out of 1359 steps complete.
2022-03-04 23:52:34 [NOTICE] [configure] 750 configuration steps out of 1371 steps complete.
2022-03-04 23:57:00 [NOTICE] [configure] 1000 configuration steps out of 1385 steps complete.
2022-03-04 23:58:23 [NOTICE] [configure] 1250 configuration steps out of 1385 steps complete.
2022-03-04 23:58:34 [NOTICE] [configure] System configuration has finished.
Executing: foreman-rake upgrade:run
  Success!
  * Foreman is running at https://foreman-server.shinefire.com
      Initial credentials are admin / EWqPjxTNXheNpyxr
  * Foreman Proxy is running at https://foreman-server.shinefire.com:8443

  The full log is at /var/log/foreman-installer/foreman.log
```

等待提示Success!安装成功，记录默认的admin**管理员密码**，例如上面的`EWqPjxTNXheNpyxr`，可以在提示的路径中查看安装日志。



#### 检查安装结果



使用 命令检查服务运行状态

不加任何参数安装后的结果如下，是默认带有puppetserver的：

```bash
~]# foreman-maintain service list
Running Service List
================================================================================
List applicable services:
dynflow-sidekiq@.service                   indirect
foreman-proxy.service                      enabled
foreman.service                            enabled
httpd.service                              enabled
postgresql.service                         enabled
pulpcore-api.service                       enabled
pulpcore-content.service                   enabled
pulpcore-worker@.service                   indirect
redis.service                              enabled
tomcat.service                             enabled

All services listed                                                   [OK]
--------------------------------------------------------------------------------
```



### WEB端登陆使用

浏览器中输入IP或者域名即可访问，

![image-20200603001531042](Deploy_Foreman.assets/image-20200603001531042.png)

查看主界面

![image-20200603001359277](Deploy_Foreman.assets/image-20200603001359277.png)



## Foreman-Kattlo资源管理框架

环境(Environment) 和发布路径（Environment Paths） :
所有从外部同步回来得资源会先放置与 Library 库中， 然后根据不同得生命周期需求，产生不同得发布路径， 如：Library   ->   开发  ->  测试 - >  生产环境

处于不同环境得client机器，可以选择从不同得environment中下载补丁包，实现生命周期管理需求， 如果为了简化，也可以统一直接从Library中拉取

完成这样定义后，所有软件包，需要经过一步步得发布流程，最终才能到生产环境中：

![1591772068393](Deploy_Foreman.assets/1591772068393.png)

### Environment 

Create Environment Path

界面操作：[menu]-->[Content]-->[Lifecycle Enviroments]-->[Create Environment Path]

如下图：

【图】

Create Environment

界面操作：

【图】

### Content Views
因为library中的内容是持续不断再更新的（follow上游repo的发布频率），但是实际生产环境中的机器往往不需要经常更新，我们需要一个相对比较静态的library的“快照”，这样客户端只需要跟随content view来刷新，而不是上游一有变化立即随之升级，content view是一个集合，可以包含软件包，配置等
content view有版本。可以定期发布一个新的版本，同步Library中的更新

创建一个Content View步骤如下：
[Main] -> [Content] -> [Content View] -> [Create New View] 

【图】

在新创建的CV 添加yum content 后 Publish New Version
【图】add repository
【图】save

查看结果
【图】

后续可以定期发布新的CV版本 来实现内容版本管理。
【图】

### Content Promote

Content View 的新版本创立初期，都默认关联当前Library库中的内容（可以当作是Library在当时的快照）

Content View需要promote到不同的环境中以便关联不同类型的客户端，通常一个新的version release出来，优先promote给dev环境中使用， 一段时间后，发布新的2.0版本，则把1.0版本推到production中。dev环境使用较新版本。 依次发布，实现版本流水线控制

![1591774479028](Deploy_Foreman.assets/1591774479028.png)

操作步骤如下:
[Main] -> [Content] -> [Content View] 
点击指定的content view进去选择指定的版本选择Actions-->Promote
【图】



## 客户端主机纳管

不同的linux服务器注册到foreman的时候，通过activation key来进行区分并绑定到不同的发布内容上， 再foreman中需要先创建好各个不同的activation key，并绑定到对应的资源，这样机器注册时指需要选择不同的activation key即可。 

![1591773520184](Deploy_Foreman.assets/1591773520184.png)





## 附录

### 附录1 获取官方errata

**CentOS Errata**

可以参考这个网站提供的（这个网站应该是个个人开源项目，具体的运作方式后面我再仔细了解一下）：https://cefs.steve-meier.de/ 

最新的 centos errata 下载地址：https://cefs.steve-meier.de/errata.latest.xml.bz2



**RHEL Errata**

红帽官方的可以在官方提供的资源中获取：https://www.redhat.com/security/data/oval/v2/

> 不同的版本所需的errata，可以在官网中自行选择。







### 附录2 重装Foreman

如果要完全重装最好还是重新安装一台机器，来重头进行安装，最新的版本已经取消掉了remove功能，自己手动移除不一定能够完全移除干净。





## Q&A

Q1：

如果最开始使用 foreman-installer 的时候，没有指定启用的一些插件，后面在使用过程中要怎么再进行添加呢？

A：

**未测试**，理论上应该是可以再次使用 `--reset` 进行重新安装的。



Q2：

Foreman 安装完毕后，例如DB的这些账户信息之类的，要在什么地方查看呢？

A：

命令行安装指定的参数，会默认保存到 /etc/foreman-installer/scenarios.d/foreman-answers.yaml 这个文件中。

但是如果这里面并不会明文包含DB账户信息之类的，默认的DB账户信息还需要在哪里去找呢？



Q3：

Foreman 的默认安装路径是？

A：

默认的安装路径在 `/etc/foreman-installer/scenarios.d/foreman.yaml` 的 `installer_dir` 参数定义，默认定义路径在 `/usr/share/foreman-installer`



Q4：

在使用 foreman-installer 安装过程中出现问题，怎么再次尝试？

A：

安装过程中如果出现问题可以增加 --reset 参数重新安装。



Q5：

Foreman 第一次安装的时候没有安装 Katello，想尝试重装一下Katello，发现报错如下：

```bash
[root@foreman-server ~]# foreman-installer --scenario katello --enable-foreman-plugin-openscap --enable-foreman-proxy-plugin-openscap --enable-foreman-cli-openscap --enable-foreman-compute-vmware --enable-foreman-compute-ovirt --foreman-initial-organization "Shine-Fire" --foreman-initial-location "China" --foreman-initial-admin-username admin --foreman-initial-admin-password password --foreman-initial-admin-timezone Asia/Shanghai --tuning medium --reset --force
2022-03-16 16:09:20 [NOTICE] [scenario_manager] Scenario /etc/foreman-installer/scenarios.d/katello.yaml was selected
2022-03-16 16:09:20 [NOTICE] [root] Due to scenario change the configuration (/etc/foreman-installer/scenarios.d/katello.yaml) was updated with /etc/foreman-installer/scenarios.d/foreman.yaml and reloaded.
2022-03-16 16:09:20 [NOTICE] [root] Loading installer configuration. This will take some time.
Traceback (most recent call last):
        18: from /usr/sbin/foreman-installer:8:in `<main>'
        17: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/kafo_configure.rb:50:in `run'
        16: from /usr/share/gems/gems/clamp-1.1.2/lib/clamp/command.rb:132:in `run'
        15: from /usr/share/gems/gems/clamp-1.1.2/lib/clamp/command.rb:132:in `new'
        14: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/kafo_configure.rb:157:in `initialize'
        13: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/kafo_configure.rb:316:in `set_parameters'
        12: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/scenario_manager.rb:217:in `load_and_setup_configuration'
        11: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/configuration.rb:268:in `preset_defaults_from_puppet'
        10: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/configuration.rb:258:in `params'
         9: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/configuration.rb:132:in `modules'
         8: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/configuration.rb:396:in `register_data_types'
         7: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/configuration.rb:396:in `each'
         6: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/configuration.rb:397:in `block in register_data_types'
         5: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/configuration.rb:397:in `each'
         4: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/configuration.rb:398:in `block (2 levels) in register_data_types'
         3: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/data_type_parser.rb:20:in `register'
         2: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/data_type_parser.rb:20:in `each'
         1: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/data_type_parser.rb:22:in `block in register'
/usr/share/gems/gems/kafo-6.4.0/lib/kafo/data_type.rb:31:in `register_type': Data type Apache::LogLevel is already registered, cannot be re-registered (ArgumentError)
```

A：

怀疑这种情况下，可能需要重装才行了。

本想尝试看看能不能完全卸载 Foreman 的，但是发现 `katello-remove` 命令已经被移除掉了的样子：https://access.redhat.com/solutions/5048661

目前是直接重新用了系统快照来解决了。



Q6：

使用 foreman-installer 过程中遇到了以下 selinux 相关的报错：

```bash
~]# foreman-installer --scenario katello --enable-foreman-plugin-openscap --enable-foreman-proxy-plugin-openscap --enable-foreman-cli-openscap --enable-foreman-plugin-remote-execution  --enable-foreman-proxy-plugin-remote-execution-ssh  --foreman-initial-organization "Shine-Fire" --foreman-initial-location "China" --foreman-initial-admin-username admin --foreman-initial-admin-password password --foreman-initial-admin-timezone Asia/Shanghai
2022-03-16 23:26:26 [NOTICE] [root] Loading installer configuration. This will take some time.
2022-03-16 23:26:31 [NOTICE] [root] Running installer with log based terminal output at level NOTICE.
2022-03-16 23:26:31 [NOTICE] [root] Use -l to set the terminal output log level to ERROR, WARN, NOTICE, INFO, or DEBUG. See --full-help for definitions.
Failed to ensure foreman-selinux, katello-selinux, candlepin-selinux, pulpcore-selinux are installed
2022-03-16 23:26:43 [ERROR ] [root] Failed to ensure foreman-selinux, katello-selinux, candlepin-selinux, pulpcore-selinux are installed
Error: Execution of '/bin/dnf -d 0 -e 1 -y install pulpcore-selinux' returned 1: Error: Unable to find a match: pulpcore-selinux
Error: /Stage[main]/Main/Package[pulpcore-selinux]/ensure: change from 'purged' to 'present' failed: Execution of '/bin/dnf -d 0 -e 1 -y install pulpcore-selinux' returned 1: Error: Unable to find a match: pulpcore-selinux
2022-03-16 23:26:43 [ERROR ] [root] Error: Execution of '/bin/dnf -d 0 -e 1 -y install pulpcore-selinux' returned 1: Error: Unable to find a match: pulpcore-selinux
Error: /Stage[main]/Main/Package[pulpcore-selinux]/ensure: change from 'purged' to 'present' failed: Execution of '/bin/dnf -d 0 -e 1 -y install pulpcore-selinux' returned 1: Error: Unable to find a match: pulpcore-selinux
```

A：

因为我刚好没有配置 extras 源，导致系统未能自动安装上 pulpcore-selinux，再次配置好 extras yum 源后暂时避免了无法找到的问题，不过还是由于依赖存在了一些其他方面的问题。



Q7：

安装一些必需的软件包时遇到了下面的问题

```bash
~]# dnf -y install foreman-installer foreman-installer-katello rubygem-foreman_maintain foreman-selinux katello-selinux candlepin-selinux pulpcore-selinux
Last metadata expiration check: 0:04:00 ago on Thu 17 Mar 2022 12:28:28 AM CST.
Error:
 Problem 1: package candlepin-selinux-4.1.8-1.el8.noarch requires candlepin = 4.1.8-1.el8, but none of the providers can be installed
  - package candlepin-4.1.8-1.el8.noarch requires tomcatjss >= 7.2.1-7.1, but none of the providers can be installed
  - cannot install the best candidate for the job
  - package tomcatjss-7.6.1-1.module_el8.5.0+737+ee953a1e.noarch is filtered out by modular filtering
  - package tomcatjss-7.7.0-0.1.alpha1.module_el8.5.0+838+8f96ca18.noarch is filtered out by modular filtering
  - package tomcatjss-7.7.0-1.module_el8.5.0+876+d4bb8aa6.noarch is filtered out by modular filtering
  - package tomcatjss-7.7.1-1.module_el8.6.0+1038+e795ee4b.noarch is filtered out by modular filtering
 Problem 2: package katello-selinux-4.0.2-1.el8.noarch requires candlepin-selinux >= 3.1.10, but none of the providers can be installed
  - package candlepin-selinux-4.1.7-1.el8.noarch requires candlepin = 4.1.7-1.el8, but none of the providers can be installed
  - package candlepin-selinux-4.1.8-1.el8.noarch requires candlepin = 4.1.8-1.el8, but none of the providers can be installed
  - package candlepin-4.1.7-1.el8.noarch requires tomcatjss >= 7.2.1-7.1, but none of the providers can be installed
  - package candlepin-4.1.8-1.el8.noarch requires tomcatjss >= 7.2.1-7.1, but none of the providers can be installed
  - conflicting requests
  - package tomcatjss-7.6.1-1.module_el8.5.0+737+ee953a1e.noarch is filtered out by modular filtering
  - package tomcatjss-7.7.0-0.1.alpha1.module_el8.5.0+838+8f96ca18.noarch is filtered out by modular filtering
  - package tomcatjss-7.7.0-1.module_el8.5.0+876+d4bb8aa6.noarch is filtered out by modular filtering
  - package tomcatjss-7.7.1-1.module_el8.6.0+1038+e795ee4b.noarch is filtered out by modular filtering
(try to add '--skip-broken' to skip uninstallable packages or '--nobest' to use not only best candidate packages)
```

A：

在社区看到了遇到了同样问题的... 然后回答里面说了，要开启 pki-core module

``` bash
~]# dnf module enable pki-core -y
```

https://community.theforeman.org/t/katello-4-foreman-2-4-centos-8-4/23871

（这也太坑了吧...  文档里面也完全没说这个呀... ）



Q8：

还是同上类似的问题...

```bash
~]# dnf install pulpcore-selinux
Last metadata expiration check: 0:09:34 ago on Thu 17 Mar 2022 01:44:33 AM CST.
Error:
 Problem: package pulpcore-selinux-1.2.6-2.el8.x86_64 requires pulpcore, but none of the providers can be installed
  - package python38-pulpcore-3.16.0-2.el8.noarch requires python38-psycopg2 >= 2.9.1, but none of the providers can be installed
  - package python38-pulpcore-3.16.1-1.el8.noarch requires python38-psycopg2 >= 2.9.1, but none of the providers can be installed
  - package python38-pulpcore-3.16.3-1.el8.noarch requires python38-psycopg2 >= 2.9.1, but none of the providers can be installed
  - conflicting requests
  - package python38-psycopg2-2.9.1-1.el8.x86_64 is filtered out by modular filtering
(try to add '--skip-broken' to skip uninstallable packages or '--nobest' to use not only best candidate packages)
```

但是官方提供的版本根本没有达到 2.9.1 版本的...

```bash
~]# dnf list| grep python38-psycopg2
python38-psycopg2.x86_64                                2.8.4-4.module_el8.5.0+742+dbad1979                        appstream
python38-psycopg2-doc.x86_64                            2.8.4-4.module_el8.5.0+742+dbad1979                        appstream
python38-psycopg2-tests.x86_64                          2.8.4-4.module_el8.5.0+742+dbad1979                        appstream
~]# dnf module provides python38-psycopg2
Last metadata expiration check: 0:14:00 ago on Thu 17 Mar 2022 01:44:33 AM CST.
python38-psycopg2-2.8.4-4.module_el8.4.0+647+0ba99ce8.x86_64
Module   : python38:3.8:8060020210921015352:5294be16:x86_64
Profiles :
Repo     : appstream
Summary  : Python programming language, version 3.8

python38-psycopg2-2.8.4-4.module_el8.4.0+647+0ba99ce8.x86_64
Module   : python38:3.8:8060020220127154734:5294be16:x86_64
Profiles :
Repo     : appstream
Summary  : Python programming language, version 3.8

python38-psycopg2-2.8.4-4.module_el8.5.0+742+dbad1979.x86_64
Module   : python38:3.8:8050020210331195435:e3d35cca:x86_64
Profiles :
Repo     : appstream
Summary  : Python programming language, version 3.8
```

A：

解决方法：

https://bugzilla.redhat.com/show_bug.cgi?id=2053917:

the required version of package is shipped via ansible-automation-platform-2.1-for-rhel-8-x86_64-rpms repo only

上面这种方式是红帽提供的，应该是需要有那个订阅才可以使用，就没有看了。后面在开源社区单独找到了这个包... ：https://fr2.rpmfind.net/linux/rpm2html/search.php?query=python38-psycopg2&submit=Search+...&system=&arch=

x86_64 rpm download url : https://fr2.rpmfind.net/linux/opensuse/tumbleweed/repo/oss/x86_64/python38-psycopg2-2.9.3-1.3.x86_64.rpm

下载好这个 rpm 包之后，dnf localinstall 安装一下，再去安装 pulpcore-selinux 就成功了。

**最终的解决方法：**

使用了另外一位大佬的文档来做的了：https://docs.theforeman.org/release/nightly/

之前一直安装依赖有问题，主要还是因为 Foreman 官方文档写的就有问题，大佬也在github提了issue吐槽他们的文档，我猜测是因为Foreman社区文档还是用的puppet6的yum源导致的。



Q9：

使用离线的 AppStream 源，遇到无可用modular元数据问题：

```bash
~]# foreman-installer ...
...

No available modular metadata for modular package 'python38-chardet-3.0.4-19.module_el8.5.0+742+dbad1979.noarch', it cannot be installed on the system
No available modular metadata for modular package 'python38-libs-3.8.12-1.module_el8.6.0+929+89303463.x86_64', it cannot be installed on the system
No available modular metadata for modular package 'python38-pip-wheel-19.3.1-5.module_el8.6.0+960+f11a9b17.noarch', it cannot be installed on the system
No available modular metadata for modular package 'python38-setuptools-41.6.0-5.module_el8.6.0+929+89303463.noarch', it cannot be installed on the system
No available modular metadata for modular package 'python38-setuptools-wheel-41.6.0-5.module_el8.6.0+929+89303463.noarch', it cannot be installed on the system
Error: No available modular metadata for modular package
```

A：

离线 AppStream 源之后，createrepo还要注意导入 modular metadata。

参考：https://access.redhat.com/solutions/4888921



Q10：

foreman-installer 报错安装 python3-pulp-ansible 软件包失败：

```bash
2022-03-17 11:27:06 [ERROR ] [configure] Execution of '/bin/dnf -d 0 -e 1 -y install python3-pulp-ansible' returned 1: Error:
2022-03-17 11:27:06 [ERROR ] [configure] Problem: package python3-pulp-ansible-1:0.9.0-2.el8.noarch requires python3-galaxy-importer >= 0.3.1, but none of the providers can be installed
2022-03-17 11:27:06 [ERROR ] [configure] - cannot install the best candidate for the job
2022-03-17 11:27:06 [ERROR ] [configure] - nothing provides ansible needed by python3-galaxy-importer-0.3.2-1.el8.noarch
2022-03-17 11:27:06 [ERROR ] [configure] /Stage[main]/Pulpcore::Plugin::Ansible/Pulpcore::Plugin[ansible]/Package[python3-pulp-ansible]/ensure: change from 'purged' to 'present' failed: Execution of '/bin/dnf -d 0 -e 1 -y install python3-pulp-ansible' returned 1: Error:
2022-03-17 11:27:06 [ERROR ] [configure] Problem: package python3-pulp-ansible-1:0.9.0-2.el8.noarch requires python3-galaxy-importer >= 0.3.1, but none of the providers can be installed
2022-03-17 11:27:06 [ERROR ] [configure] - cannot install the best candidate for the job
2022-03-17 11:27:06 [ERROR ] [configure] - nothing provides ansible needed by python3-galaxy-importer-0.3.2-1.el8.noarch

```

尝试手动安装还是失败：

```bash
~]# dnf install -y python3-pulp-ansible
Last metadata expiration check: 0:17:07 ago on Thu 17 Mar 2022 11:20:02 AM CST.
Error:
 Problem: package python3-pulp-ansible-1:0.9.0-2.el8.noarch requires python3-galaxy-importer >= 0.3.1, but none of the providers can be installed
  - cannot install the best candidate for the job
  - nothing provides ansible needed by python3-galaxy-importer-0.3.2-1.el8.noarch
```

A：

在社区看到了遇到类似问题的帖子：https://community.theforeman.org/t/facing-difficulties-when-trying-to-upgrade-2-4-to-2-5/24145/11

他里面是后来有添加了 epel 源，里面就安装成功了...

但是这个应该也不是长久之策，后来好像还是遇到了这个问题。

最终解决方法：换一个文档参考安装：https://docs.theforeman.org/release/nightly/



Q11：

foreman-installer 安装的时候遇到 `foreman-rake db:migrate` 的报错 

```bash
2022-03-17 12:06:44 [ERROR ] [configure] '/usr/sbin/foreman-rake db:migrate' returned 1 instead of one of [0]
2022-03-17 12:06:44 [ERROR ] [configure] /Stage[main]/Foreman::Database/Foreman::Rake[db:migrate]/Exec[foreman-rake-db:migrate]/returns: change from 'notrun' to ['0'] failed: '/usr/sbin/foreman-rake db:migrate' returned 1 instead of one of [0]
```



尝试手动执行一下 `foreman-rake db:migrate`

```bash
[root@foreman-server ~]# foreman-rake db:migrate --trace
** Invoke db:migrate (first_time)
** Invoke db:load_config (first_time)
** Invoke environment (first_time)
** Execute environment
** Execute db:load_config
** Invoke plugin:refresh_migrations (first_time)
** Invoke environment
** Execute plugin:refresh_migrations
** Execute db:migrate
== 20200803065041 MigratePortOverridesForAnsible: migrating ===================
rake aborted!
StandardError: An error has occurred, this and all later migrations canceled:

uninitialized constant MigratePortOverridesForAnsible::AnsibleRole
/usr/share/gems/gems/foreman_openscap-5.2.1/db/migrate/20200803065041_migrate_port_overrides_for_ansible.rb:14:in `transform_lookup_values'
/usr/share/gems/gems/foreman_openscap-5.2.1/db/migrate/20200803065041_migrate_port_overrides_for_ansible.rb:3:in `up'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:831:in `exec_migration'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:812:in `block (2 levels) in migrate'
/usr/share/ruby/benchmark.rb:293:in `measure'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:811:in `block in migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/connection_adapters/abstract/connection_pool.rb:471:in `with_connection'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:810:in `migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1002:in `migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1310:in `block in execute_migration_in_transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1361:in `block in ddl_transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/connection_adapters/abstract/database_statements.rb:280:in `block in transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/connection_adapters/abstract/transaction.rb:280:in `block in within_new_transaction'
/usr/share/gems/gems/activesupport-6.0.3.7/lib/active_support/concurrency/load_interlock_aware_monitor.rb:26:in `block (2 levels) in synchronize'
/usr/share/gems/gems/activesupport-6.0.3.7/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `handle_interrupt'
/usr/share/gems/gems/activesupport-6.0.3.7/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `block in synchronize'
/usr/share/gems/gems/activesupport-6.0.3.7/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `handle_interrupt'
/usr/share/gems/gems/activesupport-6.0.3.7/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `synchronize'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/connection_adapters/abstract/transaction.rb:278:in `within_new_transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/connection_adapters/abstract/database_statements.rb:280:in `transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/transactions.rb:212:in `transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1361:in `ddl_transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1309:in `execute_migration_in_transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1281:in `block in migrate_without_lock'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1280:in `each'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1280:in `migrate_without_lock'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1229:in `block in migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1382:in `with_advisory_lock'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1229:in `migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1061:in `up'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1036:in `migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/tasks/database_tasks.rb:238:in `migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/railties/databases.rake:86:in `block (3 levels) in <top (required)>'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/railties/databases.rake:84:in `each'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/railties/databases.rake:84:in `block (2 levels) in <top (required)>'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:281:in `block in execute'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:281:in `each'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:281:in `execute'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:219:in `block in invoke_with_call_chain'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:199:in `synchronize'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:199:in `invoke_with_call_chain'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:188:in `invoke'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:160:in `invoke_task'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:116:in `block (2 levels) in top_level'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:116:in `each'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:116:in `block in top_level'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:125:in `run_with_threads'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:110:in `top_level'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:83:in `block in run'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:186:in `standard_exception_handling'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:80:in `run'
/usr/share/gems/gems/rake-13.0.1/exe/rake:27:in `<top (required)>'
/usr/bin/rake:23:in `load'
/usr/bin/rake:23:in `<main>'

Caused by:
NameError: uninitialized constant MigratePortOverridesForAnsible::AnsibleRole
/usr/share/gems/gems/foreman_openscap-5.2.1/db/migrate/20200803065041_migrate_port_overrides_for_ansible.rb:14:in `transform_lookup_values'
/usr/share/gems/gems/foreman_openscap-5.2.1/db/migrate/20200803065041_migrate_port_overrides_for_ansible.rb:3:in `up'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:831:in `exec_migration'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:812:in `block (2 levels) in migrate'
/usr/share/ruby/benchmark.rb:293:in `measure'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:811:in `block in migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/connection_adapters/abstract/connection_pool.rb:471:in `with_connection'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:810:in `migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1002:in `migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1310:in `block in execute_migration_in_transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1361:in `block in ddl_transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/connection_adapters/abstract/database_statements.rb:280:in `block in transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/connection_adapters/abstract/transaction.rb:280:in `block in within_new_transaction'
/usr/share/gems/gems/activesupport-6.0.3.7/lib/active_support/concurrency/load_interlock_aware_monitor.rb:26:in `block (2 levels) in synchronize'
/usr/share/gems/gems/activesupport-6.0.3.7/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `handle_interrupt'
/usr/share/gems/gems/activesupport-6.0.3.7/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `block in synchronize'
/usr/share/gems/gems/activesupport-6.0.3.7/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `handle_interrupt'
/usr/share/gems/gems/activesupport-6.0.3.7/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `synchronize'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/connection_adapters/abstract/transaction.rb:278:in `within_new_transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/connection_adapters/abstract/database_statements.rb:280:in `transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/transactions.rb:212:in `transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1361:in `ddl_transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1309:in `execute_migration_in_transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1281:in `block in migrate_without_lock'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1280:in `each'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1280:in `migrate_without_lock'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1229:in `block in migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1382:in `with_advisory_lock'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1229:in `migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1061:in `up'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1036:in `migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/tasks/database_tasks.rb:238:in `migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/railties/databases.rake:86:in `block (3 levels) in <top (required)>'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/railties/databases.rake:84:in `each'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/railties/databases.rake:84:in `block (2 levels) in <top (required)>'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:281:in `block in execute'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:281:in `each'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:281:in `execute'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:219:in `block in invoke_with_call_chain'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:199:in `synchronize'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:199:in `invoke_with_call_chain'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:188:in `invoke'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:160:in `invoke_task'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:116:in `block (2 levels) in top_level'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:116:in `each'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:116:in `block in top_level'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:125:in `run_with_threads'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:110:in `top_level'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:83:in `block in run'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:186:in `standard_exception_handling'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:80:in `run'
/usr/share/gems/gems/rake-13.0.1/exe/rake:27:in `<top (required)>'
/usr/bin/rake:23:in `load'
/usr/bin/rake:23:in `<main>'
Tasks: TOP => db:migrate
```

A：

发现上面在安装相关软件包的时候，遇到了这个报错，可能会有关联：

```bash
/sbin/restorecon: SELinux: Could not get canonical path for /etc/puppet/node.rb restorecon: No such file or directory.
```

但是查了一下资料，感觉和这个应该关系不是很大，而且这个问题是一年前就被提交的bug了到现在也并没有被修复：https://projects.theforeman.org/issues/32022

另外看社区有人在安装 Ansible 也遇到了类似的问题，并建议我参考他的方法试试：https://community.theforeman.org/t/enabling-ansible-plugin-results-in-failure-of-db-migrate/27048/7

```bash
mv /usr/share/gems/gems/foreman_ansible-7.0.2/app/graphql /tmp
vi /usr/share/gems/gems/foreman_ansible-7.0.2/lib/foreman_ansible/register.rb (comment the block related to graphql)
foreman-rake db:migrate
mv /tmp/graphql /usr/share/gems/gems/foreman_ansible-7.0.2/app/
vi /usr/share/gems/gems/foreman_ansible-7.0.2/lib/foreman_ansible/register.rb (remove the comment so the code)
```



通过我之前执行 `foreman-rake db:migrate` 的结果中，可以看到：

```
StandardError: An error has occurred, this and all later migrations canceled:

uninitialized constant MigratePortOverridesForAnsible::AnsibleRole
/usr/share/gems/gems/foreman_openscap-5.2.1/db/migrate/20200803065041_migrate_port_overrides_for_ansible.rb:14:in `transform_lookup_values'
/usr/share/gems/gems/foreman_openscap-5.2.1/db/migrate/20200803065041_migrate_port_overrides_for_ansible.rb:3:in `up'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:831:in `exec_migration'
...
```

按那个朋友的做法来猜测，我这个安装失败可能会和 `foreman_openscap` 插件关系比较密切，参考他的方法先移除：

```bash
[root@foreman-server ~]# mv /usr/share/gems/gems/foreman_openscap-5.2.1/app/graphql/ /tmp/
```

再尝试修改 `foreman_openscap` 的 rb 文件，参考他的方法搜索一下 `register.rb` ，但是并没有同名文件

```bash
~]# find /usr/share/gems/gems/foreman_openscap-5.2.1/lib/ -name "*register.rb*"
```

再到目录下找了一下看着可能性比较高的文件：`foreman_openscap.rb`

```bash
~]# cat /usr/share/gems/gems/foreman_openscap-5.2.1/lib/foreman_openscap.rb
require "foreman_openscap/engine"

module ForemanOpenscap
end
```

通过文件内容看到它里面的代码是有调用 `foreman_openscap/engine` ，然后再查看 `foreman_openscap/engine.rb` 这个文件，发现里面有有一段与 graphql 关联系比较大的代码，尝试注释：

```bash
[root@foreman-server lib]# vim foreman_openscap/engine.rb
    #config.autoload_paths += Dir["#{config.root}/app/graphql"]
```

注释后，尝试再次执行 `foreman-rake db:migrate` 后还是有问题：

```bash
~]# foreman-rake db:migrate --trace
Apipie cache enabled but not present yet. Run apipie:cache rake task to speed up API calls.
rake aborted!
NameError: uninitialized constant Mutations::OvalPolicies
/usr/share/gems/gems/foreman_openscap-5.2.1/lib/foreman_openscap/engine.rb:227:in `block (2 levels) in <class:Engine>'
/usr/share/foreman/app/registries/foreman/plugin.rb:100:in `instance_eval'
/usr/share/foreman/app/registries/foreman/plugin.rb:100:in `register'
/usr/share/gems/gems/foreman_openscap-5.2.1/lib/foreman_openscap/engine.rb:50:in `block in <class:Engine>'
/usr/share/gems/gems/railties-6.0.3.7/lib/rails/initializable.rb:32:in `instance_exec'
/usr/share/gems/gems/railties-6.0.3.7/lib/rails/initializable.rb:32:in `run'
/usr/share/foreman/config/initializers/0_print_time_spent.rb:45:in `block in run'
/usr/share/foreman/config/initializers/0_print_time_spent.rb:17:in `benchmark'
/usr/share/foreman/config/initializers/0_print_time_spent.rb:45:in `run'
/usr/share/gems/gems/railties-6.0.3.7/lib/rails/initializable.rb:61:in `block in run_initializers'
/usr/share/gems/gems/railties-6.0.3.7/lib/rails/initializable.rb:60:in `run_initializers'
/usr/share/gems/gems/railties-6.0.3.7/lib/rails/application.rb:363:in `initialize!'
/usr/share/gems/gems/railties-6.0.3.7/lib/rails/railtie.rb:190:in `public_send'
/usr/share/gems/gems/railties-6.0.3.7/lib/rails/railtie.rb:190:in `method_missing'
/usr/share/foreman/config/environment.rb:5:in `<top (required)>'
/usr/share/gems/gems/polyglot-0.3.5/lib/polyglot.rb:65:in `require'
/usr/share/gems/gems/railties-6.0.3.7/lib/rails/application.rb:339:in `require_environment!'
/usr/share/gems/gems/railties-6.0.3.7/lib/rails/application.rb:523:in `block in run_tasks_blocks'
/usr/share/gems/gems/rake-13.0.1/exe/rake:27:in `<top (required)>'
Tasks: TOP => db:migrate => db:load_config => environment
(See full trace by running task with --trace)
```

尝试再次 `foreman-installer` 安装也还是一样的报错：

```bash
[root@foreman-server ~]# foreman-installer --scenario katello \
> --foreman-initial-organization "Shine-Fire" \
> --foreman-initial-location "China" \
> --foreman-initial-admin-username admin \
> --foreman-initial-admin-password password \
> --foreman-initial-admin-timezone Asia/Shanghai \
> --enable-foreman-plugin-openscap \
> --enable-foreman-proxy-plugin-openscap \
> --enable-foreman-cli-openscap \
> --tuning default
2022-03-18 00:35:29 [NOTICE] [root] Loading installer configuration. This will take some time.
2022-03-18 00:35:34 [NOTICE] [root] Running installer with log based terminal output at level NOTICE.
2022-03-18 00:35:34 [NOTICE] [root] Use -l to set the terminal output log level to ERROR, WARN, NOTICE, INFO, or DEBUG. See --full-help for definitions.
2022-03-18 00:35:46 [NOTICE] [configure] Starting system configuration.
2022-03-18 00:36:01 [NOTICE] [configure] 250 configuration steps out of 1770 steps complete.
2022-03-18 00:36:04 [NOTICE] [configure] 500 configuration steps out of 1770 steps complete.
2022-03-18 00:36:08 [NOTICE] [configure] 1000 configuration steps out of 1780 steps complete.
2022-03-18 00:36:09 [NOTICE] [configure] 1250 configuration steps out of 1782 steps complete.
2022-03-18 00:36:29 [ERROR ] [configure] '/usr/sbin/foreman-rake db:migrate' returned 1 instead of one of [0]
2022-03-18 00:36:29 [ERROR ] [configure] /Stage[main]/Foreman::Database/Foreman::Rake[db:migrate]/Exec[foreman-rake-db:migrate]/returns: change from 'notrun' to ['0'] failed: '/usr/sbin/foreman-rake db:migrate' returned 1 instead of one of [0]
2022-03-18 00:36:39 [NOTICE] [configure] 1500 configuration steps out of 1782 steps complete.
2022-03-18 00:36:48 [NOTICE] [configure] 1750 configuration steps out of 1782 steps complete.
2022-03-18 00:36:52 [NOTICE] [configure] System configuration has finished.

  There were errors detected during install.
  Please address the errors and re-run the installer to ensure the system is properly configured.
  Failing to do so is likely to result in broken functionality.

  The full log is at /var/log/foreman-installer/katello.log
```



Q12：

离线 yum 源来进行安装之前，安装一些必要的软件包，发现报错如下：

```bash
~]# dnf -y install foreman-selinux katello-selinux candlepin-selinux pulpcore-selinux
...
Repository baseos is listed more than once in the configuration
Repository appstream is listed more than once in the configuration
Repository extras is listed more than once in the configuration
Repository powertools is listed more than once in the configuration
Last metadata expiration check: 0:02:54 ago on Fri 18 Mar 2022 03:36:29 AM CST.
Package dnf-plugins-core-4.0.21-10.el8.noarch is already installed.
Dependencies resolved.
Nothing to do.
Complete!
Repository baseos is listed more than once in the configuration
Repository appstream is listed more than once in the configuration
Repository extras is listed more than once in the configuration
Repository powertools is listed more than once in the configuration
Last metadata expiration check: 0:02:56 ago on Fri 18 Mar 2022 03:36:29 AM CST.
All matches were filtered out by modular filtering for argument: rubygem-foreman_maintain
Error: Unable to find a match: rubygem-foreman_maintain
Repository baseos is listed more than once in the configuration
Repository appstream is listed more than once in the configuration
Repository extras is listed more than once in the configuration
Repository powertools is listed more than once in the configuration
Last metadata expiration check: 0:02:59 ago on Fri 18 Mar 2022 03:36:29 AM CST.
All matches were filtered out by modular filtering for argument: katello-selinux
All matches were filtered out by modular filtering for argument: pulpcore-selinux
Error: Unable to find a match: katello-selinux pulpcore-selinux
```

A：

使用离线的yum源安装的时候，还要额外做一个开启 module 的操作，这之前不知道，所以直接就报错了。

先检查没有匹配到的软件包名称，直接 list 是无法列出来的：

```bash
~]# dnf list| grep katello-selinux

```

查找出提供 `pulpcore-selinux` 的 module：

```bash
~]# yum module provides katello-selinux
Last metadata expiration check: 0:07:55 ago on Fri 18 Mar 2022 03:47:44 AM CST.
katello-selinux-4.0.2-1.el8.noarch
Module   : katello:el8:40420220309174543::x86_64
Profiles :
Repo     : katello
Summary  : Katello module
```

通过 summary 字段，可以看到指出了这个软件包是由 katello 这个 module 提供，list 看一下 katello module：

```bash
~]# dnf module list katello
Last metadata expiration check: 0:01:53 ago on Fri 18 Mar 2022 05:20:22 PM CST.
katello
Name                  Stream               Profiles                Summary
katello               el8                  installer               Katello module

Hint: [d]efault, [e]nabled, [x]disabled, [i]nstalled
```

通过命令执行结果可以看到是没有启用这个 katello 的 module ，手动 enable katello module：

```bash
~]# dnf module enable katello
Last metadata expiration check: 0:02:04 ago on Fri 18 Mar 2022 05:20:22 PM CST.
Dependencies resolved.
==============================================================================================
 Package               Architecture         Version               Repository             Size
==============================================================================================
Enabling module streams:
 foreman                                    el8
 katello                                    el8

Transaction Summary
==============================================================================================

Is this ok [y/N]: y
Complete!
```

再检查已经能够找到 `katello-selinux`

```bash
~]# dnf list| grep katello-selinux
katello-selinux.noarch                                            4.0.2-1.el8                                                katello
```







## 待测试功能

### 无fqdn

测试一下如果不是fqdn的hostname，是否会影响到后面的使用，例如安装foreman后，登录界面如果不是fqdn的话，怎么访问？

需要问一下客户，他们其他的业务，都是怎么用的？直接输入IP地址吗？

如果不配置 fqdn 的域名，会有问题：

```bash
[root@foreman-server ~]# hostname -f
foreman-server
[root@foreman-server ~]# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.31.111  foreman-server
[root@foreman-server ~]# foreman-installer --scenario katello \
> --foreman-initial-organization "Shine-Fire" \
> --foreman-initial-location "China" \
> --foreman-initial-admin-username admin \
> --foreman-initial-admin-password password \
> --foreman-initial-admin-timezone Asia/Shanghai
2022-03-18 18:22:09 [NOTICE] [root] Loading installer configuration. This will take some time.
2022-03-18 18:22:14 [NOTICE] [root] Running installer with log based terminal output at level NOTICE.
2022-03-18 18:22:14 [NOTICE] [root] Use -l to set the terminal output log level to ERROR, WARN, NOTICE, INFO, or DEBUG. See --full-help for definitions.
Output of 'facter fqdn' is different from 'hostname -f'

Make sure above command gives the same output. If needed, change the hostname permanently via the
'hostname' or 'hostnamectl set-hostname' command
and editing the appropriate configuration file.
(e.g. on Red Hat systems /etc/sysconfig/network,
on Debian based systems /etc/hostname).

If 'hostname -f' still returns an unexpected result, check /etc/hosts and put
the hostname entry in the correct order, for example:

  1.2.3.4 hostname.example.com hostname

The fully qualified hostname must be the first entry on the line
Your system does not meet configuration criteria

```

从结果上看还是必须要配置fqdn才行










## References

- theforeman 官方文档：https://www.theforeman.org/manuals/3.1/index.html
- Katello 相关文档：https://docs.theforeman.org/ （目前开源红帽Satellite文档的工作还在进行中，该站点仅用于参考，目前只有Katello相关的文档）
- Installing Katello on RHEL/CentOS：https://docs.theforeman.org/3.1/Installing_Server/index-katello.html
- Foreman Plugins 文档：https://www.theforeman.org/plugins/  