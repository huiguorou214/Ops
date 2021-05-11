# Ceph Deployment



## 环境说明

**系统版本**：CentOS7.8

**硬件配置**：5台vm，每台node机器挂载一块20G的空闲盘作为osd存储使用

**主机信息**：

| 主机名       | IP地址         | 功能                |
| ------------ | -------------- | ------------------- |
| ceph-server1 | 192.168.31.150 | Admin-->ceph-deploy |
| ceph-node1   | 192.168.31.151 | mon / mgr / osd     |
| ceph-node2   | 192.168.31.152 | osd                 |
| ceph-node3   | 192.168.31.153 | osd                 |
| ceph-client1 | 192.168.31.155 |                     |



## 系统基础配置

### 主机名配置

所有的机器配置好主机名与主机名解析

### 关闭防火墙与selinux

### 配置ceph用户

1. 所有节点创建一个普通用户并设置密码

   ```bash
   # useradd cephu
   # passwd cephu
   echo passwd123 | passwd --stdin cephu
   ```

2. 为新建的用户配置sudo权限

    ```bash
    # visudo
    cephu        ALL=(ALL)       NOPASSWD: ALL
    ```

123212321

在Admin上面做如下配置：

1. 在Admin中为cephu用户创建密钥对
2. 将cephu的密钥传给其他机器实现免密登陆
3. 



NTP配置



## ceph-deploy安装

在ceph的admin服务器上，需要先进行ceph-deploy的安装

1. 配置yum源

   ```bash
   # yum install -y yum-utils && sudo yum-config-manager --add-repo https://dl.fedoraproject.org/pub/epel/7/x86_64/ && sudo yum install --nogpgcheck -y epel-release && sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 && sudo rm /etc/yum.repos.d/dl.fedoraproject.org*
   ```

2. 软件包源加入软件仓库。用文本编辑器创建一个 YUM (Yellowdog Updater, Modified) 库文件，其路径为 `/etc/yum.repos.d/ceph.repo` 。例如：

   ```bash
   # vim /etc/yum.repos.d/ceph.repo
   ```

   把如下内容粘帖进去，用 Ceph 的最新主稳定版名字替换 `{ceph-stable-release}` （如 `firefly` ），用你的Linux发行版名字替换 `{distro}` （如 `el6` 为 CentOS 6 、 `el7` 为 CentOS 7 、 `rhel6` 为 Red Hat 6.5 、 `rhel7` 为 Red Hat 7 、 `fc19` 是 Fedora 19 、 `fc20` 是 Fedora 20 ）。最后保存到 `/etc/yum.repos.d/ceph.repo` 文件中。

   ```bash
   [ceph-noarch]
   name=Ceph noarch packages
   baseurl=http://download.ceph.com/rpm-{ceph-release}/{distro}/noarch
   enabled=1
   gpgcheck=1
   type=rpm-md
   gpgkey=https://download.ceph.com/keys/release.asc
   ```

3. 更新软件库并安装 `ceph-deploy`:

   ```bash
   # yum update && yum install ceph-deploy
   ```

4.  


