# Linux Route 详解



## route命令输出说明

route命令输出示例

```bash
~]# route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         gateway         0.0.0.0         UG    425    0        0 br0
192.168.31.0    0.0.0.0         255.255.255.0   U     425    0        0 br0
192.168.122.0   0.0.0.0         255.255.255.0   U     0      0        0 virbr0
192.168.130.0   0.0.0.0         255.255.255.0   U     0      0        0 crc

~]# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.31.1    0.0.0.0         UG    425    0        0 br0
192.168.31.0    0.0.0.0         255.255.255.0   U     425    0        0 br0
192.168.122.0   0.0.0.0         255.255.255.0   U     0      0        0 virbr0
192.168.130.0   0.0.0.0         255.255.255.0   U     0      0        0 crc
```

直接使用 `route` 命令的输出结果，是当前系统的路由表，通过这个表格可以看到系统去与不同网段通信如何进行路由。

输出项说明（详细可看route的man文档）

| Item        | Description                                                  |
| ----------- | ------------------------------------------------------------ |
| Destination | The destination network or destination host 目标网段或者主机 |
| Gateway     | 网关地址，”*”或者"0.0.0.0" 表示目标是本主机所属的网络，不需要路由 |
| Genmask     | 网络掩码，"255.255.255.255"是针对单一目标主机，"0.0.0.0"则是对于default路由独有；<br>255.255.255.255是受限广播地址，但在实际使用中，你会看到用255.255.255.255作为子网掩码，此时它表示单一主机IP地址； |
| Flags       | U (route is up)：路由是活动的                                |
|             | H (target is a host)：目标是一个主机                         |
|             | G (use gateway)：路由指向网关                                |
|             | R (reinstate route for dynamic routing)：恢复动态路由产生的表项 |
|             | D (dynamically installed by daemon or redirect)：由路由的后台程序动态地安装 |
|             | M (modified from routing daemon or redirect)：由路由的后台程序修改 |
|             | A (installed by addrconf)：通过addrconf安装                  |
|             | C (cache entry)：缓存入口                                    |
|             | !  (reject route)：拒绝路由                                  |
| Metric      | 路由距离，到达指定网络所需的中转数（linux 内核中没有使用）   |
| Ref         | 路由项引用次数（linux 内核中没有使用）                       |
| Use         | 此路由项被路由软件查找的次数                                 |
| Iface       | 该路由表项对应的输出接口                                     |



## 路由的三种类型

### 主机路由

主机路由即：Host Route

是路由选择表中指向单个IP地址或主机名的路由记录。主机路由的Flags字段为`H`。例如，在下面的示例中，本地主机通过IP地址192.168.1.1的路由器到达IP地址为10.0.0.10的主机：

```
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
-----------     -----------     --------------  ----- ------ ---    --- ------
10.0.0.10       192.168.1.1     255.255.255.255 UH    100    0        0 eth0
```



### 网络路由

网络路由即：Network Route

网络路由是代表主机可以到达的网络。网络路由的Flags字段为`G`。例如，在下面的示例中，本地主机将发送到网络192.19.12.0的数据包转发到IP地址为192.168.1.1的路由器上：

```
Destination    Gateway       Genmask        Flags    Metric    Ref     Use    Iface
-----------    -------       -------        -----    -----     ---     ---    -----
192.19.12.0   192.168.1.1    255.255.255.0   UG      0         0       0      eth0
```



### 默认路由

当主机不能在路由表中查找到目标主机的IP地址或网络路由时，数据包就被发送到默认路由（默认网关）上。默认路由的Flags字段为G。例如，在下面的示例中，默认路由是指IP地址为192.168.1.1的路由器。

```
Destination    Gateway       Genmask    Flags     Metric    Ref    Use    Iface
-----------    -------       -------    -----    ------     ---    ---    -----
default       192.168.1.1    0.0.0.0    UG        0         0      0      eth0
```





## 应用场景配置

### 配置静态路由











## Q&A

Q1：

关于这个 `route` 输出结果中的 `Metric` 参数，为什么直接就425这么大，这个数值是怎么计算的？另外就是这个数值是怎么来的？是因为以前使用过这个default路由后计算的结果吗？





## References

- [Linux下路由及网关的配置](https://ivanzz1001.github.io/records/post/linuxops/2018/11/14/linux-route#12-%E4%B8%89%E7%A7%8D%E8%B7%AF%E7%94%B1%E7%B1%BB%E5%9E%8B)