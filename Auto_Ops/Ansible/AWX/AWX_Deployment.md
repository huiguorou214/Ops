# AWX Deployment

[TOC]

## Author

```
Name:Shinefire
Blog:https://github.com/shine-fire/Ops_Notes
E-mail:shine_fire@outlook.com
```



## 环境说明

### Prerequisites

Before you can run a deployment, you'll need the following installed in your local environment:

- [Ansible](http://docs.ansible.com/ansible/latest/intro_installation.html) Requires Version 2.8+
- Docker
  - A recent version
- docker Python module
  - This is incompatible with `docker-py`. If you have previously installed `docker-py`, please uninstall it.
  - We use this module instead of `docker-py` because it is what the `docker-compose` Python module requires.
- [GNU Make](https://www.gnu.org/software/make/)
- [Git](https://git-scm.com/) Requires Version 1.8.4+

### System Requirements

The system that runs the AWX service will need to satisfy the following requirements

- At least 4GB of memory
- At least 2 cpu cores
- At least 20GB of space
- Running Docker, Openshift, or Kubernetes
- If you choose to use an external PostgreSQL database, please note that the minimum version is 9.6+.

#### Environment

| items       | value                           |
| ----------- | ------------------------------- |
| AWX         | 13.0.0                          |
| OS Version  | CentOS7.8                       |
| FQDN        | pose-awx-app-5001.shinefire.com |
| DNS 解析    | awx.shinefire.com               |
| IP          | N/A                             |
| AWX Version | 13.0.0                          |
| Docker-CE   | 19.03.12                        |
| Python      | 3.6                             |
| Git Version | 1.8                             |



## 在线部署

在线部署的操作为可以连接外网的环境下进行

### 前提要求环境搭建

#### 配置基础YUM源

配置Base与Epel源

```bash
# wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
# wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
```

#### 安装docker-ce

CentOS7中安装docker的阿里云官方操作指南如下：

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

安装后的校验

```bash
[root@ansible-awx ~]# docker version
Client: Docker Engine - Community
 Version:           19.03.12
 API version:       1.40
 Go version:        go1.13.10
 Git commit:        48a66213fe
 Built:             Mon Jun 22 15:46:54 2020
 OS/Arch:           linux/amd64
 Experimental:      false

Server: Docker Engine - Community
 Engine:
  Version:          19.03.12
  API version:      1.40 (minimum version 1.12)
  Go version:       go1.13.10
  Git commit:       48a66213fe
  Built:            Mon Jun 22 15:45:28 2020
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.2.13
  GitCommit:        7ad184331fa3e55e52b890ea95e65ba581ae3429
 runc:
  Version:          1.0.0-rc10
  GitCommit:        dc9208a3303feef5b3839f4323d9beb36df0a9dd
 docker-init:
  Version:          0.18.0
  GitCommit:        fec3683
```

安装docker的过程中，主要涉及到docker-ce-stable这个repo，如果想要用内网yum源的方式进行安装，则需要先将此repo源的rpm包同步到本地中即可。

#### 安装docker-compose

Run this command to download the current stable release of Docker Compose:

```bash
# curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

> To install a different version of Compose, substitute `1.26.2` with the version of Compose you want to use.

Apply executable permissions to the binary:

```bash
# chmod +x /usr/local/bin/docker-compose
```

#### 安装Ansible

ansible的版本应该大于2.8

```bash
# yum install ansible -y
```

#### 安装Python3

Python版本需要安装3.6以上

yum安装：

```bash
# yum install -y python3 libselinux-python3
```

#### 安装Python的docker-compose模块

先安装pip（来自updates repo）

```bash
# yum install python3-pip -y
```

安装docker-compose模块

```bash
# pip3 install docker-compose
...
Successfully installed PyYAML-5.3.1 attrs-19.3.0 bcrypt-3.1.7 cached-property-1.5.1 certifi-2020.6.20 cffi-1.14.1 chardet-3.0.4 cryptography-3.0 distro-1.5.0 docker-4.3.0 docker-compose-1.26.2 dockerpty-0.4.1 docopt-0.6.2 idna-2.10 importlib-metadata-1.7.0 jsonschema-3.2.0 paramiko-2.7.1 pycparser-2.20 pynacl-1.4.0 pyrsistent-0.16.0 python-dotenv-0.14.0 requests-2.24.0 six-1.15.0 texttable-1.6.2 urllib3-1.25.10 websocket-client-0.57.0 zipp-3.1.0
```

#### 安装git

```bash
# yum install git -y
```



### 安装部署AWX

#### 下载AWX官方源码

在 https://github.com/ansible/awx/releases 中选择一个版本下载AWX服务器中，例如选择12.0.0版本

```bash
# cd /usr/local/src/
# wget https://github.com/ansible/awx/archive/awx-13.0.0.tar.gz
# tar xzvf awx-13.0.0.tar.gz -C /usr/local/
```

也可以在windwos中下载好再传到AWX服务器中。

#### 进入awx目录下的installer

```bash
# cd /usr/local/awx-13.0.0
```

根据具体情况修改inventory文件

#### 开始直接构建和部署

```bash
# cd installer
# ansible-playbook -i inventory install.yml
```

#### 查看结果

执行结束后，可以在服务器上使用docker ps 命令查看到五个运行的容器。当然，你在部署的时候没有选择默认的PostgresSQL，可能只有四个容器，如下所示：

```bash
# docker container ls
CONTAINER ID        IMAGE                     COMMAND                  CREATED             STATUS              PORTS                  NAMES
970e8af9e682        ansible/awx_task:11.0.0   "tini -- /bin/sh -c …"   39 seconds ago      Up 38 seconds       8052/tcp               awx_task
9f35067e0066        ansible/awx_web:11.0.0    "tini -- /bin/sh -c …"   40 seconds ago      Up 38 seconds       0.0.0.0:80->8052/tcp   awx_web
6dd182caaa02        postgres:10               "docker-entrypoint.s…"   41 seconds ago      Up 28 seconds       5432/tcp               awx_postgres
0eec8dcc1341        redis                     "docker-entrypoint.s…"   41 seconds ago      Up 38 seconds       6379/tcp               awx_redis
06e38a67f860        memcached:alpine          "docker-entrypoint.s…"   41 seconds ago      Up 37 seconds       11211/tcp              awx_memcached
```

### 容器迁移

在部署完毕后，还需要连接到awx_web容器中，去执行迁移的命令才能正常的使用awx，否则便会卡在登录界面，一直提示upgrade...

#### 查看awx_web容器的ID

```bash
# docker ps | grep awx_web
43439869edc2        ansible/awx:13.0.0   "tini -- /bin/sh -c …"   2 minutes ago       Up 2 minutes        0.0.0.0:80->8052/tcp   awx_web
```

#### 交互式连接到awx_web容器中

```bash
# docker exec -it 43439869edc2 bash
```

#### 执行awx-manager命令迁移

```bash
bash-4.4# awx-manage migrate
Operations to perform:
  Apply all migrations: auth, conf, contenttypes, main, oauth2_provider, sessions, sites, social_django, sso, taggit
Running migrations:
  Applying main.0001_initial... OK
  Applying main.0002_squashed_v300_release... OK
...
  Applying social_django.0008_partial_timestamp... OK
  Applying sso.0001_initial... OK
  Applying sso.0002_expand_provider_options... OK
  Applying taggit.0003_taggeditem_add_unique_index... OK
```

#### 重新运行部署

重新部署是因为执行完上面的迁移操作后，无法使用admin用户和密码登录，似乎是因为没有这个admin账户，所以我是再次执行playbook重新部署一遍来做的。

```bash
# ansible-playbook -i inventory install.yml
```

## 离线部署

离线部署的方式用于内网不能连接外网的环境

## 排错

### Docker image超时问题

问题描述：

在执行ansible-playbook部署awx的时候，可能会在[local_docker : Start the containers]这个TASK中遇到下面的报错

```
"alpine: Pulling from library/memcached\nDigest: sha256:4f7648c92fc89a2f6ec56e0281a051efe983b6de83a31e7a52bd4a1a8ed6308f\nStatus: Downloaded newer image for memcached:alpine\nlatest: Pulling from library/redis\nDigest: sha256:09c33840ec47815dc0351f1eca3befe741d7105b3e95bc8fdb9a7e4985b9e1e5\nStatus: Downloaded newer image for redis:latest\n10: Pulling from library/postgres\nDigest: sha256:e3a02efdce3ec64cfdb76a8ff93ae14d3294e47a0203d8230c8853a3890fe340\nStatus: Downloaded newer image for postgres:10\n11.0.0: Pulling from ansible/awx_web\n", "msg": "Error starting project dial tcp 104.18.121.25:443: i/o timeout"
```

解决方案：

这个应该是DNS问题，我遇到这个问题时用的是114.114.114.114的DNS，换成8.8.8.8就好了。没有去看playbook内容了，猜测应该是涉及到了域名，然后DNS解析到的IP在我这个环境中会访问超时，估计换成8.8.8.8解析到的IP就是另外的了，就不会再超时了。

### 模块不存在问题

问题报错描述：

psycopg2.errors.UndefinedTable: relation "main_instance" does not exist

LINE 1: SELECT (1) AS "a" FROM "main_instance" WHERE "main_instance"...
                               ^

...

django.db.utils.ProgrammingError: relation "main_instance" does not exist
LINE 1: SELECT (1) AS "a" FROM "main_instance" WHERE "main_instance"...
                               ^

## 参考

- AWX quick start https://github.com/ansible/awx/blob/11.0.0/INSTALL.md
- 阿里源docker镜像安装docker-ce  https://developer.aliyun.com/mirror/docker-ce?spm=a2c6h.13651102.0.0.3e221b111LjGcc
- Ansible之AWX部署 https://www.cnblogs.com/mcsiberiawolf/p/12727229.html
- 离线获取docker镜像 https://blog.csdn.net/topswim/article/details/86613507
- Setting Up and Using AWX with docker-compose http://elatov.github.io/2018/12/setting-up-and-using-awx-with-docker-compose/
- ansible UI管理工具awx安装实践 https://cloud.tencent.com/developer/article/1632514

