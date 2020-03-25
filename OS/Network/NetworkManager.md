# NetworkManager

> 本章节主要以RHEL7为例讲解NetworkManager的一些使用方式，包括nmcli，nmtui等等。

[TOC]

## Author

```
Name:Shinefire
Blog:https://github.com/shine-fire/Ops_Notes
E-mail:shine_fire@qq.com
```



## 原理介绍

### 什么是NetworkManager？

网络管理器(NetworManager)是检测网络、自动连接网络的程序。无论是无线还是有线连接，它都可以令您轻松管理。对于无线网络,网络管理器优先连接已知的网络并可以自动切换到最可靠的无线网络。利用网络管理器的程序可以自由切换在线和离线模式。网络管理器会相对无线网络优先选择有线网络，支持 VPN。网络管理器最初由 Redhat 公司开发，现在由 GNOME 管理。

## nmcli

### 静态IP地址管理

#### 配置静态IP地址

```bash
# nmcli connection add con-name 'static-ip' ifname eth0 type Ethernet ip4 172.25.0.11/24 gw4 172.25.0.254
# nmcli connection modify static-ip ipv4.dns 172.25.254.254
# nmcli connection modify static-ip ipv4.method manual 
# nmcli connection modify static-ip connection.autoconnect yes
# nmcli connection up static-ip 
```

#### 修改静态IP地址

```bash
# nmcli connection modify eth0 ipv4.method manual ipv4.addresses "192.168.1.2/24"
# nmcli con up eth0
```

#### 通过修改配置文件来配置网络

```bash
# vim /etc/sysconfig/network-scripts/ifcfg-xxx
TYPE=Ethernet
BOOTPROTO=static
NAME=eno16777736
ONBOOT=yes
IPADDR=192.168.31.21
NETMASK=255.255.255.0
GATEWAY=192.168.31.1
DNS=192.168.31.1
# systemctl restart network
```



## 参考文献

