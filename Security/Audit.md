# Audit



## Audit审计介绍

Linux auditd 工具可以将审计记录写入日志文件。包括记录系统调用和文件访问。管理员可以检查这些日志，确定是否存在安全漏洞。

### Audit两种用法

auditctl临时添加规则

使用auditctl命令来添加规则，auditctl语法如下：

```bash
auditctl -w path_to_file -p permissions -k key_name
```

添加规则到 /etc/audit/audit.rules(*RHEL7为/etc/audit/rules.d/audit.rules*) 文件中使用永久性添加规则

```bash
 
```



## Audit审计快速启用

RHEL5/6/7的配置基本都是一样的，没什么区别，所以只要学会这个配置的流程，就能比较通用的来使用audit审计工具。

### 配置auditd.conf文件

auditd.conf配置模板

```
# 设置日志文件 
log_file = /var/log/audit/audit.log
# 设置日志文件轮询的数目，它是 0~99 之间的数。如果设置为小于 2，则不会循环日志。如果没有设置 num_logs 值，它就默认为 0，意味着从来不循环日志文件
num_logs = 5
# 设置日志文件是否使用主机名称，一般选 NONE
name_format = NONE
# 设置日志文件大小，以兆字节表示的最大日志文件容量。当达到这个容量时，会执行 max_log_file _action 指定的动作
max_log_file = 6
# 设置日志文件到达最大值后的动作，这里选择 ROTATE（轮询）
max_log_file_action = ROTATE
# 默认情况下，审计日志为每20条flush一次，为了防止由于大量后台脚本运行产生的审计日志在频繁flush到磁盘，导致磁盘使用率过高（特别是没有cache直接落盘的RAID卡），所以需要修改flush模式为NONE
flush = NONE
#freq = 50
```

### 添加规则

添加规则到 /etc/audit/audit.rules(*RHEL7为**/etc/audit/rules.d/audit.rules***) 文件中使用永久性添加规则

audit.rules配置模板

```bash
# vim /etc/audit/audit.rules
-w /etc/crontab -p wa -k crontab
-w /etc/hosts -p wa -k hosts
```

### 重启auditd服务

建议在使用RHEL7的使用也使用这个命令重启

```bash
# service auditd restart
```

### ausearch查看审计报告

使用ausearch可以很方便的查看审计报告，再加上**-k参数**则可以查找在创建规则时候添加-k参数时的关键字的审计信息，例如：

```txt
[root@server ~]# ausearch -k change_test | less
----
time->Sun Oct 20 18:26:41 2019
type=CONFIG_CHANGE msg=audit(1571567201.237:3806): auid=0 ses=480 op=add_rule key="change_test" list=4 res=1
----
time->Sun Oct 20 18:26:53 2019
type=PROCTITLE msg=audit(1571567213.597:3807): proctitle=6370002D69002F746D702F66696C6532002F746573742F
type=PATH msg=audit(1571567213.597:3807): item=1 name="/test/file2" inode=1363021 dev=08:03 mode=0100644 ouid=0 ogid=0 rdev=00:00 objtype=CREATE cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
type=PATH msg=audit(1571567213.597:3807): item=0 name="/test/" inode=1363017 dev=08:03 mode=040755 ouid=0 ogid=0 rdev=00:00 objtype=PARENT cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
type=CWD msg=audit(1571567213.597:3807):  cwd="/root"
type=SYSCALL msg=audit(1571567213.597:3807): arch=c000003e syscall=2 success=yes exit=4 a0=1ea48e0 a1=c1 a2=1a4 a3=7ffc9b0742a0 items=2 ppid=7641 pid=8154 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts1 ses=480 comm="cp" exe="/usr/bin/cp" key="change_test"
----
```

- time : 审计时间。
- name : 审计对象
- cwd : 当前路径
- syscall : 相关的系统调用
- auid : 审计用户 ID
- uid 和 gid : 访问文件的用户 ID 和用户组 ID
- comm : 用户访问文件的命令
- exe : 上面命令的可执行文件路径



## audit.rules 内容详解

示例：

```bash
~]# vim audit.rules
# First rule - delete all
-D

# Increase the buffers to survive stress events.
# Make this bigger for busy systems
-b 320

# Feel free to add below this line. See auditctl man page
-a exit,always -F arch=b64 -S execve -k exec
-a exit,always -F arch=b32 -S execve -k exec


-w /usr/sbin/fdisk -p x -k disk_partition
-w /etc/crontab -p wa -k crontab
-w /etc/hosts -p wa -k hosts
```





## auditd.conf配置文件详解

配置文件示例：

```
#
# This file controls the configuration of the audit daemon
#

log_file = /var/log/audit/audit.log
log_format = RAW
log_group = root
priority_boost = 4
flush = INCREMENTAL_ASYNC
freq = 50
num_logs = 5
disp_qos = lossy
dispatcher = /sbin/audispd
name_format = NONE
##name = mydomain
max_log_file = 40
max_log_file_action = ROTATE
space_left = 75
space_left_action = SYSLOG
action_mail_acct = root
admin_space_left = 50
admin_space_left_action = SUSPEND
disk_full_action = SUSPEND
disk_error_action = SUSPEND
use_libwrap = yes
##tcp_listen_port =
tcp_listen_queue = 5
tcp_max_per_addr = 1
##tcp_client_ports = 1024-65535
tcp_client_max_idle = 0
enable_krb5 = no
krb5_principal = auditd
##krb5_key_file = /etc/audit/audit.key
```

配置参数详解：

log_file：日志保存路径

log_format：日志保存的格式，raw/enriched.

- raw：kernel发出来什么样的就怎么样存储
- enriched：会对原始数据做一些处理，例如解析uid,gid等

log_group：指定audit log的group

priority_boost：audit daemon中使用用来指定优先级的

flush：

- none：很普通的将记录flush到磁盘保存起来即可，none模式flush相对会比较慢一些，可以避免频繁把日志flush到磁盘中，影响磁盘性能；
- incremental：由`freq`参数来指定具体的flush频率；
- incremental_async：和`incremental`相比基本一样，不过此模式在flush的时候会使用`asynchronously`技术来提高性能；
- data：使磁盘文件的data部分随时保持同步（to keep the data portion of the disk file sync'd at all times）
- sync：每次写入磁盘时对data和meta-data都是完全的同步；

freq：用来指定记录达到多少次后才flush到文件中，只有在设置`flush`为`incremental `或者`incremental_async`的时候才有用；

num_logs：日志文件的个数，范围为`2-99`，如果为1或者0则表示不轮转保存日志文件。

disp_qos：

dispatcher：

name_format：设置审计记录行首插入的内容

- none：什么也没有，默认就是这样的
- hostname：显示主机名
- fqd：显示fqdn
- numeric：显示IP地址
- user：限制管理员自定义的`name`参数的值，所以需要配合`name`参数一起用；

max_log_file：指定audit日志文件的最大保存个数；

max_log_file_action：用来定义当log file达到指定的最大size时需要执行的操作

- ignore：什么都不管，这种情况下，当log file达到最大size时，依旧会不断增大
- syslog：会给syslog发出告警，例如：`auditd[58776]: Audit daemon log file is larger than max size`
- suspend：停止继续写入
- rotate：按`num_logs`指定的个数来不断轮转日志文件
- keep_logs：类似`rotate`参数来轮转保存日志，但是不会按照手动指定的个数来，而是会一直积累下去

space_left：

space_left_action：

action_mail_acct：

admin_space_left：

admin_space_left_action：

disk_full_action：

disk_error_action：

use_libwrap：

##tcp_listen_port = 

tcp_listen_queue：

tcp_max_per_addr：

##tcp_client_ports = 1024-65535

tcp_client_max_idle：

enable_krb5：

krb5_principal：

##krb5_key_file = /etc/audit/audit.key



## auditctl command usage

auditctl -s    查询状态

```bash
~]# auditctl -s
enabled 1
failure 1
pid 7896
rate_limit 0
backlog_limit 320
lost 0
backlog 0
```

auditctl -l    查看规则

```bash
~]# auditctl -l
-a always,exit -F arch=b64 -S execve -F key=exec
-a always,exit -F arch=b32 -S execve -F key=exec
-w /usr/sbin/fdisk -p x -k disk_partition
-w /etc/crontab -p wa -k crontab
-w /etc/hosts -p wa -k hosts
```

auditctl -D    删除所有规则

疑问：删除规则是怎么样的用法呢？只删除命令行添加的临时规则吗？还是说配置文件中添加的规则也会删除，然后需要重启服务才能重新加载配置文件中的规则？



## 监控其他用户行为

开启audit审计功能，可以监控指定用户或目录，缺省会监控root的所有登录和操作。

如果想要监控其他用户的行为，包括登录、所有操作，以及shell脚本中的命令，则需要进行下面这样的配置。

```bash
# vim /etc/audit/audit.rules
-a exit,always -F arch=b64 -S execve -k exec
-a exit,always -F arch=b32 -S execve -k exec
```



## ausearch工具





## aureport工具



## 参考：

[Linux 用户空间审计工具 audit](https://www.ibm.com/developerworks/cn/linux/l-lo-use-space-audit-tool/index.html)





## Audit Troubleshoot 排故案例

### auditd进程造成CPU使用率高 （待完善）

refer：https://access.redhat.com/solutions/879373

#### Issue

- CPU consumption by auditd is increasing
- System is in hung state because of this high CPU consumption

#### Resolution

- **Check if /var/log/ partition has available space for logs. Otherwise, it can cause auditd fails to write back the logs**
- Check what logs are in /var/log/audit/audit.log which usually causes by massive number of logs by custom rules
- Check /etc/audit/audit.rules for any additional rules that could cause the issue



### 未设置轮询日志触发了auditd的BUG导致CPU使用率过高

refer：https://access.redhat.com/solutions/3430721

#### Issue

The `auditd` daemon uses high amount (100%) of CPU time after each log rotation, even though the internal log rotation of `auditd` was disabled by setting `num_logs = 0` and `max_log_file_action = IGNORE` in `/etc/audit/auditd.conf`.

#### Resolution

配置rotation --> reload配置文件

#### Root Cause

When `num_logs` has a lower value than `2` and `max_log_file_action` is set to other action than `ROTATE`, certain condition in the code of `auditd` is not met when internal log rotation mechanism is triggered, and an index variable in a for-loop underruns unexpectedly. This results in the tight for-loop running long time until its terminating condition is met. Hence `auditd` becomes busy and uses a high amount of CPU resources.

The internal log rotation mechanism can be triggered for example by a log file reaching a size limit, or by receiving a `USR1` signal externally.

#### Diagnostic Steps

refer：link



### 内存泄露

refer：https://access.redhat.com/solutions/3005691

#### Environment

- RHEL6

#### Issue

- Massive memory leak of cred data structure and connected data structures.
- Memory usage increases periodically whereas there are no processes consuming the memory. Ultimately system becomes very slow.

#### Resolution

- Please update your kernel to kernel-2.6.32-696.3.1 or higher

#### Root Cause

etc.



#### 修改刷新率来解决CPU使用率和Load高的问题

refer：https://linux-audit.redhat.narkive.com/17zoDRMH/auditd-cause-high-cpu-and-high-load

#### Issue

I am working as a developer for Garena LTD. Last week, I met a problem with Audit on our product servers. The Auditd process had caused of some pick time on our server. In that times, system CPU cost a lot, around 100%. And the Load average is over 30. We have tried to find the root cause and have failed.
Could you help us for that case?

#### Resolution

You might want to check the flush setting for /etc/audit/auditd.conf. I would recommend using incremental and set the freq to something like 200 or 500. Using sync or data will kill performance, but the event is written to disk before processing the next event.



### audit: backlog limit exceeded

refer：https://access.redhat.com/solutions/473223

#### Issue

- This message is being displayed continuously on console. I will have to power cycle to reboot.

  ```
  audit: backlog limit exceeded
  ```

- Following messages seen in system log:

  ```
  audit: audit_backlog=321 > audit_backlog_limit=320
  audit: audit_lost=44393 audit_rate_limit=0 audit_backlog_limit=320
  audit: backlog limit exceeded
  audit: audit_backlog=321 > audit_backlog_limit=320
  audit: audit_lost=44394 audit_rate_limit=0 audit_backlog_limit=320
  audit: backlog limit exceeded
  audit: audit_backlog=321 > audit_backlog_limit=320
  audit: audit_lost=44395 audit_rate_limit=0 audit_backlog_limit=320
  audit: backlog limit exceeded
  audit: audit_backlog=321 > audit_backlog_limit=320
  ```

#### Resolution

1. Unfreeze the frozen filesystem to allow the audit daemon to write out the backlog of audit data.
2. refer the link：https://access.redhat.com/solutions/473223





# Other

## VSFTP传输日志开启

vsftpd传输日志开启，修改vsftpd.conf配置文件

ftp服务器的日志设置，可以通过修改主配置文件/etc/vsftpd.conf实现。主配置文件中与日志设置有关的选项包括xferlog_enable 、xferlog_file 和dual_log_enable 等。 
xferlog_enable 
如果启用该选项，系统将会维护记录服务器上传和下载情况的日志文件。默认情况下，该日志文件为 /var/log/vsftpd.log。但也可以通过配置文件中的 vsftpd_log_file 选项来指定其他文件。默认值为NO。 
xferlog_std_format 
如果启用该选项，传输日志文件将以标准 xferlog 的格式书写，该格式的日志文件默认为 /var/log/xferlog，也可以通过 xferlog_file 选项对其进行设定。默认值为NO。 
dual_log_enable 
如果启用该选项，将生成两个相似的日志文件，默认在 /var/log/xferlog 和 /var/log/vsftpd.log 目录下。前者是 wu-ftpd 类型的传输日志，可以利用标准日志工具对其进行分析；后者是Vsftpd类型的日志。 
syslog_enable 
如果启用该选项，则原本应该输出到/var/log/vsftpd.log中的日志，将输出到系统日志中。 
常见的日志解决方案如下：

```
xferlog_enable=YES
xferlog_std_format=NO
xferlog_file=/var/log/xferlog
dual_log_enable=YES
vsftpd_log_file=/var/log/vsftpd.log
```

### xferlog对比vsftpd.log

```
[root@server log]# tailf vsftpd.log 
Sun Oct 20 21:46:36 2019 [pid 10257] CONNECT: Client "::ffff:192.168.31.215"
Sun Oct 20 21:46:36 2019 [pid 10256] [ftp] OK LOGIN: Client "::ffff:192.168.31.215", anon password "lftp@"
Sun Oct 20 21:46:42 2019 [pid 10258] [ftp] OK DELETE: Client "::ffff:192.168.31.215", "/pub/file111"
Sun Oct 20 21:47:17 2019 [pid 10258] [ftp] OK UPLOAD: Client "::ffff:192.168.31.215", "/pub/file111", 0.00Kbyte/sec
```

```
[root@server log]# cat xferlog 
Sun Oct 20 21:24:53 2019 1 ::ffff:192.168.31.215 0 /file111 b _ i a lftp@ ftp 0 * i
Sun Oct 20 21:25:02 2019 1 ::ffff:192.168.31.215 0 /pub/file111 b _ i a lftp@ ftp 0 * c
Sun Oct 20 21:36:33 2019 1 ::ffff:192.168.31.215 0 /pub/file111 b _ o a lftp@ ftp 0 * i
Sun Oct 20 21:37:07 2019 1 ::ffff:192.168.31.215 0 /pub/file111 a _ o a lftp@ ftp 0 * i
Sun Oct 20 21:37:40 2019 1 ::ffff:192.168.31.215 0 /pub/file111 b _ o a lftp@ ftp 0 * i
Sun Oct 20 21:37:49 2019 1 ::ffff:192.168.31.215 0 /pub/file111 b _ o a lftp@ ftp 0 * i
Sun Oct 20 21:39:59 2019 1 ::ffff:192.168.31.215 0 /pub/file111 b _ o a lftp@ ftp 0 * i
Sun Oct 20 21:40:30 2019 1 ::ffff:192.168.31.215 0 /pub/file111 b _ o a lftp@ ftp 0 * c
Sun Oct 20 21:41:22 2019 1 ::ffff:192.168.31.215 0 /pub/file111 b _ i a lftp@ ftp 0 * c
Sun Oct 20 21:43:29 2019 1 ::ffff:192.168.31.215 0 /pub/file111 b _ i a lftp@ ftp 0 * c
```

### 参考：

vsftpd日志配置及查看——可以将vsftpd记录在系统日志里https://blog.csdn.net/weixin_34008805/article/details/86009497

## SFTP传输日志开启

### 修改SSH的配置

```bash
# vim /etc/ssh/sshd_config
Subsystem sftp /usr/libexec/openssh/sftp-server -l INFO -f local5
LogLevel INFO
```

### 修改rsyslog配置（RHEL5中是 /etc/syslog.conf）

```bash
# vim /etc/rsyslog.conf
auth,authpriv.*,local5.* /var/log/sftp.log
```

### 重启服务(RHEL中是重启syslog服务)

```bash
# service rsyslog restart
# service sshd restart
```

### 查看日志

使用其他的机器执行`sftp root@本机IP:/tmp`即可在本机日志中看到SFTP操作日志

```
tail -f /var/log/sftp.log
Oct 21 06:22:33 localhost sshd[4778]: Accepted password for root from 192.168.31.215 port 45182 ssh2
Oct 21 06:22:33 localhost sshd[4778]: pam_unix(sshd:session): session opened for user root by (uid=0)
Oct 21 06:22:33 localhost sshd[4778]: subsystem request for sftp
Oct 21 06:22:33 localhost sftp-server[4780]: session opened for local user root from [192.168.31.215]
Oct 21 06:22:41 localhost sftp-server[4780]: opendir "/tmp/"
Oct 21 06:22:41 localhost sftp-server[4780]: closedir "/tmp/"
```

### 参考：

[CentOS下配置SFTP操作日志](https://www.cnblogs.com/kgdxpr/p/7169333.html)

## vsftpd限制家目录

配置vsftpd.conf

```
禁锢本地用户的家，只能在自己的家中活动，不能cd
禁锢大部分，允许小部分：
chroot_local_user=YES  禁锢所有用户不能跳转
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd/chroot_list  该文件没有，自己创建；允许小部分人可以跳转
echo user1 >> /etc/vsftpd/chroot_list

######################
允许大部分，禁锢小部分：
# chroot_local_user=YES 关闭
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd/chroot_list  禁锢小部分人
echo user1 >> /etc/vsftpd/chroot_list
```

