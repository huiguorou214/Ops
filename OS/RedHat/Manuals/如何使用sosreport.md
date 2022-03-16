# 如何使用 sosreport



### SOSreport

> sosreport是一个类型于supportconfig 的工具，sosreport是python编写的一个工具，适用于centos（和redhat一样，包名为sos）、ubuntu（其下包名为sosreport）等大多数版本的linux 。sosreport在github上的托管页面为：https://github.com/sosreport/sos ，而且默认在很多系统的源里都已经集成有。如果使用的是正版redhat，在出现系统问题，寻求官方支持时，官方一般也会通过sosreport将收集的信息进行分析查看。需要注意的是在一些老的redhat发行版中叫sysreport ------ 如redhat4.5之前的版本中。





### 安装 sosreport

> rhel的操作系统默认会安装有sosreport工具的，如果使用rhel的操作系统则无须进行额外安装。
>
> 如果是使用的centos的话，可能有需要额外进行一下安装。

使用以下命令进行安装：

```
yum install sos 
```



### 运行 sosreport 生成结果

步骤如下：

1. 执行 `sosreport` 命令；
2. Press ENTER to continue, or CTRL-C to quit. --> 按回车继续采集即可
3. Please enter the case id that you are generating this report for []:  --> 按回车继续采集即可
4. 等待采集完成后会在 /var/tmp/ 目录下生成一个 sosreport-xxx.tar.xz 的文件



