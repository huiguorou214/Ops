## Linux操作系统磁盘分区并永久挂载

本章主要介绍，操作系统如何对磁盘进行分区并创建文件系统永久挂载

下面以新添加的sdb磁盘为例进行分区与挂载



1. lsblk检查当前分区情况

   ```bash
   ~]# lsblk
   NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
   sda               8:0    0   40G  0 disk
   ├─sda1            8:1    0    1G  0 part /boot
   └─sda2            8:2    0   39G  0 part
     ├─centos-root 253:0    0   37G  0 lvm  /
     └─centos-swap 253:1    0    2G  0 lvm  [SWAP]
   sdb               8:16   0   20G  0 disk
   sr0              11:0    1 1024M  0 rom
   ```

2. 使用fdisk命令对

3. 

