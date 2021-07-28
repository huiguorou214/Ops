## kernel升级方案

> 本章介绍如何在提供了修复kernel漏洞的rpm包情况下对RHEL系统中的kernel进行升级。
>



[TOC]

---

### 前言

在有安全要求需要对安全漏洞进行修复的场景中，会经常遇到需要对kernel安全漏洞进行修复的情况。对于安全漏洞修复，一般有如下几种情况来进行补丁更新修复安全漏洞：

1. 通过订阅yum源来直接联网update最新的或者指定的kernel版本进行补丁修复。这种方法虽然是最简单的，但是一般比较少用，因为主要都是内网环境不太能联网；
2. 通过供应商提供最新的yum仓库来更新内网yum源仓库后，需要修复漏洞的服务器直接从内网yum源中update kernel来进行修复。这种方法也比较简单，但是用得还是会比较少，一般更新最新的yum仓库频率比较低，yum仓库中不一定包含修复安全漏洞的补丁；
3. 通过供应商提供最新/能够修复指定安全漏洞的rpm包来进行漏洞修复，只需要提供相应的几个rpm包即可达到修复安全漏洞的效果。这种方法比较麻烦一点点，但是应用场景可能会比较多，下面的升级方案则是针对此种情况编写。



### kernel升级方案

1. 将供应商提供的kernel补丁修复tar包上传到服务器中，例如'/tmp'目录

2. 对tar包进行解压，例如解压后的路径为'/tmp/kernel_update'

   ```bash
   [root@localhost ~]# ls /tmp/kernel_update
   dracut-004-411.el6.noarch.rpm
   dracut-kernel-004-411.el6.noarch.rpm
   kernel-2.6.32-754.35.1.el6.x86_64.rpm
   kernel-debug-2.6.32-754.35.1.el6.x86_64.rpm
   kernel-debug-devel-2.6.32-754.35.1.el6.x86_64.rpm
   kernel-devel-2.6.32-754.35.1.el6.x86_64.rpm
   kernel-doc-2.6.32-754.35.1.el6.noarch.rpm
   kernel-firmware-2.6.32-754.35.1.el6.noarch.rpm
   kernel-headers-2.6.32-754.35.1.el6.x86_64.rpm
   repodata
   ```

   > 注意：如果解压后的tar包里面并不包含repodata目录，则需要自己用createrepo命令在目录下自己生成一下，否则后面创建了repo文件也无法使用这个yum仓库进行更新。

3. 创建一个临时的本地yum repo文件，指定tar包解压后的路径

   ```bash
   [root@localhost ~]# vim /etc/yum.repos.d/kernel_update.repo
   [kernel_update]
   name=kernel_update
   baseurl=file:///tmp/kernel_update
   enabled=1
   gpgcheck=0
   ```

4. 清除yum缓存，使用repolist选项检查是否已经添加了新的本地kernel repo

   ```bash
   [root@localhost ~]# yum clean all
   [root@localhost ~]# yum repolist
   ```

5. 记录当前kernel相关rpm包版本，在后面如果要回退了可能会用得上

   ```bash
   [root@localhost ~]# rpm -qa | grep kernel*
   ```

6. 执行'yum update'命令来指定新配置的临时yum源来升级内核，例：

   ```bash
   [root@localhost ~]# yum update kernel-* --disablerepo=* --enablerepo=kernel_update
   ```

7. 重启操作系统来加载新kernel的模块，如果时间不方便可以放在合适的时间窗口再进行重启操作。

8. 执行`uname -r`命令检查内核升级是否成功

   ```bash
   [root@localhost ~]# uname -r
   2.6.32-754.35.1.el6.x86_64
   ```

9. 删除临时配置的repo文件

   ```bash
   [root@localhost ~]# rm -f /etc/yum.repos.d/kernel_update.repo
   [root@localhost ~]# yum clean all
   [root@localhost ~]# yum makecache
   ```



### kernel升级后异常回退方案

如果在升级之后，发现现有的业务因为升级而出现异常情况的话，可以通过下面的方法回退kernel。

#### RHEL7

1. 查看当前默认启动的kernel

   ```bash
   [root@centos75-ori ~]# grub2-editenv list
   saved_entry=CentOS Linux (3.10.0-1160.36.2.el7.x86_64) 7 (Core)
   ```

2. 查看所有启动可选kernel

   ```bash
   [root@centos75-ori ~]# cat /boot/grub2/grub.cfg | grep menuentry
   if [ x"${feature_menuentry_id}" = xy ]; then
     menuentry_id_option="--id"
     menuentry_id_option=""
   export menuentry_id_option
   menuentry 'CentOS Linux (3.10.0-1160.36.2.el7.x86_64) 7 (Core)' --class centos --class gnu-linux --class gnu --class os --unrestricted $menuentry_id_option 'gnulinux-3.10.0-862.el7.x86_64-advanced-2cb80fdc-cabc-4bea-a7e3-4e020fa818a5' {
   menuentry 'CentOS Linux (3.10.0-862.el7.x86_64) 7 (Core)' --class centos --class gnu-linux --class gnu --class os --unrestricted $menuentry_id_option 'gnulinux-3.10.0-862.el7.x86_64-advanced-2cb80fdc-cabc-4bea-a7e3-4e020fa818a5' {
   menuentry 'CentOS Linux (0-rescue-12e744bac0d64d56b5d0c8111ad5a7f1) 7 (Core)' --class centos --class gnu-linux --class gnu --class os --unrestricted $menuentry_id_option 'gnulinux-0-rescue-12e744bac0d64d56b5d0c8111ad5a7f1-advanced-2cb80fdc-cabc-4bea-a7e3-4e020fa818a5' {
   ```

3. 根据列出来的可选项选择升级前的kernel版本作为默认启动kernel

   ```bash
   [root@centos75-ori ~]# grub2-set-default 'CentOS Linux (3.10.0-862.el7.x86_64) 7 (Core)'
   [root@centos75-ori ~]# grub2-editenv list
   saved_entry=CentOS Linux (3.10.0-862.el7.x86_64) 7 (Core)
   ```

4. 重启操作系统

5. 回退其他kernel相关的软件包

   先使用`yum history list`命令查看yum的历史更新记录，如下图的结果中，可以简单判断上次更新kernel的历史ID号为3

   ```bash
   [root@localhost ~]# yum history list
   Loaded plugins: product-id, security, subscription-manager
   This system is not registered to Red Hat Subscription Management. You can use subscription-manager to register.
   ID     | Login user               | Date and time    | Action(s)      | Altered
   -------------------------------------------------------------------------------
        4 | root <root>              | 2021-03-11 18:06 | Erase          |    1
        3 | root <root>              | 2021-03-11 17:51 | I, U           |    4
        2 | root <root>              | 2021-03-11 17:49 | Install        |    3
        1 | System <unset>           | 2021-03-11 17:37 | Install        |  395
   history list
   ```

   > yum history list结果说明
   >
   > 以ID:3的这次操作为例，Action(s)这一列表示发生了I(install)和U(update)的操作，涉及到的数量就是'Altered'这一列标出的4个包
   >
   > 以ID:3的这次操作为例，Action(s)这一列表示发生了E(Erase)的操作，涉及到的数量就是'Altered'这一列标出的1个包

   可以使用`yum history info`命令来确认，示例如下：

   ```bash
   [root@localhost ~]# yum history info 3
   Loaded plugins: product-id, security, subscription-manager
   This system is not registered to Red Hat Subscription Management. You can use subscription-manager to register.
   Transaction ID : 3
   Begin time     : Thu Mar 11 17:51:01 2021
   Begin rpmdb    : 398:8d1f4d5af9cdbd7ca3f8cf62204fb6f604fab18f
   End time       :            17:51:29 2021 (28 seconds)
   End rpmdb      : 399:6fab97e98fa5eeb045dd0d813d07c93ab7469fad
   User           : root <root>
   Return-Code    : Success
   Command Line   : update kernel-*
   Transaction performed with:
       Installed     rpm-4.8.0-37.el6.x86_64                   @anaconda-RedHatEnterpriseLinux-201409260744.x86_64/6.6
       Installed     subscription-manager-1.12.14-7.el6.x86_64 @anaconda-RedHatEnterpriseLinux-201409260744.x86_64/6.6
       Installed     yum-3.2.29-60.el6.noarch                  @anaconda-RedHatEnterpriseLinux-201409260744.x86_64/6.6
   Packages Altered:
       Updated dracut-004-356.el6.noarch                  @anaconda-RedHatEnterpriseLinux-201409260744.x86_64/6.6
       Update         004-411.el6.noarch                  @kernel_update
       Updated dracut-kernel-004-356.el6.noarch           @anaconda-RedHatEnterpriseLinux-201409260744.x86_64/6.6
    Update                004-411.el6.noarch           @kernel_update
       Install kernel-2.6.32-754.35.1.el6.x86_64          @kernel_update
    Updated kernel-firmware-2.6.32-504.el6.noarch      @anaconda-RedHatEnterpriseLinux-201409260744.x86_64/6.6
       Update                  2.6.32-754.35.1.el6.noarch @kernel_update
   history info
   ```

   确认是个ID执行了更新内核的操作后，使用`yum history undo`命令来回退操作

   ```bash
   [root@localhost ~]# yum history undo 3
   ```

   **注意**：使用这种回退机制有一个必要条件：当前使用的yum源里面需要能够安装旧版本的rpm包



#### RHEL6

1. 指定默认从旧版本的kernel引导启动操作系统

   修改`/etc/grub.conf`文件，将`default=0`修改为`default=1`，来切换开机默认启动的kernel。

   **说明**：default=1，即将默认引导的内核换成`grub.conf`文件中的第二个title，一般情况下，更新后的kernel为第一个，上一个旧版本则为第二个。

2. 修改后直接重启操作系统

3. 移除新版本的kernel rpm

   ```bash
   [root@localhost ~]# rpm -qa | grep kernel-
   kernel-firmware-2.6.32-754.35.1.el6.noarch
   kernel-2.6.32-504.el6.x86_64
   kernel-2.6.32-754.35.1.el6.x86_64
   dracut-kernel-004-411.el6.noarch
   [root@localhost ~]# yum remove kernel-2.6.32-754.35.1.el6
   ```

4. 回退其他kernel相关的软件包

   先使用`yum history list`命令查看yum的历史更新记录，如下图的结果中，可以简单判断上次更新kernel的历史ID号为3

   ```bash
   [root@localhost ~]# yum history list
   Loaded plugins: product-id, security, subscription-manager
   This system is not registered to Red Hat Subscription Management. You can use subscription-manager to register.
   ID     | Login user               | Date and time    | Action(s)      | Altered
   -------------------------------------------------------------------------------
        4 | root <root>              | 2021-03-11 18:06 | Erase          |    1
        3 | root <root>              | 2021-03-11 17:51 | I, U           |    4
        2 | root <root>              | 2021-03-11 17:49 | Install        |    3
        1 | System <unset>           | 2021-03-11 17:37 | Install        |  395
   history list
   ```

   > yum history list结果说明
   >
   > 以ID:3的这次操作为例，Action(s)这一列表示发生了I(install)和U(update)的操作，涉及到的数量就是'Altered'这一列标出的4个包
   >
   > 以ID:3的这次操作为例，Action(s)这一列表示发生了E(Erase)的操作，涉及到的数量就是'Altered'这一列标出的1个包
   
      可以使用`yum history info`命令来确认
   
   ```bash
   [root@localhost ~]# yum history info 3
   Loaded plugins: product-id, security, subscription-manager
   This system is not registered to Red Hat Subscription Management. You can use subscription-manager to register.
   Transaction ID : 3
   Begin time     : Thu Mar 11 17:51:01 2021
   Begin rpmdb    : 398:8d1f4d5af9cdbd7ca3f8cf62204fb6f604fab18f
   End time       :            17:51:29 2021 (28 seconds)
   End rpmdb      : 399:6fab97e98fa5eeb045dd0d813d07c93ab7469fad
   User           : root <root>
   Return-Code    : Success
   Command Line   : update kernel-*
   Transaction performed with:
       Installed     rpm-4.8.0-37.el6.x86_64                   @anaconda-RedHatEnterpriseLinux-201409260744.x86_64/6.6
       Installed     subscription-manager-1.12.14-7.el6.x86_64 @anaconda-RedHatEnterpriseLinux-201409260744.x86_64/6.6
       Installed     yum-3.2.29-60.el6.noarch                  @anaconda-RedHatEnterpriseLinux-201409260744.x86_64/6.6
   Packages Altered:
       Updated dracut-004-356.el6.noarch                  @anaconda-RedHatEnterpriseLinux-201409260744.x86_64/6.6
       Update         004-411.el6.noarch                  @kernel_update
       Updated dracut-kernel-004-356.el6.noarch           @anaconda-RedHatEnterpriseLinux-201409260744.x86_64/6.6
    Update                004-411.el6.noarch           @kernel_update
       Install kernel-2.6.32-754.35.1.el6.x86_64          @kernel_update
    Updated kernel-firmware-2.6.32-504.el6.noarch      @anaconda-RedHatEnterpriseLinux-201409260744.x86_64/6.6
       Update                  2.6.32-754.35.1.el6.noarch @kernel_update
   history info
   ```
   
   确认是个ID执行了更新内核的操作后，使用`yum history undo`命令来回退操作
   
   ```bash
   [root@localhost ~]# yum history undo 3
   ```
   
   **注意**：使用这种回退机制有一个必要条件：当前使用的yum源里面需要能够安装旧版本的rpm包



#### RHEL5

RHEL5版本的操作系统在回退时，与之后的版本有一些区别，因为在RHEL5中还不能使用'yum history'命令来进行历史操作记录的管理，只能选择'yum downgrade'命令来进行rpm包的版本回退。

1. 指定默认从旧版本的kernel引导启动操作系统

   修改`/etc/grub.conf`文件，将`default=0`修改为`default=1`，来切换开机默认启动的kernel。

   **说明**：default=1，即将默认引导的内核换成`grub.conf`文件中的第二个title，一般情况下，更新后的kernel为第一个，上一个旧版本则为第二个。

2. 修改后直接重启操作系统

3. 移除新版本的kernel rpm，示例如下：

   ```bash
   [root@localhost ~]# rpm -qa | grep kernel-
   kernel-firmware-2.6.32-754.35.1.el5.noarch
   kernel-2.6.32-504.el5.x86_64
   kernel-2.6.32-754.35.1.el5.x86_64
   dracut-kernel-004-411.el5.noarch
   [root@localhost ~]# yum remove kernel-2.6.32-754.35.1.el5
   ```

4. 回退其他kernel相关的软件包

   执行`rpm -qa | grep kernel*`命令和升级前的结果最一个对比，看看升级了哪些rpm包。或者查看`/var/log/yum.log`文件确定升级的rpm包后进行回退

   回退命令，以回退`kernel-headers`rpm包为例：

   ```bash
   [root@localhost ~]# yum downgrade kernel-headers
   ```

   **注意**：使用这种回退机制有一个必要条件：当前使用的yum源里面需要能够安装旧版本的rpm包

 