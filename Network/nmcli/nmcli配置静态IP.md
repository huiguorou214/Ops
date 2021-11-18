# nmcli



### 静态IP地址管理

#### 配置静态IP地址

```bash
# nmcli connection add con-name 'static-ip' ifname eth0 type Ethernet ip4 172.25.0.11/24 gw4 172.25.0.254
# nmcli connection modify static-ip ipv4.dns 8.8.8.8
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

