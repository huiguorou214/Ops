# DNS原理

> 本章主要记录个人对DNS原理信息的收集与理解

## Author

```
Name:Shinefire
Blog:https://github.com/shine-fire/Ops_Notes
E-mail:shine_fire@outlook.com
```

## What is DNS?

DNS：Domain Name System

它作为将域名和IP地址相互映射的一个分布式数据库，就是根据域名查出IP地址或者根据IP地址查出域名。

## DNS解析库资源记录

### DNS解析库资源记录说明

在解析库中，每一个行是一个解析条目，叫做“资源记录” - resource record（rr），资源记录有类型的概念，用于表示解析条目的属性。

在区域解析库中，资源记录的格式如下：

```
Name [ttl]  IN  RRType  VALUE
```

分别为：名称,有效缓存时间,固定字段,资源记录类型,值

在解析库中，如果定义了变量 $TTL, 那么在每一条资源记录中，可以不写 ttl。如果想定义不同的ttl，仍然可以写出来，它会覆盖 $TTL 的值。

任何解析库文件的第一条记录必须是SOA，SOA是用于标记域内的**主服务器**是谁。

**SOA: Start of Authority**

name: 当前区域名称,通常可以简写为 "@"；
ttl: 略
RRTtype: SOA
VALUE: 主 DNS 服务器的名称（FQDN），也可以是当前区域的区域名称；这里为ns.magedu.com；

例如：

```
@ IN SOA ns.magedu.com. admin.magedu.com. (
    serial number   ; 解析库的版本号，例如：2014080401(分号是注释)
    refresh time    ; 周期性同步的时间间隔(从服务器的同步时间)
    retry time      ; 重试的时间间隔(主不响应时，从服务器的重试时间间隔)
    expire time     ; 过期时长(从服务器的过期时间)
    nagtive answer ttl  ; 查无此人时，会给出否定答案，这是否定答案的缓存时长
    )
```

注意在解析库文件内，域名最后的’.’不能省略。

admin.magedu.com.是 DNS 服务器管理员的邮箱地址，因为 @ 字符在 DNS 配置文件中有特殊意义，不能直接在邮箱地址中使用，所以这里用’.’取代。

### DNS解析库资源记录示例

#### NS: name server

name: 区域名称，可以简写为 “@”
value: DNS 服务器名称(FQDN)

示例：

```
@ IN NS ns.magedu.com. 
```

**注意：**

- 如果有多台NS服务器，每一台都必须有对应的 NS 记录，否则不会被识别为 DNS 服务器。
- 对于“正向解析文件”来讲，每一个 NS 的 FQDN 都应该有一个A记录

#### MX: Mail eXchanger

name: 区域名称，可以简写为@
priority: 优先级
value: 邮件服务器的FQDN

示例：

```
@ IN MX 10 mail.magedu.com.
@ IN MX 20 mail2.magedu.com.
```

**注意：**

- 如果有多台 MX 服务器，每一台都必须有对应的MX记录，但各个MX记录还有优先级属性。
- 但是注意，如果第一个MX服务器还能响应，就不会找第二个。
- 对于“正向解析文件”来讲，每一个 MX 的 FQDN 都应该有一个A记录。

#### A: Adress

A 记录

name: FQDN
value: IP

示例：

```
www.magedu.com. IN A 10.0.0.2
www.magedu.com. IN A 172.0.0.3

pop3.magedu.com. IN A 10.0.0.10
imap.magedu.com. IN A 10.0.0.10
```

**注意：**

- 同一个名字可以有多个地址，可以实现类似于负载均衡的效果。

- 同一个IP可能对应多个名称，比如一台服务器同时提供多种服务的情况。

#### CNAME: 正式名称是什么

name: FQDN
value: FQDN

一个 FQDN 的正式名称是另一个 FQDN。

例如，一个IP地址对应多个名称，还可以这样写:

```
www.magedu.com. IN A 10.1.1.5
web.magedu.com. IN CNAME www.magedu.com.
```

这里表示：web.magedu.com. 的正式名称是www.magedu.com.

这里为什么不直接写IP地址呢，假设一个主机有十个别名，如果主机的 IP 地址改变了，只需要改一次就行了， 就好像BASH里变量的作用。

有别名这种机制，在 CDN 上做 C 类应用时，提供一个公共 CDN 时，通常都是通过别名的方式指定的：比如访问的是www.magedu.com. ，背后却指向一个CDN的名字。

#### PTR: pointer 反向解析

name: 逆向的主机IP地址，加后缀 in-addr.arpa，注意不包含网段，是主机地址。

例如 172.16.100.9/16， 网络地址是 172.16， 主机地址是 100.7，那么，这里的 name 就是 “7.100.in-addr.arpa.”，注意最后有’.’。

value: FQDN

示例：

```
7.100.in-addr.arpa. IN PTR www.magedu.com.
```

### DNS解析库资源记录类型列表

参考：[DNS记录类型列表](https://zh.wikipedia.org/wiki/DNS%E8%AE%B0%E5%BD%95%E7%B1%BB%E5%9E%8B%E5%88%97%E8%A1%A8)

| 代码                                                        | 描述           | 功能                                                         |
| ----------------------------------------------------------- | -------------- | ------------------------------------------------------------ |
| A                                                           | IPv4地址记录   | 传回一个32位的IPv4地址，最常用于映射主机名称到IP地址         |
| CNAME                                                       | 别名记录       | 一个主机名字的别名：域名系统将会继续尝试查找新的名字<br />A CNAME B: A 的正式名称是 B |
| PTR                                                         | 指针记录       | 引导至一个[规范名称](https://zh.wikipedia.org/w/index.php?title=規範名稱&action=edit&redlink=1)（Canonical Name）。与 CNAME 记录不同，DNS“不会”进行进程，只会传回名称。最常用来运行[反向 DNS 查找](https://zh.wikipedia.org/w/index.php?title=反向_DNS_查找&action=edit&redlink=1)，其他用途包括引作 [DNS-SD](https://zh.wikipedia.org/w/index.php?title=DNS-SD&action=edit&redlink=1)。 |
| AAAA                                                        | IPv6地址记录   | 传回一个128位的IPv6地址，最常用于映射主机名称到IP地址        |
| NS                                                          | 名称服务器记录 | 委托[DNS区域](https://zh.wikipedia.org/w/index.php?title=DNS區域&action=edit&redlink=1)（DNS zone）使用已提供的权威域名服务器。 |
| [MX记录](https://zh.wikipedia.org/wiki/MX记录)（MX record） | 电邮交互记录   | 引导域名到该域名的[邮件传输代理](https://zh.wikipedia.org/w/index.php?title=郵件傳輸代理&action=edit&redlink=1)（MTA, Message Transfer Agents）列表。 |
| SRV                                                         | 服务定位器     | 广义为服务定位记录，被新式协议使用而避免产生特定协议的记录，例如：MX 记录。 |
| NAPTR                                                       | 命名管理指针   | 允许基于正则表达式的域名重写使其能够作为 [URI](https://zh.wikipedia.org/wiki/URI)、进一步域名查找等 |

## DNS解析原理与步骤

### 域名结构解析

![img](DNS%E5%8E%9F%E7%90%86.assets/v2-d4ebb1c03acc11c40aa2d0624e98f9f8_720w.jpg)

如上图所示，域名结构是树状结构

- 根域：树的最顶端代表根服务器
- 顶级域/一级域：根的下一层就是由我们所熟知的.com、.net、.cn等通用域和.cn、.uk等国家域组成，称为顶级域
- 二级域：网上注册的域名基本都是二级域名，比如http://baidu.com、http://taobao.com等等二级域名，它们基本上是归企业和运维人员管理。
- 其他：接下来是三级或者四级域名，这里不多赘述。总体概括来说域名是由整体到局部的机制结构。最多127级域名。

### DNS解析流程

![wKioL1hHv7HQ7EgNAADIkuf_fKE664.jpg](DNS%E5%8E%9F%E7%90%86.assets/wKioL1hHv7HQ7EgNAADIkuf_fKE664.jpg)



![img](DNS%E5%8E%9F%E7%90%86.assets/v2-f1e081e30e47c8c1f5af6b944d6eda3c_720w.jpg)

如上图所示，我们将详细阐述DNS解析流程。

1. 先查自己的hosts文件-->本地DNS缓存
2. 首先客户端位置是一台电脑或手机，在打开浏览器以后，比如输入http://www.zdns.cn的域名，它首先是由浏览器发起一个DNS解析请求，如果本地缓存服务器中找不到结果，则首先会向根服务器查询，根服务器里面记录的都是各个顶级域所在的服务器的位置，当向根请求http://www.zdns.cn的时候，根服务器就会返回.cn服务器的位置信息。
3. 递归服务器拿到.cn的权威服务器地址以后，就会寻问cn的权威服务器，知不知道http://www.zdns.cn的位置。这个时候cn权威服务器查找并返回http://zdns.cn服务器的地址。
4. 继续向http://zdns.cn的权威服务器去查询这个地址，由http://zdns.cn的服务器给出了地址：202.173.11.10
5. 最终才能进行http的链接，顺利访问网站。
6. 这里补充说明，一旦递归服务器拿到解析记录以后，就会在本地进行缓存，如果下次客户端再请求本地的递归域名服务器相同域名的时候，就不会再这样一层一层查了，因为本地服务器里面已经有缓存了，这个时候就直接把http://www.zdns.cn的A记录返回给客户端就可以了。

## DNS递归与迭代

### 详细说法

DNS查询有两种方式：**递归**和**迭代**

**递归**：客户端只发一次请求，要求对方给出最终结果；

**迭代**：客户端发出一次请求，对方如果没有授权回答，它就会返回一个能解答这个查询的其它名称服务器列表，客户端会再向返回的列表中发出请求，直到找到最终负责所查域名的名称服务器，从它得到最终结果。

**查询结果**：

- **递归查询**：返回的结果只有两种：查询成功或查询失败.
- **迭代查询**：又称作重指引,返回的是最佳的查询点或者主机地址.

![img](DNS%E5%8E%9F%E7%90%86.assets/464291-20170703113844956-354755333.jpg)

![img](DNS%E5%8E%9F%E7%90%86.assets/v2-ea2fa0f3bcb5b6ebbad37e810ecf8280_720w.jpg)

DNS客户端设置使用的DNS服务器一般都是递归服务器，它负责全权处理客户端的DNS查询请求，直到返回最终结果。而DNS服务器之间一般采用迭代查询方式。

以查询 zh.wikipedia.org 为例：

- 客户端发送查询报文"query zh.wikipedia.org"至DNS服务器，DNS服务器首先检查自身缓存，如果存在记录则直接返回结果。

- 如果记录老化或不存在，则：
  1. DNS服务器向根域名服务器发送查询报文"query zh.wikipedia.org"，根域名服务器返回顶级域 .org 的权威域名服务器地址。
  2. DNS服务器向 .org 域的权威域名服务器发送查询报文"query zh.wikipedia.org"，得到二级域 .wikipedia.org 的权威域名服务器地址。
  3. DNS服务器向 .wikipedia.org 域的权威域名服务器发送查询报文"query zh.wikipedia.org"，得到主机 zh 的A记录，存入自身缓存并返回给客户端。

### 简单易懂说法

#### 层级递归查询

A -> B -> C -> D

A 问 B，B不知道，但 B 知道 C 知道，于是B问C，C也不知道，但C知道D知道，逐级查询，逐级返回。

#### 迭代查询

A -> B
A -> C
A -> D

A 问 B，B不知道，但 B 知道 C 知道，于是A去问C，C也不知道，但C知道D知道，于是A去问D。

真正的DNS查询使用的哪种模式? 互联网上的绝大多数查找模型都是迭代的。但 DNS 是递归+迭代的，是先递归，后迭代的。

## DNS转发

在DNS服务器的配置中，如果采用默认的配置，其实效率是较低的，因为默认情况下，我们所有的非权威解析都会被发送到根服务器进行迭代查询。如果采用转发，如将我们的DNS解析请求转发到一些公共DNS服务器上，由于公共DNS服务器上缓存了大量的解析，因此能较原始的迭代查询快。

全局转发：
作用：实现对非权威解析（已缓存的除外）都转发到特定DNS服务器

区域转发：
从BIND9.1开始，引入一个新特新：转发区（forward zone ），及允许查询特定区域时，将其转发到指定DNS服务器上。我们可以将某个域的解析直接转发到其权威服务器上，可以实现快速解析。

## DNS子域委派

DNS委派是将相关区域（一般是自己的子域吧）解析权限下放给某一台DNS服务器，在委派服务器上只存储一条委派方与被委派方的记录。

## 其他名词概念

### 主DNS服务器

假设我们注册了域名：magedu.com, 意味着我们要负责对该域名内的所有主机进行“名称解析”。要解析，就得有解析库，要找一台主机来负责存放解析库，并负责响应对于该域名内的主机名的“解析请求”。如果本地主机发起一个请求，假设本地的DNS服务器的主机名叫做 ns.magedu.com，客户端向 ns 主机请求 www.magedu.com 的解析地址，这个主机名的解析是不是就是由 ns 这台服务器负责呢？ 假如这个域内只有这一台 DNS 主机，很显然这个域内的所有主机，只有这台 ns 主机才能知道。

这台ns主机会负责，本地的所有“名称解析”请求，或来自网络的对于本域的查询请求。

这台ns主机的IP地址，需要注册到上级服务器。

这台DNS服务器，被称为“主DNS服务器”。

### 权威DNS服务器

我们申请了一个域名之后，需要为这个域建立一台DNS服务器，来负责这个域内的所有主机名的解析。这个DNS服务器就是这个域的“权威DNS服务器”，除了这台DNS服务器，没有其他人知道该域内的主机的解析名。

### 非权威应答

如果通过缓存返回名称解析的请求，由于缓存与实际的情况存在时间差，所以被称为：“**非权威应答**”

### 缓存DNS服务器

那本地的DNS服务可不可以只做一半的工作呢，比如不负责“本地域内主机名”的解析，只负接收本地客户端的“名称解析”请求，然后向根发起迭代查询，以及对查询结果进行缓存。答案是可以的。

这样做的好处是什么呢，好处在于这个缓存，一个域名进行一次查询之后，缓存在服务器上，本地的其他客户端请求同一个域名的解析时，可以通过缓存的结果进行响应，这就可以加快本地客户端的名称解析速度，减轻网络带宽的压力。这种服务器，被称为“缓存DNS服务器”。

### DNS 转发器

还有一种DNS服务器，只负责转发DNS请求，转发给另一台DNS主机做查询，本地不做缓存，称为“转发器”。

### 辅助(从)DNS服务器

辅助DNS服务器的用处，是冗余和备用。备用的可以有多个，它有和主服务器同样的“解析库”，它会去同步主服务器上的解析库，这个同步过程(传送zone文件)，被称为“区域传送” - zone transfer，它是单向的，所有的修改，只能在 DNS 主服务器上进行。

从服务器有多个的时候，一个从服务器可从另一个从服务器获取“区域文件”。这是多级从服务器。

### 区域zone传送方式

#### 完全区域传送

第一次传送区域文件，通常是传送完整的区域文件，这叫做“完全区域传送” - axfr

#### 增量区域传送

后续传送区域文件，通常是传送增量的区域文件，这叫做“增量区域传送” - ixfr

区域文件，一方面是定期由从服务器去向主服务器询问和拉取。一方面当主服务器发生更新，会向从服务器发送更新通知，让从服务器来拉取。

而且传送区域文件，为了保证文件的完整性，使用的是 TCP 协议进行传输。前面我们知道 DNS 工作在 TCP 和 UDP 协议下，UDP 是负责监听查询请求的。

如果主服务器出现问题，不响应从服务的询问，经过一段时间的尝试，发现仍然没有响应，**从服务器就不再对DNS请求做应答，放弃解析。从服务器不会取而代之，而是在必要时提供冗余的能力。**


## References

- DNS 服务原理详解 https://www.jianshu.com/p/4394aaf97492
- 域名系统  [https://zh.wikipedia.org/wiki/%E5%9F%9F%E5%90%8D%E7%B3%BB%E7%BB%9F](https://zh.wikipedia.org/wiki/域名系统)
- DNS迭代查询和递归查询 https://zhuanlan.zhihu.com/p/61394192
- DNS原理入门 https://www.ruanyifeng.com/blog/2016/06/dns.html
- DNS高级用法（DNS转发） http://www.toxingwang.com/linux-unix/linux-admin/1215.html
- 【DNS入门学习】之DNS转发功能 https://bbs.huaweicloud.com/blogs/110060
- DNS委派 https://blog.51cto.com/wuyvzhang/1623584
- Windows server DNS服务器配置与管理 https://zhuanlan.zhihu.com/p/143166990