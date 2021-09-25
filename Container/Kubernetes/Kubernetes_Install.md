# Kubernetes Deployment



## 环境说明



软件环境

| 软件       | 版本               |
| ---------- | ------------------ |
| 操作系统   | centos7.8 mini安装 |
| 容器引擎   |                    |
| Kubernetes | v1.22              |



服务器规划

| 角色         | IP            | 组件 |
| ------------ | ------------- | ---- |
| k8s-master1  | 192.168.31.51 |      |
| k8s-master2  | 192.168.31.52 |      |
| k8s-master3  | 192.168.31.53 |      |
| k8s-node1    | 192.168.31.54 |      |
| k8s-node2    | 192.168.31.55 |      |
| 负载均衡器IP | 192.168.31.58 |      |





## Q&A

Q1：

在创建创建证书申请文件的时候，可以在hosts里面增加多个IP地址用于预留给后期扩容使用，那么如果部署的时候没有考虑到后面扩容涉及到的一些IP地址时，应该要怎么来增加呢？

A：



Q2：

看到大佬在初始化机器的过程中有以下这样的一个操作，但是还没太搞懂什么意思，为什么要使用 sysctl --system 这样的命令来操作

```bash
# 将桥接的IPv4流量传递到iptables的链 
cat > /etc/sysctl.d/k8s.conf << EOF 
net.bridge.bridge-nf-call-ip6tables = 1 
net.bridge.bridge-nf-call-iptables = 1 
EOF 
sysctl --system  # 生效 
```

而且我在使用sysctl命令生效后，sysctl -a也一样看不到这个参数

A：



Q3：

A：



Q4：

A：



Q5：

A：



Q6：

A：



Q7：

A：



## References

- [etcd集群部署](https://www.cnblogs.com/breezey/p/8836008.html)
- 

