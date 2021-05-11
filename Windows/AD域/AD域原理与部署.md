# AD域原理与部署

> 本章主要介绍如何对XXX进行一个快速的简单上手使用，适用于个人或者公司内部非常简易的传输文件使用。

## Author

```
Name:Shinefire
Blog:https://github.com/shine-fire/Ops_Notes
E-mail:shine_fire@outlook.com
```

## Introduction



## Windows域/域树/域林

概念大概如下：

![img](AD%E5%9F%9F%E5%8E%9F%E7%90%86%E4%B8%8E%E9%83%A8%E7%BD%B2.assets/907015_1339317886G3Nw.png)

1. 域是一种管理单元,也是一个管理边界,在同一个域内共享某些功能和参数;一个域可以有多台域控制器.如上图中domain1.com/A.domain1.com/domain2.com分别代表三个独立的域;
2. 域树是指基于在DNS命名空间,如果一个域是另一个域的子域,那么这两个域可以组成一个域树; 例如上图中domain1.com/A.domain1.com组成一个域树,domain2.com/A.domain2.com组成一个域树;
3. 域林是指一个后多个不连续DNS名的域(树)的集合;例如上图中的domain1.com/domain2.com/domain3.com组成一个域林;
4. 域林中的第一个被创建的域,称之为林根域;



## References

- windows域，AD域以及AD域部署 https://zhuanlan.zhihu.com/p/45553448
- Windows域/域树/域林的简单区别 https://blog.51cto.com/281816327/894475
- 

