# NTP



## 环境说明

### NTP Server

本次ntp server集群的部署使用3台RHEL主机作为server端来进行，具体描述如下：

| IP             | Hostname    | OS_Version | Role       |
| -------------- | ----------- | ---------- | ---------- |
| 192.168.31.131 | ntp-server1 | RHEL7.9    | NTP server |
| 192.168.31.132 | ntp-server2 | RHEL7.9    | NTP server |
| 192.168.31.133 | ntp-server3 | RHEL7.9    | NTP server |

### YUM源

yum源需要使用到的主要为系统的基础源，如果能连外网则可以直接使用其他服务商的在线yum源即可，我这里的环境为本地自己部署的内网yum源，不做多介绍了。

### DNS

我这里的实验环境里，已经有一台DNS Server用来为NTP Server提供域名解析了，主要目的是为了让我自己的NTP Server能够与公网的时间服务器进行时间同步时能解析到，当然如果你直接指定公网时间服务器的IP地址的话，不需要配置DNS应该也没有关系。



## Steps

### 安装ntp

在三台时间服务器中都安装ntp这个rpm包

```bash
~]# yum install ntp -y
```

### 配置ntp服务