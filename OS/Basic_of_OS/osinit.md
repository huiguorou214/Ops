# OSinit



## Items of RHEL7

###  主机名配置

``` bash
# hostnamectl set-hostname apt
```

### Disable Selinux

```bash
# setenforce 0
# sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
# reboot
```

### Stop Firewall

```bash
# systemctl disable firewalld --now
```

### Configure YUM

modify /etc/yum.repos.d/redhat.repo

### Install Some Packages

ansible/chrony/bash-completion/

### Configure Time

```bash
# systemctl status chronyd.service
# timedatectl set-timezone Asia/Shanghai
```

### VIM 

设置tab为四个空格宽度

```bash
# vim /etc/vimrc 
set ts=4
set sw=4
```

设置tab为四个空格

```bash
# vim /etc/vimrc
set ts=4
set expandtab
set autoindent
```

对于已保存的文件，可以使用下面的方法进行空格和TAB的替换：
**TAB替换为空格：**
:set ts=4
:set expandtab
:%retab!

**空格替换为TAB：**:set ts=4
:set noexpandtab
:%retab!







