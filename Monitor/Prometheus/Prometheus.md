# Prometheus

> 本章主要介绍如何对XXX进行一个快速的简单上手使用，适用于xxxx使用。



## Author

```
Name: Shinefire
Blog: https://github.com/shine-fire/Ops_Notes
E-mail: shine_fire@outlook.com
```



## Introduction

### What is prometheus？什么是Prometheus



官方原话：

[Prometheus](https://github.com/prometheus) is an open-source systems monitoring and alerting toolkit originally built at [SoundCloud](https://soundcloud.com/). Since its inception in 2012, many companies and organizations have adopted Prometheus, and the project has a very active developer and user [community](https://prometheus.io/community). It is now a standalone open source project and maintained independently of any company. To emphasize this, and to clarify the project's governance structure, Prometheus joined the [Cloud Native Computing Foundation](https://cncf.io/) in 2016 as the second hosted project, after [Kubernetes](https://kubernetes.io/).

Prometheus collects and stores its metrics as time series data, i.e. metrics information is stored with the timestamp at which it was recorded, alongside optional key-value pairs called labels.

For more elaborate overviews of Prometheus, see the resources linked from the [media](https://prometheus.io/docs/introduction/media/) section.

翻译：

Prometheus是最初由SoundCloud公司开发的集监控与告警于一身的开源工具。从2012年开始，很多公司和组织开始使用Prometheus，并且还出现了很多活跃的开发者和用户社区。它现在是一个不依赖任何公司的独立维护的开源项目。需要强调和澄清的一点的是关于Prometheus的管理架构，它在2016年已经作为在kubernetes之后的第二个加入并托管在CNCF的项目。

Prometheus以时间序列数据的方式收集并存储它的metrics，



Others：

Prometheus是一款时序（time series）数据库；但它的功能却并非止步于TSDB，而是一款设计用于进行目标（Target）监控的关键组件

结合生态系统内的其它组件，例如Pushgateway、Altermanager和Grafana等，可构成一个完整的IT监控系统。

时序数据，是在一段时间内通过重复测量（measurement）而获得的观测值的集合，将这些观测值绘制于图形之上，它会有一个数据轴和一个时间轴。服务器指标数据、应用程序、性能监控数据、网络数据等也都是时序数据







### 传统的监控系统模型

传统的监控系统模型，例如Nagios，Zabbix等，都是需要安装一个Agent在被监控设备中。



### Prometheus的优势

Prometheus是一个开源的完整监控解决方案，其对传统监控系统的测试和告警模型进行了彻底的颠覆，形成了基于中央化的规则计算、统一分析和告警的新模型。 相比于传统监控系统Prometheus具有以下优点：



#### 易于管理

Prometheus核心部分只有一个单独的二进制文件，不存在任何的第三方依赖(数据库，缓存等等)。**唯一需要的就是本地磁盘**，因此不会有潜在级联故障的风险。

Prometheus基于Pull模型的架构方式，可以在任何地方（本地电脑，开发环境，测试环境）搭建我们的监控系统。对于一些复杂的情况，还可以使用Prometheus服务发现(Service Discovery)的能力动态管理监控目标。



#### 监控服务的内部运行状态

Pometheus鼓励用户监控服务的内部状态（这个应该就是所谓的白盒监控吧），基于Prometheus丰富的Client库，用户可以轻松的在应用程序中添加对Prometheus的支持，从而让用户可以获取服务和应用内部真正的运行状态。

![image-20210803165822828](pictures/image-20210803165822828.png)



#### 强大的数据模型

所有采集的监控数据均以指标(metric)的形式保存在内置的时间序列数据库当中(TSDB)。所有的样本除了基本的指标名称以外，还包含一组用于描述该样本特征的标签。

如下所示：

```
http_request_status{code='200',content_path='/api/path', environment='produment'} => [value1@timestamp1,value2@timestamp2...]

http_request_status{code='200',content_path='/api/path2', environment='produment'} => [value1@timestamp1,value2@timestamp2...]
```

每一条时间序列由指标名称(Metrics Name)以及一组标签(Labels)唯一标识。每条时间序列按照时间的先后顺序存储一系列的样本值。

表示维度的标签可能来源于你的监控对象的状态，比如code=404或者content_path=/api/path。也可能来源于的你的环境定义，比如environment=produment。基于这些Labels我们可以方便地对监控数据进行聚合，过滤，裁剪。



#### 强大的查询语言PromQL

Prometheus内置了一个强大的数据查询语言PromQL。 通过PromQL可以实现对监控数据的查询、聚合。同时PromQL也被应用于数据可视化(如Grafana)以及告警当中。

通过PromQL可以轻松回答类似于以下问题：

- 在过去一段时间中95%应用延迟时间的分布范围？
- 预测在4小时后，磁盘空间占用大致会是什么情况？
- CPU占用率前5位的服务有哪些？(过滤)



#### 高效

对于监控系统而言，大量的监控任务必然导致有大量的数据产生。而Prometheus可以高效地处理这些数据，对于单一Prometheus Server实例而言它可以处理：

- 数以百万的监控指标
- 每秒处理数十万的数据点。



#### 可扩展

Prometheus是如此简单，因此你可以在每个数据中心、每个团队运行独立的Prometheus Sevrer。Prometheus对于联邦集群的支持，可以让多个Prometheus实例产生一个逻辑集群，当单实例Prometheus Server处理的任务量过大时，通过使用功能分区(sharding)+联邦集群(federation)可以对其进行扩展。



#### 易于集成

使用Prometheus可以快速搭建监控服务，并且可以非常方便地在应用程序中进行集成。目前支持： Java， JMX， Python， Go，Ruby， .Net， Node.js等等语言的客户端SDK，基于这些SDK可以快速让应用程序纳入到Prometheus的监控当中，或者开发自己的监控数据收集程序。同时这些客户端收集的监控数据，不仅仅支持Prometheus，还能支持Graphite这些其他的监控工具。

同时Prometheus还支持与其他的监控系统进行集成：Graphite， Statsd， Collected， Scollector， muini， Nagios等。

Prometheus社区还提供了大量第三方实现的监控数据采集支持：JMX， CloudWatch， EC2， MySQL， PostgresSQL， Haskell， Bash， SNMP， Consul， Haproxy， Mesos， Bind， CouchDB， Django， Memcached， RabbitMQ， Redis， RethinkDB， Rsyslog等等。



#### 可视化

Prometheus Server中自带了一个Prometheus UI，通过这个UI可以方便地直接对数据进行查询，并且支持直接以图形化的形式展示数据。同时Prometheus还提供了一个独立的基于Ruby On Rails的Dashboard解决方案Promdash。最新的Grafana可视化工具也已经提供了完整的Prometheus支持，基于Grafana可以创建更加精美的监控图标。基于Prometheus提供的API还可以实现自己的监控可视化UI。



#### 开放性

通常来说当我们需要监控一个应用程序时，一般需要该应用程序提供对相应监控系统协议的支持。因此应用程序会与所选择的监控系统进行绑定。为了减少这种绑定所带来的限制。对于决策者而言要么你就直接在应用中集成该监控系统的支持，要么就在外部创建单独的服务来适配不同的监控系统。

而对于Prometheus来说，使用Prometheus的client library的输出格式不止支持Prometheus的格式化数据，也可以输出支持其它监控系统的格式化数据，比如Graphite。

因此你甚至可以在不使用Prometheus的情况下，采用Prometheus的client library来让你的应用程序支持监控数据采集。



### Prometheus的数据采集工作原理

在Prometheus采集数据的方式是基于http的pull方式

被采集数据的服务器，其实类似于server端，通过将自己的数据暴露出来，让作为client端的Prometheus则通过http pull的形式访问获取需要的数据

如下图：

![image-20210803155201250](pictures/image-20210803155201250.png)



Prometheus支持三种类型的途径从目标上抓取（Scrape）指标数据：

- Exporters
- Instrumentation
- Pushgateway，我觉得这个设计真的挺棒的，适用于一些短期任务（Short-lived jobs）数据生产者之类，不知道什么时候临时生产一些数据也不好暴露展示了，就直接自己什么时候生产了数据就先push到这个pushgateway中间商，Prometheus自己看自己的安排去这个中间商这里pull指标数据就完事了。

图示：

![image-20210803155406188](pictures/image-20210803155406188.png)



### Prometheus的生态组件

Prometheus本身在狭义上来说主要是一个TSDB，负责时序型指标数据的采集及存储，承担起整个企业级监控系统的重任时，还需要其他一些生态组件的配合使用才行。

例如数据的分析、聚合及直观展示以及告警等功能并非由Prometheus Server所负责，而是需要结合其他的组件一起来实现这些功能。

简单的生态组件架构如下图：

![image-20210803204922533](pictures/image-20210803204922533.png)

各组件说明：

- **Prometheus Server**: 收集和存储时间序列数据
- **Client Library**: 客户端库，目的在于为那些期望原生提供Instrumentation功能的应用程序提供便捷的开发途径
- **Push Gateway**: 接收那些通常由短期作业生成的指标数据的网关，并支持由PrometheusServer进行指标拉取操作
- **Exporters**: 用于暴露现有应用程序或服务（不支持Instrumentation）的指标给Prometheus Server
- **Alertmanager**: 从Prometheus Server接收到“告警通知”后，通过去重、分组、路由等预处理功能后以高效向用户完成告警信息发送
- **Data** **Visualization**：Prometheus Web UI （Prometheus Server内建），及Grafana等
- **Service** **Discovery**：动态发现待监控的Target，从而完成监控配置的重要组件，在容器化环境中尤为有用；该组件目前由Prometheus Server内建支持







### Prometheus数据模型

#### Prometheus数据采集的原理

Prometheus是时间序列数据：按照时间顺序记录系统、设备状态变化的数据，每个数据成为一个样本

- 数据采集以特定的时间周期进行，因而随着时间流逝，讲这些样本数据记录下来，将生成一个离散的样本数据序列。注意：**采集的时候，其实如果完全是同一时间的话，指标过多压力会很大，所以它其实是将所有的指标随机分散在一个时间窗口内进行采集**
- 该序列也称为向量（vector）；而将多个序列放在同一个坐标系内（以时间为横轴，以序列为纵轴），将形成一个由数据点组成的矩阵；
- prometheus默认是存放一个月的数据，如果对数据有特别需要，想长时间保留或者用作其他数据分析用途的话，还需要借助额外的数据库来存储比较合适

![image-20210804225032361](pictures/image-20210804225032361.png)



### Metric Name

Prometheus的metric命名，一般是用来表达它的作用。

metric name可以包含ASCII字母和数字，以及下划线和冒号。

即一定能被这个正则匹配到：`[a-zA-Z_:][a-zA-Z0-9_:]*`



### Prometheus指标类型

PromQL有四个指标类型，它们主要由Prometheus的客户端库使用

- Counter：计数器，单调递增，除非重置（例如服务器或进程重启）；
- Gauge：仪表盘，可增可减的数据
- Histogram：直方图，将时间范围内的数据划分成不同的时间段，并各自评估其样本个数及样本值之和，因而可计算出分位数
  - 可用于分析因异常值而引起的平均值过大的问题
  - 分位数计算要使用专用的histogram_quantile函数
- Summary：类似于Histogram，但客户端会直接计算并上报分位数





### Prometheus架构

架构图：

![image-20210804080003100](pictures/image-20210804080003100.png)





## Architecture Design

### 容量规划

内存

内存的大小可以通过查看`process_resident_memory_bytes`这个指标。



磁盘

对于每秒10万个样本的示例，我们知道按时间序列收集的每个样本在磁盘上占用大约1到2个字节。假设每个样本有2个字节，那么保留15天的时间序列意味着需要大约259 GB的磁盘。









## Deployment

### 环境说明

操作系统：RHEL7.9

Prometheus版本：2.29

节点说明：

| IP            | Hostname           | Role    |
| ------------- | ------------------ | ------- |
| 192.168.31.62 | prometheus-server1 | server  |
| 192.168.31.63 | prometheus-client1 | client1 |
| 192.168.31.64 | prometheus-client2 | client2 |
| 192.168.31.65 | prometheus-client3 | client3 |





### 安装包获取说明

安装方式一般有两种

1. 直接去官网下载使用源码包解压安装
2. 配置yum仓库之类的，来进行安装

这里我使用的是通过下载源码包来进行安装



源码包的获取方法：直接到[Prometheus官网](https://prometheus.io/)中的[Download界面](https://prometheus.io/download/)即可看到官方发布的适用于各个操作系统以及架构的源码包，可以根据自己的实际情况来进行选择

![image-20210804082810371](pictures/image-20210804082810371.png)



### 下载安装包

我这里使用选择好相应的源码包之后，直接copy了下载链接在我的机器中直接使用wget下载：

```bash
[root@prometheus-server1 ~]# cd prometheus-softs/
[root@prometheus-server1 prometheus-softs]# wget https://github.com/prometheus/prometheus/releases/download/v2.28.1/prometheus-2.28.1.linux-amd64.tar.gz
--2021-08-04 08:23:42--  https://github.com/prometheus/prometheus/releases/download/v2.28.1/prometheus-2.28.1.linux-amd64.tar.gz
Resolving github.com (github.com)... 13.229.188.59
Connecting to github.com (github.com)|13.229.188.59|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://github-releases.githubusercontent.com/6838921/4063cb00-da9b-11eb-8735-e43628dda2bc?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20210804%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20210804T002139Z&X-Amz-Expires=300&X-Amz-Signature=d06b0824106fa369bc103914cbba557b90e86fe857a1387e0f24c38f041fbb2f&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=6838921&response-content-disposition=attachment%3B%20filename%3Dprometheus-2.28.1.linux-amd64.tar.gz&response-content-type=application%2Foctet-stream [following]
--2021-08-04 08:23:43--  https://github-releases.githubusercontent.com/6838921/4063cb00-da9b-11eb-8735-e43628dda2bc?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20210804%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20210804T002139Z&X-Amz-Expires=300&X-Amz-Signature=d06b0824106fa369bc103914cbba557b90e86fe857a1387e0f24c38f041fbb2f&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=6838921&response-content-disposition=attachment%3B%20filename%3Dprometheus-2.28.1.linux-amd64.tar.gz&response-content-type=application%2Foctet-stream
Resolving github-releases.githubusercontent.com (github-releases.githubusercontent.com)... 185.199.108.154, 185.199.109.154, 185.199.111.154, ...
Connecting to github-releases.githubusercontent.com (github-releases.githubusercontent.com)|185.199.108.154|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 71109475 (68M) [application/octet-stream]
Saving to: ‘prometheus-2.28.1.linux-amd64.tar.gz’

100%[==============================================================================================================================>] 71,109,475  19.4MB/s   in 4.7s

2021-08-04 08:23:48 (14.4 MB/s) - ‘prometheus-2.28.1.linux-amd64.tar.gz’ saved [71109475/71109475]
```



### Prometheus

#### 安装Prometheus

将下载好的安装包，解压到指定的路径下并进行编译安装

```bash
[root@prometheus-server1 prometheus-softs]# ls
prometheus-2.28.1.linux-amd64.tar.gz
[root@prometheus-server1 prometheus-softs]# tar xzf prometheus-2.28.1.linux-amd64.tar.gz -C /usr/local/
[root@prometheus-server1 prometheus-softs]# cd /usr/local/
[root@prometheus-server1 local]# ls
bin  etc  games  include  lib  lib64  libexec  prometheus-2.28.1.linux-amd64  sbin  share  src
[root@prometheus-server1 local]# ln -snf prometheus-2.28.1.linux-amd64 prometheus  ## 加nf参数主要是统一一下，如果以后需要做软链接更新的话，也直接用这参数即可
[root@prometheus-server1 local]# ls
bin  etc  games  include  lib  lib64  libexec  prometheus  prometheus-2.28.1.linux-amd64  sbin  share  src
[root@prometheus-server1 local]# cd prometheus
[root@prometheus-server1 prometheus]# ls
console_libraries  consoles  LICENSE  NOTICE  prometheus  prometheus.yml  promtool
```



#### 检查Prometheus配置文件语法

```bash
[root@prometheus-server1 prometheus]# ./promtool check config prometheus.yml
Checking prometheus.yml
  SUCCESS: 0 rule files found
```



#### 运行Prometheus

进入到prometheus的解压目录后，直接启动prometheus这个二进制文件就可以运行prometheus

```bash
[root@prometheus-server1 prometheus]# ./prometheus
level=info ts=2021-08-04T00:59:07.173Z caller=main.go:389 msg="No time or size retention was set so using the default time retention" duration=15d
level=info ts=2021-08-04T00:59:07.173Z caller=main.go:443 msg="Starting Prometheus" version="(version=2.28.1, branch=HEAD, revision=b0944590a1c9a6b35dc5a696869f75f422b107a1)"
level=info ts=2021-08-04T00:59:07.173Z caller=main.go:448 build_context="(go=go1.16.5, user=root@2915dd495090, date=20210701-15:20:10)"
level=info ts=2021-08-04T00:59:07.173Z caller=main.go:449 host_details="(Linux 3.10.0-1160.el7.x86_64 #1 SMP Tue Aug 18 14:50:17 EDT 2020 x86_64 prometheus-server1 (none))"
level=info ts=2021-08-04T00:59:07.173Z caller=main.go:450 fd_limits="(soft=1024, hard=4096)"
level=info ts=2021-08-04T00:59:07.173Z caller=main.go:451 vm_limits="(soft=unlimited, hard=unlimited)"
level=info ts=2021-08-04T00:59:07.177Z caller=web.go:541 component=web msg="Start listening for connections" address=0.0.0.0:9090
level=info ts=2021-08-04T00:59:07.178Z caller=main.go:824 msg="Starting TSDB ..."
level=info ts=2021-08-04T00:59:07.179Z caller=tls_config.go:191 component=web msg="TLS is disabled." http2=false
level=info ts=2021-08-04T00:59:07.181Z caller=head.go:780 component=tsdb msg="Replaying on-disk memory mappable chunks if any"
level=info ts=2021-08-04T00:59:07.181Z caller=head.go:794 component=tsdb msg="On-disk memory mappable chunks replay completed" duration=4.609µs
level=info ts=2021-08-04T00:59:07.181Z caller=head.go:800 component=tsdb msg="Replaying WAL, this may take a while"
level=info ts=2021-08-04T00:59:07.182Z caller=head.go:854 component=tsdb msg="WAL segment loaded" segment=0 maxSegment=0
level=info ts=2021-08-04T00:59:07.182Z caller=head.go:860 component=tsdb msg="WAL replay completed" checkpoint_replay_duration=12.253µs wal_replay_duration=199.413µs total_replay_duration=231.924µs
level=info ts=2021-08-04T00:59:07.182Z caller=main.go:851 fs_type=XFS_SUPER_MAGIC
level=info ts=2021-08-04T00:59:07.182Z caller=main.go:854 msg="TSDB started"
level=info ts=2021-08-04T00:59:07.182Z caller=main.go:981 msg="Loading configuration file" filename=prometheus.yml
level=info ts=2021-08-04T00:59:07.184Z caller=main.go:1012 msg="Completed loading of configuration file" filename=prometheus.yml totalDuration=2.099877ms remote_storage=3.767µs web_handler=451ns query_engine=1.563µs scrape=1.75464ms scrape_sd=40.456µs notify=45.335µs notify_sd=10.851µs rules=15.679µs
level=info ts=2021-08-04T00:59:07.184Z caller=main.go:796 msg="Server is ready to receive web requests."

```

另外开一个终端，可以看到prometheus的监听端口默认为9090 

```bash
[root@prometheus-server1 ~]# ss -ntl
State      Recv-Q Send-Q Local Address:Port               Peer Address:Port     
LISTEN     0      128          *:22                       *:*
LISTEN     0      128       [::]:22                    [::]:*
LISTEN     0      128       [::]:9090                  [::]:*
```



#### 访问prometheus

##### 内建UI界面

直接访问prometheus的9090端口，可以进入到prometheus内建的UI界面

例如我这里直接访问：http://prometheus-server1.shinefire.com:9090

![image-20210804090753002](pictures/image-20210804090753002.png)



##### metrics指标数据

浏览器访问测试，通过访问prometheus的metrics，例如我这里的：http://prometheus-server1.shinefire.com:9090/metrics，可以看到prometheus这台服务器中自身的大量指标数据

![image-20210804090353292](pictures/image-20210804090353292.png)



### node_exporter

#### 安装运行node_exporter

node_exporter安装包的下载方式也跟prometheus一样，在官网的下载站点选择相应的包进行下载即可。

解压与运行node_exporter如下：

```bash
[root@prometheus-server1 prometheus-softs]# ls
node_exporter-1.2.0.linux-amd64.tar.gz  prometheus-2.28.1.linux-amd64.tar.gz
[root@prometheus-server1 prometheus-softs]# tar xzf node_exporter-1.2.0.linux-amd64.tar.gz -C /usr/local/
[root@prometheus-server1 prometheus-softs]# cd /usr/local/
[root@prometheus-server1 local]# ls
bin  etc  games  include  lib  lib64  libexec  node_exporter-1.2.0.linux-amd64  prometheus  prometheus-2.28.1.linux-amd64  sbin  share  src
[root@prometheus-server1 local]# ln -snf node_exporter-1.2.0.linux-amd64/ node_exporter  ## 加nf参数主要是统一一下，如果以后需要做软链接更新的话，也直接用这参数即可
[root@prometheus-server1 local]# cd node_exporter
[root@prometheus-server1 node_exporter]# ls
LICENSE  node_exporter  NOTICE
[root@prometheus-server1 node_exporter]# ./node_exporter
level=info ts=2021-08-04T01:57:11.570Z caller=node_exporter.go:182 msg="Starting node_exporter" version="(version=1.2.0, branch=HEAD, revision=12968948aec1e2b216a2ecefc45cf3a50671aecb)"
level=info ts=2021-08-04T01:57:11.570Z caller=node_exporter.go:183 msg="Build context" build_context="(go=go1.16.6, user=root@6b17174de526, date=20210715-16:35:54)"
level=warn ts=2021-08-04T01:57:11.570Z caller=node_exporter.go:185 msg="Node Exporter is running as root user. This exporter is designed to run as unpriviledged user, root is not required."
level=info ts=2021-08-04T01:57:11.571Z caller=filesystem_common.go:110 collector=filesystem msg="Parsed flag --collector.filesystem.mount-points-exclude" flag=^/(dev|proc|sys|var/lib/docker/.+)($|/)
level=info ts=2021-08-04T01:57:11.571Z caller=filesystem_common.go:112 collector=filesystem msg="Parsed flag --collector.filesystem.fs-types-exclude" flag=^(autofs|binfmt_misc|bpf|cgroup2?|configfs|debugfs|devpts|devtmpfs|fusectl|hugetlbfs|iso9660|mqueue|nsfs|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|selinuxfs|squashfs|sysfs|tracefs)$
level=info ts=2021-08-04T01:57:11.571Z caller=node_exporter.go:108 msg="Enabled collectors"
level=info ts=2021-08-04T01:57:11.571Z caller=node_exporter.go:115 collector=arp
level=info ts=2021-08-04T01:57:11.571Z caller=node_exporter.go:115 collector=bcache
level=info ts=2021-08-04T01:57:11.571Z caller=node_exporter.go:115 collector=bonding
level=info ts=2021-08-04T01:57:11.571Z caller=node_exporter.go:115 collector=btrfs
level=info ts=2021-08-04T01:57:11.571Z caller=node_exporter.go:115 collector=conntrack
level=info ts=2021-08-04T01:57:11.571Z caller=node_exporter.go:115 collector=cpu
level=info ts=2021-08-04T01:57:11.571Z caller=node_exporter.go:115 collector=cpufreq
level=info ts=2021-08-04T01:57:11.571Z caller=node_exporter.go:115 collector=diskstats
level=info ts=2021-08-04T01:57:11.571Z caller=node_exporter.go:115 collector=edac
level=info ts=2021-08-04T01:57:11.571Z caller=node_exporter.go:115 collector=entropy
level=info ts=2021-08-04T01:57:11.571Z caller=node_exporter.go:115 collector=fibrechannel
level=info ts=2021-08-04T01:57:11.571Z caller=node_exporter.go:115 collector=filefd
...
```

node_exporter监听端口为9100：

```bash
[root@prometheus-server1 ~]# ss -tnl
State      Recv-Q Send-Q Local Address:Port               Peer Address:Port     
LISTEN     0      128          *:22                       *:*
LISTEN     0      128       [::]:9100                  [::]:*
LISTEN     0      128       [::]:22                    [::]:*
LISTEN     0      128       [::]:9090                  [::]:*
```

#### 查看metrics

浏览器访问查看：

![image-20210804102532583](pictures/image-20210804102532583.png)









## Administration Guide

### Exporter 对应端口整理

常用的几个export对应的端口整理：

| Exporter Name   | Port |
| --------------- | ---- |
| prometheus      | 9090 |
| AlertManager    | 9093 |
| node_exporter   | 9100 |
| mysqld_exporter | 9104 |









### Add Targets

#### Static Configure 静态配置

适合变动很小的主机环境，直接在配置文件`prometheus.yml`中写入相应的机器即可，例如：

```
...
  ## all nodes
  - job_name: 'node'
    static_configs:
    - targets:
      - 192.168.31.62:9100
      - 192.168.31.63:9100
      - 192.168.31.64:9100
      - 192.168.31.65:9100
```

建议：即使环境变化较小的环境中，也不建议自己来进行手动配置，推荐还是使用动态发现的机制来进行管理。



#### 服务发现

适用于环境变化较快较大的环境，例如容器环境，随时可能会创建/销毁新的容器实例出来。

动态发现机制主要有以下方式：

- 基于文件的服务发现
- 基于DNS的服务发现
- 基于API的服务发现：Kubernetes、Consul、Azure、……



##### 基于文件的服务发现





##### 基于DNS的服务发现





##### 基于API的服务发现





### Consul





### AlertManager



#### 分组



#### 抑制











## User Guide





## PromQL

PromQL是学习prometheus的重点，这个在这里只是简单的写一下，具体更深入与高级的PromQL用法，会单独拿出来在另外的章节写。



### 聚合函数

Prometheus中内置了11个聚合函数

- sum( )：对样本值求和；
- avg( ) ：对样本值求平均值，这是进行指标数据分析的标准方法；
- count( ) ：对分组内的时间序列进行数量统计；
- stddev( ) ：对样本值求标准差，以帮助用户了解数据的波动大小（或称之为波动程度）；
- stdvar( ) ：对样本值求方差，它是求取标准差过程中的中间状态；
- min( ) ：求取样本值中的最小者；
- max( ) ：求取样本值中的最大者；
- topk( ) ：逆序返回分组内的样本值最大的前k个时间序列及其值；
- bottomk( ) ：顺序返回分组内的样本值最小的前k个时间序列及其值；
- quantile( ) ：分位数用于评估数据的分布状态，该函数会返回分组内指定的分位数的值，即数值落在小于等于指定的分位区间的比例；
- count_values( ) ：对分组内的时间序列的样本值进行数量统计；





### 基于现有样本的未来趋势预测





## Exporter

### node_exporter









### textfile收集器









### mysqld_exporter

mysql的exporter主要监控的内容：

- 数据吞吐量，主要是对数据的增、删、改、查
  - 服务器执行查询语句的总次数
  - 服务器写操作的总次数
  - MySQL实例insert语句的执行次数总量
  - ...
- 连接情况，在MySQL中通过全局设置max_connections限制了当前服务器允许的最大客户端连接数量。一旦可用连接数被用尽，新的客户端连接都会被直接拒绝。 因此当监控MySQL运行状态时，需要时刻关注MySQL服务器的连接情况
  - 类似可以做成当前连接数与总连接数相比的使用情况。
  - 查询当前MySQL实例连接拒绝数
- 监控缓存池使用情况，MySQL默认的存储引擎InnoDB使用了一片称为缓冲池的内存区域，用于缓存数据表以及索引的数据。 当缓冲池的资源使用超出限制后，可能会导致数据库性能的下降，同时很多查询命令会直接在磁盘中执行，导致磁盘I/O不断攀升
  - 缓冲池中的内存页的总页数
  - 缓冲池中的内存页的使用页数
  - 当缓冲池无法满足时，MySQL只能从磁盘中读取数据。Innodb_buffer_pool_reads即记录了从磁盘读取数据的请求数量
- 性能查询
  - long_query_time超时时间
  - Slow_queries增长率情况等













## Q&A

Q1：

pushgateway说是适用于短生命周期的任务，自己产生指标数据的时候自己可以直接推送到pushgateway中，但是这样说起来，其实挺抽象的，有什么合适的例子或者说场景来介绍一下吗？

A：



**Q2：**

counter指标类型中的rate和irate对比，为什么说irate()是一个更加高灵敏度函数且更加适合短期时间范围内的变化速率分析？深入理解一下两个函数的原理！

A：



Q3：

向量，标量这些数学概念

A：





Q4：

基于文件的服务发现，一般用怎么样的整套方案比较合适呢？

主要是在考虑，如果直接prometheus.yml在修改包含的文件中的指定过程中也可能会发生改变的，那这时候是不是必须要重启prometheus服务才可以呢？有不有更合适的方式来进行管理基于文件的自动发现呢

A：



Q5：

整个系统的数据存储是不是只与Prometheus Server的存储有关，跟grafana这些应该都没有任何关系吧？

A：



Q6：

rate()函数的原理，或者说它的计算方式

A：



Q7：

Prometheus的高可用架构如何实现

A：

参考官方：https://prometheus.io/docs/introduction/faq/#can-prometheus-be-made-highly-available

Yes, run identical Prometheus servers on two or more separate machines. Identical alerts will be deduplicated by the [Alertmanager](https://github.com/prometheus/alertmanager).

For [high availability of the Alertmanager](https://github.com/prometheus/alertmanager#high-availability), you can run multiple instances in a [Mesh cluster](https://github.com/weaveworks/mesh) and configure the Prometheus servers to send notifications to each of them.

至于prometheus联邦则可以参考：[Scaling and Federating Prometheus](https://www.robustperception.io/scaling-and-federating-prometheus/)



Q8：

配置了AlertManager之后，告警消息dashboard是会在grafana中的地方显示吗？是否可以做到呢？

还是说需要在AlertManager的界面去看才能看到所有的呢？

A：



Q9：

关于这个匹配的描述如下：

```
一对多/多对一匹配
“一”侧的每个元素，可与“多”侧的多个元素进行匹配；
必须使用group_left或group_right明确指定哪侧为“多”侧；
```

那么：如果是多对多呢？还要不要用group或者怎么用呢？或者是根本没有这种用法？

A：



Q10：

在想prometheus能不能做成那种类似MySQL读写分离的架构，架构中统一适用一个远程的存储，部分Prometheus专门用来收集存储数据，当使用查询的时候，则另外有一台专门用来查询的服务器来提供查询服务。

包括grafana在读取数据展示的是不是，也可以另外走通道，不知道可否做成这样？

A：



Q11：

关于这个prometheus的数据抓取频率和exporter的关系，exporter不是负责采集暴露metrics的吗？那exporter自身是不是也有采集频率呢？还是说它是根据prometheus设定的抓取频率来调整自身的采集频率的呢？

我想的是exporter作为数据生产者应该有个生产数据的频率才对，然后prometheus根据自己设置的抓取频率去抓取，但是实际上好像不是和我想的这样的。

A：

一般来说，采集的时候，同步抓取，当然也不是固定的，也可以异步抓取。最终由exporter决定。



Q12：

需求：VMware环境中，机器会出现IP变动的问题，能不能用Prometheus监控到IP变了就告警？

我想到就是先用Ansible用vm_guest模块来调用VMware的接口，查看并保存指定vcenter整个环境里面的IP和Mac地址对应关系，然后定期拉取一遍比对一下，如果不一致的就告警。

不知道这样的思路能不能实现，或者有不有什么其他的方案。

A：



Q13：

prometheus config file 里面这个 evaluation_interval 是什么意思呢？有点不太懂，直译是评估间隔，但是评估什么呢？

书上是说：参数evaluation_interval用来指定Prometheus评估规则的频率。目前主要有两种规则：记录规则 （recording rule）和警报规则（alerting rule）

但是也还是不太明白评估的意思，难道是说修改了规则配置文件的读取频率刷新间隔吗？

A：

prometheus会根据全局global设定的evaluation_interval参数进行扫描加载，规则改动后会自动加载。

相当于是用来重新读取那些规则配置文件用的，如果更改了规则，会间隔性的扫描规则配置以及更新规则。



Q14：

在书上看到过滤收集器那里提到了关于使用node_exporter中可以加params: collect[]: 里面那些CPU、meminfo的选项，这个有什么办法看一个exporter提供了哪些collect选项吗？

![image-20210816150225840](pictures/image-20210816150225840.png)

A：



Q15：

Prometheus有两个阶段的重新打标机会，那这两个阶段，具体是怎么在应用中使用呢？有不有合适的示例来帮助理解？

A：

第一个阶段是对来自服务发现的目标进行重新标记，这对于将来自服务发现的元数据标签中的信息应用于指标上的标签来说非常有用。这是在作业内的 relabel_configs块中完成的。

第二个阶段是在抓取之后且指标被保存于存储系统之前。这样，我们就可以确定哪些指标需要保存、哪些需要丢弃以及这些指标的样式。这是在我们作业内的metric_relabel_configs块中完成的。

记住这两个阶段的最简单方法是：在抓取之前使用relabel_configs，在抓取之后使用 metric_relabel_configs。



Q16：

书中4.1.1章节中提到了systemd收集器，通过这个收集器，可以在后面看到系统中各种服务的运行状态，这个是怎么使用呢？

A：



Q17：

关于rule中的一个record的写法问题：

```
rules:
  - record: instance:node_cpu:avg_rate5m
```

为什么书上record的命名是这样的格式，用逗号分割的，只是作者自己的使用习惯吗？因为我看prometheus自带的那些metric名字都是下划线做分隔符的。

虽然这个不是metric，但是我可不可以把它也理解成一个metric呢？感觉使用的时候都差不多，例如查询的时候。

A：



Q18：

如果想指定node_exporter所带来了哪些metrics，我需要怎么去查看呢？

A：



Q19：

Prometheus的警报能不能和Zabbix一样，对于一些不想要它继续告警的警报做一个取消操作。

A：



Q20：

关于下面这段代码的一些疑问：

```yaml
  - alert: DiskWillFillIn4Hours
    expr: predict_linear(node_filesystem_free_bytes{mountpoint="/"}[1h], 4*3600) < 0
    for: 5m
    labels:
      severity: critical
    annotations:
      summary: Device {{$labels.device}} on node {{$labels.instance}} is running
              full within the next 4 hours (mounted at {{ $labels.mountpoint }})
```

里面的 {{$labels.device}} 这个是怎么来的呢？Prometheus里面有内置一些相关的东西吗？

A：

变量$labels和$value分别是底层Go变量.Labels和.Value的名称，具体的应该要研究一下Go语言才行了。





















## Ohters

### What is the plural of Prometheus?

After [extensive research](https://youtu.be/B_CDeYrqxjQ), it has been determined that the correct plural of 'Prometheus' is 'Prometheis'.

有意思，没想到官网的F&A还提到了这个Prometheus的复数形式怎么表达，但是这是个非正式的单词，没有音标我也不会读呀。



### 85％的查询是针对26小时内的数据

Prometheus专注于现在正在发生的事情，而不是追踪数周或数月前的数据。它基于这样一个前 提，即大多数监控查询和警报都是从最近的（通常是一天内的）数据中生成的。

Facebook在其内部时 间序列数据库Gorilla的论文中验证了这一观点。Facebook发现85％的查询是针对26小时内的数据。 

Prometheus假定你尝试修复的问题可能是最近出现的，因此最有价值的是最近时间的数据，这反映在强大的查询语言和通常有限的监控数据保留期上。







## 待整理的信息

在Prometheus的架构设计中，Prometheus Server并不直接服务监控特定的目标，其主要任务负责数据的收集，存储并且对外提供数据查询支持

---

Prometheus Server的联邦集群能力可以使其从其他的Prometheus Server实例中获取数据，因此在大规模监控的情况下，可以通过联邦集群以及功能分区的方式对Prometheus Server进行扩展。

---

由于Prometheus数据采集基于Pull模型进行设计，因此在网络环境的配置上必须要让Prometheus Server能够直接与Exporter进行通信。 当这种网络需求无法直接满足时，就可以利用PushGateway来进行中转。可以通过PushGateway将内部网络的监控数据主动Push到Gateway当中。而Prometheus Server则可以采用同样Pull的方式从PushGateway中获取到监控数据。

---











## References

- [Prometheus Docs](https://prometheus.io/docs/introduction/overview/) 官方原文
- [prometheus-book](https://yunlzheng.gitbook.io/prometheus-book/) 中文
- [Prometheus 中文文档](https://www.prometheus.wang/)
- [Prometheus专栏](https://cloud.tencent.com/developer/column/87999)
- [高可用 Prometheus：Thanos 实践](http://www.xuyasong.com/?p=1925)
- [Thanos：开源的大规模Prometheus集群解决方案](http://dockone.io/article/6019)

