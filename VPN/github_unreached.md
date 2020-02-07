# github不能访问



## 问题描述

github不能ping通，不能被访问，不过nslookup是可以解析的

## 问题分析

GFW的问题

## 解决方案

hosts文件中添加：

```
192.30.253.112 github.com
151.101.88.249 github.global.ssl.fastly.net
```

## 参考博客

github不能访问,ping不通github.com解决办法 https://blog.csdn.net/sdta25196/article/details/80203152 

