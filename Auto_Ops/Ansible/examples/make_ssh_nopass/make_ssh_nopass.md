# make ssh nopass



## 一、ansible

## 二、ssh-keyscan获取集群机器ssh公钥指纹

使用`ssh-keyscan`命令，批量获取集群上机器的密钥指纹。

ssh-keyscan语法：  
ssh-keyscan [-46Hv] [-f file] [-p port] [-T timeout] [-t type] [host | addrlist namelist] ...

详情查看 `man ssh-keyscan`

### 1.1 编写IP列表文件

将所有需要管理的机器IP写入IP列表文件中。

```bash
# vim hostlist.txt
192.168.43.106
47.101.59.219
```

### 1.2 使用ssh-keyscan进行扫描

```bash
# ssh-keyscan -f hostlist.txt -t ecdsa 1>>~/.ssh/known_hosts 2>/dev/null
# cat ~/.ssh/known_hosts
192.168.43.106 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCABh/vq0j+lotmvJU463jIPBom8VHXk7rsOD8yeucMBkibW6s4U6yhL6clVUZ/qRhH5zQG+RVd1uPAZLawXrrs=
47.101.59.219 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPzVNARaxo4ECUKIEPBv04DDGZRxKC5WsATbs3W43vxMzP+PmCJFrbX1G9XBB3XwKqZRRxxX5CVXHLCXcIBBcfA=
```

## 二、编写inventory

```
# vim inventory 
[client]
client1 ansible_ssh_host=192.168.43.106 ansible_ssh_pass=123456
```







## 参考文档

利用ssh-keyscan获取集群机器SSH公钥指纹：https://liam.page/2018/01/24/ssh-keyscan/





















