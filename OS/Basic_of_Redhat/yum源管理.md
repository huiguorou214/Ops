#  Yum源


 > 本章节主要是介绍了yum源相关的各方面使用，例如如何使用yum来管理软件包，如何创建yum源，自建yum仓库等

## 一、RHEL用户订阅红帽yum源

如果我们使用的是RHEL的系统，那么如果安装系统后没有进行激活授权的话，官方的yum repo是不可用的，使用下面这个命令就可以进行红帽的yum repo订阅了。

```bash
subscription-manager register --username=用户名  --password=密码  --auto-attach
```

参考：[RHEL7正版系统注册和订阅](https://www.xjimmy.com/rhel7_register.html)

## 二、createrepo创建本地yum源

- **安装 createrepo**

  createrepo：用于创建yum源（软件仓库），即为存放于本地特定位置的众多rpm包建立索引，描述各包所需依赖信息，并形成元数据。

  ```bash
  [root@apt-1 ~]# yum -y install createrepo
  ```

- **将软件包放入指定路径**

  需要创建一个路径用来专门做我们的软件包仓库，之后的所有rpm包都可以放在这个路径下

- **使用 createrepo 创建依赖关系**

  *具体可以参考下面的同步yum源中所提到的内容*


## 三、同步yum源

​	在CentOS或者RHEL中，我们的本地yum源是需要定期更新的，所以应该要如何去同步yum源呢？  
使用`reposync`命令可以用来同步yum源，需要安装`yum-utils`包。  
yum-utils：与Yum整合以多种方式扩大其机功能实用程序的集合，从而使其功能更强大，使用更方便。  
yum-utils 的更多功能介绍参考： [yum-utils](https://blog.csdn.net/xiaoxiao_22/article/details/7044583)

- **安装 yum-utils 与 createrepo**

  ```bash
  [root@apt-1 ~]# yum -y install yum-utils createrepo
  ```

- **使用 reposync 下载指定源的rpm包**

  reposync -n -r `<repoid>` -p `<down_path>`

  ```bash
  [root@apt-1 ~]# reposync -n -r base -p /test/repo/
  (1/10019): 389-ds-base-devel-1.3.8.4-15.el7.x86_64.rpm       | 271 kB  00:00:00     
  (2/10019): 389-ds-base-libs-1.3.8.4-15.el7.x86_64.rpm        | 698 kB  00:00:00     
  (3/10019): 389-ds-base-1.3.8.4-15.el7.x86_64.rpm             | 1.7 MB  00:00:00 
  ...
  ```

  -n参数可以只同步最新版本的包，这样就不会把所有版本都同步下来

  具体参数的意思可以查看 `reposync --help`

- **下载完毕后创建依赖关系**

  通过 createrepo 也可以自己创建元数据信息，但是不会自动生成组之类的信息，也就是不能使用 yum grouplist   

  ```bash
  [root@apt-1 ~]# createrepo -d /test/repo/base/
  Spawning worker 0 with 5010 pkgs
  Spawning worker 1 with 5009 pkgs
  Workers Finished
  Saving Primary metadata
  Saving file lists metadata
  Saving other metadata
  Generating sqlite DBs
  Sqlite DBs complete
  
  [root@apt-1 ~]# ls /test/repo/base/
  Packages  repodata
  # 可以看到已经生成了一个 repodata 的目录来存放软件包之间的依赖关系
  ```

- **下载 metadata** 

  下载metadata之后才能直接使用那些组，这里是演示直接同步rpms的时候就一起把metadata也下载下来了

  ```bash
  [root@apt-1 repodata]# reposync -r base -p /test/repo/ --downloadcomps --download-metadata 
  [root@apt-1 base]# ll
  total 1752
  -rw-r--r--. 1 root root 169676 Jul  2 21:13 bc140c8149fc43a5248fccff0daeef38182e49f6fe75d9b46db1206dc25a6c1c-c7-x86_64-comps.xml.gz
  -rw-r--r--. 1 root root 913932 Jul  2 21:13 comps.xml
  drwxr-xr-x. 2 root root 557056 Jul  2 20:00 Packages
  drwxr-xr-x. 2 root root   4096 Jul  2 20:17 repodata
  ```

- **创建yum文件索引与组索引**

  ```bash
  [root@apt-1 base]# createrepo /test/repo/base/ -g comps.xml  
  Spawning worker 0 with 5010 pkgs
  Spawning worker 1 with 5009 pkgs
  Workers Finished
  Saving Primary metadata
  Saving file lists metadata
  Saving other metadata
  Generating sqlite DBs
  Sqlite DBs complete
  ```

- **加载组信息repodata里面的文件对比**

  自己生成依赖关系后的repodata目录：

  ```bash
  [root@apt-1 base]# ll repodata/
  total 27876
  -rw-r--r--. 1 root root 2951663 Jul  2 20:16 25cd2c29e5adb2b6f8a5b091237dd9f760e97815b37f2557f2cd1c12a5f294f0-primary.xml.gz
  -rw-r--r--. 1 root root 7514424 Jul  2 20:16 48632a48107dce6d5b7ffc08a404085e0c19a1a675492cc02b1bd166299ab51c-filelists.xml.gz
  -rw-r--r--. 1 root root 6289348 Jul  2 20:17 6614b3605d961a4aaec45d74ac4e5e713e517debb3ee454a1c91097955780697-primary.sqlite.bz2
  -rw-r--r--. 1 root root 1629864 Jul  2 20:16 7da504ebb833ae8a240e126d12e591c90a7b2066be4625b6760ef2cb895916f1-other.xml.gz
  -rw-r--r--. 1 root root 7461122 Jul  2 20:17 a0ec5a4708a1026db100d4799c404c9ed48a9371a4bab234a1355f86628a244a-filelists.sqlite.bz2
  -rw-r--r--. 1 root root 2684613 Jul  2 20:16 fbebcd3de05e22bd1cd526e594f235968401471d4a9aef3c1ad356b6d1965365-other.sqlite.bz2
  -rw-r--r--. 1 root root    3012 Jul  2 20:17 repomd.xml
  ```

  通过加载 comps.xml 生成后的repodata目录：

  ```bash
  [root@apt-1 base]# ll repodata/
  total 28940
  -rw-r--r--. 1 root root 2951663 Jul  2 21:23 25cd2c29e5adb2b6f8a5b091237dd9f760e97815b37f2557f2cd1c12a5f294f0-primary.xml.gz
  -rw-r--r--. 1 root root 7514424 Jul  2 21:23 48632a48107dce6d5b7ffc08a404085e0c19a1a675492cc02b1bd166299ab51c-filelists.xml.gz
  -rw-r--r--. 1 root root 6289348 Jul  2 21:24 6614b3605d961a4aaec45d74ac4e5e713e517debb3ee454a1c91097955780697-primary.sqlite.bz2
  -rw-r--r--. 1 root root 1629864 Jul  2 21:23 7da504ebb833ae8a240e126d12e591c90a7b2066be4625b6760ef2cb895916f1-other.xml.gz
  -rw-r--r--. 1 root root 7461122 Jul  2 21:23 a0ec5a4708a1026db100d4799c404c9ed48a9371a4bab234a1355f86628a244a-filelists.sqlite.bz2
  -rw-r--r--. 1 root root  913932 Jul  2 21:24 aced7d22b338fdf7c0a71ffcf32614e058f4422c42476d1f4b9e9364d567702f-comps.xml
  -rw-r--r--. 1 root root  169676 Jul  2 21:24 bc140c8149fc43a5248fccff0daeef38182e49f6fe75d9b46db1206dc25a6c1c-comps.xml.gz
  -rw-r--r--. 1 root root 2684613 Jul  2 21:23 fbebcd3de05e22bd1cd526e594f235968401471d4a9aef3c1ad356b6d1965365-other.sqlite.bz2
  -rw-r--r--. 1 root root    3716 Jul  2 21:24 repomd.xml
  ```

  加载comps.xml文件的话，能看到grouplist的分组信息

## 四、使用yum源

- **修改yum源配置文件为本地yum源**

  ```bash
  [root@apt-1 yum.repos.d]# tar zcvf repo-bk.tar.gz CentOS-*
  
  ```
  
- **清除cache，创建cache**

  ```bash
  [root@apt-1 yum.repos.d]# yum clean all
  [root@apt-1 yum.repos.d]# yum makecache
  ```

- **查看 groups**

  ```bash
  [root@apt-1 yum.repos.d]# yum groups list 
  Loaded plugins: fastestmirror, product-id, search-disabled-repos, subscription-manager
  This system is not registered with an entitlement server. You can use subscription-manager to register.
  There is no installed groups file.
  Maybe run: yum groups mark convert (see man yum)
  Loading mirror speeds from cached hostfile
  Available Environment Groups:
     Minimal Install
     Compute Node
     Infrastructure Server
     File and Print Server
     Basic Web Server
     Virtualization Host
     Server with GUI
     GNOME Desktop
     KDE Plasma Workspaces
     Development and Creative Workstation
  Available Groups:
     Compatibility Libraries
     Console Internet Tools
     Development Tools
     Graphical Administration Tools
     Legacy UNIX Compatibility
     Scientific Support
     Security Tools
     Smart Card Support
     System Administration Tools
     System Management
  Done
  ```
  
  **注意：**这样查看的话会有一些隐藏的groups是无法查看到的，如果想查看一些隐藏的groups需要使用命令`yum groups list hidden`


## 五、通过HTTP的方式让局域网内其他机器共享本地yum源

- **部署HTTP服务**

  ```bash
  # yum -y install httpd 
  ```

- **配置httpd**

  ```bash 
  # cat /etc/httpd/conf.d/pub.conf    
  <Directory "/var/www/html/pub">
      Options Indexes FollowSymLinks
      AllowOverride None
      Order Allow,deny
      Allow from all
  </Directory>
  ```

- **创建好相应的文件存放路径**

  文件目录结构如下：

  ```bash
  # find /var/www/html/ -maxdepth 6
  /var/www/html/
  /var/www/html/index.html
  /var/www/html/sorry.html
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

- 配置html页面

  实际的HTML页面内容请查看yum源服务端的 /var/www/html/index.html

  以下模板仅为参考：

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
  <address>内部红帽 Linux yum仓库</address>
  </body></html>
  ```

- 启动HTTP服务并设置为开机自启动

  ```bash
  # systemctl enable httpd --now
  # systemctl status httpd
  ```

## 六、通过ftp的方式让局域网内其他机器共享本地yum源

略（待以后补充吧）

## 七、客户端 .repo 配置文件详解

## 参考文档

- [CentOS / RHEL See Detailed History Of yum history Commands](https://www.cyberciti.biz/faq/yum-history-command/)
- How to create a local mirror of the latest update for Red Hat Enterprise Linux 5, 6, 7, 8 without using Satellite server? https://access.redhat.com/solutions/23016

