# Harbor

> 



## Author

```
Name: Shinefire
Blog: https://github.com/shine-fire/Ops_Notes
E-mail: shine_fire@outlook.com
```



## Introduction



### online vs. offline

offline是离线版本，下载的时候就会下载很多镜像





## Harbor Deployment

### 创建自签名证书

生成自签名证书：

```bash
~]# mkdir /opt/harbor/certs
~]# cd /opt/harbor/certs

# 生成私钥
~]# openssl genrsa -out server.key 1024
```

根据私钥生成证书申请文件 `csr`：

```bash
~]# openssl req -new -key server.key -out server.csr
```

这里根据命令行向导来进行信息输入：

```bash
[root@bastion certs]# openssl req -new -key server.key -out server.csr
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:CN
State or Province Name (full name) []:Shenzhen
Locality Name (eg, city) [Default City]:Shenzhen
Organization Name (eg, company) [Default Company Ltd]:Shinefire
Organizational Unit Name (eg, section) []:Shinefire
Common Name (eg, your name or your server's hostname) []:*.harbor.shinefire.com
Email Address []:shine_fire@qq.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
```

> Common Name 可以输入：`*.harbor.shinefire.com`，这种方式可以生成通配符域名证书。
>
> 最后的密码输入，没有密码可以直接跳过
>
> 另外这些交互式的创建，也可以通过直接命令行加参数换成非交互式来实现，这里先略过了

使用私钥对证书申请进行签名从而生成证书：

```bash
[root@bastion certs]# openssl x509 -req -days 3650 -in server.csr -signkey server.key -out server.crt
Signature ok
subject=/C=CN/ST=Shenzhen/L=Shenzhen/O=Shinefire/OU=Shinefire/CN=*.harbor.shinefire.com/emailAddress=shine_fire@qq.com
Getting Private key
```

这样就生成了有效期为 10 年的证书文件，对于自己内网服务使用足够。

证书搞定了之后，就可以接着配置 Harbor 了。



### 安装部署harbor

使用 `Harbor` 部署一个镜像仓库供容器平台使用，目前最为流行的私有镜像仓库便是 CNCF 的毕业生之一的 Harbor（中文含义：港口）。

修改基础节点主机名：

```bash
~]# hostnamectl set-hostname harbor.shinefire.com
```

Docker安装

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

# 注意：
# 官方软件源默认启用了最新的软件，您可以通过编辑软件源的方式获取各个版本的软件包。例如官方并没有将测试版本的软件源置为可用，您可以通过以下方式开启。同理可以开启各种测试版本等。
# vim /etc/yum.repos.d/docker-ee.repo
# 将[docker-ce-test]下方的enabled=0修改为enabled=1
#
# 安装指定版本的Docker-CE:
# Step 1: 查找Docker-CE的版本:
# yum list docker-ce.x86_64 --showduplicates | sort -r
#   Loading mirror speeds from cached hostfile
#   Loaded plugins: branch, fastestmirror, langpacks
#   docker-ce.x86_64            17.03.1.ce-1.el7.centos            docker-ce-stable
#   docker-ce.x86_64            17.03.1.ce-1.el7.centos            @docker-ce-stable
#   docker-ce.x86_64            17.03.0.ce-1.el7.centos            docker-ce-stable
#   Available Packages
# Step2: 安装指定版本的Docker-CE: (VERSION例如上面的17.03.0.ce.1-1.el7.centos)
# sudo yum -y install docker-ce-[VERSION]
```

docker-compose安装

```bash
~]# curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
~]# chmod +x /usr/local/bin/docker-compose
```

下载 Harbor 离线安装包并解压

```bash
~]# wget https://github.com/goharbor/harbor/releases/download/v2.0.0/harbor-offline-installer-v2.0.0.tgz
~]# tar -xvf harbor-offline-installer-v2.0.0.tgz -C /opt/
```

> 当前版本是否有更新的，也可以去官网看看，然后把url和文件名称替换一下就行了

打开 `/opt/harbor/harbor.yml` 文件，修改 hostname 域名、https 证书等配置信息，具体如下：

```tex
# Configuration file of Harbor
# The IP address or hostname to access admin UI and registry service.
# DO NOT use localhost or 127.0.0.1, because Harbor needs to be accessed by external clients.
hostname: bastion.openshift4.example.com
# http related config
http:
  # port for http, default is 80. If https enabled, this port will redirect to https port
  port: 8080
# https related config
https:
  # https port for harbor, default is 443
  port: 8443
  # The path of cert and key files for nginx
  certificate: /opt/harbor/certs/server.crt
  private_key: /opt/harbor/certs/server.key
```

> 我这里把所有需要的基础服务都部署在同一个节点上，后面安装 OCP 时需要用到负载均衡器的 `443` 和 `80` 端口，所以这里 Harbor 使用了非标准端口。如果你资源充足，可以将 Harbor 部署在不同的节点上。



接着执行下面的命令进行安装：

```bash
[root@bastion harbor]# ./install.sh
```

以上安装命令同时安装了 Clair 服务，一个用户镜像漏洞静态分析的工具。如果不需要，可以省略该选项。

安装成功后，将自签名的证书复制到默认信任证书路径：

```bash
~]# cp /opt/harbor/certs/server.crt /etc/pki/ca-trust/source/anchors/
~]# update-ca-trust extract
```

或者将其复制到 docker 的信任证书路径：

```bash
~]# mkdir -p /etc/docker/certs.d/bastion.openshift4.example.com:8443
~]# cp /opt/harbor/certs/server.crt /etc/docker/certs.d/bastion.openshift4.example.com:8443/
~]# systemctl restart docker
```

现在可以通过 `docker login` 命令来测试仓库的连通性，看到如下字样即表示安装成功（也可以通过浏览器访问 Web UI）：

```bash
[root@bastion harbor]# docker login bastion.harbor.shinefire.com:8443
Username: admin
Password:
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```



## References





## Doc Changelogs

- 

