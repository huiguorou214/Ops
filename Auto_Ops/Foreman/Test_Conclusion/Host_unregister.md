# Host 注册取消方法测试





## 想法说明

关于 Host 注册到 Foreman 上面来使用 Content 后，如果 Host 想取消注册，不想再继续使用 Foreman 里面的 Content 资源来进行补丁包管理的时候又该如何操作呢？

对于这个想法想到了几个问题：

1. foreman 的 All Hosts 中 delete host 后，会不会自动在 host 上自动删掉订阅？
2. Foreman 中 "Hosts" --> "Content Hosts" 中 Delete Host 后，会不会自动在 host 上自动删掉订阅？
3. host 中 执行 subscription-manager unregister 命令后，能否在 foreman 自动 delete 掉？



## 测试详情



### Delete Hosts from "All Hosts"

测试过程：

"Hosts" --> "All Hosts" 界面中，删除掉指定的客户端主机后，再次登录到客户端机器测试 YUM 命令能否正常使用，发现会直接出现报错：

```bash
[root@foreman-client01 yum.repos.d]# subscription-manager repos --list
Consumer profile "96d5047b-824c-47fc-ae32-99120bc276a1" has been deleted from the server. You can use command clean or unregister to remove local profile.
[root@foreman-client01 yum.repos.d]# yum clean all
Loaded plugins: fastestmirror, product-id, search-disabled-repos, subscription-manager
HTTP error (410 - Gone): Unit 96d5047b-824c-47fc-ae32-99120bc276a1 has been deleted
Cleaning repos: Foreman_CentOS-7_CentOS-7-Latest-Base
Cleaning up list of fastest mirrors
Other repos take up 75 M of disk space (use --verbose for details)
[root@foreman-client01 yum.repos.d]# yum repolist
Loaded plugins: fastestmirror, product-id, search-disabled-repos, subscription-manager
HTTP error (410 - Gone): Unit 96d5047b-824c-47fc-ae32-99120bc276a1 has been deleted
Determining fastest mirrors
Foreman_CentOS-7_CentOS-7-Latest-Base                                  | 2.0 kB  00:00:00
(1/2): Foreman_CentOS-7_CentOS-7-Latest-Base/updateinfo                | 115 kB  00:00:00
(2/2): Foreman_CentOS-7_CentOS-7-Latest-Base/primary                   | 4.0 MB  00:00:00
Foreman_CentOS-7_CentOS-7-Latest-Base                                             10072/10072
repo id                                              repo name                          status
!Foreman_CentOS-7_CentOS-7-Latest-Base               CentOS-7-Latest-Base               10,072
repolist: 10,072
```

发现虽然会报错提示订阅被删掉了，HTTP Error，但是还是可以正常的使用 yum 去做一些操作，例如 update vim 就成功了。

不太确定具体原因，但是直接从 Foreman 中删除看起来是无法直接操作 Client 上的订阅取消注册。

尝试再从 Client unregister 之后，发现是正常了。



结论：

直接从 "Hosts" --> "All Hosts" 界面中，删除掉指定的客户端主机后，并不能直接让 Host 也失去订阅，而是会一边报错一边能够继续使用 Foreman 来作为 YUM 源更新软件包，需要再从 Host 中执行 `subscription-manager unregister` 后才能彻底删除订阅。





###  Delete Hosts from "Content Hosts"

测试过程：

"Hosts" --> "Content Hosts" 中删除掉指定的客户端主机后，再次登录到客户端机器测试 YUM 命令能否正常使用。

```bash
[root@foreman-client01 ~]# subscription-manager repos --list
Consumer profile "024499cd-c580-4caa-acac-a6e27adafc49" has been deleted from the server. You can use command clean or unregister to remove local profile.
[root@foreman-client01 ~]# yum clean all
Loaded plugins: fastestmirror, product-id, search-disabled-repos, subscription-manager
HTTP error (410 - Gone): Unit 024499cd-c580-4caa-acac-a6e27adafc49 has been deleted
Cleaning repos: Foreman_CentOS-7_CentOS-7-Latest-Base
Cleaning up list of fastest mirrors
Other repos take up 75 M of disk space (use --verbose for details)
[root@foreman-client01 ~]# subscription-manager unregister
Unregistering from: foreman-server.shinefire.com:443/rhsm
System has been unregistered.
[root@foreman-client01 ~]# yum clean all
Loaded plugins: fastestmirror, product-id, search-disabled-repos, subscription-manager

This system is not registered with an entitlement server. You can use subscription-manager to register.

Determining fastest mirrors
There are no enabled repos.
 Run "yum repolist all" to see the repos you have.
 To enable Red Hat Subscription Management repositories:
     subscription-manager repos --enable <repo>
 To enable custom repositories:
     yum-config-manager --enable <repo>
```

结论：

这种方式也一样还是会报错，并且本身提示了我 `You can use command clean or unregister to remove local profile` ，看来即使从 Foreman 中删除 Hosts 也是不影响 Host 本身执行的一些 register 操作的，始终还是要从 Host 这边执行一下 unregister 来进行清理移除本地的profile。





### subscription-manager unregister

测试过程：

先从 Host 中使用命令行进行 unregister 操作

```bash
[root@foreman-client01 ~]# subscription-manager unregister
Unregistering from: foreman-server.shinefire.com:443/rhsm
System has been unregistered.
[root@foreman-client01 ~]# yum repolist
Loaded plugins: fastestmirror, product-id, search-disabled-repos, subscription-manager

This system is not registered with an entitlement server. You can use subscription-manager to register.

Loading mirror speeds from cached hostfile
repolist: 0
```

再看 Foreman 的 "Hosts" --> "Content Hosts"  界面，发现 unregister 的 Host 还存在，但是 `Subscription Status` 这一栏的状态已经变成了红叉。

点击进 Host 尝试查看详情界面，发现 `Details` 这一栏提示： "This Host is not currently registered with subscription-manager. Use the [Register Host](https://192.168.31.111/hosts/register) workflow to complete registration."

结论：

看来即使从 Host 那边主动去 unregister ，也不会自动让 Foreman 自动删除 Host。





## 总结

不管是从 Foreman 中删除 Host，还是从 Host 中主动取消注册，都不会影响另外一边的情况，也就是说如果既想要从 Foreman 中删除 Host，有想要让 Host 不再使用 Foreman 提供的 YUM 源的话，那么这两步操作都是不可缺失的。