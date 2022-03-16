> 3.1版本，当前的文档版  --  2022.02.21



# 快速入门指南

`Foreman installer` 是一个 Puppet 模块的合集，可以通过它自动地安装配置整个 Foreman 所需要的一切。它使用本机的软件包格式打包而成（例如 RPM 或者 .deb 之类），并且添加一些必要配置以便于能够完整的安装。

它的组件包括以下一些：

- Foreman Web UI
- Smart Proxy
- Puppet Server端
- 可选的 TFTP
- DNS
- DHCP Server

 It is configurable and the Puppet modules can be read or run in “no-op” mode to see what changes it will make.



Foreman 所支持的平台：

- CentOS 7 x86_64
- CentOS 8 x86_64
- CentOS 8 Stream x86_64
- Debian 10 (Buster), amd64
- Red Hat Enterprise Linux 7, x86_64
- Red Hat Enterprise Linux 8, x86_64
- Ubuntu 20.04 (Focal), amd64

其他的一些平台款能未进行自动化安装验证，所以如果使用其他的平台还需要自己额外进行测试，不保证能够正常使用，其他平台的相关疑问还可以在这里寻求帮助：[discourse support section](https://community.theforeman.org/c/support/10)



