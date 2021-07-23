# General Parameters

> 本章主要用来记录与解释一些在rhel/centos系统中比较常用的一些内核参数，以及对于这些参数的一些配置建议。

## Author

```
Name:Shinefire
Blog:https://github.com/shine-fire/Ops_Notes
E-mail:shine_fire@outlook.com
```



## System parameters

系统参数的一些建议值以及说明

| items                        | default | 建议     | 说明                                                         |
| ---------------------------- | ------- | -------- | ------------------------------------------------------------ |
| net.ipv4.conf.all.arp_ignore | 0       | 保持默认 | 不允许ignore arp（只有LVS时才需要此选项）<br />参考https://www.yinxiang.com/everhub/note/c054a620-cbf6-4ace-8ae9-38f1a1c3bc83 |
|                              |         |          |                                                              |
|                              |         |          |                                                              |
|                              |         |          |                                                              |





## References

## 一些参数的详细说明

### arp_ignore

#### 相关知识

**关于ARP协议**：

1. ARP（Address Resolution Protocol）即地址解析协议， 用于实现从 IP 地址到 MAC 地址的映射，即询问目标IP对应的MAC地址。在
2. 网络通信中，主机和主机通信的数据包需要依据OSI模型从上到下进行数据封装，当数据封装完整后，再向外发出。所以在局域网的通信中，不仅需要源目IP地址的封装，也需要源目MAC的封装。
3. 一般情况下，上层应用程序更多关心IP地址而不关心MAC地址，所以需要通过ARP协议来获知目的主机的MAC地址，完成数据封装。

#### 参数作用

此参数的作用是控制系统在收到外部的arp请求时，是否要返回arp响应。常用的取值主要有0，1，2；3~8较少用到：

- 0：响应任意网卡上接收到的对本机IP地址的arp请求（包括环回网卡上的地址），而不管该目的IP是否在接收网卡上。就是接收网卡会响应目的地址是任意本机上的网卡的arp请求都会回应。
- 1：只响应目的IP地址为接收网卡上的本地地址的arp请求。只响应找我的，找本机其他网卡的不回应
- 2：只响应目的IP地址为接收网卡上的本地地址的arp请求，并且arp请求的源IP必须和接收网卡同网段。
- 3：如果ARP请求数据包所请求的IP地址对应的本地地址其作用域（scope）为主机（host），则不回应ARP响应数据包，如果作用域为全局（global）或链路（link），则回应ARP响应数据包。
- 4~7保留未使用
- 8： 不回应所有的arp请求

#### 参数应用场景

在123212321LVS的DR场景下，它们的配置直接影响到DR转发是否正常。

sysctl.conf中包含all和eth/lo（具体网卡）的arp_ignore参数，取其中较大的值生效。