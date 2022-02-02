# yum



## yum的主要命令

```
List of Commands:
check          Check for problems in the rpmdb
check-update   Check for available package updates
clean          Remove cached data
deplist        List a package's dependencies
downgrade      downgrade a package
erase          Remove a package or packages from your system
groups         Display, or use, the groups information
history        Display, or use, the transaction history
info           Display details about a package or group of packages
install        Install a package or packages on your system
list           List a package or groups of packages
makecache      Generate the metadata cache
provides       Find what package provides the given value
reinstall      reinstall a package
repolist       Display the configured software repositories
search         Search package details for the given string
shell          Run an interactive yum shell
swap           Simple way to swap packages, instead of using shell
update         Update a package or packages on your system
update-minimal Works like upgrade, but goes to the 'newest' package match which fixes a problem that affects your system
updateinfo     Acts on repository update information
upgrade        Update packages taking obsoletes into account
version        Display a version for the machine and/or available repos.
```



## yum deplist

deplist用来查看指定rpm包所需要的依赖包





## yum updateinfo

获取 updateinfo.xml

官方参考：https://access.redhat.com/solutions/23016

```bash
# mkdir /var/repo
# reposync --gpgcheck -l --repoid=rhel-5-server-els-rpms --download_path=/var/repo --downloadcomps
# cd /var/repo/rhel-5-server-els-rpms
# createrepo -v /var/repo/rhel-5-server-els-rpms
# yum clean all
# yum list-sec
# find /var/cache/yum/ -name *updateinfo.xml*
# mv /var/cache/yum/rhel-5-server-els-rpms/365ae03ca85bb9d3bc509ea9129d1d3fb9a18381-updateinfo.xml.gz /tmp
# cd /tmp
# gzip -d 365ae03ca85bb9d3bc509ea9129d1d3fb9a18381-updateinfo.xml.gz
# mv 365ae03ca85bb9d3bc509ea9129d1d3fb9a18381-updateinfo.xml updateinfo.xml
# cp updateinfo.xml /var/repo/rhel-5-server-els-rpms/repodata/
# modifyrepo /var/repo/rhel-5-server-els-rpms/repodata/updateinfo.xml /var/repo/rhel-5-server-els-rpms/repodata/
```



实际操作，在注册订阅后，更新 yum 缓存

```bash
~]# yum clean all && yum makecache
```



find 查找 updateinfo.xml 文件

```bash
~]# find /var/cache/yum/ -name *updateinfo.xml*
/var/cache/yum/x86_64/7Server/rhel-7-server-rpms/gen/updateinfo.xml
/var/cache/yum/x86_64/7Server/rhel-7-server-rpms/cb3d9d7cb375eabdb15a24fb0727c62eb7aca179-updateinfo.xml.gz
~]# mv /var/cache/yum/x86_64/7Server/rhel-7-server-rpms/cb3d9d7cb375eabdb15a24fb0727c62eb7aca179-updateinfo.xml.gz /tmp/
~]# cd /tmp
~]# gzip -d cb3d9d7cb375eabdb15a24fb0727c62eb7aca179-updateinfo.xml.gz
~]# ls cb3d9d7cb375eabdb15a24fb0727c62eb7aca179-updateinfo.xml
~]# mv cb3d9d7cb375eabdb15a24fb0727c62eb7aca179-updateinfo.xml updateinfo.xml
```

虽然官方文档后续是用这个 gz 文件操作的，不过我觉得不用这个也没关系，上面这个 gen 目录下的应该就是解压好了的，不过我没有测试过。



modifyrepo 修改更新 yum repo

```bash
~]# cp updateinfo.xml /var/www/html/yum/rhel/rhel7/rhel-7-server-rpms/repodata/
~]# modifyrepo /var/www/html/yum/rhel/rhel7/rhel-7-server-rpms/repodata/updateinfo.xml /var/www/html/yum/rhel/rhel7/rhel-7-server-rpms/repodata/
Wrote: /var/www/html/yum/rhel/rhel7/rhel-7-server-rpms/repodata/updateinfo.xml.gz
           type = updateinfo
       location = repodata/0a916af1676f937ff2eed97fa8febd1106632633d058a439c336bf69838302f2-updateinfo.xml.gz
       checksum = 0a916af1676f937ff2eed97fa8febd1106632633d058a439c336bf69838302f2
      timestamp = 1641905212
  open-checksum = a961a31e7e9a0a5c23861f1d3b1adaa0cbf06b265afa649d346080c81846b477
Wrote: /var/www/html/yum/rhel/rhel7/rhel-7-server-rpms/repodata/repomd.xml
```



检查结果

```bash
~]# yum updateinfo list --security | grep '^RHSA'
RHSA-2020:1542 Important/Sec. ansible-2.9.7-1.el7ae.noarch
RHSA-2020:3602 Important/Sec. ansible-2.9.13-1.el7ae.noarch
RHSA-2021:0663 Moderate/Sec.  ansible-2.9.18-1.el7ae.noarch
RHSA-2021:1342 Moderate/Sec.  ansible-2.9.20-1.el7ae.noarch
RHSA-2021:2664 Important/Sec. ansible-2.9.23-1.el7ae.noarch
RHSA-2021:3872 Important/Sec. ansible-2.9.27-1.el7ae.noarch
...
```





## yum groups

groups用来查看一些与groups相关的信息

- yum groups list   列出gropus
- yum groups list hidden  列出所有的groups（包括隐藏的）
- yum groups info