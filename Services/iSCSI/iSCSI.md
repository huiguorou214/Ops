# iSCSI部署与使用

> 本章节主要介绍在RHEL7操作系统上部署iSCSI服务，以及客户端如何使用iSCSI。另外简述了RHEL6中使用iSCSI的基本流程。
>
> 注意RHEL7中部署iSCSI与RHEL6比起来有一些区别，RHEL7中好像需要使用**targetcli**这个命令行工具来对server端进行管理，在RHEL6中是直接编辑配置文件即可，还需要再找找RHEL7是否可以直接通过编辑配置文件来实现。

## Author

```
Name:Shinefire
Blog:https://github.com/shine-fire/Ops_Notes
E-mail:shine_fire@outlook.com
```

## 原理介绍

早期的企业使用的服务器若有大容量磁盘的需求时，通常是透过 SCSI 来串接 SCSI 磁盘，因此服务器上面必须要加装 SCSI 适配卡，而且这个 SCSI 是专属于该服务器的。后来这个外接式的 SCSI 设备被上述提到的 SAN 的架构所取代， 在 SAN 的标准架构下，虽然有很多的服务器可以对同一个 SAN 进行存取的动作，不过为了速度需求，通常使用的是光纤信道。 但是光纤信道就是贵嘛！不但设备贵，服务器上面也要有光纤接口，很麻烦～所以光纤的 SAN 在中小企业很难普及啊～

后来网络实在太普及，尤其是以 IP 封包为基础的 LAN 技术已经很成熟，再加上以太网络的速度越来越快， 所以就有厂商将 SAN 的连接方式改为利用 IP 技术来处理。然后再透过一些标准的订定，最后就得到 Internet SCSI (iSCSI) 这玩意的产生啦！iSCSI 主要是透过 TCP/IP 的技术，将储存设备端透过 iSCSI target (iSCSI 目标) 功能，做成可以提供磁盘的服务器端，再透过 iSCSI initiator (iSCSI 初始化用户) 功能，做成能够挂载使用 iSCSI target 的客户端，如此便能透过 iSCSI 协议来进行磁盘的应用了 ([注3](http://cn.linux.vbird.org/linux_server/0460iscsi.php#ps3))。

也就是说，iSCSI 这个架构主要将储存装置与使用的主机分为两个部分，分别是：

- iSCSI target：就是储存设备端，存放磁盘或 RAID 的设备，目前也能够将 Linux 主机仿真成 iSCSI target 了！目的在提供其他主机使用的『磁盘』；

  

- iSCSI initiator：就是能够使用 target 的客户端，通常是服务器。 也就是说，想要连接到 iSCSI target 的服务器，也必须要安装 iSCSI initiator 的相关功能后才能够使用 iSCSI target 提供的磁盘就是了。

如下图所示，**iSCSI 是在 TCP/IP 上面所开发出来的一套应用**，所以得要有网络才行啊！

 ![img](iSCSI.assets/iscsi.gif) 

> 以上（本段摘抄自鸟哥的Linux私房菜）



## RHEL7配置iSCSI步骤

### 环境说明

### 服务端配置iSCSI

1. 安装rpm包

   ```bash
   [root@iscsi ~]# yum install targetcli targetd -y
   ```

2. 配置初始密码，否则可能会启动失败，以下示例在`password:`后面加一个密码

   ```bash
   [root@iscsi ~]# vim /etc/target/targetd.yaml
   ...
   password: 123456
   ...
   ```

4. 新添加磁盘并进行分区

   > 测试使用的是VMware创建的虚拟机，并添加了新的磁盘来进行测试；
   >
   > 这一步跳过，直接对整块新添加的磁盘全部空间分到了一个区

5. 添加创建的分区到资源池中

   > 把刚才新创建的分区加入到“资源池”中，并将该文件重新命名为disk0，这样用户就不会知道是由服务器中的哪块硬盘来提供共享存储资源，而只会看到一个名为disk0的存储设备。
   >
   > 根据红帽官方的说法： The block driver allows the use of any block device that appears in the `/sys/block` to be used with LIO. This includes physical devices (for example, HDDs, SSDs, CDs, DVDs) and logical devices (for example, software or hardware RAID volumes, or LVM volumes). 
   >
   > 所以新创建的分区需要在`backstores/block`中去创建
   
   ```bash
   [root@iscsi ~]# targetcli
   /> ls 
   o- / ......................................................................... [...]
    o- backstores .............................................................. [...]
    | o- block .................................................. [Storage Objects: 0]
    | o- fileio ................................................. [Storage Objects: 0]
    | o- pscsi .................................................. [Storage Objects: 0]
    | o- ramdisk ................................................ [Storage Objects: 0]
    o- iscsi ............................................................ [Targets: 0]
    o- loopback ......................................................... [Targets: 0]
   /> backstores/block create name=disk0 dev=/dev/sdb1 
   Created block storage object disk0 using /dev/sdb1.
   /> ls 
   o- / ......................................................................... [...]
    o- backstores .............................................................. [...]
    | o- block .................................................. [Storage Objects: 1]
    | | o- disk0 ........................ [/dev/sdb1 (20.0GiB) write-thru deactivated]
    | |   o- alua ................................................... [ALUA Groups: 1]
    | |     o- default_tg_pt_gp ....................... [ALUA state: Active/optimized]
    | o- fileio ................................................. [Storage Objects: 0]
    | o- pscsi .................................................. [Storage Objects: 0]
    | o- ramdisk ................................................ [Storage Objects: 0]
    o- iscsi ............................................................ [Targets: 0]
   o- loopback ......................................................... [Targets: 0]
   ```
   
6.  创建iSCSI target名称及配置共享资源

   ```bash
   /> cd iscsi 
   /iscsi> create 
   Created target iqn.2003-01.org.linux-iscsi.iscsi.x8664:sn.620b14fe195f.
   Created TPG 1.
   Global pref auto_add_default_portal=true
   Created default portal listening on all IPs (0.0.0.0), port 3260.
   /iscsi> cd iqn.2003-01.org.linux-iscsi.iscsi.x8664:sn.620b14fe195f/
   /iscsi/iqn.20....620b14fe195f> ls 
   o- iqn.2003-01.org.linux-iscsi.iscsi.x8664:sn.620b14fe195f ............... [TPGs: 1]
     o- tpg1 ................................................... [no-gen-acls, no-auth]
       o- acls .............................................................. [ACLs: 0]
       o- luns .............................................................. [LUNs: 0]
       o- portals ........................................................ [Portals: 1]
         o- 0.0.0.0:3260 ......................................................... [OK] 
   /iscsi/iqn.20....620b14fe195f> cd tpg1/luns 
   /iscsi/iqn.20...95f/tpg1/luns> create /backstores/block/disk0 
   Created LUN 0.
   /iscsi/iqn.20...95f/tpg1/luns> ls 
   o- luns .................................................................. [LUNs: 1]
     o- lun0 ............................. [block/disk0 (/dev/sdb1) (default_tg_pt_gp)]
   ```

   注意：*默认create的是系统命名的，也可以自己创建一个指定名称的，例：*

   ```bash
   /iscsi > create iqn.2006-04.com.example:444
   Created target iqn.2006-04.com.example:444
   Created TPG1
   ```

7. 配置acl

   这一步酌情添加吧，应该是可以不设置ACL也行的，暂时未进行验证。

   更多关于ACL的可以看一下： https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/storage_administration_guide/online-storage-management#target-setup-configure-acl 

   ```bash
   /iscsi/iqn.20...95f/tpg1/acls> create iqn.2003-01.org.linux-iscsi.iscsi.x8664:sn.620b14fe195f
   Created Node ACL for iqn.2003-01.org.linux-iscsi.iscsi.x8664:sn.620b14fe195f
   Created mapped LUN 0.
   ```

8. 修改portals

   > 指名向客户端提供服务的IP地址与端口，默认使用3260端口
   >
   > 使用两个网卡写两个IP地址来实现高可用，在一个网卡出现故障的时候另外一个网卡还能继续提供服务

   ```bash
   /iscsi/iqn.20...14fe195f/tpg1> cd portals/
   /iscsi/iqn.20.../tpg1/portals> ls 
   o- portals ............................................................ [Portals: 1]
     o- 0.0.0.0:3260 ............................................................. [OK]
   /iscsi/iqn.20.../tpg1/portals> delete 0.0.0.0 3260
   Deleted network portal 0.0.0.0:3260
   /iscsi/iqn.20.../tpg1/portals> create 192.168.31.228    <== 本机IP
   Using default IP port 3260
   Created network portal 192.168.31.228:3260.
   /iscsi/iqn.20.../tpg1/portals> create 192.168.31.229    <== 写两个IP来做高可用
   Using default IP port 3260
   Created network portal 192.168.31.229:3260.
   ```

9. 启动服务

   ```bash
   [root@iscsi ~]# systemctl enable target --now
   ```
   
9. 关闭/配置防火墙

   > 需要放行3260端口

   ```bash
   firewall-cmd --permanent --add-port=3260/tcp
   firewall-cmd --reload
   ```

### 客户端配置iSCSI

1. 安装软件包

   ```bash
   [root@nuc ~]# yum install iscsi-initiator-utils -y
   ```

2. 配置initiatorname.iscsi（如果服务端设置了ACL，就把ACL的那一段在这里写入）

   ```bash
   [root@nuc ~]# cat /etc/iscsi/initiatorname.iscsi
   iqn.2003-01.org.linux-iscsi.iscsi.x8664:sn.620b14fe195f
   ```

3. 启动服务

   ```bash
   [root@nuc ~]# systemctl restart iscsid.service
   ```

4. 发现目标

   ```bash
   [root@nuc ~]# iscsiadm -m discovery -t st -p 192.168.31.229
   192.168.31.228:3260,1 iqn.2003-01.org.linux-iscsi.iscsi.x8664:sn.620b14fe195f
   192.168.31.229:3260,1 iqn.2003-01.org.linux-iscsi.iscsi.x8664:sn.620b14fe195f
   ```

5. 登录，两个IP都登录一遍

   ```bash
   [root@nuc ~]# iscsiadm -m node -T iqn.2003-01.org.linux-iscsi.iscsi.x8664:sn.620b14fe195f -p 192.168.31.228 -l
   Logging in to [iface: default, target: iqn.2003-01.org.linux-iscsi.iscsi.x8664:sn.620b14fe195f, portal: 192.168.31.228,3260] (multiple)
   Login to [iface: default, target: iqn.2003-01.org.linux-iscsi.iscsi.x8664:sn.620b14fe195f, portal: 192.168.31.229,3260] successful.
   [root@nuc ~]# iscsiadm -m node -T iqn.2003-01.org.linux-iscsi.iscsi.x8664:sn.620b14fe195f -p 192.168.31.229 -l
   Logging in to [iface: default, target: iqn.2003-01.org.linux-iscsi.iscsi.x8664:sn.620b14fe195f, portal: 192.168.31.229,3260] (multiple)
   Login to [iface: default, target: iqn.2003-01.org.linux-iscsi.iscsi.x8664:sn.620b14fe195f, portal: 192.168.31.229,3260] successful.
   ```

6. fdisk查看，可以看到多了target共享的磁盘


### iSCSI的CHAP用法

服务端配置

```bash
# targetcli
# / cd /iscsi/iqn.2017-02.local.target.server:disk2/tpg1/acls/iqn.2017-02.local.intiator.server:client/
# set auth userid=redhat password=redhat
```

客户端配置

```bash
[root@rhv-h1 ~]# vim /etc/iscsi/iscsid.conf
node.session.auth.authmethod = CHAP

# To set a CHAP username and password for initiator
# authentication by the target(s), uncomment the following lines:
node.session.auth.username = redhat
node.session.auth.password = redhat
[root@rhv-h1 ~]# systemctl restart iscsi
[root@rhv-h1 ~]# systemctl restart iscsid
```

## RHEL6中配置iSCSI概述

### 服务端

1. 安装scsi-target-utils
2. 创建好需要用来给客户端使用的分区（分区/未分区磁盘/dd出来的大文件都行）
3. 修改配置文件，配置指定target名称以及所包含的分区路径，以及对客户端的限制，例如只允许指定网段访问，还有指定客户端的登录用户和密码等
4. 启动服务
5. 修改防火墙/iptables配置（如若有必要）

### 客户端

1. 安装iscsi-initiator-utils 
2. 修改/etc/iscsi/iscsid.conf配置文件指定target和登录需要的用户密码
3. 使用iscsiadm命令去发现target可挂载源
4. 启动iscsi服务
5. 登录指定的target
6. 当做本地分区一样进行使用即可

## 参考文献

- [网络驱动器装置： iSCSI 服务器](http://linux.vbird.org/linux_server/0460iscsi.php)
- [使用iSCSI服务部署网络存储](https://www.linuxprobe.com/chapter-17.html)
- [RHEL7 配置iSCSI模拟环境](https://www.cnblogs.com/jyzhao/p/9349846.html)
- [redhat官方文档](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html-single/storage_administration_guide/index#online-storage-management)
- [configure iscsi initiator with CHAP authentication in RHEL 7](https://access.redhat.com/solutions/3056021)

## 疑问

- RHEL7配置iSCSI中，ACL那一步的作用于client的意义是什么？  参考： https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/storage_administration_guide/online-storage-management#target-setup-configure-acl 

  


