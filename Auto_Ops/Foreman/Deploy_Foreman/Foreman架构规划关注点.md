# Foreman架构规划关注事项





主要关注的一些事项如下：

[TOC]



## 操作系统

Foreman Server 所部署在的环境，是需要重点考虑的一个因素。

不过一般在条件允许的情况下，直接部署在最新发行版本的操作系统即可，一些旧版本的操作系统后面会慢慢的取消兼容性测试等，在版本的迭代过程中慢慢会失去支持。

例如官方在 2021/08 的时候就宣布了在不久后会考虑启用 EL7 版本的系统了。

[原话如下](https://community.theforeman.org/t/deprecation-plans-for-foreman-on-el7-debian-10-and-ubuntu-18-04/25008)：

Then we should also consider that EL9 is on the horizon. It’s expected that CentOS Stream 9 should be on the mirror network in a matter of weeks ([source 2](https://lists.centos.org/pipermail/centos-devel/2021-August/077263.html)). This brings us to some CI limitations. We don’t have enough resources to do our pipeline testing on all OSes. Dropping EL7 will free up those resources.

For that I’m proposing that we start announcing with Foreman 3.0 that we’re deprecating EL7 support. Actual removal can happen later. This isn’t based on a lot, but I’m thinking about 3.2 or 3.3.





## 节点考虑

需要根据当前或者未来规划的组织资源环境，来考虑是单节点还是多节点之类。

对于大型组织，存在多个数据中心的情况下，是有必要去考虑部署Proxy节点的。





## 插件扩展考虑

首次部署的话，最好是先多看一下官方文档再进行操作，Foreman有些功能是不支持部署后进行拓展的，所以最好是先结合文档与自己的需求来考虑有哪些插件是自己必需的。

例如安装的过程中，是需要额外指定才能添加 Ansible 插件的。
