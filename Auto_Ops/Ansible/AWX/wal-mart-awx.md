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

| items       | value         |
| ----------- | ------------- |
| OS Version  | RHEL7.6       |
| hostname    | oser000043    |
| IP          | 10.233.71.231 |
| AWX Version | 13.0.0        |
| Docker-CE   | 19.03.12      |
| Python      | 3.6           |
| Git Version | 1.8           |



## 部署步骤

### 前提要求环境搭建

#### 配置基础YUM源

部署AWX需要基础镜像源，epel源，docker源等，目前服务器已经注册到satellite中，所以yum源已经满足要求无需进行配置。

#### 安装docker-ce

RHEL7中安装docker-ce的操作如下：

```bash
$ sudo yum -y install docker-ce
$ sudo systemctl enable docker --now
```

安装后的校验

```bash
$ sudo docker version
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

#### 安装docker-compose

docker-compose的官方下载地址：https://github.com/docker/compose/releases

从windows中下载一个较新的稳定版本后直接传到服务器的 /usr/local/bin/ 路径下即可，然后添加执行权限：

```bash
$ sudo chmod +x /usr/local/bin/docker-compose
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

如果默认已经存在docker-py模块的话，要先remove，否则会出现不兼容的问题导致无法继续。网速比较慢或者网络不太稳定时，可能会出现timeout安装失败的情况，这时候重新运行一遍继续安装即可。

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



## 参考

- AWX quick start https://github.com/ansible/awx/blob/11.0.0/INSTALL.md
- 阿里源docker镜像安装docker-ce  https://developer.aliyun.com/mirror/docker-ce?spm=a2c6h.13651102.0.0.3e221b111LjGcc
- Ansible之AWX部署 https://www.cnblogs.com/mcsiberiawolf/p/12727229.html
- 离线获取docker镜像 https://blog.csdn.net/topswim/article/details/86613507
- Setting Up and Using AWX with docker-compose http://elatov.github.io/2018/12/setting-up-and-using-awx-with-docker-compose/
- ansible UI管理工具awx安装实践 https://cloud.tencent.com/developer/article/1632514

