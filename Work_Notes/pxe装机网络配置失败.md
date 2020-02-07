# pxe装机网络配置失败

[TOC]



## 问题详细

使用kickstart安装RHEL7.4系统，PXE引导的最后一步跑脚本配置网络，但是启动后发现系统没有预先设置好的IP地址和主机名。

重新执行一遍脚本，是能成功的。

### kickstart配置文件内容

最后一个脚本start_init.sh就是配置网络OS等信息的脚本

![image-20191220201004955](pxe%E8%A3%85%E6%9C%BA%E7%BD%91%E7%BB%9C%E9%85%8D%E7%BD%AE%E5%A4%B1%E8%B4%A5.assets/image-20191220201004955.png)![image-20191220201034948](pxe%E8%A3%85%E6%9C%BA%E7%BD%91%E7%BB%9C%E9%85%8D%E7%BD%AE%E5%A4%B1%E8%B4%A5.assets/image-20191220201034948.png)

![image-20191220201044186](pxe%E8%A3%85%E6%9C%BA%E7%BD%91%E7%BB%9C%E9%85%8D%E7%BD%AE%E5%A4%B1%E8%B4%A5.assets/image-20191220201044186.png)

### 配置脚本内容

配置IP

![image-20191220201347918](pxe%E8%A3%85%E6%9C%BA%E7%BD%91%E7%BB%9C%E9%85%8D%E7%BD%AE%E5%A4%B1%E8%B4%A5.assets/image-20191220201347918.png)

配置主机名

![image-20191220201355671](pxe%E8%A3%85%E6%9C%BA%E7%BD%91%E7%BB%9C%E9%85%8D%E7%BD%AE%E5%A4%B1%E8%B4%A5.assets/image-20191220201355671.png)

### 解决方案

