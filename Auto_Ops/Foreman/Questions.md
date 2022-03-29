# Questions



## 指定RHSA批量应用

Q1：

是否可以对指定的RHSA在多台服务器中进行更新呢？

A1：

可以的，直接指定Errata，然后选择要应用的机器即可。



## 指定 RPM 批量安装更新

Q2：

是否可以对指定的RPM包在多台服务器中进行批量更新呢

A1：

这个好像不行，目前看来只能是指定errata。

如果要实现批量更新或者安装的话，应该要考虑使用 Job Template 的方式，进行远程批量操作了。

（待验证）



## 过滤需要重启的机器

Q3：

对于全面性的 yum update，在更新后，是否还能过滤出需要重启的机器呢？

这样主要是考虑更新为更新，不主动在更新完直接重启机器，而是在更新完毕之后再重启机器。

A1：

可以考虑用 need reboot 来进行筛选



## 对接外部数据库

Q5：

如果想使用外部自己已有的数据库要怎么定义呢？

A：

如果想使用自己已有的数据库来进行管理，可以参考官方文档：

https://www.theforeman.org/manuals/3.1/index.html#3.2.3InstallationScenarios

使用额外的一系列 `--foreman-db-xxxx` 的参数来进行定义外部数据库，

更详细的文档可以参考：https://docs.theforeman.org/3.1/Installing_Server/index-katello.html#using-external-databases_foreman





## 后续添加plugin

Q1：

如果最开始使用 foreman-installer 的时候，没有指定启用的一些插件，后面在使用过程中要怎么再进行添加呢？

A：

**未测试**，理论上应该是可以再次使用 `--reset` 进行重新安装的。

好像直接再重新加插件参数进行加装即可。



## 如何找默认DB账户信息

Q2：

Foreman 安装完毕后，例如DB的这些账户信息之类的，要在什么地方查看呢？

A：

命令行安装指定的参数，会默认保存到 /etc/foreman-installer/scenarios.d/foreman-answers.yaml 这个文件中。

但是如果这里面并不会明文包含DB账户信息之类的，默认的DB账户信息还需要在哪里去找呢？



## Foreman 默认安装路径

Q：

Foreman 的默认安装路径是？

A：

默认的安装路径在 `/etc/foreman-installer/scenarios.d/foreman.yaml` 的 `installer_dir` 参数定义，默认定义路径在 `/usr/share/foreman-installer`



## foreman-installer 安装出问题如何重装问题

Q4：

在使用 foreman-installer 安装过程中出现问题，怎么再次尝试？

A：

安装过程中如果出现问题可以增加 --reset 参数重新安装。

不过应该也可以直接安装，这个问题还是个问题...



## 加装 katello 报错

Q5：

Foreman 第一次安装的时候没有安装 Katello，想尝试重装一下Katello，发现报错如下：

```bash
[root@foreman-server ~]# foreman-installer --scenario katello --enable-foreman-plugin-openscap --enable-foreman-proxy-plugin-openscap --enable-foreman-cli-openscap --enable-foreman-compute-vmware --enable-foreman-compute-ovirt --foreman-initial-organization "Shine-Fire" --foreman-initial-location "China" --foreman-initial-admin-username admin --foreman-initial-admin-password password --foreman-initial-admin-timezone Asia/Shanghai --tuning medium --reset --force
2022-03-16 16:09:20 [NOTICE] [scenario_manager] Scenario /etc/foreman-installer/scenarios.d/katello.yaml was selected
2022-03-16 16:09:20 [NOTICE] [root] Due to scenario change the configuration (/etc/foreman-installer/scenarios.d/katello.yaml) was updated with /etc/foreman-installer/scenarios.d/foreman.yaml and reloaded.
2022-03-16 16:09:20 [NOTICE] [root] Loading installer configuration. This will take some time.
Traceback (most recent call last):
        18: from /usr/sbin/foreman-installer:8:in `<main>'
        17: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/kafo_configure.rb:50:in `run'
        16: from /usr/share/gems/gems/clamp-1.1.2/lib/clamp/command.rb:132:in `run'
        15: from /usr/share/gems/gems/clamp-1.1.2/lib/clamp/command.rb:132:in `new'
        14: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/kafo_configure.rb:157:in `initialize'
        13: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/kafo_configure.rb:316:in `set_parameters'
        12: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/scenario_manager.rb:217:in `load_and_setup_configuration'
        11: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/configuration.rb:268:in `preset_defaults_from_puppet'
        10: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/configuration.rb:258:in `params'
         9: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/configuration.rb:132:in `modules'
         8: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/configuration.rb:396:in `register_data_types'
         7: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/configuration.rb:396:in `each'
         6: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/configuration.rb:397:in `block in register_data_types'
         5: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/configuration.rb:397:in `each'
         4: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/configuration.rb:398:in `block (2 levels) in register_data_types'
         3: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/data_type_parser.rb:20:in `register'
         2: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/data_type_parser.rb:20:in `each'
         1: from /usr/share/gems/gems/kafo-6.4.0/lib/kafo/data_type_parser.rb:22:in `block in register'
/usr/share/gems/gems/kafo-6.4.0/lib/kafo/data_type.rb:31:in `register_type': Data type Apache::LogLevel is already registered, cannot be re-registered (ArgumentError)
```

A：

怀疑这种情况下，可能需要重装才行了。

本想尝试看看能不能完全卸载 Foreman 的，但是发现 `katello-remove` 命令已经被移除掉了的样子：https://access.redhat.com/solutions/5048661

目前是直接重新用了系统快照来解决了。

后来根据官方文档的描述来看，如果要想使用 Katello 的话，必须是要在第一开始部署 Foreman 就要进行安装 Katello，无法通过后续的类型加装 Plugin 的方式来进行，不过官方还有说以后可能会考虑真正的把 Katello 独立出来，能够实现 Plugin 的方式加装，所以目前是可选的，但是你要使用的话，需要一开始就清楚自己是否需要，不然后续是没法加上去的。



## 安装 selinux 相关软件包报错

Q6：

使用 foreman-installer 过程中遇到了以下 selinux 相关的报错：

```bash
~]# foreman-installer --scenario katello --enable-foreman-plugin-openscap --enable-foreman-proxy-plugin-openscap --enable-foreman-cli-openscap --enable-foreman-plugin-remote-execution  --enable-foreman-proxy-plugin-remote-execution-ssh  --foreman-initial-organization "Shine-Fire" --foreman-initial-location "China" --foreman-initial-admin-username admin --foreman-initial-admin-password password --foreman-initial-admin-timezone Asia/Shanghai
2022-03-16 23:26:26 [NOTICE] [root] Loading installer configuration. This will take some time.
2022-03-16 23:26:31 [NOTICE] [root] Running installer with log based terminal output at level NOTICE.
2022-03-16 23:26:31 [NOTICE] [root] Use -l to set the terminal output log level to ERROR, WARN, NOTICE, INFO, or DEBUG. See --full-help for definitions.
Failed to ensure foreman-selinux, katello-selinux, candlepin-selinux, pulpcore-selinux are installed
2022-03-16 23:26:43 [ERROR ] [root] Failed to ensure foreman-selinux, katello-selinux, candlepin-selinux, pulpcore-selinux are installed
Error: Execution of '/bin/dnf -d 0 -e 1 -y install pulpcore-selinux' returned 1: Error: Unable to find a match: pulpcore-selinux
Error: /Stage[main]/Main/Package[pulpcore-selinux]/ensure: change from 'purged' to 'present' failed: Execution of '/bin/dnf -d 0 -e 1 -y install pulpcore-selinux' returned 1: Error: Unable to find a match: pulpcore-selinux
2022-03-16 23:26:43 [ERROR ] [root] Error: Execution of '/bin/dnf -d 0 -e 1 -y install pulpcore-selinux' returned 1: Error: Unable to find a match: pulpcore-selinux
Error: /Stage[main]/Main/Package[pulpcore-selinux]/ensure: change from 'purged' to 'present' failed: Execution of '/bin/dnf -d 0 -e 1 -y install pulpcore-selinux' returned 1: Error: Unable to find a match: pulpcore-selinux
```

A：

因为我刚好没有配置 extras 源，导致系统未能自动安装上 pulpcore-selinux，再次配置好 extras yum 源后暂时避免了无法找到的问题，不过还是由于依赖存在了一些其他方面的问题。



## 安装软件包遇到一些软件包被 filter out 问题

Q7：

安装一些必需的软件包时遇到了下面的问题

```bash
~]# dnf -y install foreman-installer foreman-installer-katello rubygem-foreman_maintain foreman-selinux katello-selinux candlepin-selinux pulpcore-selinux
Last metadata expiration check: 0:04:00 ago on Thu 17 Mar 2022 12:28:28 AM CST.
Error:
 Problem 1: package candlepin-selinux-4.1.8-1.el8.noarch requires candlepin = 4.1.8-1.el8, but none of the providers can be installed
  - package candlepin-4.1.8-1.el8.noarch requires tomcatjss >= 7.2.1-7.1, but none of the providers can be installed
  - cannot install the best candidate for the job
  - package tomcatjss-7.6.1-1.module_el8.5.0+737+ee953a1e.noarch is filtered out by modular filtering
  - package tomcatjss-7.7.0-0.1.alpha1.module_el8.5.0+838+8f96ca18.noarch is filtered out by modular filtering
  - package tomcatjss-7.7.0-1.module_el8.5.0+876+d4bb8aa6.noarch is filtered out by modular filtering
  - package tomcatjss-7.7.1-1.module_el8.6.0+1038+e795ee4b.noarch is filtered out by modular filtering
 Problem 2: package katello-selinux-4.0.2-1.el8.noarch requires candlepin-selinux >= 3.1.10, but none of the providers can be installed
  - package candlepin-selinux-4.1.7-1.el8.noarch requires candlepin = 4.1.7-1.el8, but none of the providers can be installed
  - package candlepin-selinux-4.1.8-1.el8.noarch requires candlepin = 4.1.8-1.el8, but none of the providers can be installed
  - package candlepin-4.1.7-1.el8.noarch requires tomcatjss >= 7.2.1-7.1, but none of the providers can be installed
  - package candlepin-4.1.8-1.el8.noarch requires tomcatjss >= 7.2.1-7.1, but none of the providers can be installed
  - conflicting requests
  - package tomcatjss-7.6.1-1.module_el8.5.0+737+ee953a1e.noarch is filtered out by modular filtering
  - package tomcatjss-7.7.0-0.1.alpha1.module_el8.5.0+838+8f96ca18.noarch is filtered out by modular filtering
  - package tomcatjss-7.7.0-1.module_el8.5.0+876+d4bb8aa6.noarch is filtered out by modular filtering
  - package tomcatjss-7.7.1-1.module_el8.6.0+1038+e795ee4b.noarch is filtered out by modular filtering
(try to add '--skip-broken' to skip uninstallable packages or '--nobest' to use not only best candidate packages)
```

A：

在社区看到了遇到了同样问题的... 然后回答里面说了，要开启 pki-core module

``` bash
~]# dnf module enable pki-core -y
```

https://community.theforeman.org/t/katello-4-foreman-2-4-centos-8-4/23871

（这也太坑了吧...  文档里面也完全没说这个呀... ）



## 安装 pulpcore-selinux 遇到软件版本冲突的问题

Q8：

还是同上类似的问题...

```bash
~]# dnf install pulpcore-selinux
Last metadata expiration check: 0:09:34 ago on Thu 17 Mar 2022 01:44:33 AM CST.
Error:
 Problem: package pulpcore-selinux-1.2.6-2.el8.x86_64 requires pulpcore, but none of the providers can be installed
  - package python38-pulpcore-3.16.0-2.el8.noarch requires python38-psycopg2 >= 2.9.1, but none of the providers can be installed
  - package python38-pulpcore-3.16.1-1.el8.noarch requires python38-psycopg2 >= 2.9.1, but none of the providers can be installed
  - package python38-pulpcore-3.16.3-1.el8.noarch requires python38-psycopg2 >= 2.9.1, but none of the providers can be installed
  - conflicting requests
  - package python38-psycopg2-2.9.1-1.el8.x86_64 is filtered out by modular filtering
(try to add '--skip-broken' to skip uninstallable packages or '--nobest' to use not only best candidate packages)
```

但是官方提供的版本根本没有达到 2.9.1 版本的...

```bash
~]# dnf list| grep python38-psycopg2
python38-psycopg2.x86_64                                2.8.4-4.module_el8.5.0+742+dbad1979                        appstream
python38-psycopg2-doc.x86_64                            2.8.4-4.module_el8.5.0+742+dbad1979                        appstream
python38-psycopg2-tests.x86_64                          2.8.4-4.module_el8.5.0+742+dbad1979                        appstream
~]# dnf module provides python38-psycopg2
Last metadata expiration check: 0:14:00 ago on Thu 17 Mar 2022 01:44:33 AM CST.
python38-psycopg2-2.8.4-4.module_el8.4.0+647+0ba99ce8.x86_64
Module   : python38:3.8:8060020210921015352:5294be16:x86_64
Profiles :
Repo     : appstream
Summary  : Python programming language, version 3.8

python38-psycopg2-2.8.4-4.module_el8.4.0+647+0ba99ce8.x86_64
Module   : python38:3.8:8060020220127154734:5294be16:x86_64
Profiles :
Repo     : appstream
Summary  : Python programming language, version 3.8

python38-psycopg2-2.8.4-4.module_el8.5.0+742+dbad1979.x86_64
Module   : python38:3.8:8050020210331195435:e3d35cca:x86_64
Profiles :
Repo     : appstream
Summary  : Python programming language, version 3.8
```

A：

解决方法：

https://bugzilla.redhat.com/show_bug.cgi?id=2053917:

the required version of package is shipped via ansible-automation-platform-2.1-for-rhel-8-x86_64-rpms repo only

上面这种方式是红帽提供的，应该是需要有那个订阅才可以使用，就没有看了。后面在开源社区单独找到了这个包... ：https://fr2.rpmfind.net/linux/rpm2html/search.php?query=python38-psycopg2&submit=Search+...&system=&arch=

x86_64 rpm download url : https://fr2.rpmfind.net/linux/opensuse/tumbleweed/repo/oss/x86_64/python38-psycopg2-2.9.3-1.3.x86_64.rpm

下载好这个 rpm 包之后，dnf localinstall 安装一下，再去安装 pulpcore-selinux 就成功了。

**最终的解决方法：**

使用了另外一位大佬的文档来做的了：https://docs.theforeman.org/release/nightly/

之前一直安装依赖有问题，主要还是因为 Foreman 官方文档写的就有问题，大佬也在github提了issue吐槽他们的文档，我猜测是因为Foreman社区文档还是用的puppet6的yum源导致的。



## 离线 AppStream 安装软件包提示无可用 modular metadata 问题

Q9：

使用离线的 AppStream 源，遇到无可用modular元数据问题：

```bash
~]# foreman-installer ...
...

No available modular metadata for modular package 'python38-chardet-3.0.4-19.module_el8.5.0+742+dbad1979.noarch', it cannot be installed on the system
No available modular metadata for modular package 'python38-libs-3.8.12-1.module_el8.6.0+929+89303463.x86_64', it cannot be installed on the system
No available modular metadata for modular package 'python38-pip-wheel-19.3.1-5.module_el8.6.0+960+f11a9b17.noarch', it cannot be installed on the system
No available modular metadata for modular package 'python38-setuptools-41.6.0-5.module_el8.6.0+929+89303463.noarch', it cannot be installed on the system
No available modular metadata for modular package 'python38-setuptools-wheel-41.6.0-5.module_el8.6.0+929+89303463.noarch', it cannot be installed on the system
Error: No available modular metadata for modular package
```

A：

离线 AppStream 源之后，createrepo还要注意导入 modular metadata。

参考：https://access.redhat.com/solutions/4888921





## foreman-installer 遇到的 pulp 相关软件包找不到问题

Q10：

foreman-installer 报错安装 python3-pulp-ansible 软件包失败：

```bash
2022-03-17 11:27:06 [ERROR ] [configure] Execution of '/bin/dnf -d 0 -e 1 -y install python3-pulp-ansible' returned 1: Error:
2022-03-17 11:27:06 [ERROR ] [configure] Problem: package python3-pulp-ansible-1:0.9.0-2.el8.noarch requires python3-galaxy-importer >= 0.3.1, but none of the providers can be installed
2022-03-17 11:27:06 [ERROR ] [configure] - cannot install the best candidate for the job
2022-03-17 11:27:06 [ERROR ] [configure] - nothing provides ansible needed by python3-galaxy-importer-0.3.2-1.el8.noarch
2022-03-17 11:27:06 [ERROR ] [configure] /Stage[main]/Pulpcore::Plugin::Ansible/Pulpcore::Plugin[ansible]/Package[python3-pulp-ansible]/ensure: change from 'purged' to 'present' failed: Execution of '/bin/dnf -d 0 -e 1 -y install python3-pulp-ansible' returned 1: Error:
2022-03-17 11:27:06 [ERROR ] [configure] Problem: package python3-pulp-ansible-1:0.9.0-2.el8.noarch requires python3-galaxy-importer >= 0.3.1, but none of the providers can be installed
2022-03-17 11:27:06 [ERROR ] [configure] - cannot install the best candidate for the job
2022-03-17 11:27:06 [ERROR ] [configure] - nothing provides ansible needed by python3-galaxy-importer-0.3.2-1.el8.noarch

```

尝试手动安装还是失败：

```bash
~]# dnf install -y python3-pulp-ansible
Last metadata expiration check: 0:17:07 ago on Thu 17 Mar 2022 11:20:02 AM CST.
Error:
 Problem: package python3-pulp-ansible-1:0.9.0-2.el8.noarch requires python3-galaxy-importer >= 0.3.1, but none of the providers can be installed
  - cannot install the best candidate for the job
  - nothing provides ansible needed by python3-galaxy-importer-0.3.2-1.el8.noarch
```

A：

在社区看到了遇到类似问题的帖子：https://community.theforeman.org/t/facing-difficulties-when-trying-to-upgrade-2-4-to-2-5/24145/11

他里面是后来有添加了 epel 源，里面就安装成功了...

但是这个应该也不是长久之策，后来好像还是遇到了这个问题。

最终解决方法：换一个文档参考安装：https://docs.theforeman.org/release/nightly/

上面换一个文档参考安装解决了的原因是因为那个 nightly 所使用的根本就不是 Foreman 3.1 的安装，而是最新的一些测试版本的安装，Foreman 3.1 安装的话，应该问题还是存在的，目前换 Foreman 3.2 版本来进行安装了，可以避开此问题，具体原因也不太清楚，为什么 Foreman 3.1 版本在安装的时候，会依赖到一些自己不存在的软件包？





## foreman-installer 遇到的 foreman-rake db:migrate 报错

Q11：

foreman-installer 安装的时候遇到 `foreman-rake db:migrate` 的报错 

```bash
2022-03-17 12:06:44 [ERROR ] [configure] '/usr/sbin/foreman-rake db:migrate' returned 1 instead of one of [0]
2022-03-17 12:06:44 [ERROR ] [configure] /Stage[main]/Foreman::Database/Foreman::Rake[db:migrate]/Exec[foreman-rake-db:migrate]/returns: change from 'notrun' to ['0'] failed: '/usr/sbin/foreman-rake db:migrate' returned 1 instead of one of [0]
```



尝试手动执行一下 `foreman-rake db:migrate`

```bash
[root@foreman-server ~]# foreman-rake db:migrate --trace
** Invoke db:migrate (first_time)
** Invoke db:load_config (first_time)
** Invoke environment (first_time)
** Execute environment
** Execute db:load_config
** Invoke plugin:refresh_migrations (first_time)
** Invoke environment
** Execute plugin:refresh_migrations
** Execute db:migrate
== 20200803065041 MigratePortOverridesForAnsible: migrating ===================
rake aborted!
StandardError: An error has occurred, this and all later migrations canceled:

uninitialized constant MigratePortOverridesForAnsible::AnsibleRole
/usr/share/gems/gems/foreman_openscap-5.2.1/db/migrate/20200803065041_migrate_port_overrides_for_ansible.rb:14:in `transform_lookup_values'
/usr/share/gems/gems/foreman_openscap-5.2.1/db/migrate/20200803065041_migrate_port_overrides_for_ansible.rb:3:in `up'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:831:in `exec_migration'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:812:in `block (2 levels) in migrate'
/usr/share/ruby/benchmark.rb:293:in `measure'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:811:in `block in migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/connection_adapters/abstract/connection_pool.rb:471:in `with_connection'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:810:in `migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1002:in `migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1310:in `block in execute_migration_in_transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1361:in `block in ddl_transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/connection_adapters/abstract/database_statements.rb:280:in `block in transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/connection_adapters/abstract/transaction.rb:280:in `block in within_new_transaction'
/usr/share/gems/gems/activesupport-6.0.3.7/lib/active_support/concurrency/load_interlock_aware_monitor.rb:26:in `block (2 levels) in synchronize'
/usr/share/gems/gems/activesupport-6.0.3.7/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `handle_interrupt'
/usr/share/gems/gems/activesupport-6.0.3.7/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `block in synchronize'
/usr/share/gems/gems/activesupport-6.0.3.7/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `handle_interrupt'
/usr/share/gems/gems/activesupport-6.0.3.7/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `synchronize'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/connection_adapters/abstract/transaction.rb:278:in `within_new_transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/connection_adapters/abstract/database_statements.rb:280:in `transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/transactions.rb:212:in `transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1361:in `ddl_transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1309:in `execute_migration_in_transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1281:in `block in migrate_without_lock'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1280:in `each'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1280:in `migrate_without_lock'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1229:in `block in migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1382:in `with_advisory_lock'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1229:in `migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1061:in `up'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1036:in `migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/tasks/database_tasks.rb:238:in `migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/railties/databases.rake:86:in `block (3 levels) in <top (required)>'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/railties/databases.rake:84:in `each'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/railties/databases.rake:84:in `block (2 levels) in <top (required)>'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:281:in `block in execute'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:281:in `each'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:281:in `execute'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:219:in `block in invoke_with_call_chain'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:199:in `synchronize'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:199:in `invoke_with_call_chain'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:188:in `invoke'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:160:in `invoke_task'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:116:in `block (2 levels) in top_level'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:116:in `each'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:116:in `block in top_level'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:125:in `run_with_threads'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:110:in `top_level'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:83:in `block in run'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:186:in `standard_exception_handling'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:80:in `run'
/usr/share/gems/gems/rake-13.0.1/exe/rake:27:in `<top (required)>'
/usr/bin/rake:23:in `load'
/usr/bin/rake:23:in `<main>'

Caused by:
NameError: uninitialized constant MigratePortOverridesForAnsible::AnsibleRole
/usr/share/gems/gems/foreman_openscap-5.2.1/db/migrate/20200803065041_migrate_port_overrides_for_ansible.rb:14:in `transform_lookup_values'
/usr/share/gems/gems/foreman_openscap-5.2.1/db/migrate/20200803065041_migrate_port_overrides_for_ansible.rb:3:in `up'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:831:in `exec_migration'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:812:in `block (2 levels) in migrate'
/usr/share/ruby/benchmark.rb:293:in `measure'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:811:in `block in migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/connection_adapters/abstract/connection_pool.rb:471:in `with_connection'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:810:in `migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1002:in `migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1310:in `block in execute_migration_in_transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1361:in `block in ddl_transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/connection_adapters/abstract/database_statements.rb:280:in `block in transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/connection_adapters/abstract/transaction.rb:280:in `block in within_new_transaction'
/usr/share/gems/gems/activesupport-6.0.3.7/lib/active_support/concurrency/load_interlock_aware_monitor.rb:26:in `block (2 levels) in synchronize'
/usr/share/gems/gems/activesupport-6.0.3.7/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `handle_interrupt'
/usr/share/gems/gems/activesupport-6.0.3.7/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `block in synchronize'
/usr/share/gems/gems/activesupport-6.0.3.7/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `handle_interrupt'
/usr/share/gems/gems/activesupport-6.0.3.7/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `synchronize'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/connection_adapters/abstract/transaction.rb:278:in `within_new_transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/connection_adapters/abstract/database_statements.rb:280:in `transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/transactions.rb:212:in `transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1361:in `ddl_transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1309:in `execute_migration_in_transaction'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1281:in `block in migrate_without_lock'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1280:in `each'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1280:in `migrate_without_lock'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1229:in `block in migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1382:in `with_advisory_lock'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1229:in `migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1061:in `up'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:1036:in `migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/tasks/database_tasks.rb:238:in `migrate'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/railties/databases.rake:86:in `block (3 levels) in <top (required)>'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/railties/databases.rake:84:in `each'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/railties/databases.rake:84:in `block (2 levels) in <top (required)>'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:281:in `block in execute'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:281:in `each'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:281:in `execute'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:219:in `block in invoke_with_call_chain'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:199:in `synchronize'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:199:in `invoke_with_call_chain'
/usr/share/gems/gems/rake-13.0.1/lib/rake/task.rb:188:in `invoke'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:160:in `invoke_task'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:116:in `block (2 levels) in top_level'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:116:in `each'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:116:in `block in top_level'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:125:in `run_with_threads'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:110:in `top_level'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:83:in `block in run'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:186:in `standard_exception_handling'
/usr/share/gems/gems/rake-13.0.1/lib/rake/application.rb:80:in `run'
/usr/share/gems/gems/rake-13.0.1/exe/rake:27:in `<top (required)>'
/usr/bin/rake:23:in `load'
/usr/bin/rake:23:in `<main>'
Tasks: TOP => db:migrate
```

A：

发现上面在安装相关软件包的时候，遇到了这个报错，可能会有关联：

```bash
/sbin/restorecon: SELinux: Could not get canonical path for /etc/puppet/node.rb restorecon: No such file or directory.
```

但是查了一下资料，感觉和这个应该关系不是很大，而且这个问题是一年前就被提交的bug了到现在也并没有被修复：https://projects.theforeman.org/issues/32022

另外看社区有人在安装 Ansible 也遇到了类似的问题，并建议我参考他的方法试试：https://community.theforeman.org/t/enabling-ansible-plugin-results-in-failure-of-db-migrate/27048/7

```bash
mv /usr/share/gems/gems/foreman_ansible-7.0.2/app/graphql /tmp
vi /usr/share/gems/gems/foreman_ansible-7.0.2/lib/foreman_ansible/register.rb (comment the block related to graphql)
foreman-rake db:migrate
mv /tmp/graphql /usr/share/gems/gems/foreman_ansible-7.0.2/app/
vi /usr/share/gems/gems/foreman_ansible-7.0.2/lib/foreman_ansible/register.rb (remove the comment so the code)
```



通过我之前执行 `foreman-rake db:migrate` 的结果中，可以看到：

```
StandardError: An error has occurred, this and all later migrations canceled:

uninitialized constant MigratePortOverridesForAnsible::AnsibleRole
/usr/share/gems/gems/foreman_openscap-5.2.1/db/migrate/20200803065041_migrate_port_overrides_for_ansible.rb:14:in `transform_lookup_values'
/usr/share/gems/gems/foreman_openscap-5.2.1/db/migrate/20200803065041_migrate_port_overrides_for_ansible.rb:3:in `up'
/usr/share/gems/gems/activerecord-6.0.3.7/lib/active_record/migration.rb:831:in `exec_migration'
...
```

按那个朋友的做法来猜测，我这个安装失败可能会和 `foreman_openscap` 插件关系比较密切，参考他的方法先移除：

```bash
[root@foreman-server ~]# mv /usr/share/gems/gems/foreman_openscap-5.2.1/app/graphql/ /tmp/
```

再尝试修改 `foreman_openscap` 的 rb 文件，参考他的方法搜索一下 `register.rb` ，但是并没有同名文件

```bash
~]# find /usr/share/gems/gems/foreman_openscap-5.2.1/lib/ -name "*register.rb*"
```

再到目录下找了一下看着可能性比较高的文件：`foreman_openscap.rb`

```bash
~]# cat /usr/share/gems/gems/foreman_openscap-5.2.1/lib/foreman_openscap.rb
require "foreman_openscap/engine"

module ForemanOpenscap
end
```

通过文件内容看到它里面的代码是有调用 `foreman_openscap/engine` ，然后再查看 `foreman_openscap/engine.rb` 这个文件，发现里面有有一段与 graphql 关联系比较大的代码，尝试注释：

```bash
[root@foreman-server lib]# vim foreman_openscap/engine.rb
    #config.autoload_paths += Dir["#{config.root}/app/graphql"]
```

注释后，尝试再次执行 `foreman-rake db:migrate` 后还是有问题：

```bash
~]# foreman-rake db:migrate --trace
Apipie cache enabled but not present yet. Run apipie:cache rake task to speed up API calls.
rake aborted!
NameError: uninitialized constant Mutations::OvalPolicies
/usr/share/gems/gems/foreman_openscap-5.2.1/lib/foreman_openscap/engine.rb:227:in `block (2 levels) in <class:Engine>'
/usr/share/foreman/app/registries/foreman/plugin.rb:100:in `instance_eval'
/usr/share/foreman/app/registries/foreman/plugin.rb:100:in `register'
/usr/share/gems/gems/foreman_openscap-5.2.1/lib/foreman_openscap/engine.rb:50:in `block in <class:Engine>'
/usr/share/gems/gems/railties-6.0.3.7/lib/rails/initializable.rb:32:in `instance_exec'
/usr/share/gems/gems/railties-6.0.3.7/lib/rails/initializable.rb:32:in `run'
/usr/share/foreman/config/initializers/0_print_time_spent.rb:45:in `block in run'
/usr/share/foreman/config/initializers/0_print_time_spent.rb:17:in `benchmark'
/usr/share/foreman/config/initializers/0_print_time_spent.rb:45:in `run'
/usr/share/gems/gems/railties-6.0.3.7/lib/rails/initializable.rb:61:in `block in run_initializers'
/usr/share/gems/gems/railties-6.0.3.7/lib/rails/initializable.rb:60:in `run_initializers'
/usr/share/gems/gems/railties-6.0.3.7/lib/rails/application.rb:363:in `initialize!'
/usr/share/gems/gems/railties-6.0.3.7/lib/rails/railtie.rb:190:in `public_send'
/usr/share/gems/gems/railties-6.0.3.7/lib/rails/railtie.rb:190:in `method_missing'
/usr/share/foreman/config/environment.rb:5:in `<top (required)>'
/usr/share/gems/gems/polyglot-0.3.5/lib/polyglot.rb:65:in `require'
/usr/share/gems/gems/railties-6.0.3.7/lib/rails/application.rb:339:in `require_environment!'
/usr/share/gems/gems/railties-6.0.3.7/lib/rails/application.rb:523:in `block in run_tasks_blocks'
/usr/share/gems/gems/rake-13.0.1/exe/rake:27:in `<top (required)>'
Tasks: TOP => db:migrate => db:load_config => environment
(See full trace by running task with --trace)
```

尝试再次 `foreman-installer` 安装也还是一样的报错：

```bash
[root@foreman-server ~]# foreman-installer --scenario katello \
> --foreman-initial-organization "Shine-Fire" \
> --foreman-initial-location "China" \
> --foreman-initial-admin-username admin \
> --foreman-initial-admin-password password \
> --foreman-initial-admin-timezone Asia/Shanghai \
> --enable-foreman-plugin-openscap \
> --enable-foreman-proxy-plugin-openscap \
> --enable-foreman-cli-openscap \
> --tuning default
2022-03-18 00:35:29 [NOTICE] [root] Loading installer configuration. This will take some time.
2022-03-18 00:35:34 [NOTICE] [root] Running installer with log based terminal output at level NOTICE.
2022-03-18 00:35:34 [NOTICE] [root] Use -l to set the terminal output log level to ERROR, WARN, NOTICE, INFO, or DEBUG. See --full-help for definitions.
2022-03-18 00:35:46 [NOTICE] [configure] Starting system configuration.
2022-03-18 00:36:01 [NOTICE] [configure] 250 configuration steps out of 1770 steps complete.
2022-03-18 00:36:04 [NOTICE] [configure] 500 configuration steps out of 1770 steps complete.
2022-03-18 00:36:08 [NOTICE] [configure] 1000 configuration steps out of 1780 steps complete.
2022-03-18 00:36:09 [NOTICE] [configure] 1250 configuration steps out of 1782 steps complete.
2022-03-18 00:36:29 [ERROR ] [configure] '/usr/sbin/foreman-rake db:migrate' returned 1 instead of one of [0]
2022-03-18 00:36:29 [ERROR ] [configure] /Stage[main]/Foreman::Database/Foreman::Rake[db:migrate]/Exec[foreman-rake-db:migrate]/returns: change from 'notrun' to ['0'] failed: '/usr/sbin/foreman-rake db:migrate' returned 1 instead of one of [0]
2022-03-18 00:36:39 [NOTICE] [configure] 1500 configuration steps out of 1782 steps complete.
2022-03-18 00:36:48 [NOTICE] [configure] 1750 configuration steps out of 1782 steps complete.
2022-03-18 00:36:52 [NOTICE] [configure] System configuration has finished.

  There were errors detected during install.
  Please address the errors and re-run the installer to ensure the system is properly configured.
  Failing to do so is likely to result in broken functionality.

  The full log is at /var/log/foreman-installer/katello.log
```



## 安装一些selinux相关软件包报错问题

Q12：

离线 yum 源来进行安装之前，安装一些必要的软件包，发现报错如下：

```bash
~]# dnf -y install foreman-selinux katello-selinux candlepin-selinux pulpcore-selinux
...
Repository baseos is listed more than once in the configuration
Repository appstream is listed more than once in the configuration
Repository extras is listed more than once in the configuration
Repository powertools is listed more than once in the configuration
Last metadata expiration check: 0:02:54 ago on Fri 18 Mar 2022 03:36:29 AM CST.
Package dnf-plugins-core-4.0.21-10.el8.noarch is already installed.
Dependencies resolved.
Nothing to do.
Complete!
Repository baseos is listed more than once in the configuration
Repository appstream is listed more than once in the configuration
Repository extras is listed more than once in the configuration
Repository powertools is listed more than once in the configuration
Last metadata expiration check: 0:02:56 ago on Fri 18 Mar 2022 03:36:29 AM CST.
All matches were filtered out by modular filtering for argument: rubygem-foreman_maintain
Error: Unable to find a match: rubygem-foreman_maintain
Repository baseos is listed more than once in the configuration
Repository appstream is listed more than once in the configuration
Repository extras is listed more than once in the configuration
Repository powertools is listed more than once in the configuration
Last metadata expiration check: 0:02:59 ago on Fri 18 Mar 2022 03:36:29 AM CST.
All matches were filtered out by modular filtering for argument: katello-selinux
All matches were filtered out by modular filtering for argument: pulpcore-selinux
Error: Unable to find a match: katello-selinux pulpcore-selinux
```

A：

使用离线的yum源安装的时候，还要额外做一个开启 module 的操作，这之前不知道，所以直接就报错了。

先检查没有匹配到的软件包名称，直接 list 是无法列出来的：

```bash
~]# dnf list| grep katello-selinux

```

查找出提供 `pulpcore-selinux` 的 module：

```bash
~]# yum module provides katello-selinux
Last metadata expiration check: 0:07:55 ago on Fri 18 Mar 2022 03:47:44 AM CST.
katello-selinux-4.0.2-1.el8.noarch
Module   : katello:el8:40420220309174543::x86_64
Profiles :
Repo     : katello
Summary  : Katello module
```

通过 summary 字段，可以看到指出了这个软件包是由 katello 这个 module 提供，list 看一下 katello module：

```bash
~]# dnf module list katello
Last metadata expiration check: 0:01:53 ago on Fri 18 Mar 2022 05:20:22 PM CST.
katello
Name                  Stream               Profiles                Summary
katello               el8                  installer               Katello module

Hint: [d]efault, [e]nabled, [x]disabled, [i]nstalled
```

通过命令执行结果可以看到是没有启用这个 katello 的 module ，手动 enable katello module：

```bash
~]# dnf module enable katello
Last metadata expiration check: 0:02:04 ago on Fri 18 Mar 2022 05:20:22 PM CST.
Dependencies resolved.
==============================================================================================
 Package               Architecture         Version               Repository             Size
==============================================================================================
Enabling module streams:
 foreman                                    el8
 katello                                    el8

Transaction Summary
==============================================================================================

Is this ok [y/N]: y
Complete!
```

再检查已经能够找到 `katello-selinux`

```bash
~]# dnf list| grep katello-selinux
katello-selinux.noarch                                            4.0.2-1.el8                                                katello
```



## All Hosts 界面 Host 前面的感叹号提示问题

Q13：

client 订阅 key 后，在 Foreman server 的 "Hosts" --> "All Hosts" 上看到一下告警信息：

![image-20220327162218054](pictures/image-20220327162218054.png)

A：

原因应该是没有在订阅的 Activation Keys 中添加 Subscription 导致订阅后无法查询到可用的 subscription

![image-20220327162632954](pictures/image-20220327162632954.png)

实际上应该是那几个都是一些告警提示之类的信息，而不是只有单纯的一个，是一个集合。

后来解决了一部分，但是也还是有一些存在





## Client 修改主机名后该如何更新？

Q14：

client 修改了主机名之后，在 Foreman 上面是否会及时更新呢？

如果不会及时更新或者根本就不会自动更新的话，又应该如何进行操作主动更新呢？

A：

*发现改了主机名之后，已经不是能否在 Foreman 上及时更新的问题了，而是直接就提示："alert:Host has not been registered with subscription-manager"，连注册都被取消掉了，这样的管理方式让我感到迷惑。*





## 后增加的repository 能否自动加入到已注册的hosts上

Q15：

在已经注册到 Foreman 上面的 Hosts，如果想额外再加一些 repositories 到订阅的 key 上，或者想给 hosts 用的话，需要怎么操作呢？

A：

不确定是不是和这个文档描述的内容差不多，可以参考一下试试：[Updating Subscriptions Associated with an Activation Key](https://docs.theforeman.org/3.2/Content_Management_Guide/index-katello.html#Updating_Subscriptions_Associated_with_an_Activation_Key_content-management) 





## Foreman Server 如何管理 Client？

Q：

Foreman Server 管理 Client 的方式是怎么样的呢？

通过 agent 吗？但是好像也没有看到有 agent 。

如果不是通过 agent 的话，那又是建立长连接的方式还是定期连接一下检查一下呢？还是说由 client 自动去定时发送一些信息报给 Foreman Server 呢？

A：





## DNS会影响Foreman远程执行吗？

Q：

如果没有DNS来提供client的解析的情况下，Foreman Proxy 还是否能够正常的去在 Client 上面执行命令或者 Apply Errata 之类的呢？

A：





## Job Templates 使用的是什么语言？

Q：

使用 Foreman 的时候，可能会涉及到使用、修改甚至自己创建 Job Templates 的情况，但是发现 Job Templates 里面的那些语法比较陌生，刚开始觉得它是使用 puppet 来进行管理的，不确定是不是使用了 puppet 的一些特别语法。

所以 Job Templates 里面的那些写法是什么编程语言的写法呢？

A：

根据官方文档说明：[Job templates use the **Embedded Ruby (ERB) syntax**](https://docs.theforeman.org/3.2/Managing_Hosts/index-foreman-el.html#setting-up-job-templates_managing-hosts)

Job template 所使用的是 **嵌入式Ruby语法**，另外也有一些写法参考，可以查看官方文档进行学习。

语法参考：https://docs.theforeman.org/3.2/Managing_Hosts/index-katello.html#Template_Writing_Reference_managing-hosts





