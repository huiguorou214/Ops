## baseline_configure

> 默认是在RHEL7上使用，如果RHEL6等其他版本不一样的，我会特别标注



#### 配置yum源

```bash
configure_yum_repository(){
    wget http://IP/rhel7.repo || exit 1
}
```

#### 服务管理

```bash
services_enable(){
    services="auditd rsyslog sshd crond kdump chronyd irqbalance"

    for service in $services
    do
        systemctl enable $service
    done
}
```

#### 关闭需要关闭的服务

RHEL7:

```bash
services_disable(){
    stop_services="firewalld rsh rexecd rlogind xinetd ypbind tftp autofs rhnsd avahi abrtd cpus pcscd smartd alsasound iscsitarget acpid"
    for serv in $stop_services; do
            systemctl stop $serv >/dev/null 2>&1
            systemctl disable $serv >/dev/null 2>&1
    done
}
```

RHEL6:

```bash

```

#### SELinux关闭

```bash
disable_selinux(){
    sed -i 's/^\(SELINUX=\).*/\1disabled/g' /etc/selinux/config
    setenforce 0
}
```

#### firewalld、iptables关闭

关闭firewalld（已包含在需要关闭的服务中）

```bash

```

关闭iptables

```bash

```

#### 命令时间戳记录

```bash
timestamp_configure(){
    grep "HISTTIMEFORMAT" /etc/bashrc
    if [ $? -eq 0 ]
    then
        sed '/HISTTIMEFORMAT/d' /etc/bashrc
        echo "export HISTTIMEFORMAT=\"%F %T \"" >> /etc/bashrc
    else
        echo "export HISTTIMEFORMAT=\"%F %T \"" >> /etc/bashrc
    fi
    export  HISTTIMEFORMAT="%F %T "

    cp -f ${config_files_path}/ps1.sh /etc/profile.d/
}
```

#### 命令行提示符配置

```bash

```

#### 文件系统挂载选项配置

```bash
fs_default_mount_parameters(){
    fsnum=""
    if cat /etc/fstab |grep -w "/var" &> /dev/null;then
        cat /etc/fstab |grep -v "/var/" |grep "/var" |grep "nodev" &>/dev/null
        if [ $? -ne 0 ]
        then
            fsnum=`grep -n var /etc/fstab |grep -v "/var/" |grep "/var" |awk -F: '{print $1}'`
            sed -i "$fsnum s/defaults/defaults,nodev,nosuid/g" /etc/fstab
        fi
    fi
    unset fsnum

    if cat /etc/fstab |grep -w "/tmp" &> /dev/null;then
        cat /etc/fstab |grep -v "/tmp/" |grep "/tmp" |grep "nodev" &>/dev/null
        if [ $? -ne 0 ]
        then
            fsnum=`grep -n tmp /etc/fstab |grep -v "/tmp/" |grep "/tmp" |awk -F: '{print $1}'`
            sed -i "$fsnum s/defaults/defaults,nodev,nosuid/g" /etc/fstab
        fi
    fi
    unset fsnum

    if cat /etc/fstab |grep -w "/home" &> /dev/null;then
        cat /etc/fstab |grep -v "/home/" |grep "/home" |grep "nosuid" &>/dev/null
        if [ $? -ne 0 ]
        then
            fsnum=`grep -n home /etc/fstab |grep -v "/home/" |grep "/home" |awk -F: '{print $1}'`
            sed -i "$fsnum s/defaults/defaults,nosuid/g" /etc/fstab
        fi
    fi
}
```

#### rsyslog配置与启动服务

```bash

```

#### crontab配置

```bash
disable_cron_mail(){
    sed -i 's/^\(CRONDARGS=\).*/\1"-m off"/g' /etc/sysconfig/crond
}
```

#### ntp server配置

chrony.conf:

```bash

```

ntp.conf

```bash

```

#### ulimit配置

```bash

```

#### 开启大页配置

```bash

```

#### 透明页关闭

```bash

```

#### /dev/shm 配置

```bash

```

#### SSH安全加固配置

```bash

```

#### audit日志审计配置

```bash

```

#### SFTP安全加固配置

```bash

```

#### 删除高风险文件

```bash
delete_high_risk_file(){
    [ -f /root/.rhosts ] && rm -f /root/.rhosts
    [ -f /root/.shosts ] && rm -f /root/.shosts
    [ -f /etc/hosts.equiv ] && rm -f /etc/hosts.equiv
    [ -f /etc/shost.equiv ] && rm -f /etc/shost.equiv
}
```

#### 敏感文件权限配置

```bash
system_sensitive_file_permission(){
    chmod 400 /etc/crontab
    chmod 400 /etc/securetty
    chmod 600 /etc/inittab
    chmod 600 /etc/login.defs

    ls /boot/grub2/grub.cfg &>/dev/null
    if [ $? -eq 0 ]
    then
      chmod 600 /boot/grub2/grub.cfg
    fi

    ls /boot/efi/EFI/redhat/grub.cfg &>/dev/null
    if [ $? -eq 0 ]
    then
      chmod 600 /boot/efi/EFI/redhat/grub.cfg
    fi

    ls /boot/efi/EFI/centos/grub.cfg &>/dev/null
    if [ $? -eq 0 ]
    then
      chmod 600 /boot/efi/EFI/centos/grub.cfg
    fi
}
```

#### 风险软件包移除

```bash
remove_softwares(){
    remove_softwares="rsh-server xinetd ypserv tftp-server sendmail xorg-x11-server-common"
    for software in $remove_softwares;do
        yum remove -y $software >/dev/null 2>&1
    done
}
```

#### 超时自动退出配置

```bash

```

#### 命令历史记录配置

```bash

```

#### 内核参数配置

```bash

```