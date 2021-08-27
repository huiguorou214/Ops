# tcpdump

> 本章是我对抓包工具tcpdump的一个基础使用学习与理解，以及在实际场景中应用的记录。



## tcpdump命令详解

### 语法

```tex
tcpdump [ -DenNqvX ] [ -c count ] [ -F file ] [ -i interface ] [ -r file ]
        [ -s snaplen ] [ -w file ] [ expression ]

抓包选项：
-c：指定要抓取的包数量。注意，是最终要获取这么多个包。例如，指定"-c 10"将获取10个包，但可能已经处理了100个包，只不过只有10个包是满足条件的包。
-i interface：指定tcpdump需要监听的接口。若未指定该选项，将从系统接口列表中搜寻编号最小的已配置好的接口(不包括loopback接口，要抓取loopback接口使用tcpdump -i lo)，            ：一旦找到第一个符合条件的接口，搜寻马上结束。可以使用'any'关键字表示所有网络接口。
-n：对地址以数字方式显式，否则显式为主机名，也就是说-n选项不做主机名解析。
-nn：除了-n的作用外，还把端口显示为数值，否则显示端口服务名。
-N：不打印出host的域名部分。例如tcpdump将会打印'nic'而不是'nic.ddn.mil'。
-P：指定要抓取的包是流入还是流出的包。可以给定的值为"in"、"out"和"inout"，默认为"inout"。
-s len：设置tcpdump的数据包抓取长度为len，如果不设置默认将会是65535字节。对于要抓取的数据包较大时，长度设置不够可能会产生包截断，若出现包截断，      ：输出行中会出现"[|proto]"的标志(proto实际会显示为协议名)。但是抓取len越长，包的处理时间越长，并且会减少tcpdump可缓存的数据包的数量，      ：从而会导致数据包的丢失，所以在能抓取我们想要的包的前提下，抓取长度越小越好。

输出选项：
-e：输出的每行中都将包括数据链路层头部信息，例如源MAC和目标MAC。
-q：快速打印输出。即打印很少的协议相关信息，从而输出行都比较简短。
-X：输出包的头部数据，会以16进制和ASCII两种方式同时输出。
-XX：输出包的头部数据，会以16进制和ASCII两种方式同时输出，更详细。
-v：当分析和打印的时候，产生详细的输出。
-vv：产生比-v更详细的输出。
-vvv：产生比-vv更详细的输出。

其他功能性选项：
-D：列出可用于抓包的接口。将会列出接口的数值编号和接口名，它们都可以用于"-i"后。
-F：从文件中读取抓包的表达式。若使用该选项，则命令行中给定的其他表达式都将失效。
-w：将抓包数据输出到文件中而不是标准输出。可以同时配合"-G time"选项使得输出文件每time秒就自动切换到另一个文件。可通过"-r"选项载入这些文件以进行分析和打印。
-r：从给定的数据包文件中读取数据。使用"-"表示从标准输入中读取。
```

### tcpdump表达式

表达式用于筛选输出哪些类型的数据包，如果没有给定表达式，所有的数据包都将输出，否则只输出表达式为true的包。在表达式中出现的shell元字符建议使用单引号包围。

tcpdump的表达式由一个或多个"单元"组成，每个单元一般包含ID的修饰符和一个ID(数字或名称)。有三种修饰符：

(1).type：指定ID的类型。

可以给定的值有host/net/port/portrange。例如"host foo"，"net 128.3"，"port 20"，"portrange 6000-6008"。默认的type为host。

(2).dir：指定ID的方向。

可以给定的值包括src/dst/src or dst/src and dst，默认为src or dst。例如，"src foo"表示源主机为foo的数据包，"dst net 128.3"表示目标网络为128.3的数据包，"src or dst port 22"表示源或目的端口为22的数据包。

(3).proto：通过给定协议限定匹配的数据包类型。

常用的协议有tcp/udp/arp/ip/ether/icmp等，若未给定协议类型，则匹配所有可能的类型。例如"tcp port 21"，"udp portrange 7000-7009"。

所以，一个基本的表达式单元格式为"proto dir type ID"

![733013-20180621121410609-1741572810](pictures/733013-20180621121410609-1741572810.png)

除了使用修饰符和ID组成的表达式单元，还有关键字表达式单元：gateway，broadcast，less，greater以及算术表达式。

表达式单元之间可以使用操作符" and / && / or / || / not / ! "进行连接，从而组成复杂的条件表达式。如"host foo and not port ftp and not port ftp-data"，这表示筛选的数据包要满足"主机为foo且端口不是ftp(端口21)和ftp-data(端口20)的包"，常用端口和名字的对应关系可在linux系统中的/etc/service文件中找到。

另外，同样的修饰符可省略，如"tcp dst port ftp or ftp-data or domain"与"tcp dst port ftp or tcp dst port ftp-data or tcp dst port domain"意义相同，都表示包的协议为tcp且目的端口为ftp或ftp-data或domain(端口53)。

使用括号"()"可以改变表达式的优先级，但需要注意的是括号会被shell解释，所以应该使用反斜线"\"转义为"\(\)"，在需要的时候，还需要包围在引号中。



## tcpdump抓包输出分析

首先我们注意一下，基本上tcpdump总的的输出格式为：系统时间 来源主机.端口 > 目标主机.端口 数据包参数

tcpdump 的输出格式与协议有关.以下简要描述了大部分常用的格式及相关例子.

### TCP数据包

(注意:以下将会假定你对 RFC-793所描述的TCP熟悉. 如果不熟, 以下描述以及tcpdump程序可能对你帮助不大.(nt:警告可忽略,
只需继续看, 不熟悉的地方可回头再看.).

通常tcpdump对tcp数据包的显示格式如下:

```
src > dst: flags data-seqno ack window urgent options
```

src 和 dst 是源和目的IP地址以及相应的端口

**flags 标志**由S(SYN), F(FIN), P(PUSH, R(RST),W(ECN CWT(nt | rep:未知, 需补充))或者 E(ECN-Echo(nt | rep:未知,　需补充))组成

单独一个'.'表示没有flags标识，数据段顺序号(Data-seqno)描述了此包中数据所对应序列号空间中的一个位置(nt:整个数据被分段,每段有一个顺序号，所有的顺序号构成一个序列号空间)(可参考以下例子)

Ack 描述的是同一个连接,同一个方向,下一个本端应该接收的(对方应该发送的)数据片段的顺序号

Window是本端可用的数据接收缓冲区的大小(也是对方发送数据时需根据这个大小来组织数据)

Urg(urgent) 表示数据包中有紧急的数据. options 描述了tcp的一些选项, 这些选项都用尖括号来表示(如 <mss 1024>).





## 实践场景示例

### icmp信息抓取的一次应用

背景描述

一台服务器在iptables规则设置后，成为了理论上不会被ping通的一台服务器，但是实际上被ping通了，所以想要借助tcpdump来辅助分析一下ping通服务器的win主机，是否在iptables规则中被无意中放行了。



下面是一种可参考测试方法：

在需要分析的服务器中执行下面的命令

```bash
tcpdump -nn -i ens33 'icmp and (src host 192.168.31.196 or dst host 192.168.31.196)'
```

命令解释：指定ens33这个网卡，抓来自192.168.31.196或者到达192.168.31.196的icmp数据包，其实这里用来ping服务器的IP地址也是可以的，icmp有来有回，理论上都是OK的。



执行完上面的命令后，那个终端就处于一个等待printf的状态了，此时再去另外一边ping这个服务器（这里只是测试方法，是用的另外一台Linux去ping我们的服务器的）

```bash
[root@nuc ~]# ping -c2  192.168.31.196
PING 192.168.31.196 (192.168.31.196) 56(84) bytes of data.
64 bytes from 192.168.31.196: icmp_seq=1 ttl=64 time=0.643 ms
64 bytes from 192.168.31.196: icmp_seq=2 ttl=64 time=0.532 ms

--- 192.168.31.196 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1000ms
rtt min/avg/max/mdev = 0.532/0.587/0.643/0.060 ms
```



再回到被ping的服务器中查看输出：

```bash
[root@rhel76-ori ~]# tcpdump -nn -i ens33 'icmp and (src host 192.168.31.196 or dst host 192.168.31.196)'
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ens33, link-type EN10MB (Ethernet), capture size 262144 bytes
14:20:48.808652 IP 192.168.31.100 > 192.168.31.196: ICMP echo request, id 14155, seq 1, length 64
14:20:48.808722 IP 192.168.31.196 > 192.168.31.100: ICMP echo reply, id 14155, seq 1, length 64
14:20:49.808806 IP 192.168.31.100 > 192.168.31.196: ICMP echo request, id 14155, seq 2, length 64
14:20:49.808841 IP 192.168.31.196 > 192.168.31.100: ICMP echo reply, id 14155, seq 2, length 64
```

通过终端print的内容，可以用来确认是来自192.168.31.100这个IP地址发送的icmp数据包，再利用这个准确的信息去看看iptables规则中的设置是否合适。







## Reference

- Linux tcpdump命令详解 https://www.cnblogs.com/ggjucheng/archive/2012/01/14/2322659.html
- [tcpdump详解](https://www.cnblogs.com/111testing/p/13620931.html)  这位大佬的这篇博客写得挺不错的

