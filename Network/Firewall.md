# Firewall 防火墙



## Author

```bash
Name:Shinefire
Blog:https://github.com/shine-fire/Ops_Notes
E-mail:shine_fire@outlook.com
```

## Description 

###  theory 

支持动态更新技术：iptables每一个更改都需要先清除所有旧有的规则，然后重新加载所有的规则（包括新的和修改后的规则）；而firewalld任何规则的变更都不需要对整个防火墙规则重新加载。

加入了区域（zone）概念， 区域就是firewalld预先准备了几套防火墙策略集合（策略模板），用户可以根据生产场景的不同而选择合适的策略集合，从而实现防火墙策略之间的快速切换。 

### modules

### zones

- truested 允许所有的数据包进出
- home 拒绝进入的流量，除非与出去的流量相关；而如果流量与ssh、mdns、ipp-client、amba-client与dhcpv6-client服务相关，则允许进入
- internal 拒绝进入的流量，除非与出去的流量相关；而如果流量与ssh、mdns、ipp-client、amba-client与dhcpv6-client服务相关，则允许进入
- work 拒绝进入的流量，除非与出去的流量相关；而如果流量与ssh、ipp-client与dhcpv6-client服务相关，则允许进入
- public 拒绝进入的流量，除非与出去的流量相关；而如果流量与ssh、ipp-client与dhcpv6-client服务相关，则允许进入
- external 拒绝进入的流量，除非与出去的流量相关；而如果流量与ssh服务相关，则允许进入
- dmz 拒绝进入的流量，除非与出去的流量相关；而如果流量与ssh服务相关，则允许进入
- block 拒绝进入的流量，除非与出去的流量相关
- drop 拒绝进入的流量，除非与出去的流量相关

### zone items

```bash
# firewall-cmd --list-all                     
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: ens33
  sources: 
  services: dhcpv6-client ssh
  ports: 
  protocols: 
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 
```

  target: 目标
  icmp-block-inversion:  ICMP协议类型黑白名单开关（yes/no） 
  interfaces:  关联的网卡接口 
  sources:  来源，可以是IP地址，也可以是mac地址 
  services:  允许的服务 
  ports:  允许的目标端口，即本地开放的端口 
  protocols:  允许通过的协议 
  masquerade:  是否允许伪装（yes/no），可改写来源IP地址及mac地址 
  forward-ports:  允许转发的端口 
  source-ports:  允许的来源端口 
  icmp-blocks:  可添加ICMP类型，当icmp-block-inversion为no时，这些ICMP类型被拒绝；当icmp-block-inversion为yes时，这些ICMP类型被允许。 
  rich rules:  富规则，即更细致、更详细的防火墙规则策略，它的优先级在所有的防火墙策略中也是最高的。
查看所有预设的服务 

## Usage



## firewall-cmd

### services

查看services，使用--get-services参数来列出/usr/lib/firewalld/services/目录中所有的服务名称。 

> 其实service的文件里面就是写了该服务会涉及到的端口，说到底还是通过对端口来进行控制流量的。

```bash
[root@ce-client2 ~]# firewall-cmd --get-services 
RH-Satellite-6 amanda-client amanda-k5-client amqp amqps apcupsd audit bacula bacula-client ......（略）
[root@ce-client2 ~]# ls /usr/lib/firewalld/services/
amanda-client.xml        dns.xml                  ipp-client.xml         matrix.xml                plex.xml            samba-client.xml       syslog.xml
amanda-k5-client.xml     docker-registry.xml      ipp.xml                mdns.xml                  pmcd.xml            samba-dc.xml           telnet.xml
[root@ce-client2 ~]# cat /usr/lib/firewalld/services/iscsi-target.xml 
<?xml version="1.0" encoding="utf-8"?>
<service>
  <short>iSCSI target</short>
  <description>Internet SCSI target is a storage resource located on an iSCSI server.</description>
  <port protocol="tcp" port="3260"/>
  <port protocol="udp" port="3260"/>
</service>
```

### zones



## reference 
[firewalld防火墙详解](https://blog.51cto.com/andyxu/2137046)











































