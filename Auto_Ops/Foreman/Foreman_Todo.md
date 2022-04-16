# Foreman Todo



## 测试扩展新功能

### 测试功能说明

对于首次在使用 foreman-installer 安装后，一些插件或者功能未启用的情况下，想再进行增加需要如何进行操作比较合适？



### 测试结果

对于 **Katello** ，官方明确说明不能在后续添加，所以这个必须在一开始安装 Foreman 时就需要加上。

对于其他的一些功能，



### 测试过程

先使用 foreman-installer 安装少量的插件部署基础环境





添加额外的插件，尝试直接添加安装看是否可行。

额外添加 vmware ovirt 试试看





## 如何安装puppet

使用 katello 的 scenario 安装的话，默认是不会再进行 puppet 的安装了，

参考：Starting with Katello 4.3/Foreman 3.1, Puppet is not enabled and configured by default. https://community.theforeman.org/t/foreman-installer-scenario-katello-does-not-install-puppet-server/26664/5



所以现在有两个疑问，一个是如果不安装 puppet 会有什么影响？另外一个就是如果有影响的话，是否可以在此基础上进行加装。 



尝试直接加装

```bash
~]# foreman-installer --enable-puppet
```

但是从 `foreman-maintain service list` 的结果上，也没有看有加上 puppetserver 之类的服务，看来这样操作并不是正确的方法。



加装应该是没问题的，后续需要参考一下帖子里面提到的文档进行测试：https://community.theforeman.org/t/foreman-installer-scenario-katello-does-not-install-puppet-server/26664/6?u=shinefire

在 Foreman 启用 puppet 集成可以参考官方文档：https://docs.theforeman.org/3.2/Managing_Configurations_Puppet/index-katello.html#Enabling_Puppet_Integration_managing-configurations-puppet



不加装应该也是没有关系的，目前看来加装启用 Puppet 应该也就和增加一个 Ansible 的作用差不多，如果不需要使用 Puppet 自动化工具去管理客户端主机的话，也可以不加。





## Ansible Plugin 安装



Foreman 中的 Ansible 的详细配置与使用参考：https://docs.theforeman.org/3.2/Configuring_Ansible/index-foreman-el.html#getting-started-with-ansible_ansible







## 如何安装一个单独的 proxy 节点？





## 测试后增加的repository 如何方便地加入到已注册的hosts上





## 考虑补丁包安装后如何回退的方案

目前考虑是不是要使用ansible来借助 yum history 来搜索回退之类的。





## 报表生成的文档

参考：https://docs.theforeman.org/3.2/Managing_Hosts/index-foreman-el.html#Generating_Host_Monitoring_Reports_managing-hosts

可以生成一些报表，例如





## 测试关闭 rhsmcertd.service

测试一下，如果在 host 关闭了 rhsmcertd.service 之后，是不是就无法正常的使用订阅管理了，以及补丁那些也都无法正常使用了。





## 修改远程使用的用户

尝试修改远程执行命令的用户为其他用户的时候，发现远程命令运行失败...





## 测试生成的命令行安装 subscription-manager

正常情况下，是要先在 client 安装好 subscription-manager 才能进行管理的，但是如果在生成的命令行上给它加上默认安装这个软件包，是不是就可以在使用命令行注册的时候就安装上了？









## 对比一下红帽和开源的errata



红帽的 https://www.redhat.com/security/data/oval/v2/RHEL7/rhel-7.oval.xml.bz2





## 对比一下安装前后的 密钥 

不安装 remote exec ssh 的话，是不是 /usr/share/foreman-proxy/.ssh/ 目录下也不会有密钥？

没有！！！





## 安装前后的软件包

看看安装前后的那些 ansible-runner 的是否能够正常安装

如果锁死了repofile的话，报错安装完成后，ansible-runner 这个yum源里面那些软件包也不会自动安装的。