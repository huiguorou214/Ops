## net.ipv4.ip_local_port_range



### 内核参数作用

主要用于预留一个端口范围，让系统中程序去连接目标端时所使用



### 系统默认值

```bash
[root@localhost ~]# cat /proc/sys/net/ipv4/ip_local_port_range 
32768   61000
```



### 在某些场景下的建议值



### References

- net.ipv4.ip_local_port_range 的值究竟影响了啥 https://mozillazg.com/2019/05/linux-what-net.ipv4.ip_local_port_range-effect-or-mean.html
  这篇博客主要通过自己测试来验证了该参数对于连接上的限制，例如相同目标 ip 不同目标端口下的限制，多个目标 ip 相同目标端口，多个目标 ip 不同目标端口等...