# Linux系统规范检查

## 检查大纲

- 服务检查

  检查指定的多个服务是否在各个级别启动中都已经是关闭状态。

  ```
  apmd,autofs,avahi-daemon,bluetooth,cups,hidd,hplip,innd,irda,isdn,krb5-telnet,mdmonitor,netfs,nfslock,pcscd,portmap,rhnfs,rpcgssd,rpcidmapd,sendmail,yum-updatesd,eklogin,ekrb5-telnet,kshell,ktalk,rsync,vsftpd
  ```

- 系统用户合规性检查

  ```
  sync,shutdown,halt,news,postgres,mysql
  ```

  - 检查系统内置用户是否处于`bin/false|sbin/nologin|/sbin/shutdown|/sbin/halt|/sbin/sync`等不能登录的shell 
    sync--sync,shutdown--shutdown,halt--halt
    
  - /etc/shadow第二位内容为"!!"

  - 会话超时配置检查

    超过900秒自动断开连接，检查配置文件中是否有：
    export TMOUT=900
    readonly TMOUT

- 口令策略合规性检查

  - auth认证策略与password复杂度策略，检查system-auth和password-auth

  - 口令策略：密码使用最长期限为90天，设置密码可尝试5次，密码长度最小为8位，修改密码不能设置为前三次用过的密码，至少一位数字和一位字母  
    password requisite
    
    ```
    RHEL6
    password    requisite     pam_cracklib.so retry=5 minlen=8 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1 minclass=2 remember=3
    RHEL7
    
    ```
    
  - 口令锁定策略：登录失败5次后锁定账号，锁定时长为15分钟。

    参考：`grep -E -i "^PASS_max_days[[:space:]]99999" /etc/login.defs `

- 时间服务健康检查

  - 服务是否启动

    RHEL6和RHEL7先判断服务是否自启动

    通过/var/run/ntpd.pid和/var/run/chronyd.pid文件是否存在判断是否正在运行

  - 检查是否配置好server

    如果配置文件里面grep不到server关键字段，$?则不为0，以此判断是否配置server

  - 时间校准是否正常

    ntpd -p 和chronyc sources

- 配置文件权限控制检查

  检查指定文件的权限配置是否合规

  ```
  /etc/passwd	644
  /etc/group	644
  /etc/exports	644
  /etc/issue	644
  /var/log/wtmp root wtmp	644
  /etc/services	644
  /etc/hosts.deny	644
  /etc/securetty	600
  /etc/ssh/sshd_config	600
  /var/log/messages	600
  ```

- swap剩余空间检查

  - 是否配置swap
  - free命令查看swap使用率是否大于20%

- coredump记录检查

  检查/var/crash目录下是否存在文件

- fstab自动挂载检查

  `mount -a`查看是否报错，报错则提示有问题

  需加强：`date +%Y%m%d%H%M`通过创建一个临时文件保存`mount -a`的标准错误输出，再赋值给一个变量，然后输出到结果中，告诉客户哪个挂载点有问题

  更强：检查fstab中写的挂载点是否和现在的挂载情况是否一致，不一致则报错；再进一步可以列出哪个挂载点不一致之类的。

- 操作系统报错日志收集

  grep加一些关键字将一些异常内容保存到一个文件里面来收集

- 系统版本统计

  可以先收集系统版本信息，再对本地的文件进行个数量统计应该就行了



## other

/var/log/wtmp 文件权限应该是664，看是否是因为特别需求要改成644？
