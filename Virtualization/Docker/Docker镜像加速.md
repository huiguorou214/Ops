# Docker镜像加速配置



## Daocloud

参考：https://www.daocloud.io/mirror

```bash
# curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io
# systemctl restart docker
```

该脚本可以将 --registry-mirror 加入到你的 Docker 配置文件 /etc/docker/daemon.json 中。适用于 Ubuntu14.04、Debian、CentOS6 、CentOS7、Fedora、Arch Linux、openSUSE Leap 42.1，其他版本可能有细微不同。更多详情请访问文档。

不过RHEL用这个脚本执行的话，是不能执行的，里面的版本判断，并不支持redhat的操作系统。