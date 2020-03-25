# RHEL5安装git方法

## 一、前言

由于RHEL5版本较老，官方不提供git的rpm包。开源社区对于5版本也基本上都撤掉了镜像，所以在RHEL5中安装git目前最便捷的方式是直接找到git的旧版本源码包进行源码编译安装。

以下即RHEL5源码编译安装git的操作方法。

## 二、源码编译安装Git步骤

1. 配置yum源，普通的系统镜像源即可

2. 使用yum安装编译需要的依赖包

   ```bash
   [root@localhost ~]# yum install gettext-devel expat-devel curl-devel zlib-devel openssl-devel tk gcc
   ```

3. 获取git源码包（这里我已经下好了一份）

   可以在官方挑选不同的版本，官方地址：https://mirrors.edge.kernel.org/pub/software/scm/git/

   ```bash
   [root@localhost ~]# cd /usr/local/src/
   [root@localhost src]# wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-1.8.3.4.tar.gz --no-check-certificate
   ```

4. 解压源码包

   ```bash
   [root@localhost src]# tar xzvf git-1.8.3.4.tar.gz
   ```

5. 安装源码包

   ```bash
   [root@localhost src]# cd git-1.8.3.4
   [root@localhost git-1.8.3.4]# make prefix=/usr/local/ all
   [root@localhost git-1.8.3.4]# make prefix=/usr/local/ install
   ```

6. 检查安装结果

   ```bash
   [root@localhost ~]# git --version
   git version 1.8.3.4
   ```