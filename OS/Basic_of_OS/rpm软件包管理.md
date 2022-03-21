# Linux软件包管理（RPM）



### Author

```txt
Name:Shinefire
Blog:
E-mail:czy@clinux.cn
```



> 本章节主要是介绍了一下在Linux系统中的软件包以及红帽系基础的RPM软件包管理工具的日常使用



---

### 软件包的分类

**rpm包** ：xxx-1.2.el6.x86_64.rpm 
**rpm源码包（半成品）** ： xxx-1.2.el6.x86_64.src.rpm 或 xxx.srpm  src.rpm --> rpm --->再安装 
**源码包** ：xxx.tar.gz  xx.tar.xz xx.tar.bz2





---

### RPM包介绍

**rpm包的命名规则**

xlockmore-5.31-2.el6.x86_64.rpm 

软件名字-主版本号.次版本号-发布版本号.系统版本.cpu架构.rpm



**rpm包的构成**
软件包元数据信息（软件包的版本信息，作者信息，安装前后需要执行的脚本等）+软件文件（程序，配置文件，文档等）



**红帽软件包特征<一个软件由多个包组成>**
samba-3.5.10-125.el6.x86_64.rpm          --服务端
samba-client-3.5.10-125.el6.x86_64.rpm   --客户端
samba-common-3.5.10-125.el6.i686.rpm     --32位公共包<工具|库文件>
samba-common-3.5.10-125.el6.x86_64.rpm   --64位公共包<工具|库文件>



**如何选择rpm包**？
适合的系统版本号： 优先选择操作系统的版本号 ， 找不到适合的，才去尝试别的系统版本号

向下兼容，例如el6的系统可以安装el5的软件包，但是el5的系统无法el6的软件包

选择适合cpu的架构：

x86_64包 只能安装在 64位 intel生产的cpu 

i386,i586,i686 的软件包可以安装 intel的32、64位平台         

**noarch表示通用**，这个软件包与硬件构架无关 

32位系统不能安装64位包

尽量不要跨大版本号去安装软件包，尽量使用当前版本自带软件包ISO安装



---

### RPM常用参数

下面是一些平时在使用RPM的常用参数，更多参数可以去查看man文档

**rpm -ivh**  安装  i表示安装（install），v表示冗余的信息（verbose），h表示hash记号（#号）

**rpm -e** 卸载（如果删除的时候有依赖关系就 rpm -e --force强制移除）

**rpm -Uvh**  升级  已经安装过一个同名的旧版本的软件，现在再安装同名新版本的；如果软件不存在就安装

**rpm -Fvh**  升级一个软件,如果软件不存在就停止安装

**rpm -ivh --force**  强制安装（覆盖已经安装了的软件包）

rpm -ivh --force --nodeps  忽略依赖关系依赖报错，直接强制安装
​	注意：不建议忽略依赖关系强制安装，但是卸载的时候最好是忽略依赖关系卸载，`rpm -e xxx --nodeps`

**rpm -qa**   查看本机安装了的所有rpm包

**rpm -ql**   查看一个已经安装了的软件的文件列表

rpm -qlp  查看某个rpm包文件里的文件列表（可以直接查看未安装的）

rpm -qd   查看一个已经安装了的软件的文档列表

rpm -qi   查看一个软件的详细信息

rpm -qf   查看文件到底来自哪个rpm包 

rpm -qc   查看软件包带来的配置文件 rpm --import key_file       导入公钥用于检查rpm文件的签名

rpm -qa | grep pubkey       列出rpm导入的所有公钥

rpm --checksig package.rpm  检查rpm文件的签名



---

### RPM进行包管理的实践案例