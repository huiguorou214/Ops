# Standardized_OS

> RHEL操作系统标准化建设，尽量涵盖到RHEL6/7/8三个操作系统版本，从不同的方面来做一个RHEL操作系统的标准化建议。



## Basic Configure

#### 主机名命名规范

**注意事项**

- 主机名中不要包含大写字母，某些软件不支持
- 主机名中不要包含下划线
- 主机名不要以数字开头



#### 服务优化

启用建议：

| 服务名称   | 服务说明                                                     | 是否启用 |
| ---------- | ------------------------------------------------------------ | -------- |
| irqbalance | Irqbalance服务用于在多处理器环境中合理分配调整硬件中断平衡从而达到优化系统性能以及节能的目录。如果在多处理器环境（包括单个多核CPU环境）中，应该打开这个服务。但是如果服务器只有一个处理器（单个单核处理器），应该关闭这个服务Irqbalance | 是       |
| kdump      | kdump服务可以在服务器崩溃的时候用于加载第二内核进行内存转储的收集工作。 | 是       |
| crond      | 用于设置系统定制执行某些命令，其中几乎所有的系统服务都会调用cron功能定制执行必要的维护任务，因此需要正确设置cron服务的权限。 | 是       |
|            |                                                              |          |
|            |                                                              |          |
|            |                                                              |          |
|            |                                                              |          |
|            |                                                              |          |
|            |                                                              |          |

禁用建议：

| 服务名称 | 服务说明                                                     | 是否启用 |
| -------- | ------------------------------------------------------------ | -------- |
| smartd   | 是磁盘的一个特性，用于检测磁盘故障并且报告给操作系统。**通常认为这个服务会带来潜在的低级别安全风险。**如果服务器磁盘支持并打开了SMART功能，可以考虑开启这个服务，虚拟机完全不用开启。 | 否       |
| acpid    | 提供了下一代（当前主流）电源管理支持。如果没有明确的需求，可以保持该服务开启。 | 否       |
|          |                                                              |          |



##### disabled services

RHEL6

- 

RHEL7

- 

RHEL8







##### enabled services

RHEL6

- 

RHEL7    

- 

RHEL8

- 



## Kernel Configure





## Security

### 物理安全配置

#### 禁止`Control+Alt+Delete`直接重启服务器：

- RHEL5
  待补充

- RHEL6

  ```bash
  # sed -i 's/^start on control-alt-delete/#start on control-alt-delete/g' /etc/init/control-alt-delete.conf
  ```

- RHEL7

  ```bash
  # systemctl mask ctrl-alt-del.target
  ```

- RHEL8

  ```bash
  # systemctl mask ctrl-alt-del.target
  ```

注：`systemctl disable` vs.`systemctl mask`，执行 `systemctl mask xxx`会`屏蔽`这个服务。它和`systemctl disable xxx`的区别在于，前者只是删除了符号链接，后者会建立一个指向`/dev/null`的符号链接，这样，即使有其他服务要启动被`mask`的服务，仍然无法执行成功。

#### 禁用USB存储设备

应禁止使用usb存储设备，防止物理usb设备引入木马文件

```bash
# echo "install usb-storage /bin/true" >> /etc/modprobe.d/usb-storage.conf
```

*注意：这个还要看看不同版本是否存在区别，后续待验证*

### 密码复杂度

#### 密码复杂度规则设置

1. 要求

   - 长度为12位
   - 包含英语大写字母 A, B, C, … Z
   - 包含英语小写字母 a, b, c, … z
   - 包含西方阿拉伯数字 0, 1, 2, … 9
   - 包含非字母数字字符，如标点符号，@, #, $, %, &, *等
   - 以上规则对**root**用户也一样生效

2. 修改方法

   - RHEL5

     ```bash
     # sed -i "s/^\(password[[:space:]]*requisite[[:space:]]*pam_cracklib.so\).*/\1 try_first_pass retry=6 minlen=12 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1 enforce_for_root/g" /etc/pam.d/system-auth-ac
     ```

   - RHEL6

     ```bash
     # sed -i "s/^\(password[[:space:]]*requisite[[:space:]]*pam_cracklib.so\).*/\1 try_first_pass retry=6 minlen=12 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1 enforce_for_root/g" /etc/pam.d/system-auth-ac
     ```

   - RHEL7

     ```bash
     # sed -i "s/^\(password[[:space:]]*requisite[[:space:]]*pam_pwquality.so\).*/\1 try_first_pass    local_users_only retry=6 minlen=12 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1 enforce_for_root authtok_type=/g" /etc/pam.d/system-auth-ac
     ```

   - RHEL8

     ```bash
     # sed -i "s/^\(password[[:space:]]*requisite[[:space:]]*pam_pwquality.so\).*/\1 try_first_pass    local_users_only retry=6 minlen=12 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1 enforce_for_root authtok_type=/g" /etc/pam.d/system-auth-ac
     ```



#### 密码历史

1. 要求
   密码历史为3次，是指修改口令时禁止使用最近3次已使用过的密码口令（己使用过的口令会被保存在 /etc/security/opasswd 下面）

2. 修改方法

   - RHEL5

     ```bash
     # sed -i '/^password[[:space:]]\{1,\}requisite[[:space:]]\{1,\}pam_cracklib.so/a\password    required      pam_pwhistory.so use_authtok remember=3 enforce_for_root' /etc/pam.d/system-auth-ac
     ```

   - RHEL6

     ```bash
     # sed -i '/^password[[:space:]]\{1,\}requisite[[:space:]]\{1,\}pam_cracklib.so/a\password    required      pam_pwhistory.so use_authtok remember=3 enforce_for_root' /etc/pam.d/system-auth-ac
     ```

   - RHEL7

     ```bash
     # sed -i  '/^password[[:space:]]\{1,\}requisite[[:space:]]\{1,\}pam_pwquality.so/a\password    required      pam_pwhistory.so use_authtok remember=3 enforce_for_root' /etc/pam.d/system-auth-ac
     ```

   - RHEL8

     ```bash
     # sed -i  '/^password[[:space:]]\{1,\}requisite[[:space:]]\{1,\}pam_pwquality.so/a\password    required      pam_pwhistory.so use_authtok remember=3 enforce_for_root' /etc/pam.d/system-auth-ac
     ```



#### 密码有效期

1. 要求
   最长期限：
   最短期限：
   最短字符长度：
   提醒修改密码的提前天数：

2. 修改方法
   修改`/etc/login.defs`文件，修改如下参数的值：

   ```
   PASS_MAX_DAYS	9999 （最长期限9999天）
   PASS_MIN_DAYS	0 	（最短期限0天）
   PASS_MIN_LEN 	12 	（最少12个字符）
   PASS_WARN_AGE	7	（提前7天提示密码修改）   
   ```



### 系统登录安全设置



#### 多次登录失败锁定策略

1. 要求
   连续10次输错密码禁用一段时间，建议配置成60秒

2. 修改方法

   - RHEL5**（待修正... 5版本中都没有password-auth）**

     ```bash
     # sed -i '/auth[[:space:]]*required[[:space:]]*pam_env.so/a\auth        required      pam_tally2.so onerr=fail deny=10 unlock_time=60 even_deny_root root_unlock_time=60' /etc/pam.d/system-auth-ac
     # sed -i '/account[[:space:]]*required[[:space:]]*pam_unix.so/i\account     required      pam_tally2.so' /etc/pam.d/system-auth-ac
     # sed -i '/auth[[:space:]]*required[[:space:]]*pam_env.so/a\auth        required      pam_tally2.so onerr=fail deny=10 unlock_time=60 even_deny_root root_unlock_time=60' /etc/pam.d/password-auth-ac
     # sed -i '/account[[:space:]]*required[[:space:]]*pam_unix.so/i\account     required      pam_tally2.so' /etc/pam.d/password-auth-ac
     ```

   - RHEL6

     ```bash
     # sed -i '/auth[[:space:]]*required[[:space:]]*pam_env.so/a\auth        required      pam_tally2.so onerr=fail deny=10 unlock_time=60 even_deny_root root_unlock_time=60' /etc/pam.d/system-auth-ac
     # sed -i '/account[[:space:]]*required[[:space:]]*pam_unix.so/i\account     required      pam_tally2.so' /etc/pam.d/system-auth-ac
     # sed -i '/auth[[:space:]]*required[[:space:]]*pam_env.so/a\auth        required      pam_tally2.so onerr=fail deny=10 unlock_time=60 even_deny_root root_unlock_time=60' /etc/pam.d/password-auth-ac
     # sed -i '/account[[:space:]]*required[[:space:]]*pam_unix.so/i\account     required      pam_tally2.so' /etc/pam.d/password-auth-ac
     ```

   - RHEL7

     ```bash
     # sed -i '/auth[[:space:]]*required[[:space:]]*pam_env.so/a\auth        required      pam_tally2.so onerr=fail deny=10 unlock_time=60 even_deny_root root_unlock_time=60' /etc/pam.d/system-auth-ac
     # sed -i '/account[[:space:]]*required[[:space:]]*pam_unix.so/i\account     required      pam_tally2.so' /etc/pam.d/system-auth-ac
     # sed -i '/auth[[:space:]]*required[[:space:]]*pam_env.so/a\auth        required      pam_tally2.so onerr=fail deny=10 unlock_time=60 even_deny_root root_unlock_time=60' /etc/pam.d/password-auth-ac
     # sed -i '/account[[:space:]]*required[[:space:]]*pam_unix.so/i\account     required      pam_tally2.so' /etc/pam.d/password-auth-ac
     ```

   - RHEL8（RHEL8已弃用pam_tally2模块，建议使用pam_faillock.so）

     ```bash
     # sed -i '/auth[[:space:]]*required[[:space:]]*pam_env.so/a\auth        required      pam_faillock.so preauth audit deny=10 unlock_time=60 even_deny_root root_unlock_time=60' /etc/pam.d/system-auth
     # sed -i '/auth[[:space:]]*sufficient[[:space:]]*pam_unix.so/a\auth        [default=die] pam_faillock.so authfail audit deny=10 unlock_time=60 even_deny_root root_unlock_time=60' /etc/pam.d/system-auth
     # sed -i '/account[[:space:]]*required[[:space:]]*pam_unix.so/i\account     required      pam_faillock.so' /etc/pam.d/system-auth
     # sed -i '/auth[[:space:]]*required[[:space:]]*pam_env.so/a\auth        required      pam_faillock.so preauth audit deny=10 unlock_time=60 even_deny_root root_unlock_time=60' /etc/pam.d/password-auth
     # sed -i '/auth[[:space:]]*sufficient[[:space:]]*pam_unix.so/a\auth        [default=die] pam_faillock.so authfail audit deny=10 unlock_time=60 even_deny_root root_unlock_time=60' /etc/pam.d/password-auth
     # sed -i '/account[[:space:]]*required[[:space:]]*pam_unix.so/i\account     required      pam_faillock.so' /etc/pam.d/password-auth
     ```



### SELinux设置

为了更方便的管理系统及应用程序服务，如非特殊需要，建议关闭系统的SELinux服务，操作步骤如下：

```bash
# getenforce			#检查当前SELinux状态，若为Enforcing或Permissive则需修改
# sed -i 's/^\(SELINUX=\).*/\1disabled/g' /etc/selinux/config		#修改配置文件
# reboot				#重启系统，若当前场景不适合重启系统，可执行以下步骤
# setenforce 0			#临时关闭
```



### 防火墙设置

如无特殊需要，建议关闭防火墙

- RHEL5

  ```bash
  # chkconfig iptables off
  # service iptables stop
  ```

- RHEL6

  ```bash
  # chkconfig iptables off
  # service iptables stop
  ```

- RHEL7

  ```bash
  # systemctl disable firewalld --now
  ```

- RHEL8

  ```bash
  # systemctl disable firewalld --now
  ```



#### SSHD安全加固





## 内核调优

### 网络参数

### 系统参数

