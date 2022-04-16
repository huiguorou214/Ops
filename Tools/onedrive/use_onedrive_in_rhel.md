# How to use OneDrive in RHEL

> 本篇主要是将在 RHEL 来使用 OneDrive 进行一些文件同步或者上传用于平时工作中的一些工作用途，这个对有 Linux 作为主力或者助力办公的人来说，应该会很有实际意义。



## Author

```
Name: Shinefire
Blog: https://github.com/shine-fire/Ops_Notes
E-mail: shine_fire@outlook.com
create-time: 2022-02-02
```



## 本章说明

使用的项目： **[abraunegg / onedrive](https://github.com/abraunegg/onedrive)**

这个项目现在还是在维护的，而且支持商业版本的 OneDrive ，我记得半年多前的时候，那时候想在我的 Linux 上做 OneDrive 来同步一些资料的时候，还没有合适的项目来支持，因为那会儿找到的项目作者已经停止维护了，而且那个停止的项目也并不支持国内商业版的 OneDrive ，当时觉得无法解决就暂时性的先放弃了。

另外就是当时国内其他常用的云盘呀，也都没法在 Linux 上使用，这对我来说也是挺头大的一件事情。



项目相关的详细介绍可以参考项目文档，这里就不详细说明了。



## 环境说明

当前环境如下：

| 名称                    | 内容   |
| ----------------------- | ------ |
| OS_Version              | RHEL7  |
| onedrive_client_version | 2.4.14 |



## 部署

安装基础环境包

```
sudo yum groupinstall 'Development Tools'
sudo yum install libcurl-devel
sudo yum install sqlite-devel
curl -fsS https://dlang.org/install.sh | bash -s dmd
```

需要通知功能还要再额外安装：

```
sudo yum install libnotify-devel
```







