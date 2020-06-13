# 故障排查



### Author

```txt
Name:Shinefire
Blog:
E-mail:czy@clinux.cn
```



> 本章节主要是介绍了与操作系统故障排查相关的各类方法。



---

### SOSreport

> sosreport是一个类型于supportconfig 的工具，sosreport是python编写的一个工具，适用于centos（和redhat一样，包名为sos）、ubuntu（其下包名为sosreport）等大多数版本的linux 。sosreport在github上的托管页面为：https://github.com/sosreport/sos ，而且默认在很多系统的源里都已经集成有。如果使用的是正版redhat，在出现系统问题，寻求官方支持时，官方一般也会通过sosreport将收集的信息进行分析查看。需要注意的是在一些老的redhat发行版中叫sysreport ------ 如redhat4.5之前的版本中。



#### 安装SOSreport

```
yum install sos 
```



