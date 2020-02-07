# 局域网YUM源部署方案

 

 **文档属性**

| **文档属性**     | **内容**                                                     |
| ---------------- | ------------------------------------------------------------ |
| 文档名称         | 局域网YUM源部署方案                                          |
| 内容简述         | 本文档为在局域网内部署YUM源的方案，使用一台RHEL7的服务器作为YUM源服务端为局域网内其他的机器提供YUM源服务 |
| 阅读对象         | 需要对局域网内yum源进行管理的工作人员                        |
| 文档版本号       | V 1.0                                                        |
| 文档状态         | 初稿                                                         |
| 文档编写完成日期 | 2019年8月18日                                                |
| 作    者         | Apt                                                          |

 

##  一、概述

### 1.1 意义

​        在管理服务器与部署项目的过程中，需要安装各类软件以及大量依赖包，而项目部署的环境一般属于内网环境，与Internet网完全隔离，无法采用配置网络yum源的方式安装rpm包，直接在每台linux服务器上配置本地yum源也很不方便。所以在内网环境下采用配置局域网yum源，实现下载、安装、升级软件包有利于提高软件部署效率、保障软件版本一致性。

### **1.2 范围**

本文档描述在RHEL7服务器中部署局域网YUM源的方案。



## 二、同步yum源

内网YUM源服务器需要先通过网络或者其他能联网的服务器通过reposync同步官方YUM源中的所有rpm包来作为自己对局域网内其他的机器提供yum源服务的基础。

1. 配置redhat.repo

   ```bash
   # cat /etc/yum.repos.d/redhat.repo
   [rhel-7-server-rpms]
   metadata_expire = 86400
   sslclientcert = /etc/pki/entitlement/cert.pem
   baseurl = https://cdn.redhat.com/content/dist/rhel/server/7/$releasever/$basearch/os
   ui_repoid_vars = releasever basearch
   sslverify = 1
   name = Red Hat Enterprise Linux 7 Server (RPMs)f
   sslclientkey = /etc/pki/entitlement/key.pem
   gpgkey = file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
   enabled = 1
   sslcacert = /etc/rhsm/ca/redhat-uep.pem
   gpgcheck = 1
   ```

2. 更新yum缓存

   ```bash
   # yum clean all && yum repolist 
   ```

3. reposync同步官方yum源到本地

   ```bash
   # mkdir /rpms
   # reposync -p /rpms --downloadcomps --download-metadata 
   ```

4. createrepo创建本地yum文件索引与组索引

   ```bash
   # cd /rpms/rhel-7-server-rpms/
   # ls 
   comps.xml  Packages
   # createrepo ./ -g comps.xml
   ```

5. 修改yum源服务端的repo文件

   注意：如果yum源服务器无法联网同步官方yum源，则需要使用其他能联网同步官方yum源的机器执行上面的步骤后，再将做好的软件包上传至yum源服务端中。

   将yum源服务端的repo文件修改为本地yum源，以便于后续在服务端上部署其他的服务。

## 三、部署HTTP服务

局域网YUM源服务器通过部署HTTP服务，即可将服务端制作好的YUM源共享给局域网内其他的客户端使用。

1. 部署HTTP服务

   部署HTTP服务，并将/var/www/html/pub目录设置为共享目录

   ```bash
   # yum -y install httpd 
   # cat /etc/httpd/conf.d/pub.conf    
   <Directory "/var/www/html/pub">
       Options Indexes FollowSymLinks
       AllowOverride None
       Order Allow,deny
       Allow from all
   </Directory>
   ```

2. 创建好相应文件存放路径

   创建好目录，并放置yum源相关的各类文件至相应的路径下，示例如下：

   ```bash
   # find /var/www/html/ -maxdepth 6
   /var/www/html/
   /var/www/html/index.html
   /var/www/html/pub
   /var/www/html/pub/isos
   /var/www/html/pub/isos/rhel7
   /var/www/html/pub/isos/rhel7/rhel-server-7.2-x86_64-dvd.iso
   /var/www/html/pub/isos/rhel7/rhel-server-7.6-x86_64-dvd.iso
   /var/www/html/pub/isos/rhel6
   /var/www/html/pub/isos/rhel6/rhel-server-6.1-x86_64-dvd.iso
   /var/www/html/pub/isos/rhel6/rhel-server-6.6-x86_64-dvd.iso
   /var/www/html/pub/yum
   /var/www/html/pub/yum/rhel
   /var/www/html/pub/yum/rhel/rhel7
   /var/www/html/pub/yum/rhel/rhel7/x86_64
   /var/www/html/pub/yum/rhel/rhel7/x86_64/rhel-7.2-server-rpms
   /var/www/html/pub/yum/rhel/rhel6
   /var/www/html/pub/yum/rhel/rhel6/x86_64
   /var/www/html/pub/yum/rhel/rhel6/x86_64/rhel-6.1-server-rpms
   /var/www/html/pub/yum/rhel/rhel6/x86_64/rhel-6.6-server-rpms
   /var/www/html/pub/repos
   /var/www/html/pub/repos/rhel7
   /var/www/html/pub/repos/rhel7/rhel72.repo
   /var/www/html/pub/repos/rhel6
   /var/www/html/pub/repos/rhel6/rhel66.repo
   /var/www/html/pub/repos/rhel6/rhel61.repo
   ```
   
3. 配置HTML页面

   以下模板仅供参考：

   ```
   <!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
   <html><head>
   <title>Red Hat Enterprise Linux yum 仓库</title>
   </head><body>
   <h1>Red Hat Enterprise Linux yum 仓库</h1>
   <hr>
   
   <h3>Red Hat Enterprise Linux 6</h3>
   <div class="messagebox" style="background-color: grey; boarder: 1px solid #c5d7e0; color: black; padding: 5px; margin: 1ex 0; min-height: 35px; padding-left: 45px;">
   <ul><li>Red Hat Enterprise Linux 6 Server RPMS</li></ul>
   </div>
   <table width="100%" border="1">
     <tr>
       <th>Red Hat Enterprise Linux 6 yum配置</th>
       <th>Red Hat Enterprise Linux 6 官方镜像：  &nbsp; &nbsp; &nbsp; &nbsp;  <a href="http://IP/pub/isos/rhel6">点击查看</a></th>
     </tr>
     <tr>
       <th>Red Hat Enterprise Linux 6.1 yum 配置文件:  &nbsp; &nbsp; &nbsp; &nbsp;  <a href="http://IP/pub/repos/rhel6/rhel65.repo">点击查看</a></th>
       <th>Red Hat Enterprise Linux 6.1 官方yum源: &nbsp; &nbsp; &nbsp; <a href="http://IP/pub/yum/rhel/rhel6/x86_64/rhel-6.1-server-rpms">点击进入</a></th>
     </tr>
     <tr>
       <th>Red Hat Enterprise Linux 6.6 yum 配置文件:  &nbsp; &nbsp; &nbsp; &nbsp;  <a href="http://IP/pub/repos/rhel6/rhel66.repo">点击查看</a></th>
       <th>Red Hat Enterprise Linux 6.6 官方yum源: &nbsp; &nbsp; &nbsp; <a href="http://IP/pub/yum/rhel/rhel6/x86_64/rhel-6.6-server-rpms">点击进入</a></th>
     </tr>
     <tr>
   </table>
   <h3>Red Hat Enterprise Linux 7</h3>
   <div class="messagebox" style="background-color: grey; boarder: 1px solid #c5d7e0; color: black; padding: 5px; margin: 1ex 0; min-height: 35px; padding-left: 45px;">
   <ul><li>Red Hat Enterprise Linux 7  Server RPMS</li></ul>
   </div>
   <table width="100%" border="1">
     <tr>
       <th>Red Hat Enterprise Linux 7 yum配置</th>
       <th>Red Hat Enterprise Linux 7 官方镜像：  &nbsp; &nbsp; &nbsp; &nbsp;  <a href="http://IP/pub/isos/rhel7">点击查看</a></th>
     </tr>
     <tr>
       <th>Red Hat Enterprise Linux 7.2 yum 配置文件:  &nbsp; &nbsp; &nbsp; &nbsp;  <a href="http://IP/pub/repos/rhel7/rhel72.repo">点击查看</a></th>
       <th>Red Hat Enterprise Linux 7.2 官方yum源: &nbsp; &nbsp; &nbsp; <a href="http://IP//pub/yum/rhel/rhel7/x86_64/rhel-7.2-server-rpms">点击进入</a></th>
     </tr>
     <tr>
       <th>Red Hat Enterprise Linux 7.6 yum 配置文件:  &nbsp; &nbsp; &nbsp; &nbsp;  <a href="http://IP/pub/repos/rhel7/rhel76.repo">点击查看</a></th>
       <th>Red Hat Enterprise Linux 7.6 官方yum源: &nbsp; &nbsp; &nbsp; <a href="http://IP/sorry.html">点击进入</a></th>
     </tr>
   </table>
   
   <h4>yum配置文件使用方法：</h4>
   <hr>
   <div class="messagebox" style="background-color: grey; boarder: 1px solid #c5d7e0; color: black; padding: 5px; margin: 1ex 0; min-height: 35px; padding-left: 45px;">
   <p># wget http://IP/pub/repos/rhel7/rhel7.repo</p>
   <p># mv rhel7.repo /etc/yum.repos.d</p>
   <p># yum clean all</p>
   <p># yum repolist</p>
   </div>
   <hr>
   <address>Llinux yum仓库</address>
   </body></html>
   ```

4. 启动HTTP服务

   ```bash
   # systemctl enable httpd --now
   # systemctl status httpd
   ```

5. 浏览器访问测试结果是否正确

## 四、客户端配置yum源

1. wget 服务端的repo配置文件

   ```bash
   # wget http://192.168.31.101/pub/repos/rhel7/rhel7.repo
   ```

2. 更新yum缓存

   ```bash
   # yum clean all && yum makecache
   ```

## 五、yum源服务端更新

本章节会介绍如何定期更新yum源服务端，因为官方的rpm包会不断的更新升级，所以局域网内的yum源服务端可能也会有定期更新升级rpm包的需要。

1. 将新增的rpm包上传至服务端

   新增的rpm包数量一般不会太多，以rhel-7.2为例。需要把新增的rpm包上传至yum源服务端中相应的目录后，然后执行下面的操作：

   ```bash
   # createrepo --update /var/www/html/pub/yum/rhel/rhel7/x86_64/rhel-7.2-server-rpms
   ```

   --update参数更新repodata即"使用现有的repodata来加速新数据的创建"

2. Yum客户端需要刷新缓存

   ```bash
   # yum clean all && yum makecache
   ```
