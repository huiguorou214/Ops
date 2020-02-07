# Inspection Template 

> This is a inspection template. I can use it for most of work.
>
> If you need to inspection for your Linux , I hope my this inspection template will help you.
>
> But you should know cleanly how to modify this template and let it suit you. For example, you can read your Baseline Document before inspection. 



## 一、Inspection Items

### 1.1 About Security

#### 1.1.1 Review the kernel args 

Use this command:`sysctl -a `

#### 1.1.2 Check for high-risk vulnerabilities

#### 1.1.3 Check for high-risk files

#### 1.1.4 Check the configuration file of password 

check this files:

#### 1.1.5 Check the security of user 

check this file: `/etc/passwd`

#### 1.1.6 Check the configuration of selinux 

check this file : `/etc/selinux/config`

#### 1.1.7 Check the process numbers of zombie 

use this command : ``

### 1.2 About Running status

### 1.3 Others

#### 1.3.1 Uptime

`uptime`

#### 1.3.2 Check the services

For RHEL6:`chkconfig --list ` 

For RHEL7:`systemctl list-unit-files | grep enabled`





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

