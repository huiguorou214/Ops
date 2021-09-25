## Docker Network



### Docker网络模式

docker中有四种网络模式：

- bridge（默认网络模式）
- host
- none
- 用户自定义网络



可以通过docker network ls命令来查看当前环境中存在的网络模式

```bash
[root@docker-test ~]# docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
66ae3aff96c3   bridge    bridge    local
740093df352b   host      host      local
3d2c2e0eba89   none      null      local
```



#### host网络

host网络模式，容器与宿主机共享网络地址，多个容器的话，需要解决端口冲突的问题，因为相当于是同一个IP地址上的端口了

```bash
[root@docker-test ~]# docker run -d --net host --name webserver1 httpd
956bccabb40a83e9a43bb0a77c77afe607442665147ec6ffcf05d4fab686bdd0
[root@docker-test ~]# netstat -nltup | grep 80
tcp6       0      0 :::80                   :::*                    LISTEN      306760/httpd  
```

如果再次启动使用同样端口的容器，则会因为端口冲突从而导致启动失败：

```bash
[root@docker-test ~]# docker run -d --net host --name webserver2 httpd:latest
f320b184051af59183b7909a49440bfc0aec39b839e0e6729b3f3b6aa776d5cb
[root@docker-test ~]# docker ps -a
CONTAINER ID   IMAGE          COMMAND              CREATED          STATUS                     PORTS                                     NAMES
f320b184051a   httpd:latest   "httpd-foreground"   8 seconds ago    Exited (1) 7 seconds ago                                             webserver2
5135df6dc743   httpd:latest   "httpd-foreground"   56 seconds ago   Up 55 seconds                                                        webserver1
[root@docker-test ~]# docker logs f320b184051a
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using docker-test.shinefire.com. Set the 'ServerName' directive globally to suppress this message
(98)Address already in use: AH00072: make_sock: could not bind to address [::]:80
(98)Address already in use: AH00072: make_sock: could not bind to address 0.0.0.0:80
no listening sockets available, shutting down
AH00015: Unable to open logs
```

提示`(98)Address already in use: AH00072: make_sock: could not bind to address [::]:80`

其他说明：因为





#### bridge网络

Docker默认的网络模式为bridge模式

使用iptables的snat转发实现对外访问（需要开启内核net.ipv4.ip_forward=1）

使用iptables的dnat端口映射实现外部访问容器



默认创建的容器都是能够正常网络访问：

```bash
[root@docker-test ~]# docker ps -aq | xargs docker rm -f
de9cc65a5c77
[root@docker-test ~]# docker run -it busybox /bin/sh
/ # ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
20: eth0@if21: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.2/16 brd 172.17.255.255 scope global eth0
       valid_lft forever preferred_lft forever
/ # ping baidu.com
PING baidu.com (220.181.38.251): 56 data bytes
64 bytes from 220.181.38.251: seq=0 ttl=48 time=41.385 ms
64 bytes from 220.181.38.251: seq=1 ttl=48 time=41.292 ms
^C
--- baidu.com ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 41.292/41.338/41.385 ms
/ # ip route
default via 172.17.0.1 dev eth0
172.17.0.0/16 dev eth0 scope link  src 172.17.0.2
```



查看宿主机的iptables中NAT表

```bash
[root@docker-test ~]# iptables -t nat -L
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination
DOCKER     all  --  anywhere             anywhere             ADDRTYPE match dst-type LOCAL

Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
DOCKER     all  --  anywhere            !loopback/8           ADDRTYPE match dst-type LOCAL

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
MASQUERADE  all  --  172.17.0.0/16        anywhere

Chain DOCKER (2 references)
target     prot opt source               destination
RETURN     all  --  anywhere             anywhere
```

通过查看NAT表的POSTROUTING链，可以看到有一条规则是会接受所有来自`172.17.0.0/16`这个网络的。 



ip命令查看一下宿主机的docker0网络

```bash
[root@docker-test ~]# ip addr show docker0
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:5a:44:3c:a3 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:5aff:fe44:3ca3/64 scope link
       valid_lft forever preferred_lft forever
```

在安装了docker之后，默认系统上会自动创建一个docker0的桥接模式网卡

也就是我们在创建容器的时候，不做任何设置的默认情况下，所有的容器都会默认的桥接到docker0这个网卡上。



#### none网络

啥也没有

```bash
[root@docker-test ~]# docker run -it --net none busybox /bin/sh
/ # ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
```





#### 用户自定义网络

Docker提供三种自定义网络驱动：

- bridge
- overlay，代表性的有[Flannel](./Flannel.md)
- macvlan



##### 创建自定义桥接模式网络

创建一个bridge模式的自定义网络：

```bash
[root@docker-test ~]# docker network create -d bridge my_net_bridge1
2070100d7e1d564d7fc398f05d0585360af84565dc23928200a5135681793361
[root@docker-test ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:c2:f5:0a brd ff:ff:ff:ff:ff:ff
    inet 192.168.31.91/24 brd 192.168.31.255 scope global noprefixroute eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fec2:f50a/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
3: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:5a:44:3c:a3 brd ff:ff:ff:ff:ff:ff
    inet 172.18.0.1/24 brd 172.18.0.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:5aff:fe44:3ca3/64 scope link
       valid_lft forever preferred_lft forever
25: veth4f684a4@if24: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP group default
    link/ether 6a:73:2f:6d:9e:24 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::6873:2fff:fe6d:9e24/64 scope link
       valid_lft forever preferred_lft forever
26: br-2070100d7e1d: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:86:c6:ac:33 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global br-2070100d7e1d
       valid_lft forever preferred_lft forever
```

自定义的桥接模式网络创建完毕之后可以看到宿主机上面又多了一个网卡`br-2070100d7e1d`

默认会总动从`127.17.0.1/16`开始，例如再创建一个就会是`127.17.0.2/16`



也可以指定子网与网关的方式来创建一个bridge网络：

```bash
[root@docker-test ~]# docker network create -d bridge --subnet 172.22.16.0/24 --gateway 172.22.16.1 my_net_bridge2
001d3c5ae84ef526f9b95cbf6f24df574ce6b1edcfa378bce83e5c2e1e35c226
[root@docker-test ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:c2:f5:0a brd ff:ff:ff:ff:ff:ff
    inet 192.168.31.91/24 brd 192.168.31.255 scope global noprefixroute eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fec2:f50a/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
3: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:5a:44:3c:a3 brd ff:ff:ff:ff:ff:ff
    inet 172.18.0.1/24 brd 172.18.0.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:5aff:fe44:3ca3/64 scope link
       valid_lft forever preferred_lft forever
25: veth4f684a4@if24: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP group default
    link/ether 6a:73:2f:6d:9e:24 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::6873:2fff:fe6d:9e24/64 scope link
       valid_lft forever preferred_lft forever
26: br-2070100d7e1d: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:86:c6:ac:33 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global br-2070100d7e1d
       valid_lft forever preferred_lft forever
27: br-001d3c5ae84e: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:3c:df:2e:96 brd ff:ff:ff:ff:ff:ff
    inet 172.22.16.1/24 brd 172.22.16.255 scope global br-001d3c5ae84e
       valid_lft forever preferred_lft forever
```



指定网络创建容器

```bash
[root@docker-test ~]# docker run -it --network my_net_bridge2 busybox
/ # ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
28: eth0@if29: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue
    link/ether 02:42:ac:16:10:02 brd ff:ff:ff:ff:ff:ff
    inet 172.22.16.2/24 brd 172.22.16.255 scope global eth0
       valid_lft forever preferred_lft forever
```







### 端口映射原理

Docker端口映射的原理，其实通过使用iptables来进行转发

```bash
[root@docker-test ~]# docker run -d -p 8080:80 httpd:latest
62e14b61483e7dbca066d5ea40454b91e1eb19f38c49d0814b7c0c90d366873a
[root@docker-test ~]# docker ps
CONTAINER ID   IMAGE          COMMAND              CREATED          STATUS          PORTS                                   NAMES
62e14b61483e   httpd:latest   "httpd-foreground"   14 seconds ago   Up 13 seconds   0.0.0.0:8080->80/tcp, :::8080->80/tcp   suspicious_wu
[root@docker-test ~]# iptables -t nat -L
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination
DOCKER     all  --  anywhere             anywhere             ADDRTYPE match dst-type LOCAL

Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
DOCKER     all  --  anywhere            !loopback/8           ADDRTYPE match dst-type LOCAL

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
MASQUERADE  all  --  172.18.0.0/24        anywhere
MASQUERADE  tcp  --  172.18.0.2           172.18.0.2           tcp dpt:http

Chain DOCKER (2 references)
target     prot opt source               destination
RETURN     all  --  anywhere             anywhere
DNAT       tcp  --  anywhere             anywhere             tcp dpt:webcache to:172.18.0.2:80
```

通过在宿主机上使用iptables命令，可以看到最后的DOCKER链中，iptables有做DNAT，将端口转发到桥接网卡的`172.18.0.2:80`处





### Usages

#### 修改bridge网络

如果有特别需要，也可以修改默认的bridge网络地址

例如把docker0的网络改成`172.18.0.1/24`，如下示例：

```bash
[root@docker-test ~]# vim /etc/docker/daemon.json
{
"bip": "172.18.0.1/24",
"registry-mirrors": ["http://f1361db2.m.daocloud.io"]
}
[root@docker-test ~]# systemctl restart docker.service
[root@docker-test ~]# ip addr show docker0
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:5a:44:3c:a3 brd ff:ff:ff:ff:ff:ff
    inet 172.18.0.1/24 brd 172.18.0.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:5aff:fe44:3ca3/64 scope link
       valid_lft forever preferred_lft forever
```

这之后再创建容器后，ip地址也会使用这个网段了。



#### 端口映射

在使用端口映射的时候有两个可选项`-P`和`-p`，两者的区别在于`-P`为随机端口映射，`-p`则为自己手动指定端口映射。





