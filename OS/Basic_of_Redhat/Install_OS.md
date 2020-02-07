# Install OS



### Author

```txt
Name:Shinefire
Blog:
E-mail:czy@clinux.cn
```



> 本章的目的主要是为了介绍如何安装Linux OS
>
> 本来是想介绍安装RHEL的，不过目前的条件有限，还是先以安装CentOS为例吧，之后会好好努力不断更新的。
>



### 虚拟机安装

**VMware workstations 图形化界面安装CentOS6.6**

链接博客地址：<https://www.cnblogs.com/huanghuahui/p/7085453.html>

P.S. 因为这些在虚拟机安装OS的基础教材网上很多，我目前就先不重复造轮子了，直接放个链接吧，侵删。



### U盘启动盘安装

参考博客：

U盘安装CentOS7.1教程

https://blog.csdn.net/happy_joker/article/details/52822025



1. 制作U盘

   `看上述博客即可`

   a. 使用UltraISO工具，文件→打开，选择你的ISO文件

   b. 启动→写入硬盘映像→写入方式（一般默认即可）

   ​	（写入方式的区别：https://zhidao.baidu.com/question/526542283.html）

2. 安装系统

   a. 使用U盘安装系统一开始就有个很麻烦的问题需要注意，后续都是一样的。参考的博客就是以前我自己在使用U盘安装系统的时候找到的解决了我的方法的博客。

   在出现选择安装的界面时，按下面的方式进行操作：

   ```
   先移动到第一项Install
   然后按tab键编辑路径
   将
   vmlinuz initrd=initrd.img inst.stage2=hd:LABEL=CentOS\x207\x20x86_64 quiet
   改成
   vmlinuz initrd=initrd.img linux dd quiet
   回车
   然后就能在显示出的列表中 查看你的硬盘信息，很清晰就能知道哪一个是你的U盘（一般显示的几个 格式为NTFS的都是你电脑自身的盘符，另外的一个就是你的U盘，记下你的U盘的盘符名字 我的就是sda4）
   使用ctrl+alt+del 重新启动电脑，重复上面的步骤 这一次 将
   vmlinuz initrd=initrd.img inst.stage2=hd:LABEL=CentOS\x207\x20x86_64 quiet
   改成
   vmlinuz initrd=initrd.img inst.stage2=hd:/dev/sda4（你自己的U盘盘符） quiet
   回车 等待安装程序启动，进行CentOS的安装
   ```




### 光盘安装

这个应该没必要吧？ 略过了



### Cobbler批量安装

点击进入 Cobbler专题 查看更详细的 **cobbler** 批量安装系统软件的使用



