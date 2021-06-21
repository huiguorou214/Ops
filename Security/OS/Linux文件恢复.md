# Linux 文件恢复（XFS & EXT4）

在`Linux`中，删除`rm`命令使用需谨慎，有时候可能由于误操作，导致重要文件删除了，这时不要太紧张，操作得当的话，还是可以恢复的。

------



## EXT 类型文件恢复

删除一个文件，实际上并不清除`inode`节点和`block`的数据，只是在这个文件的父目录里面的`block`中，删除这个文件的名字。`Linux`是通过`Link`的数量来控制文件删除的，只有当一个文件不存在任何`Link`的时候，这个文件才会被删除。

当然，这里所指的是彻底删除，即已经不能通过`回收站`找回的情况，比如使用`rm -rf`来删除数据。针对`Linux`下的`EXT`文件系统，可用的恢复工具有`debugfs`、`ext3grep`、`extundelete`等。 其中`extundelete`是一个开源的`Linux`数据恢复工具，支持`ext3`、`ext4`文件系统。

在数据被误删除后，第一时间要做的就是卸载被删除数据所在的分区，如果是根分区的数据遭到误删，就需要将系统进入单用户模式，并且将根分区以只读模式挂载。这样做的原因很简单，因为将文件删除后，仅仅是将文件的`inode`节点中的扇区指针清零，实际文件还存储在磁盘上，如果磁盘继续以读写模式挂载，这些已删除的文件的数据块就可能被操作系统重新分配出去，在这些数据库被新的数据覆盖后，这些数据就真的丢失了，恢复工具也回天无力。所以以只读模式挂载磁盘可以尽量降低数据库中数据被覆盖的风险，以提高恢复数据成功的比例。



## Demo

在编译安装`extundelete`之前需要先安装两个依赖包`e2fsprogs-libs`和`e2fsprogs-devel`，这两个包在系统安装光盘的`/Package`目录下就有，使用`rpm`或`yum`命令将其安装。`e2fsprogs-devel`安装依赖于`libcom_err-devel`包。

1.系统使用的是`rhel6.5`，挂载光盘，安装依赖包，这里使用的是`rpm`安装方式。

```
[root@localhost ~]# mkdir /mnt/cdrom
[root@localhost ~]# mount /dev/cdrom /mnt/cdrom/
mount: block device /dev/sr0 is write-protected, mounting read-only
[root@localhost ~]# cd /mnt/cdrom/Packages/
[root@localhost Packages]# rpm -ivh e2fsprogs-libs-1.41.12-18.el6.x86_64.rpm
warning: e2fsprogs-libs-1.41.12-18.el6.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID fd431d51: NOKEY
Preparing...                ########################################### [100%]
	package e2fsprogs-libs-1.41.12-18.el6.x86_64 is already installed
[root@localhost Packages]# rpm -ivh libcom_err-devel-1.41.12-18.el6.x86_64.rpm
warning: libcom_err-devel-1.41.12-18.el6.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID fd431d51: NOKEY
Preparing...                ########################################### [100%]
   1:libcom_err-devel       ########################################### [100%]
[root@localhost Packages]# rpm -ivh e2fsprogs-devel-1.41.12-18.el6.x86_64.rpm
warning: e2fsprogs-devel-1.41.12-18.el6.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID fd431d51: NOKEY
Preparing...                ########################################### [100%]
   1:e2fsprogs-devel        ########################################### [100%]
```

2.创建本地`yum`源，安装编译环境。

```
[root@localhost ~]# yum install gcc gcc-c++ -y
```

3.解压`extundelete`软件包。

```
[root@localhost ~]# tar jxvf extundelete-0.2.4.tar.bz2 -C ~
extundelete-0.2.4/
extundelete-0.2.4/acinclude.m4
extundelete-0.2.4/missing
extundelete-0.2.4/autogen.sh
extundelete-0.2.4/aclocal.m4
extundelete-0.2.4/configure
extundelete-0.2.4/LICENSE
extundelete-0.2.4/README
extundelete-0.2.4/install-sh
extundelete-0.2.4/config.h.in
extundelete-0.2.4/src/
extundelete-0.2.4/src/extundelete.cc
extundelete-0.2.4/src/block.h
extundelete-0.2.4/src/kernel-jbd.h
extundelete-0.2.4/src/insertionops.cc
extundelete-0.2.4/src/block.c
extundelete-0.2.4/src/cli.cc
extundelete-0.2.4/src/extundelete-priv.h
extundelete-0.2.4/src/extundelete.h
extundelete-0.2.4/src/jfs_compat.h
extundelete-0.2.4/src/Makefile.in
extundelete-0.2.4/src/Makefile.am
extundelete-0.2.4/configure.ac
extundelete-0.2.4/depcomp
extundelete-0.2.4/Makefile.in
extundelete-0.2.4/Makefile.am
```

4.配置、编译、安装`extundelete`软件包

```
[root@localhost ~]# cd extundelete-0.2.4
[root@localhost extundelete-0.2.4]# ls
acinclude.m4  aclocal.m4  autogen.sh  config.h.in  configure  configure.ac  depcomp  install-sh  LICENSE  Makefile.am  Makefile.in  missing  README  src
[root@localhost extundelete-0.2.4]# ./configure
Configuring extundelete 0.2.4
Writing generated files to disk
[root@localhost extundelete-0.2.4]# make
make -s all-recursive
Making all in src
extundelete.cc:571: 警告：未使用的参数‘flags’
[root@localhost extundelete-0.2.4]# make install
Making install in src
  /usr/bin/install -c extundelete '/usr/local/bin'
```

5.准备好用于测试的分区，`/dev/sdb1`为`ext4`格式，挂载到`/mnt/ext4`目录下。

```
[root@localhost ~]# mkdir /mnt/ext4
[root@localhost ~]# mount /dev/sdb1 /mnt/ext4/
[root@localhost ~]# df -hT /mnt/ext4/
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/sdb1      ext4   20G  172M   19G   1% /mnt/ext4
```

6.创建测试文件。

```
[root@localhost ~]# cd /mnt/ext4/
[root@localhost ext4]# echo 1 > a
[root@localhost ext4]# echo 2 > b
[root@localhost ext4]# echo 3 > c
[root@localhost ext4]# ls
a  b  c  lost+found
```

7.删除测试文件。

```
[root@localhost ext4]# rm -f a b
[root@localhost ext4]# ls
c  lost+found
```

8.卸载对应的分区。

```
[root@localhost ext4]# cd
[root@localhost ~]# umount /mnt/ext4/
```

9.恢复删除的内容。

```
[root@localhost ~]# extundelete /dev/sdb1 --restore-all
NOTICE: Extended attributes are not restored.
Loading filesystem metadata ... 160 groups loaded.
Loading journal descriptors ... 24 descriptors loaded.
Searching for recoverable inodes in directory / ...
2 recoverable inodes found.
Looking through the directory structure for deleted files ...
0 recoverable inodes still lost.
```

10.恢复的文件会在在当前目录下的`RECOVERED_FILES`文件夹内。

```
[root@localhost ~]# ls RECOVERED_FILES/
a  b
```



## 附

一、文件删除原理
在ext3/4文件系统中，inode索引节点除了存放文件属性还指向文件的block节点，是书的目录，block存放文件的实际数据，是书的每一页，文件的上级目录的block存放的是文件名及其inode节点编号，删除文件实际上是删除文件名和inode节点编号的关联以及inode节点内的指针信息，那么实际上，文件的block还在，加上ext3/4文件系统是日志文件系统，格式化时会分配一个固定大小的空间的日志文件journal，它记录创建和删除文件的记录，当删除一个文件，操作系统首先把文件inode信息和文件名称写入到journal，然后删除文件并清空inode原始数据指针。

二、有两种情况无法恢复
1）当新的数据写入到被删除文件占用的block后，原来的inode号就指向新的数据，那么这样是无法找回的。
2）当journal日志文件存满之后，会释放前面的空间，循环使用，存放最新的记录，如果删除文件的记录被覆盖，是恢复不了的。

三、恢复文件的原理
根据journal日志文件残留inode的信息，定位到相关目录，恢复残留inode对应的block。但日志文件恢复只适合小数据量的恢复，因为journal的空间有限，存放不了太多记录。对于大文件如oracle等数据库文件恢复采用逆向推算和数据文件本身特点来提取。

作者：冬日大草原的黄昏
链接：https://www.jianshu.com/p/41f54d30ce68
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。