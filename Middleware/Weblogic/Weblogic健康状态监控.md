# Weblogic健康状态监控





设计思路

​	

1. 建立一个文本，存放现在所有的weblogic业务，IP:PORT
2. 选择一台weblogic服务器，专门收集所有的weblogic running状态
3. 如果检测到非running状态的weblogic即会创建一个保存状态的文件和保存告警信息的文件，保存告警信息的文件里面会列出所有的not running的weblogic IP:PORT 以及业务名称
4. 自定义一个key值，用来读取存放告警信息文件里面的内容，并且可以通过zabbix-server端那边创建Item的时候设定执行的频率
5. 在zabbix-web端定义item的时候，需要定义两个item，一个用于判断保存状态文件是否存在，另外一个用来使用自定义的key值
6. 再定义两个触发器，一个是如果保存状态的文件存在，即触发；另外一个则是依赖于第一个触发器，如果存在就读取第二个item的key值内容
7. 在动作里面对第二个触发器进行告警，告警内容主要是自定义的key.value
8. 后期只需要对存放现在的weblogic业务的文本进行维护即可















获取running状态结果



java weblogic.Admin -url 10.1.6.52:7001 -username weblogic -password weblogic2019 GETSTATE

java weblogic.Admin -url 10.1.6.52:7001 -username weblogic -password ut2014.com GET -pretty -type ServerRuntime | findstr state 



[root@srweblogic czy]# java weblogic.Admin -url 10.1.6.52:7001 -username weblogic -password weblogic2019 GET -pretty -type ServerRuntime | grep "^\s*State:"

​        State: RUNNING











## 参考资料

- shell脚本监控weblogic的运行状态、健康状态、打开的套接字数

  <http://blog.chinaunix.net/uid-17176286-id-4361790.html>

- 定期访问weblogic server返回状态的脚本

  <https://www.cnblogs.com/ericnie/p/5282706.html>

- shell脚本监控启动停止weblogic服务

  <https://blog.csdn.net/bbwangj/article/details/81321241>

- weblogic状态监控脚本

  <https://blog.csdn.net/forest_hou/article/details/5468288>

- **利用shell脚本实时监控weblogic运行情况**
  <http://www.xuwangcheng.com/articles/2017/02/15/1487119727954.html#b3_solo_h1_0>

- 使用Linux脚本更新weblogic部署的应用程序

  <https://www.cnblogs.com/wuyida/p/6300278.html>

