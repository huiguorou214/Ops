# FreeIPA说明及要求



## 一、FreeIPA简介

FreeIPA是一个集成的安全信息管理解决方案，它结合了389目录服务器、MIT Kerberos、NTP、Dogtag(证书系统)，由web界面和命令行管理工具组成。

FreeIPA是一个用于Linux/UNIX网络环境的集成身份验证解决方案。FreeIPA服务器通过存储有关用户、组、主机和其他管理计算机网络安全方面所必需的对象的数据，提供集中的身份验证、授权和帐户信息。



## 二、freeIPA与AD域建立Trust要求

### Trust

使用FreeIPA作为中央服务器（类比AD域控制器）来控制Linux系统，然后与AD建立cross-realm Kerberos信任，使AD中的用户能够登录并使用单点登录来访问Linux系统和资源。

这个解决方案中，FreeIPA域将自己作为一个单独的forest呈现给AD，并利用AD支持的forest信任，使用Kerberos的功能在不同的身份源之间建立信任。

![1597038549047](IdM%E4%BB%8B%E7%BB%8D.assets/1597038549047.png)

建立trust的过程中需要AD域根域的 **domain admin** 或 **enterprise admin** 组中的一个成员用户与密码认证来建立trust。

### FreeIPA Domain

FreeIPA控制的Linux域类似于一个AD资源域或域，与现有的AD域建立trust，需要先创建一个独立于现有AD域的新FreeIPA Domain，例如名为：idm.cn.wal-mart.com的FreeIPA Domain。

### DNS Zone

在Windows中，每个域同时也是一个Kerberos realm和DNS domain，由域控制器管理的每个域都需要有自己的专用DNS zone。

freeIPA Domain也一样，也需要有一个与freeIPA Domain同名的新的DNS Zone专用于为FreeIPA控制的域提供DNS解析服务，包括一些IPA Server的A/PTR/SRV记录等信息。



## 其他问题

### 用户操作记录

### 用户信息改动的生效时间

如果AD域用户的密码做了修改，是可以马上生效的。

### 用户的有效性

假如用户在AD域中被删除/禁用，那么马上就无法继续登录客户端机器，不过在web界面管理中，之前添加的该用户还是需要自己手动去做处理。

### 二次认证能否集成赛门铁克认证