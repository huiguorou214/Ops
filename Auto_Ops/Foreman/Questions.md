# Questions





Q1：

是否可以对指定的RHSA在多台服务器中进行更新呢？

A1：



Q2：

是否可以对指定的RPM包在多台服务器中进行批量更新呢

A1：



Q3：

对于全面性的 yum update，在更新后，是否还能过滤出需要重启的机器呢？

这样主要是考虑更新为更新，不主动在更新完直接重启机器，而是在更新完毕之后再重启机器。

A1：

可以考虑用 need reboot 来进行筛选



Q4：

Foreman 的默认安装路径是？

A：

默认的安装路径在 `/etc/foreman-installer/scenarios.d/foreman.yaml` 的 `installer_dir` 参数定义，默认定义路径在 `/usr/share/foreman-installer`



Q5：

如果想使用外部自己已有的数据库要怎么定义呢？

A：

如果想使用自己已有的数据库来进行管理，可以参考官方文档：

https://www.theforeman.org/manuals/3.1/index.html#3.2.3InstallationScenarios

使用额外的一系列 `--foreman-db-xxxx` 的参数来进行定义外部数据库，

更详细的文档可以参考：https://docs.theforeman.org/3.1/Installing_Server/index-katello.html#using-external-databases_foreman

