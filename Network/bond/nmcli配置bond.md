## nmcli配置bond



### nmcli配置bond4

#### 测试环境说明

新添加了两块网卡，ens38 & ens39

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
    link/ether 00:0c:29:46:2f:35 brd ff:ff:ff:ff:ff:ff
4: ens39: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:0c:29:46:2f:2b brd ff:ff:ff:ff:ff:ff
```

#### nmcli命令配置bond4

nmcli命令查看当前的连接状态

```bash
[root@rhel76-ori ~]# nmcli device
DEVICE  TYPE      STATE         CONNECTION
ens33   ethernet  connected     ens33
ens38   ethernet  disconnected  --
ens39   ethernet  disconnected  --
lo      loopback  unmanaged     --
[root@rhel76-ori ~]# nmcli connection
NAME   UUID                                  TYPE      DEVICE
ens33  4f8a7bc2-a9c4-4e9d-82a3-3e18360798c9  ethernet  ens33
```

