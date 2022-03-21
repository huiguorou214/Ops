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
- Foreman 3.1
- Foreman plugins 3.1
- Puppet 6 Repository el 8 - x86_64
- katello
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



### 关闭SELinux（待删除）

```bash
~]# vim /etc/selinux/config
SELINUX=disabled
~]# reboot
```



### 配置在线YUM源

#### 配置最新的基础源

略过基础源的配置，用系统默认的或者配置国内的镜像源即可。

- BaseOS
- AppStream
- Extras





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
~]# dnf -y install https://yum.theforeman.org/releases/3.1/el8/x86_64/foreman-release.rpm
```



配置 Katello 仓库

```bash
~]# dnf -y localinstall https://yum.theforeman.org/katello/4.3/katello/el8/x86_64/katello-repos-latest.rpm
```



配置 Ansible 仓库

```bash
~]# dnf -y install centos-release-ansible-29
```



配置 puppet 仓库

``` bash
~]# dnf -y install https://yum.puppet.com/puppet6-release-el-8.noarch.rpm
```



### 配置内网离线YUM源

如果企业环境无法联网的时候，则无法使用在线yum源，只能根据实际环境来配置内网yum源（此处略过）









### 检查加的repos

```bash
~]# dnf repolist
repo id                                        repo name
CentOS-Stream-8-AppStream                      CentOS-Stream-8-AppStream
CentOS-Stream-8-BaseOS                         CentOS-Stream-8-BaseOS
CentOS-Stream-8-Extras                         CentOS-Stream-8-Extras
centos-ansible-29                              centos-ansible-29
foreman                                        Foreman 3.1
foreman-plugins                                foreman-plugins
katello                                        katello
katello-candlepin                              katello-candlepin
pulpcore                                       pulpcore
puppet6                                        puppet6
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

配置时钟服务器

```bash
vim /etc/chrony.conf
server 10.241.67.8
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
~]# dnf module reset ruby
~]# dnf module enable ruby:2.7 -y
```

启用 pki-core module

``` bash
~]# dnf module enable pki-core -y
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



安装 katello 相关

```bash
~]# dnf -y install katello puppet-agent-oauth
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



##### 安装命令

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
--enable-foreman-plugin-openscap \
--enable-foreman-proxy-plugin-openscap \
--enable-foreman-cli-openscap \
--foreman-initial-organization "Shine-Fire" \
--foreman-initial-location "China" \
--foreman-initial-admin-username admin \
--foreman-initial-admin-password password \
--foreman-initial-admin-timezone Asia/Shanghai \
--tuning default

--enable-foreman-plugin-remote-execution  \
--enable-foreman-proxy-plugin-remote-execution-ssh  \

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
puppetserver.service                       enabled
redis.service                              enabled

All services listed                                                   [OK]
--------------------------------------------------------------------------------
```





## WEB端登陆使用

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



Q11：

foreman-installer 安装的时候遇到 `foreman-rake db:migrate` 的报错 

```bash
2022-03-17 12:06:44 [ERROR ] [configure] '/usr/sbin/foreman-rake db:migrate' returned 1 instead of one of [0]
2022-03-17 12:06:44 [ERROR ] [configure] /Stage[main]/Foreman::Database/Foreman::Rake[db:migrate]/Exec[foreman-rake-db:migrate]/returns: change from 'notrun' to ['0'] failed: '/usr/sbin/foreman-rake db:migrate' returned 1 instead of one of [0]
```





## 待测试功能










## References

- theforeman 官方文档：https://www.theforeman.org/manuals/3.1/index.html
- Katello 相关文档：https://docs.theforeman.org/ （目前开源红帽Satellite文档的工作还在进行中，该站点仅用于参考，目前只有Katello相关的文档）
- Installing Katello on RHEL/CentOS：https://docs.theforeman.org/3.1/Installing_Server/index-katello.html
- Foreman Plugins 文档：https://www.theforeman.org/plugins/  