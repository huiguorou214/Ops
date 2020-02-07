# Zabbix



## zabbix 简介

### zabbix 原理

### zabbix 架构

### zabbix 功能

### zabbix 发展





## zabbix部署

### 环境、版本

| Key    | Value      |
| ------ | ---------- |
| OS     | CentOS 7.2 |
| zabbix | 3.2        |
|        |            |



### 服务端单机部署实施步骤

1. 关闭防火墙

   ```bash
   # systemctl stop firewalld.service
   # systemctl disable firewalld.service
   ```

2. 关闭selinux

3. 配置yum源

   如果不是7的系统或者不打算安装3.2版本的，都可以根据自己的情况修改地址

   ```bash
   # rpm -ivh http://mirrors.aliyun.com/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm 
   # rpm -ivh http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm 
   ```

4. 搭建一个LAMP架构平台

   1. 配置yum并安装LAMP

      ```bash
      # wget -P /etc/yum.repos.d http://mirrors.aliyun.com/repo/Centos-7.repo
      # yum -y install mariadb mariadb-server php php-mysql httpd
      ```

   2. 启动并初始化数据库

      ```bash
      # systemctl start mariadb.service           
      # systemctl enable mariadb.service
      # mysql_secure_installation   ##这一步是为了初始化数据库，安装好数据库后必须要做的
      
      Enter current password for root (enter for none):    ##初始化第一步提示直接敲回车
      
      Set root password? [Y/n]  y    ##第二步这里输入y，输入以后就是设置root的密码了，要输入两次你要设置的密码就会提示你 successfully! 即可
      
      ## 后面的选项全部 y 过去就可以初始化完毕了！
      ```

   3. 创建zabbix数据库及用户

      ```bash
      # mysql -uroot -pqwert.12345  -e "create database zabbix default character set utf8 collate utf8_bin;"
      # mysql -uroot -pqwert.12345  -e "grant all on zabbix.* to \"zabbix\"@\"%\" identified by \"zabbix\";"
      # mysql -uzabbix -pzabbix -e "show databases;"
      +--------------------+
      | Database           |
      +--------------------+
      | information_schema |
      | zabbix             |
      +--------------------+
      ```

   4. 启动Apache服务并检测是否能正常访问

      ```bash
      # systemctl start httpd.service
      # systemctl enable httpd.service
      
      # yum -y install elinks
      # elinks -dump 127.0.0.1
         haha
      ```

5. 安装zabbix以及相关的一些软件

   在服务端安装zabbix-get可以方便之后向agent端发起测试采集数据的请求

   ```bash
   # yum -y install zabbix-server-mysql zabbix-web-mysql zabbix-get
   ```

6. 导入数据到zabbix数据库中，这里需要用到数据库的root用户和密码。

   ```bash
   # cd /usr/share/doc/zabbix-server-mysql-3.2.11/
   # zcat create.sql.gz | mysql -uroot -p*** zabbix
   ```

7. 修改zabbix的配置文件

   ```bash
   # vim /etc/zabbix/zabbix_server.conf
   DBHost=localhost
   DBName=zabbix
   DBUser=zabbix
   DBPassword=zabbix
   ```

   这里的DBPassword指明密码的时候不能用引号，因为有的人密码可能会设置得比较复杂，有些复杂的符号，但是不管是单引号，双引号都是不可以的，不然后续会出现问题。

8. 修改时区，把时区改成 Asia/Shanghai

   ```bash
   # vim /etc/httpd/conf.d/zabbix.conf
   
           php_value date.timezone Asia/Shanghai
   ```

9. 启动zabbix服务，并添加到开机自启动

   ```bash
   # systemctl start zabbix-server.service
   # systemctl enable zabbix-server.service
   ```

10. 重启Apache服务

    ```bash
    # systemctl restart httpd.service 
    ```

11. 在web界面进行server端的最后配置

    1. 在firefox浏览器的网址栏输入： http://IP/zabbix/setup.php

    2. 来到 welcome to 页面后，点击右下角的next stop

    3. 来到check of pre-requisites页面，我们可以看到，我们的check项后都是OK的，继续点击右下角的next stop

    4. 来到configure DB connection界面，需要填写我们之前创建的zabbix数据库以及zabbix用户的帐号密码，继续下一步

    5. 来到zabbix server details页面后继续点击下一步

    6. 来到pre-installation summary页面后继续点击下一步

    7. 来到Install界面，可以看到 恭喜你已经成功安装了zabbix

    8. 最后一步了，输入我们的帐号密码进行登录即可

       username：Admin

       Password：zabbix

    9. 之后登录到zabbix的管理界面可以直接输入下面这个地址进去即可：

       http://IP/zabbix

12. 安装完毕



### 服务端监控自己配置





### agent端加入到监控





### 附：离线下载zabbix依赖

1. 配置好epel源与zabbix源

   ```bash
   # rpm -ivh http://mirrors.aliyun.com/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm 
   # rpm -ivh http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm 
   # yum clean all && yum repolist 
   ```

2. yum downonly 下载好相关依赖包

   ```bash
   # mkdir -p /softs/zabbix/Packages
   # yum install mariadb mariadb-server php php-mysql httpd zabbix-server-mysql zabbix-web-mysql zabbix-get --downloadonly --downloaddir=/softs/zabbix/Packages
   # ls /softs/zabbix/Packages
   apr-1.4.8-3.el7_4.1.x86_64.rpm                 mariadb-server-5.5.60-1.el7_5.x86_64.rpm        php-common-5.4.16-46.el7.x86_64.rpm
   apr-util-1.5.2-6.el7.x86_64.rpm                net-snmp-libs-5.7.2-38.el7_6.2.x86_64.rpm       php-gd-5.4.16-46.el7.x86_64.rpm
   dejavu-fonts-common-2.33-6.el7.noarch.rpm      OpenIPMI-libs-2.0.23-2.el7.x86_64.rpm           php-ldap-5.4.16-46.el7.x86_64.rpm
   dejavu-sans-fonts-2.33-6.el7.noarch.rpm        OpenIPMI-modalias-2.0.23-2.el7.x86_64.rpm       php-mbstring-5.4.16-46.el7.x86_64.rpm
   fontpackages-filesystem-1.44-8.el7.noarch.rpm  perl-Compress-Raw-Bzip2-2.061-3.el7.x86_64.rpm  php-mysql-5.4.16-46.el7.x86_64.rpm
   fping-3.10-4.el7.x86_64.rpm                    perl-Compress-Raw-Zlib-2.061-4.el7.x86_64.rpm   php-pdo-5.4.16-46.el7.x86_64.rpm
   httpd-2.4.6-89.el7.centos.1.x86_64.rpm         perl-DBD-MySQL-4.023-6.el7.x86_64.rpm           php-xml-5.4.16-46.el7.x86_64.rpm
   httpd-tools-2.4.6-89.el7.centos.1.x86_64.rpm   perl-DBI-1.627-4.el7.x86_64.rpm                 t1lib-5.1.2-14.el7.x86_64.rpm
   iksemel-1.4-2.el7.centos.x86_64.rpm            perl-IO-Compress-2.061-2.el7.noarch.rpm         unixODBC-2.3.1-11.el7.x86_64.rpm
   libtool-ltdl-2.4.2-22.el7_3.x86_64.rpm         perl-Net-Daemon-0.48-5.el7.noarch.rpm           zabbix-get-3.2.11-1.el7.x86_64.rpm
   libXpm-3.5.12-1.el7.x86_64.rpm                 perl-PlRPC-0.2020-14.el7.noarch.rpm             zabbix-server-mysql-3.2.11-1.el7.x86_64.rpm
   libzip-0.10.1-8.el7.x86_64.rpm                 php-5.4.16-46.el7.x86_64.rpm                    zabbix-web-3.2.11-1.el7.noarch.rpm
   mailcap-2.1.41-2.el7.noarch.rpm                php-bcmath-5.4.16-46.el7.x86_64.rpm             zabbix-web-mysql-3.2.11-1.el7.noarch.rpm
   mariadb-5.5.60-1.el7_5.x86_64.rpm              php-cli-5.4.16-46.el7.x86_64.rpm
   ```

3. createrepo 创建依赖关系

   ```bash
   # yum -y install createrepo
   # createrepo -d /softs/zabbix/
   Spawning worker 0 with 41 pkgs
   Workers Finished
   Saving Primary metadata
   Saving file lists metadata
   Saving other metadata
   Generating sqlite DBs
   Sqlite DBs complete
   ```

4. 编写 .repo 文件进行局域网内的zabbix yum安装

   ```bash
   # vim /etc/yum.repos.d/zabbix_local.repo
   [zabbix_local]
   name = zabbix_local
   baseurl = file:///softs/zabbix/
   enabled = 1
   gpgcheck = 0
   # yum clean all && yum repolist 
   # yum -y install zabbix-server-mysql zabbix-web-mysql zabbix-get
   ...
   ...
   
   Installed:
     zabbix-get.x86_64 0:3.2.11-1.el7                   zabbix-server-mysql.x86_64 0:3.2.11-1.el7                   zabbix-web-mysql.noarch 0:3.2.11-1.el7                  
   
   Dependency Installed:
     OpenIPMI-libs.x86_64 0:2.0.23-2.el7     OpenIPMI-modalias.x86_64 0:2.0.23-2.el7    apr.x86_64 0:1.4.8-3.el7_4.1                apr-util.x86_64 0:1.5.2-6.el7          
     dejavu-fonts-common.noarch 0:2.33-6.el7 dejavu-sans-fonts.noarch 0:2.33-6.el7      fontpackages-filesystem.noarch 0:1.44-8.el7 fping.x86_64 0:3.10-4.el7              
     httpd.x86_64 0:2.4.6-89.el7.centos.1    httpd-tools.x86_64 0:2.4.6-89.el7.centos.1 iksemel.x86_64 0:1.4-2.el7.centos           libXpm.x86_64 0:3.5.12-1.el7           
     libtool-ltdl.x86_64 0:2.4.2-22.el7_3    libzip.x86_64 0:0.10.1-8.el7               mailcap.noarch 0:2.1.41-2.el7               net-snmp-libs.x86_64 1:5.7.2-38.el7_6.2
     php.x86_64 0:5.4.16-46.el7              php-bcmath.x86_64 0:5.4.16-46.el7          php-cli.x86_64 0:5.4.16-46.el7              php-common.x86_64 0:5.4.16-46.el7      
     php-gd.x86_64 0:5.4.16-46.el7           php-ldap.x86_64 0:5.4.16-46.el7            php-mbstring.x86_64 0:5.4.16-46.el7         php-mysql.x86_64 0:5.4.16-46.el7       
     php-pdo.x86_64 0:5.4.16-46.el7          php-xml.x86_64 0:5.4.16-46.el7             t1lib.x86_64 0:5.1.2-14.el7                 unixODBC.x86_64 0:2.3.1-11.el7         
     zabbix-web.noarch 0:3.2.11-1.el7       
   
   Complete!
   ```

5. OK !!!



