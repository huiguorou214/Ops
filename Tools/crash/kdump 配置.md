# kdump 配置

> 本章节主要介绍 kdump 要如何配置才能有效的用于在操作系统发生异常重启或 crash 的时候捕获内核自动生成 vmcore 文件用于分析。



## Author

```
Name:Shinefire
Blog:https://github.com/shine-fire/Ops_Notes
E-mail:shine_fire@outlook.com
```



## 原理介绍

什么是 kexec ？

系统应开启 kdump 服务，以便在服务器系统崩溃时能够加载捕获内核，将系统内核崩溃前的内存镜像保存并进行转储，以定位内核崩溃的原因并改进。



## kdump 配置步骤

以 RHEL7 版本的操作系统为例，按下面的步骤进行 kdump 配置

安装 kdump 的工具包

```bash
~]# yum clean all
~]# yum makecache
~]# yum install -y kexec-tools
```



默认 kdump 保存路径为 /var/crash，如非特殊不可修改。

配置 kdump 服务需要提前在grub内核引导项中设置 `crashkernel=xxM` 参数，也可以填写 `crashkernel=auto` 来实现系统自动分配。

xx值通过下表来计算：

| 内存大小 | crashkernel 值大小 |
| -------- | ------------------ |
| <2GB     | 128MB              |
| 2GB-6GB  | 256MB              |
| 6GB-8GB  | 512MB              |
| >8GB     | 768MB              |



添加 crashkernel 参数。

在grub中的配置方法如下所示：

```bash
~]# vim /etc/default/grub
```

编辑 GRUB_CMDLINE_LINUX 添加 crashkernel 的参数，如下：

```bash
GRUB_CMDLINE_LINUX="crashkernel=auto rd.lvm.lv=rhel_hosted-by/root biosdevname=0 net.ifnames=0 rhgb quiet"
```

重新生成新的grub文件分 2 种引导方式

bios引导的方法如下所示：

```bash
~]# grub2-mkconfig -o /boot/grub2/grub.cfg
```

uefi引导的方法如下所示：

```bash
~]# grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
```



重启操作系统

配置完 crashkernel 后需要重启系统才可生效。

```bash
~]# reboot
```



配置完后开启 kdump 服务，命令如下：

```bash
~]# systemctl start kdump.service
~]# systemctl enable kdump.service
```



永久启用魔术键 SysRq key

在 `/etc/sysctl.conf` 配置文件中增加相应的配置项：

```bash
~]# vi /etc/sysctl.conf
kernel.sysrq = 1
```

使配置生效：

```bash
~]# sysctl -p
```



配置完 kdump 服务后，需要使用以下的命令来触发 kernel panic 检测 kdump 服务是否配置正确：

> **该命令会导致系统 crash 重启，切莫在正在运行的生产环境使用！！**

```bash
~]# echo c > /proc/sysrq-trigger  
```

若kdump提示out-of-memory错误，可根据情况增大crashkernel的值。



## 手动触发 kernel panic

使用魔术键（"Magic" SysRq key）手动触发 kernel panic（生成 vmcore 并重启主机） 的方法有两种。

方法一：在键盘上同时按下 "Alt-SysRq-c"（如果是使用 KVM，则现在 KVM 的HotKey 中进行定义，再按下定义的 HotKey）

方法二：echo c > /proc/sysrq-trigger

两种方式可以根据实际情况来使用，通常在系统 hang 住的时候已经无法再使用命令的情况下，只能使用键盘按键来触发 kernel panic 让 kdump 将系统内核崩溃前的内存镜像保存并进行转储，以定位内核崩溃的原因并改进。



**其他注意事项：**

- 使用 DELL 服务器 KVM 上的 "Alt-SysRq-B" 键，会直接断电重启电脑，不会触发 kdump。这个时候可以将 KVM 全屏，然后在键盘上同时按下 "Alt-SysRq-c" ，但是如果主机 hang 住的情况下，也存在无反应的可能性。



## 通过kdump排错



## 参考文献

- [深入探索 Kdump，第 1 部分：带你走进 Kdump 的世界](https://www.ibm.com/developerworks/cn/linux/l-cn-kdump1/index.html)

