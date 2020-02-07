# Cobbler自动化部署操作系统



##  Author

```yaml
Name: Shinefire
Blog: https://github.com/shine-fire/Ops_Notes
E-mail: shine-fire@qq.com
```



## Cobbler Reference 



## Install Cobbler

**环境描述**

| 项目               | 名称                                 |
| :----------------- | ------------------------------------ |
| OS                 | CentOS Linux release 7.6.1810 (Core) |
| Cobbler            | Cobbler 2.8.4-4.el7                  |
| VMware WorkStation | 14.0.0 build-6661328                 |

**关闭selinux**

```bash
# setenforce 0
#sed –i '/^SELINUX=/c\SELINUX=disabled' /etc/selinux/config
```

**关闭防火墙**

```bash
# systemctl stop firewalld.service
```

**配置yum源**

```bash
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
```

**安装软件包**

```bash
# yum -y install cobbler cobbler-web fence-agents pykickstart
```

**启动服务**

```bash
[root@apt-2 repo]# systemctl start cobblerd.service    
[root@apt-2 repo]# systemctl start httpd.service 
```

**Cobbler check**

```bash
# cobbler check 
The following are potential configuration items that you may want to fix:

1 : The 'server' field in /etc/cobbler/settings must be set to something other than localhost, or kickstarting features will not work.  This should be a resolvable hostname or IP for the boot server as reachable by all machines that will use it.
2 : For PXE to be functional, the 'next_server' field in /etc/cobbler/settings must be set to something other than 127.0.0.1, and should match the IP of the boot server on the PXE network.
3 : change 'disable' to 'no' in /etc/xinetd.d/tftp
4 : Some network boot-loaders are missing from /var/lib/cobbler/loaders, you may run 'cobbler get-loaders' to download them, or, if you only want to handle x86/x86_64 netbooting, you may ensure that you have installed a *recent* version of the syslinux package installed and can ignore this message entirely.  Files in this directory, should you want to support all architectures, should include pxelinux.0, menu.c32, elilo.efi, and yaboot. The 'cobbler get-loaders' command is the easiest way to resolve these requirements.
5 : enable and start rsyncd.service with systemctl
6 : debmirror package is not installed, it will be required to manage debian deployments and repositories
7 : The default password used by the sample templates for newly installed machines (default_password_crypted in /etc/cobbler/settings) is still set to 'cobbler' and should be changed, try: "openssl passwd -1 -salt 'random-phrase-here' 'your-password-here'" to generate new one
```

**修复上述提示**

1. 修改 /etc/cobbler/settings 文件，将IP换成cobbler服务器端的IP

   ```bash
   # sed -i '/^next_server/{s/127.0.0.1/192.168.31.121/;p;q}' /etc/cobbler/settings
   ```

2. 修改 /etc/cobbler/settings 文件，将IP换成cobbler服务器端的IP

   ```bash
   # sed -i '/^server/{s/127.0.0.1/192.168.31.121/;p;q}' /etc/cobbler/settings
   ```

3. 修改配置 /etc/xinetd.d/tftp 文件

   ```bash
   # sed -i '/disable/{s/yes/no/;p;q}'  /etc/xinetd.d/tftp
   ```

4. 运行命令

   ```bash
   # cobbler get-loaders
   ```

5. 运行命令，根据实际情况看是否需要设置为开机自启动

   ```bash
    # systemctl start rsyncd.service
    # systemctl enable rsyncd.service
   ```

6. 部署debian相关的，目前可以忽略，因为用不着

7. 创建加密密码，使用 `# openssl passwd -1 -salt 'suiyitianxie' 'redhat' ` 命令即可。

   ```bash
   # openssl passwd -1 -salt 'suiyitianxie' 'redhat' 
   $1$suiyitia$6u/UI5bW1iuw/0x6TvAHa1
   ```

   redhat为密码，suiyitianxie为干扰码，然后会得到一串加密字符，填写到 setting 配置文件中去，将 **default_password_crypted** 这个参数的值设置为创建的加密密码即可。

8. 其他，配置 /etc/cobbler/settings

   ```bash
   # sed -i '/^manage_dhcp/{s/0/1/;p;q}' /etc/cobbler/settings
   # sed -i '/^manage_dns/{s/0/1/;p;q}' /etc/cobbler/settings
   # sed -i '/^manage_tftpd/{s/0/1/;p;q}' /etc/cobbler/settings
   # sed -i '/^restart_dhcp/{s/0/1/;p;q}' /etc/cobbler/settings
   # sed -i '/^restart_dns/{s/0/1/;p;q}' /etc/cobbler/settings
   # sed -i '/^pxe_just_once/{s/0/1/;p;q}' /etc/cobbler/settings
   ```

**重启服务**

```bash
# systemctl restart cobblerd.service
# cobbler sync

task started: 2019-08-01_170150_sync
task started (id=Sync, time=Thu Aug  1 17:01:50 2019)
running pre-sync triggers
cleaning trees
removing: /var/lib/tftpboot/grub/images
copying bootloaders
trying hardlink /var/lib/cobbler/loaders/pxelinux.0 -> /var/lib/tftpboot/pxelinux.0
trying hardlink /var/lib/cobbler/loaders/menu.c32 -> /var/lib/tftpboot/menu.c32
trying hardlink /var/lib/cobbler/loaders/yaboot -> /var/lib/tftpboot/yaboot
trying hardlink /usr/share/syslinux/memdisk -> /var/lib/tftpboot/memdisk
trying hardlink /var/lib/cobbler/loaders/grub-x86.efi -> /var/lib/tftpboot/grub/grub-x86.efi
trying hardlink /var/lib/cobbler/loaders/grub-x86_64.efi -> /var/lib/tftpboot/grub/grub-x86_64.efi
copying distros to tftpboot
copying images
generating PXE configuration files
generating PXE menu structure
rendering TFTPD files
generating /etc/xinetd.d/tftp
cleaning link caches
running post-sync triggers
running python triggers from /var/lib/cobbler/triggers/sync/post/*
running python trigger cobbler.modules.sync_post_restart_services
running shell triggers from /var/lib/cobbler/triggers/sync/post/*
running python triggers from /var/lib/cobbler/triggers/change/*
running python trigger cobbler.modules.manage_genders
running python trigger cobbler.modules.scm_track
running shell triggers from /var/lib/cobbler/triggers/change/*
*** TASK COMPLETE ***
```



## Cobbler Usage

### mount image

```bash
# mkdir /mnt/rhel76
# mount -o loop /dev/cdrom  /centos76
```

### import image

```bash
# mount -o loop rhel-server-7.6-x86_64-dvd.iso /mnt/rhel76/
```

### Cobbler Commands

- cobbler list

  ```bash
  # cobbler list
  distros:
     rhel76-x86_64
  profiles:
     rhel76-x86_64
  systems:
  repos:
  images:
  mgmtclasses:
  packages:
  files:
  ```

  cobbler list 列出的几个选项都会有相对应的命令

- distro相关命令

  ```bash
  # cobbler distro
  usage
  =====
  cobbler distro add
  cobbler distro copy
  cobbler distro edit
  cobbler distro find
  cobbler distro list
  cobbler distro remove
  cobbler distro rename
  cobbler distro report
  ```

  cobbler distro remove 可以移除指定的 distro，不过需要先移除相关的profile

  cobbler distro report 可以查看指定的 distro 详情

- profile相关命令

  ```bash
  # cobbler profile
  usage
  =====
  cobbler profile add
  cobbler profile copy
  cobbler profile dumpvars
  cobbler profile edit
  cobbler profile find
  cobbler profile getks
  cobbler profile list
  cobbler profile remove
  cobbler profile rename
  cobbler profile report
  ```

- repo 相关命令

  ```bash
  # cobbler repo
  usage
  =====
  cobbler repo add
  cobbler repo copy
  cobbler repo edit
  cobbler repo find
  cobbler repo list
  cobbler repo remove
  cobbler repo rename
  cobbler repo report
  ```

- `cobbler profile add` 为指定的镜像添加新自定义的 profile

  ```bash
  # cobbler profile add --name=test --distro=centos76-x86_64 --kickstart=/var/lib/cobbler/kickstarts/test.ks
  # cobbler list
  distros:
     rhel76-x86_64
  profiles:
     rhel76-x86_64
     test
  systems:
  repos:
  images:
  mgmtclasses:
  packages:
  files:
  ```

- `cobbler profile remove` 删除一个指定的 profile

  ```bash
  # cobbler profile remove --name=test
  # cobbler list
  distros:
     rhel76-x86_64
  profiles:
     rhel76-x86_64
  ```

- `cobbler profile edit` 修改profile的Kickstart

  ```bash
  # cobbler profile edit --name=rhel76-x86_64 --kickstart=/var/lib/cobbler/kickstarts/test.ks
  ```

### Kickstar Configuration

参考 kickstart.md

### DHCP Configuration 

文件配置

重启DHCP



## Deployment Client 

注意： *虚拟机网卡采用NAT模式，不要使用桥接模式，因为稍后我们会搭建DHCP服务器，在同一局域网多个DHCP服务会有冲突。* VMware的NAT模式的dhcp服务也关闭，避免干扰。





## Questions

- cobbler在企业中的通用性

  突然在想，如果只有一个cobbler服务器的话，如果在比较复杂的网络环境中，还能够适用吗？  
  会不会因为复杂的网络环境导致很多区域内的服务器无法从cobbler server这里通过DHCP进行IP分配以及获取需要的RPM等  
  另外就是如果不同的网段的话，怎么办？cobbler中的DHCP已经是指定了网段的，总不可能每个网段搭建一个cobbler server端吧，难道不同的网段安装机器就重新对cobbler服务端的DHCP重新进行设置吗？还是有什么其他更方便的方式去解决。

## References Documents 

- 使用Cobbler自动化和管理系统安装<https://www.ibm.com/developerworks/cn/linux/l-cobbler/index.html>
- kickstart无人值守安装 https://www.zyops.com/autoinstall-kickstart/
- kickstart配置文件 https://www.jianshu.com/p/2d12b187be7e





