# Kickstart



## Author

```
Name: Shinefire
Blog: https://github.com/shine-fire/Ops_Notes
E-mail: shine-fire@qq.com
```



## Configuration Description 

- kickstart模板

  ```
  #platform=x86, AMD64, or Intel EM64T
  #version=DEVEL
  
  # 关闭防火墙
  # Firewall configuration
  firewall --disabled
  
  # 指定每次都为全新安装，默认选项
  # Install OS instead of upgrade
  install
  
  #指定装树(镜像的路径)，支持ftp协议、http协议
  # Use network installation
  url --url="http://172.16.0.1/centos6/"          
  url --url="ftp://172.16.0.1/centos6/"           #指定装树(镜像的路径)
  
  # root 的密码，经过加密后的密码
  # Root password
  rootpw --iscrypted $6$dGARWYghrvhD9W7P$4af2uw8A4tHvNLe2F6bDrk0J69dt.uYoV4SneKG4kzIsc/nF3JpfnuHg7D5lVE.jxC3p6.K29FCjwtom9VXWf.
  
  # 定义用户的默认认证加密方式
  # System authorization information
  auth  --useshadow  --passalgo=sha512
  
  # 安装方式，text为命令行界面安装
  # Use text mode install
  text
  firstboot --disable
  
  # 设定键盘的布局
  # System keyboard
  keyboard us
  
  # 操作系统语言
  # System language
  lang en_US
  
  # 关闭SELinux
  # SELinux configuration
  selinux --disabled
  
  # 安装时的日志记录路径，日志记录等级
  # Installation logging level
  logging --level=info --host=172.16.0.1
  
  # 安装完毕后重启
  # Reboot after installation
  reboot
  
  # 设置时区，时间
  # System timezone
  timezone  Asia/Shanghai
  
  # bootloader相关参数的设定
  # System bootloader configuration
  bootloader --append="rhgb crashkernel=auto quiet" --location=mbr --driveorder="sda"
  
  # 清除MBR分区表
  # Clear the Master Boot Record
  zerombr
  
  # 清除磁盘上的数据。旧磁盘可能会有其他数据谨慎操作。
  # Partition clearing information
  clearpart --all  
  
  # 对磁盘进行分区
  # Disk partitioning information
  part /boot --fstype="ext4" --size=200
  part pv.008 --size=61440
  volgroup vg0 --pesize=8192 pv.008
  logvol / --fstype=ext4 --name=root --vgname=vg0 --size=20480
  logvol swap --name=swap --vgname=vg0 --size=2048
  logvol /usr --fstype=ext4 --name=usr --vgname=vg0 --size=10240
  logvol /var --fstype=ext4 --name=var --vgname=vg0 --size=20480
  
  # 需要安装的软件包，安装前要确认安装源重定义的镜像存在此软件包。%packages开始 %end结束
  %packages    
  @base
  @basic-desktop
  @chinese-support
  @client-mgmt-tools
  @core
  @desktop-platform
  @fonts
  @general-desktop
  @graphical-admin-tools
  @legacy-x
  @network-file-system-client
  @perl-runtime
  @remote-desktop-clients
  @x11
  func
  lftp
  ibus-table-cangjie
  ibus-table-erbi
  ibus-table-wubi
  puppet
  %end
  
  # 安装完毕后指定的代码，可以将一些需要初始化定义的脚本写在这里。
  # %post 开始、%end结束
  %post
  wget -O /tmp/optimization.sh http://10.0.0.7/ks_config/optimization.sh &>/dev/null
  /bin/sh /tmp/optimization.sh
  %end
  ```

- 配置项说明

  https://www.zyops.com/autoinstall-kickstart/



## Kickstart Configurator

Kickstart Configurator 是一个可以用来生成ks配置文件的图形工具

### Install

```
# yum -y install system-config-kickstart
```

### Usage

```

```



## Templates

My RHEL7

```
# version=RHEL7
# System authorization information
auth --useshadow --enablemd5
# Install OS instead of upgrade
install
# Reboot after installation
reboot
# Use CDROM installation media
# cdrom
# Use network install os
url --url=""
# Firewall configuration
firewall --enabled
firstboot --disable
ignoredisk --only-use=sda
# Keyboard layouts
# old format: keyboard us
# new format:
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp
network  --hostname=localhost.localdomain
# Root password
rootpw --iscrypted $1$suiyitia$6u/UI5bW1iuw/0x6TvAHa1
# System services
services --enabled="chronyd"
# System timezone
timezone Asia/Shanghai --isCST
# X Window System configuration information
xconfig  --startxonboot
# System bootloader configuration
bootloader --location=mbr --boot-drive=sda
# Clear the Master Boot Record
zerombr
# Partition clearing information
clearpart --all --initlabel 
# Disk partitioning information
part swap --fstype="swap" --size=1056
part /boot --fstype="xfs" --size=300
part / --fstype="xfs" --size=19123

%post
/usr/sbin/adduser apt
/usr/sbin/usermod -p '$1$nf$pXv7cZIcqPqhKI6MamNOc/' apt
/usr/bin/chfn -f "apt" apt
mv /etc/rc.d/rc.local /etc/rc.d/rc.local.00
echo '#!/bin/bash' > /etc/rc.d/rc.local
ln -s ../rc.local /etc/rc.d/rc5.d/S99rclocal
chmod 755 /etc/rc.d/rc.local
echo 'mkdir -p /var/log/vmware' >> /etc/rc.d/rc.local
echo 'exec 1> /var/log/vmware/rc.local.log' >> /etc/rc.d/rc.local
echo 'exec 2>&1' >> /etc/rc.d/rc.local
echo 'set -x' >> /etc/rc.d/rc.local
echo 'echo Installing Open VM Tools' >> /etc/rc.d/rc.local
echo 'set -x' >> /etc/rc.d/rc.local
echo '/bin/eject sr0 || /bin/true' >> /etc/rc.d/rc.local
echo '/bin/eject sr1 || /bin/true' >> /etc/rc.d/rc.local
echo '/bin/vmware-rpctool' \'guest.upgrader_send_cmd_line_args --default\' >> /etc/rc.d/rc.local
echo '/bin/vmware-rpctool' \'upgrader.setGuestFileRoot /tmp\' >> /etc/rc.d/rc.local
echo '/bin/vmware-rpctool' \'toolinstall.installerActive 1\' >> /etc/rc.d/rc.local
echo '/bin/vmware-rpctool' \'toolinstall.installerActive 100\' >> /etc/rc.d/rc.local
echo 'rm -f /etc/rc.d/rc.local' >> /etc/rc.d/rc.local
echo 'rm -f /etc/rc.d/rc5.d/S99rclocal' >> /etc/rc.d/rc.local
echo 'mv /etc/rc.d/rc.local.00 /etc/rc.d/rc.local' >> /etc/rc.d/rc.local
/bin/echo done
%end

%packages
@base
@core
@guest-desktop-agents
binutils
chrony
ftp
gcc
kernel-devel
make
open-vm-tools
patch
python

%end
```



## 参考博客

- kickstart配置文件详解和system-config-kickstart https://blog.csdn.net/taiyang1987912/article/details/42176709
- [KICKSTART INSTALLATIONS](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/installation_guide/chap-kickstart-installations)