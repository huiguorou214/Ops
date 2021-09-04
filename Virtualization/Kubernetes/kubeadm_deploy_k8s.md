# Kubeadm Deploy K8s





## 环境说明



软件环境

| 软件       | 版本               |
| ---------- | ------------------ |
| 操作系统   | centos7.9 mini安装 |
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



## Steps

### OS环境配置

#### 关闭防火墙

略

#### 关闭selinux

略

#### 允许 iptables 检查桥接流量

确保 `br_netfilter` 模块被加载。这一操作可以通过运行 `lsmod | grep br_netfilter` 来完成。若要显式加载该模块，可执行 `sudo modprobe br_netfilter`。

为了让你的 Linux 节点上的 iptables 能够正确地查看桥接流量，你需要确保在你的 `sysctl` 配置中将 `net.bridge.bridge-nf-call-iptables` 设置为 1。例如：

```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

modprobe br_netfilter
lsmod | grep br_netfilter
sysctl -p
```

### 配置yum源

删除系统默认的repofile，配置国内阿里云或者其他的源

```bash
rm -f /etc/yum.repos.d/*.repo
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
```



### Install kubectl

#### yum安装kubectl

建议直接用yum安装就行了，都用kubeadm来省事了就多省点

配置yum repo

```bash
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
```

安装kubectl

```bash
yum install -y kubelet kubeadm kubectl
```

启动kubelet

```bash
systemctl enable kubelet && systemctl start kubelet
```



#### curl方式安装

1. 用以下命令下载最新发行版：

   ```bash
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
   ```

1. 验证该可执行文件（可选步骤）

   下载 kubectl 校验和文件：

   ```bash
   curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
   ```

   基于校验和文件，验证 kubectl 的可执行文件：

   ```bash
   echo "$(<kubectl.sha256) kubectl" | sha256sum --check
   ```

   验证通过时，输出为：

   ```console
   kubectl: OK
   ```

   验证失败时，`sha256` 将以非零值退出，并打印如下输出：

   ```bash
   kubectl: FAILED
   sha256sum: WARNING: 1 computed checksum did NOT match
   ```

   > **说明：**
   >
   > 下载的 kubectl 与校验和文件版本必须相同。

1. 安装 kubectl

   ```bash
   sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
   ```

   > **说明：**
   >
   > 即使你没有目标系统的 root 权限，仍然可以将 kubectl 安装到目录 `~/.local/bin` 中：
   >
   > ```bash
   > chmod +x kubectl
   > mkdir -p ~/.local/bin/kubectl
   > mv ./kubectl ~/.local/bin/kubectl
   > # 之后将 ~/.local/bin/kubectl 添加到 $PATH
   > ```

1. 执行测试，以保障你安装的版本是最新的：

   ```bash
   kubectl version --client
   ```



### Docker-CE安装

安装Docker

```bash
# step 1: 安装必要的一些系统工具
yum install -y yum-utils device-mapper-persistent-data lvm2
# Step 2: 添加软件源信息
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# Step 3: 更新并安装Docker-CE
yum makecache fast
yum -y install docker-ce
# Step 4: 开启Docker服务
systemctl enable docker --now
```

配置Docker加速

```bash
mkdir /etc/docker
vi /etc/docker/daemon.json 
{
"registry-mirrors": ["https://dlbpv56y.mirror.aliyuncs.com"]
}
```

> 这个可以直接用，也可以自己去阿里云弄个自己的
>











## Q&A

Q1：



A：



Q2：



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

