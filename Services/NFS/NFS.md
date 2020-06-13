# NFS

## 环境说明

| Items | Value            |
| ----- | ---------------- |
| OS    | RHEL7            |
| NFS   | 1:1.3.0-0.65.el7 |



## Install and Configure NFS

1. configure yum

   略

2. Install NFS

   ```bash
   [root@nuc ~]# yum -y install nfs-utils 
   ```

3. Modify /etc/exports

   ```bash
   [root@nuc ~]# vim /etc/exports
   /nfs/ISO/       192.168.0.0(rw)
   ```

   配置文件说明：左边写的是共享路径，即把本机的`/nfs/ISO/`目录共享出去；右边的是可使用的机器与权限，支持IP和域名写法，()里面的选项可以查看`man exports`

4. Start NFS 

   ```bash
   [root@nuc ~]# systemctl start nfs 
   ```

   *注：在RHEL6中需要先启动rpcbind服务，不过在RHEL7中，可以直接启动NFS，但是rpcbind应该是会自行启动*

5. 



## 配置文件详解

```
<输出目录> [客户端1 选项（访问权限,用户映射,其他）] [客户端2 选项（访问权限,用户映射,其他）]
```

参考博客：http://www.cnblogs.com/mchina/archive/2013/01/03/2840040.html
共享目录        共享选项
/nfs/share     *(ro,sync)
共享主机：

*：代表所有主机
192.168.0.0/24：代表共享给某个网段
192.168.0.0/24(rw) 192.168.1.0/24(ro) :代表共享给不同网段
192.168.0.254：共享给某个IP
*.uplook.com:代表共享给某个域下的所有主机
共享选项：
ro：只读
rw：读写
sync：实时同步，直接写入磁盘
async：异步，先缓存在内存再同步磁盘
anonuid：设置访问nfs服务的用户的uid，uid需要在/etc/passwd中存在
anongid：设置访问nfs服务的用户的gid
root_squash：默认选项 root用户创建的文件的属主和属组都变成nfsnobody,其他人server端是它自己，client端是nobody。
no_root_squash：root用户创建的文件属主和属组还是root，其他人server端是它自己uid，client端是nobody。
all_squash：不管是root还是其他普通用户创建的文件的属主和属组都是nfsnobody