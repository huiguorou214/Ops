# 新增网卡后自动生成ifcfg配置文件方法



本测试是在VMware Workstations中的RHEL7操作系统虚拟机中进行，为虚拟机新添加一个新添加一个网络适配器

添加完毕网络适配器之后，可以在系统中使用ip命令查看到新加的网卡，但是ifcfg配置文件是没有自动生成的：

```bash
[root@rhel76-ori ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:0c:29:46:2f:21 brd ff:ff:ff:ff:ff:ff
    inet 192.168.31.196/24 brd 192.168.31.255 scope global noprefixroute ens33
       valid_lft forever preferred_lft forever
    inet6 fe80::e7cc:dc62:7da1:33e6/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
3: ens38: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:0c:29:46:2f:2b brd ff:ff:ff:ff:ff:ff
[root@rhel76-ori ~]# ls /etc/sysconfig/network-scripts/
ifcfg-ens33  ifdown-isdn      ifdown-tunnel  ifup-isdn    ifup-Team
ifcfg-lo     ifdown-post      ifup           ifup-plip    ifup-TeamPort
ifdown       ifdown-ppp       ifup-aliases   ifup-plusb   ifup-tunnel
ifdown-bnep  ifdown-routes    ifup-bnep      ifup-post    ifup-wireless
ifdown-eth   ifdown-sit       ifup-eth       ifup-ppp     init.ipv6-global
ifdown-ippp  ifdown-Team      ifup-ippp      ifup-routes  network-functions
ifdown-ipv6  ifdown-TeamPort  ifup-ipv6      ifup-sit     network-functions-ipv6
```



使用nmcli命令查看当前的网络连接情况：

```bash
[root@rhel76-ori ~]# nmcli connection
NAME   UUID                                  TYPE      DEVICE
ens33  4f8a7bc2-a9c4-4e9d-82a3-3e18360798c9  ethernet  ens33
```



使用nmcli命令创建网络连接

```bash
[root@rhel76-ori ~]# nmcli connection add con-name 'static-ip' ifname ens38 type Ethernet ip4 192.168.31.200/24 gw4 192.168.31.254
Connection 'static-ip' (82a5c0f0-7149-42fa-984f-c718ee21bc2f) successfully added.
[root@rhel76-ori ~]# nmcli connection modify static-ip ipv4.dns 8.8.8.8
[root@rhel76-ori ~]# nmcli connection modify static-ip ipv4.method manual
[root@rhel76-ori ~]# nmcli connection modify static-ip connection.autoconnect yes
[root@rhel76-ori ~]# nmcli connection up static-ip
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/4)
```



创建完毕之后使用nmcli命令再次查看当前网络连接

```bash
[root@rhel76-ori ~]# nmcli connection
NAME       UUID                                  TYPE      DEVICE
ens33      4f8a7bc2-a9c4-4e9d-82a3-3e18360798c9  ethernet  ens33
static-ip  82a5c0f0-7149-42fa-984f-c718ee21bc2f  ethernet  ens38
```



再次查看ifcfg网卡配置文件，可以看到已经自动生成了新的配置文件

```bash
[root@rhel76-ori ~]# ls /etc/sysconfig/network-scripts/
ifcfg-ens33      ifdown-isdn      ifup          ifup-plusb     ifup-wireless
ifcfg-lo         ifdown-post      ifup-aliases  ifup-post      init.ipv6-global
ifcfg-static-ip  ifdown-ppp       ifup-bnep     ifup-ppp       network-functions
ifdown           ifdown-routes    ifup-eth      ifup-routes    network-functions-ipv6
ifdown-bnep      ifdown-sit       ifup-ippp     ifup-sit
ifdown-eth       ifdown-Team      ifup-ipv6     ifup-Team
ifdown-ippp      ifdown-TeamPort  ifup-isdn     ifup-TeamPort
ifdown-ipv6      ifdown-tunnel    ifup-plip     ifup-tunnel
```