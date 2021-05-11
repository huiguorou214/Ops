Inspection Template

> This is a inspection template. I can use it for most of work.
>
> If you need to inspection for your Linux , I hope my this inspection template will help you.
>
> But you should know cleanly how to modify this template and let it suit you. For example, you can read your Baseline Document before inspection. 



## 一、Inspection Items

### OS Basic Info

- [ ] hostname/fqdn
- [ ] ip addr
- [ ] os version
- [ ] kernel version



### OS Basic Config

- [ ] swap
  configure & usage info
- [ ] /etc/fstab
- [ ] time server configure
- [ ] sshd_config
- [ ] password policy
- [ ] user login lock policy
- [ ] auditd configure and enable



### About Security

- [ ] kernel_args
  - [ ] kernel.sysrq
  - [ ] 
- [ ] file permission
  - [ ] /etc/crontab
  - [ ] /etc/securetty
  - [ ] /boot/grub2/grub.cfg
  - [ ] /boot/efi/EFI/redhat/grub.cfg
  - [ ] /etc/inittab
  - [ ] /etc/login.defs
- [ ] ulimit



### About Running Status

- [ ] selinux status
- [ ] firewalld status
- [ ] zombie process
- [ ] uptime
- [ ] cpu load
- [ ] FileSystem usage info
- [ ] memory usage info
- [ ] kdump service status
- [ ] crash file in /var/crash/
- [ ] enable services
- [ ] disable services
- [ ] run level



### About Error Log

- [ ] messages
- [ ] dmesg





## 二、Inspection command

### OS Basic Info

- hostname/fqdn

  ```bash
  hostname
  ```

- ip addr

  ```bash
  ip addr
  ```

- os version

  ```bash
  cat /etc/redhat-release
  ```

- kernel version

  ```bash
  uname -r
  ```

- selinux status

  - shell

    ```bash
    getenforce
    ```

  - ansible(built-in variable)

    ```bash
    ansible_selinux.status
    ```






### OS Basic Config

- /etc/fstab
- time server configure
- sshd_config
- password policy
- user login lock policy
- auditd configure and enable
- /etc/selinux/config



### About Running Status

- firewalld status

  - running status(list firewalld when it running)

    ```bash
  systemctl list-units | grep firewalld
    ```
  
  - disabled

    ```bash
  systemctl list-unit-files | grep firewalld | awk '{print $2}'
    ```

- zombie process

  ```bash
  top -b -n1 |grep ^Task |awk  '{print $10}'
  ```

- uptime

  ```bash
  uptime
  ```

- cpu load

  ```bash
  uptime
  ```

- FileSystem usage info

  ```bash
  df
  ```

- memory usage info

  ```bash
  free
  ```

- swap usage info

  ```bash
  free
  ```

- kdump service status

  - RHEL6

    ```bash
    chkconfig --list kdump
    ```

  - RHEL7

    ```bash
    systemctl list-unit-files | grep kdump
    ```

- crash file in /var/crash/

  ```bash
  if [ "`ls /var/crash/`" = "" ]; then echo empty ;else ls /var/crash/; fi
  ```

- enable services

  - RHEL6

    ```bash
    chkconfig --list
    ```

  - RHEL7 & RHEL8

    ```bash
    systemctl list-unit-files | grep enabled
    ```

- disable services

  - RHEL6

    ```bash
    chkconfig --list
    ```

  - RHEL7

    ```bash
    systemctl list-unit-files | grep disabled
    ```

- runlevel

  ```bash
  runlevel | awk '{print $2}'
  ```



### About Security

- kernel_args
  - 
- file permission
  - /etc/crontab
  - /etc/securetty
  - /boot/grub2/grub.cfg
  - /boot/efi/EFI/redhat/grub.cfg
  - /etc/inittab
  - /etc/login.defs
- ulitmi
  - /etc/security/limits.conf



### About Error Log

- messages

  ```bash
  grep -Ei '(error|warn|block|fail|flood|lockup|bug|stuck|kill|respond|try|return|wait|fragment|abort|mce)'  /var/log/messages*
  ```

- dmesg

  ```bash
  dmesg | grep -Ei '( error|warn|block|fail|flood|lockup|bug|stuck|kill|respond|try|return|wait|fragment|abort|mce)'
  ```
  
  RHEL7新增`-T`参数可以用来更好的显示日志的时间。





## 二、Shell Script

```shell
#!/bin/bash
# this is a script for inspection 

# defined variable
save_dir=/tmp/check
os_version=`cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/'`

# create a floder for save data
[ ! -d ${save_dir} ] && mkdir ${save_dir}

# check hostname
hostname > ${save_dir}/hostname

# check kernel args
sysctl -a --ignore 2>/dev/null > ${save_dir}/kernel_args
cp /etc/sysctl.conf ${save_dir}/

# check the zombie
ZombieNum=`top -b -n1 |grep ^Task |awk  '{print $10}'`
echo "ZombieNum = ${ZombieNum}" > ${save_dir}/zombienum

# copy passwd
cp /etc/passwd ${save_dir}/
```



## 三、Ansible script

设计思路：

- 关于一些基础配置内容，可以考虑使用template，将一些基础信息先填写成key，然后直接用变量直接var，这样就可以直接看到一些内容的值；
- 关于日志信息，则直接使用命令，通过关键字将需要的日志内容过滤出来；
- 