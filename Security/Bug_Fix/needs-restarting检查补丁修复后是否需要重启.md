## needs-restarting 详解

> 平时在公司内部，我们管理的Linux操作系统可能会面临安全审计，对于一些漏洞扫描出来之后会需要进行一些漏洞修复的工作。
>
> 有的客户在修复漏洞后会考虑是否需要重启服务器来让安全补丁生效的问题，这里介绍一下使用'needs-restarting'工具来检查服务器在完成补丁更新之后是否重启



## Author

```
Name: Shinefire
Blog: https://github.com/shine-fire/Ops_Notes
E-mail: shine_fire@outlook.com
```



## Introduction

`needs-restarting`是包含在`yum-utils`套件中的一个小公举，它可以快速检查当前的系统状态，**列出需要重启的服务**和检查Linux核心的版本来**判断是否需要重启操作系统**。



## Usages

### 安装 needs-restarting

使用前需要先安装`yum-utils`套件

```bash
~]# yum install yum-utils -y
```



### 查看命令帮助文档

简单的查看一下`needs-restarting`命令的功能

```bash
~]# needs-restarting --help
Usage:
    needs-restarting: Report a list of process ids of programs that started
                    running before they or some component they use were updated.


Options:
  -h, --help        show this help message and exit
  -u, --useronly    show processes for my userid only
  -r, --reboothint  only report whether a full reboot is required (exit code
                    1) or not (exit code 0)
  -s, --services    list the affected systemd services only
```



### 直接使用

Report a list of process ids of programs that started running before they or some component they use were updated

直接使用命令会输出一个报表，展示那些在一些组件更新之前就已经运行了的进程以及进程id

```bash
~]# needs-restarting
8104 : sshd: root@notty
8106 : -bash
8100 : sshd: root@pts/0
7609 : rhnsd
3636 : /usr/lib/systemd/systemd-journald
8131 : /usr/libexec/openssh/sftp-server
1 : /usr/lib/systemd/systemd --system --deserialize 18
7041 : /sbin/agetty --noclear tty1 linux
7126 : /usr/sbin/NetworkManager --no-daemon
7005 : /usr/bin/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation
7004 : /usr/lib/systemd/systemd-logind
36672 : /usr/lib/systemd/systemd-udevd
```



### -u选项

show processes for my userid only

在直接使用的基础上只展示属于当前用户的进程，这里直接使用root用户执行的，所以结果和默认的基本上是一致的

```bash
~]# needs-restarting -u
8104 : sshd: root@notty
8106 : -bash
8100 : sshd: root@pts/0
7609 : rhnsd
3636 : /usr/lib/systemd/systemd-journald
8131 : /usr/libexec/openssh/sftp-server
1 : /usr/lib/systemd/systemd --system --deserialize 18
7041 : /sbin/agetty --noclear tty1 linux
7126 : /usr/sbin/NetworkManager --no-daemon
7005 : /usr/bin/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation
7004 : /usr/lib/systemd/systemd-logind
36672 : /usr/lib/systemd/systemd-udevd
```



### -r选项

only report whether a full reboot is required (exit code1) or not (exit code 0)

仅检查操作系统当前是否需要重启，如果需要重启则命令执行返回码为1，不需要则返回码为0，这个可以用在一些脚本或者自动化任务之类的里面来做判断。

```bash
~]# needs-restarting -r
Core libraries or services have been updated:
  kernel -> 3.10.0-1160.25.1.el7
  openssl-libs -> 1:1.0.2k-21.el7_9
  dbus -> 1:1.10.24-15.el7
  linux-firmware -> 20200421-80.git78c0348.el7_9
  glibc -> 2.17-324.el7_9
  systemd -> 219-78.el7_9.3

Reboot is required to ensure that your system benefits from these updates.

More information:
https://access.redhat.com/solutions/27943
```



### -s选项

list the affected systemd services only

仅列出受到影响的systemd服务，这里的受到影响也可以理解为，这些服务启动之后有一些软件的更新影响到他们的直接调用了。

```bash
~]# needs-restarting -s
systemd-logind.service
NetworkManager.service
dbus.service
getty@tty1.service
systemd-journald.service
rhnsd.service
systemd-udevd.service
```

