# Ansible 2.10 New Features



## Prerequisites

安装前需要注意查看Ansible控制节点和被管理节点的要求，控制节点和被管理节点有不一样的最小化要求



### Control node requirements

控制节点（即运行Ansible的机器），可以使用已安装Python2（2.7版本）或者Python3（3.5或更高版本）。

ansible-core 2.11 和 Ansible 4.0.0 则将需要依赖Python 3.8，不过之前的版本也是可以运行。

ansible-core 2.12 和 Ansible 5.0.0 则将需要依赖Python 3.8或者更高的版本才可以运行。

从ansible-core 2.11 开始，本项目仅被打包进了 Python 3.8 或者更新的版本里面



### Managed node requirements

Ansible控制端和被管理节点通信的时候，需要使用到SSH来进行连接和SFTP来做传输模块，如果你的SFTP在被管理节点是无法使用的，那你需要在`ansible.cfg`中将传输方式修改为scp，

如果启用了SELinux则需要提前安装`libselinux-python`



## Selecting an Ansible artifact and version to install

从2.10版本开始，Ansible发布了两个类型的模块，即`ansible`和`ansible-core`，选择适合你需要的即可。



### Installing the Ansible community package

`ansible`包含了Ansible语言和运行时一系列社区收集的插件，它重建并扩展了包含在Ansible2.9里面的功能

你可以选择以下两个方法去安装 Ansible community package：

- 从YUM源里面安装
- 通过pip进行安装



### Installing ansible-core

Ansible还发布了一个极简的对象称为`ansible-core`，它包含了Ansible语言，运行时，核心模块和其他插件的简短列表，







## Questions

- `ansible`和`ansible-core`的所代表的模块的意义