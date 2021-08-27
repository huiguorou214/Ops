# ethtool 详解







## ethtool命令详解







## ethtool查看网卡信息详解

通常用ethtool查看一个网卡的信息内容结果如下：

```bash
[root@nuc network-scripts]# ethtool eno1
Settings for eno1:
       Supported ports: [ TP ]
       Supported link modes:   10baseT/Half 10baseT/Full
                               100baseT/Half 100baseT/Full
                               1000baseT/Full
       Supported pause frame use: No
       Supports auto-negotiation: Yes
       Supported FEC modes: Not reported
       Advertised link modes:  10baseT/Half 10baseT/Full
                               100baseT/Half 100baseT/Full
                               1000baseT/Full
       Advertised pause frame use: No
       Advertised auto-negotiation: Yes
       Advertised FEC modes: Not reported
       Speed: 1000Mb/s
       Duplex: Full
       Port: Twisted Pair
       PHYAD: 1
       Transceiver: internal
       Auto-negotiation: on
       MDI-X: on (auto)
       Supports Wake-on: pumbg
       Wake-on: g
       Current message level: 0x00000007 (7)
                       drv probe link
       Link detected: yes
```

参数说明：

Supported ports：

Supported link modes：网卡当前支持的连接模式

Supported pause frame use：



## References

