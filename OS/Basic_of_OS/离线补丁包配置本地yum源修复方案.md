# 离线补丁包配置本地yum源修复方案

> 本章主要介绍，在面临一些补丁修复工作时，如何将厂商提供的离线补丁包配置成系统的本地yum源之后使用yum命令来进行补丁修复。
>
> 以下为一个RHEL7操作系统的openssl漏洞修复方案为例进行说明，其他漏洞修复均可参考此方案进行。





## 修复方案



### 环境说明

操作系统：RHEL7

openssl升级指定版本：openssl-1.0.2k-19.el7.x86_64



### 上传补丁包到服务器中

将提供的补丁包上传到服务器中，大概率是一个 .tar.gz 的压缩包，上传的路径根据自己需要自行决定即可。



### 解压压缩包

如果上传的是一个 .tar.gz 的压缩包，则需要先进行解压，如果只是一个普通的文件夹，则略过此解压压缩包步骤

```bash
[root@rhel76-ori ~]# ls 
rhel7.tar.gz
[root@rhel76-ori ~]# tar xzvf rhel7.tar.gz
... output ...
[root@rhel76-ori ~]# ls 
rhel7  rhel7.tar.gz
[root@rhel76-ori ~]# pwd 
/root
```



### 配置本地yum源

配置一个本地的yum源，指定补丁包的存放路径即可。

配置示例：

```bash
[root@rhel76-ori ~]# vi /etc/yum.repos.d/local.repo
[local]
name=local
baseurl=file:///root/rhel7
enable=1
gpgcheck=0
```



### 更新yum缓存

配置好yum源之后，需要更新一下yum缓存

```bash
[root@rhel76-ori ~]# yum clean all && yum makecache 
Loaded plugins: product-id, search-disabled-repos, subscription-manager
This system is not registered with an entitlement server. You can use subscription-manager to register.
Cleaning repos: local
Other repos take up 26 M of disk space (use --verbose for details)
Loaded plugins: product-id, search-disabled-repos, subscription-manager
This system is not registered with an entitlement server. You can use subscription-manager to register.
local                                                                                                                                               | 2.9 kB  00:00:00     
(1/3): local/filelists_db                                                                                                                           | 449 kB  00:00:00     
(2/3): local/other_db                                                                                                                               |  47 kB  00:00:00     
(3/3): local/primary_db                                                                                                                             | 930 kB  00:00:00     
Metadata Cache Created
```



### 检查系统当前openssl版本

先检查一下系统当前的版本

```bash
[root@rhel76-ori ~]# rpm -qa | grep openssl
openssl-libs-1.0.2k-16.el7.x86_64
xmlsec1-openssl-1.2.20-7.el7_4.x86_64
openssl-1.0.2k-16.el7.x86_64
```



### 查看yum源中可用的更新版本

查看yum源中可用的更新版本，检查是否为已经达到了漏洞修复要求的版本，如果发现不对，请联系相关管理人员确认。

```bash
[root@rhel76-ori ~]# yum list | grep openssl
openssl.x86_64                        1:1.0.2k-16.el7             @anaconda/7.6 
openssl-libs.x86_64                   1:1.0.2k-16.el7             @anaconda/7.6 
xmlsec1-openssl.x86_64                1.2.20-7.el7_4              @anaconda/7.6 
openssl.x86_64                        1:1.0.2k-19.el7             local         
openssl-devel.x86_64                  1:1.0.2k-19.el7             local         
openssl-libs.x86_64                   1:1.0.2k-19.el7             local         
openssl098e.x86_64                    0.9.8e-29.el7_2.3           local 
```

从输出结果可以看到openssl的版本为`1.0.2k-19.el7`，已经满足了修复漏洞的需要。



### 更新openssl

使用``yum update`命令来更新openssl

```bash
[root@rhel76-ori ~]# yum update openssl -y
Loaded plugins: product-id, search-disabled-repos, subscription-manager
This system is not registered with an entitlement server. You can use subscription-manager to register.
Resolving Dependencies
--> Running transaction check
---> Package openssl.x86_64 1:1.0.2k-16.el7 will be updated
---> Package openssl.x86_64 1:1.0.2k-19.el7 will be an update
--> Processing Dependency: openssl-libs(x86-64) = 1:1.0.2k-19.el7 for package: 1:openssl-1.0.2k-19.el7.x86_64
--> Running transaction check
---> Package openssl-libs.x86_64 1:1.0.2k-16.el7 will be updated
---> Package openssl-libs.x86_64 1:1.0.2k-19.el7 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

===========================================================================================================================================================================
 Package                                    Arch                                 Version                                         Repository                           Size
===========================================================================================================================================================================
Updating:
 openssl                                    x86_64                               1:1.0.2k-19.el7                                 local                               493 k
Updating for dependencies:
 openssl-libs                               x86_64                               1:1.0.2k-19.el7                                 local                               1.2 M

Transaction Summary
===========================================================================================================================================================================
Upgrade  1 Package (+1 Dependent package)

Total download size: 1.7 M
Downloading packages:
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                      649 MB/s | 1.7 MB  00:00:00     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : 1:openssl-libs-1.0.2k-19.el7.x86_64                                                                                                                     1/4 
  Updating   : 1:openssl-1.0.2k-19.el7.x86_64                                                                                                                          2/4 
  Cleanup    : 1:openssl-1.0.2k-16.el7.x86_64                                                                                                                          3/4 
  Cleanup    : 1:openssl-libs-1.0.2k-16.el7.x86_64                                                                                                                     4/4 
  Verifying  : 1:openssl-libs-1.0.2k-19.el7.x86_64                                                                                                                     1/4 
  Verifying  : 1:openssl-1.0.2k-19.el7.x86_64                                                                                                                          2/4 
  Verifying  : 1:openssl-libs-1.0.2k-16.el7.x86_64                                                                                                                     3/4 
  Verifying  : 1:openssl-1.0.2k-16.el7.x86_64                                                                                                                          4/4 

Updated:
  openssl.x86_64 1:1.0.2k-19.el7                                                                                                                                           

Dependency Updated:
  openssl-libs.x86_64 1:1.0.2k-19.el7                                                                                                                                      

Complete!
```



### 更新后检查

更新成功后，检查软件版本是否满足要求

```bash
[root@rhel76-ori ~]# rpm -qa | grep openssl    
openssl-1.0.2k-19.el7.x86_64
xmlsec1-openssl-1.2.20-7.el7_4.x86_64
openssl-libs-1.0.2k-19.el7.x86_64
```



### 重启操作系统

在升级内核，openssl这两类的软件后，建议在合适的时间窗口对操作系统进行重启。





## 回退方案

升级后若出现异常，可以对已更新的包进行回退。

**注意：**回退成功的前提是要现有的yum源能够安装旧版本的软件包



### 回退操作

使用`yum downgrade`命令可以对指定的软件包进行版本回退操作。

```bash
# yum downgrade openssl
```



### 检查回退后的版本

检查回退成功后的版本是否能对应上升级前的版本号

```bash
[root@rhel76-ori ~]# rpm -qa | grep openssl
openssl-libs-1.0.2k-16.el7.x86_64
xmlsec1-openssl-1.2.20-7.el7_4.x86_64
openssl-1.0.2k-16.el7.x86_64
```