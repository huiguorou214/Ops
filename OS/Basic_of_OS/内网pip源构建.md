# 内网pip源构建

> 本章主要介绍如何构建一个内网pip源，适用于个人或者公司内部一些不能上外网的机器使用pip源。

## Author

```
Name:Shinefire
Blog:https://github.com/shine-fire/Ops_Notes
E-mail:shine_fire@outlook.com
```

## Introduction

此文档主要是用于解决一些环境中，不能够连接外网，但是需要使用到pip安装一些软件包的情况。

因为pip的话不像yum这么规范，pip的软件包的兼容性较差，存在多种版本和打包方式，统一性比较低，不能像yum源那样简单的在外网download就能打包到内网环境中使用，所以考虑对比较封闭的环境部署一个pip内网的源提高内网主机使用pip源的便捷性。



## 国内可用源

系统默认的源是国外的地址，如果想使用国内的源地址，可用参考下面这个常用的源清单：

```
阿里云 http://mirrors.aliyun.com/pypi/simple/
国科技大学 https://pypi.mirrors.ustc.edu.cn/simple/
豆瓣(douban) http://pypi.douban.com/simple/
清华大学 https://pypi.tuna.tsinghua.edu.cn/simple/
中国科学技术大学 http://pypi.mirrors.ustc.edu.cn/simple/
```



## pip安装的加速技巧

```bash
1.使用豆瓣或者阿里云的源进行加速软件的安装
pip install -i https://pypi.douban.com/simple/  flask

2.设置配置文件，不用每次都输入网址
# ~/.pip/pip.conf
cat pip.conf

[global]
index-url = https://pypi.douban.com/simple
```



## pip的基础使用

```
1.查找安装包
pip search flask

2.安装特定版本的安装包
pip install flask==0.8

3.删除安装包
pip uninstall Werkzeug

4.查看安装包信息
pip show flask

5.检查安装包依赖是否完整
pip check flask

6.查看已安装的安装包列表
pip list

7.导出系统已有安装包列表 到 requirements文件
pip freeze > requirements.txt

8.从requirements.txt文件安装
pip install -r requirements.txt

9.使用补全命令
pip completion --bash >> ~/.profile
source ~/.profile
输入 pip i + tab ---> pip install
```



## 普通离线指定pip包到内网环境安装

Step1 下载到本地

```bash
# pip install –download=“pwd” -r requirements.txt
# pip download -d pwd -r requirements.txt
```

Step2 本地安装

```bash
# pip install --no-index -f file://'pwd' -r requirements.txt
```



## 部署内网pip源

（待更新）



## 部署内网pip源（容器版本）




## References

- **pip私有源部署** https://segmentfault.com/a/1190000039264219
- python搭建本地pip源，离线安装python模块 https://www.cnblogs.com/quanloveshui/p/13398592.html
- 制作pip离线源 https://blog.csdn.net/anqixiang/article/details/103410440
- pip 使用，pip加速源配置和本地安装 https://blog.csdn.net/sunt2018/article/details/86232939

