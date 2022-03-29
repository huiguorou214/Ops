# Puppet for Foreman

> 本章主要是研究 puppet 对于 Foreman 是具有什么样的意义与功能，以及以前在安装 Foreman 之前都是提前安装 puppet 的软件包的，需要探索一下如果不安装 puppet 会有什么影响？另外就是如果有影响的话，是否可以在此基础上进行加装。 
>
> 参考的文档是基于 Foreman 3.2 版本的官方文档。



[TOC]





## Puppet 介绍

Puppet 可以用来管理和自动配置 Hosts ，而且 Puppet 使用的是声明式语言来描述被管理主机的期望状态。





## Puppet module 管理







## Puppet Classes 使用





## Others

当前的理解是 Puppet 只是相当于一个加装在 Foreman 上面的自动化运维工具，可以选择性的是否需要，如果不需要也没有什么实质性的影响，毕竟管理远程主机的话，平时主要是用来这个 remote execution 通过 ssh 免密去执行我们的一些管理操作。







## References

- [Configuring Hosts Using Puppet](https://docs.theforeman.org/3.2/Managing_Configurations_Puppet/index-katello.html)

