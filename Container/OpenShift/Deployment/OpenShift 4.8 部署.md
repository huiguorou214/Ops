# Deployment UPI OpenShift 4.8.12



## Introduction

### UPI（UserProvisioned Infrastructure）

离线环境安装的方案	



## Architecture

### Host List

服务器规划如下：

- 一台离线OpenShift镜像节点，用于专门连接公网离线部署需要的镜像，后面再将离线好的镜像导入到集群中的私有镜像仓库节点使用
- 一个bastion节点，用于部署负载均衡。
- 三个控制平面节点，安装 `Etcd`、控制平面组件和 `Infras` 基础组件。
- 两个计算节点，运行实际负载。
- 一个bootstrap引导主机，执行安装任务，集群部署完成后可删除。
- 一个内部镜像仓库，用于部署OCP时使用以及后续镜像存放于使用。
- 一个基础节点nuc，用于准备提到安装OpenShift的离线资源，同时用来部署 DNS

| Hostname                      | IP             | Hardware     | Role                 |
| ----------------------------- | -------------- | ------------ | -------------------- |
| mirror-ocp.ocp4.example.com   | 192.168.31.158 | 4C/8G/100GB  | Harbor离线镜像的仓库 |
| bastion.ocp4.shinefire.com    | 192.168.31.160 | 4C/8G/100GB  | OpenShift客户端      |
| api.ocp4.shinefire.com        | 192.168.31.160 | 4C/8G/100GB  | HAProxy              |
| api-int.ocp4.shinefire.com    | 192.168.31.160 | 4C/8G/100GB  |                      |
| bootstrap.ocp4.shinefire.com  | 192.168.31.159 | 4C/16G/100GB | bootstrap            |
| master-1.ocp4.shinefire.com   | 192.168.31.161 | 4C/16G/100GB | master节点           |
| etcd-1.ocp4.shinefire.com     | 192.168.31.161 | 4C/16G/100GB | etcd节点             |
| master-2.ocp4.shinefire.com   | 192.168.31.162 | 4C/16G/100GB | master节点           |
| etcd-2.ocp4.shinefire.com     | 192.168.31.162 | 4C/16G/100GB | etcd节点             |
| master-3.ocp4.shinefire.com   | 192.168.31.163 | 4C/16G/100GB | master节点           |
| etcd-3.ocp4.shinefire.com     | 192.168.31.163 | 4C/16G/100GB | etcd节点             |
| worker-1.ocp4.shinefire.com   | 192.168.31.164 | 2C/8G/100GB  | worker节点           |
| apps.ocp4.shinefire.com       | 192.168.31.164 | 2C/8G/100GB  | 入口地址             |
| worker-2.ocp4.shinefire.com   | 192.168.31.165 | 2C/8G/100GB  | worker节点           |
| registry-1.ocp4.shinefire.com | 192.168.31.167 | 4C/8G/100GB  | 内部镜像仓库         |
| nuc.shinefire.com             | 192.168.31.100 | N/A          | YUM/DNS/httpd        |

官方对于每个节点的最小化建议如下：

| Machine       | Operating System  | vCPU | Virtual RAM | Storage |
| :------------ | :---------------- | :--- | :---------- | :------ |
| Bootstrap     | RHCOS             | 4    | 16 GB       | 100 GB  |
| Control plane | RHCOS             | 4    | 16 GB       | 100 GB  |
| Compute       | RHCOS or RHEL 7.9 | 2    | 8 GB        | 100 GB  |



### Softwares List

| 软件名称              | 软件包名                             |
| --------------------- | ------------------------------------ |
| RHEL8.4 DVD           | rhel-server-8.4-x86_64-dvd.iso       |
|                       |                                      |
| 镜像仓库软件          | harbor-offline-installer-v2.3.2.tgz  |
| Registry仓库镜像      | ocp4.tar.gz                          |
| Openshift客户端oc命令 | openshift-client-linux-4.8.12.tar.gz |
| Openshift安装程序     | openshift-install                    |
| CoreOS引导光盘        |                                      |
| CoreOS远程部署内核    |                                      |

资源获取说明：

- rhel-server-8.4-x86_64-dvd.iso：官方下载iso即可
- harbor-offline-installer-v2.3.2.tgz：官方下载的offline版本
- ocp4.tar.gz：需要自己离线官方的镜像并保存使用，后面离线 OpenShift 镜像的步骤中会说明
- openshift-client-linux-4.8.12.tar.gz：官网下载
- openshift-install：离线镜像后生成，后面离线 OpenShift 镜像的步骤中会说明
- 



### Install Produce

在安装 OCP 时，我们需要有一台引导主机（`Bootstrap`）。这个主机可以访问所有的 OCP 节点。引导主机启动一个临时控制平面，它启动 OCP 集群的其余部分然后被销毁。引导主机使用 Ignition 配置文件进行集群安装引导，该文件描述了如何创建 OCP 集群。**安装程序生成的 Ignition 配置文件包含 24 小时后过期的证书，所以必须在证书过期之前完成集群安装。**

引导集群安装包括如下步骤：

- 引导主机启动并开始托管 `Master` 节点启动所需的资源。
- `Master` 节点从引导主机远程获取资源并完成引导。
- `Master` 节点通过引导主机构建 `Etcd` 集群。
- 引导主机使用新的 `Etcd` 集群启动临时 `Kubernetes` 控制平面。
- 临时控制平面在 Master 节点启动生成控制平面。
- 临时控制平面关闭并将控制权传递给生产控制平面。
- 引导主机将 OCP 组件注入生成控制平面。
- 安装程序关闭引导主机。

引导安装过程完成以后，OCP 集群部署完毕。然后集群开始下载并配置日常操作所需的其余组件，包括创建计算节点、通过 `Operator` 安装其他服务等。

![image-20210704233952433](pictures/image-20210704233952433.png)



### 端口开放要求

Ports used for all-machine to all-machine communications

| Protocol | Port            | Description                                                  |
| :------- | :-------------- | :----------------------------------------------------------- |
| ICMP     | N/A             | Network reachability tests                                   |
| TCP      | 1936            | Metrics                                                      |
|          | `9000`-`9999`   | Host level services, including the node exporter on ports `9100`-`9101` and the Cluster Version Operator on port `9099`. |
|          | `10250`-`10259` | The default ports that Kubernetes reserves                   |
|          | `10256`         | openshift-sdn                                                |
| UDP      | `4789`          | VXLAN and Geneve                                             |
|          | `6081`          | VXLAN and Geneve                                             |
|          | `9000`-`9999`   | Host level services, including the node exporter on ports `9100`-`9101`. |
| TCP/UDP  | `30000`-`32767` | Kubernetes node port                                         |

Ports used for all-machine to control plane communications

| Protocol | Port   | Description    |
| :------- | :----- | :------------- |
| TCP      | `6443` | Kubernetes API |

Ports used for control plane machine to control plane machine communications

| Protocol | Port          | Description                |
| :------- | :------------ | :------------------------- |
| TCP      | `2379`-`2380` | etcd server and peer ports |



## 基础环境设施提供说明

### DNS

公共 DNS 是由 dnsmasq 部署的，这里就只介绍一下具体配置的内容，具体的部署方法可以自行检索

官方要求：

https://docs.openshift.com/container-platform/4.8/installing/installing_bare_metal/installing-restricted-networks-bare-metal.html#installation-dns-user-infra_installing-restricted-networks-bare-metal

我的环境中配置的解析条目如下：

```
# ocp4
address=/mirror-ocp.ocp4.shinefire.com/192.168.31.158
address=/bootstrap.ocp4.shinefire.com/192.168.31.159
address=/bastion.ocp4.shinefire.com/192.168.31.160
address=/registry.ocp4.shinefire.com/192.168.31.160
address=/api.ocp4.shinefire.com/192.168.31.160
address=/api-int.ocp4.shinefire.com/192.168.31.160
address=/apps.ocp4.shinefire.com/192.168.31.160
address=/master-1.ocp4.shinefire.com/192.168.31.161
address=/etcd-1.ocp4.shinefire.com/192.168.31.161
address=/master-2.ocp4.shinefire.com/192.168.31.162
address=/etcd-2.ocp4.shinefire.com/192.168.31.162
address=/master-3.ocp4.shinefire.com/192.168.31.163
address=/etcd-3.ocp4.shinefire.com/192.168.31.163
address=/worker-1.ocp4.shinefire.com/192.168.31.164
address=/worker-2.ocp4.shinefire.com/192.168.31.165
ptr-record=158.31.168.192.in-addr.arpa,mirror-ocp.ocp4.shinefire.com
ptr-record=159.31.168.192.in-addr.arpa,bootstrap.ocp4.shinefire.com
ptr-record=160.31.168.192.in-addr.arpa,bastion.ocp4.shinefire.com
ptr-record=160.31.168.192.in-addr.arpa,api.ocp4.shinefire.com
ptr-record=160.31.168.192.in-addr.arpa,api-int.ocp4.shinefire.com
ptr-record=160.31.168.192.in-addr.arpa,apps.ocp4.shinefire.com
ptr-record=161.31.168.192.in-addr.arpa,master-1.ocp4.shinefire.com
ptr-record=162.31.168.192.in-addr.arpa,master-2.ocp4.shinefire.com
ptr-record=163.31.168.192.in-addr.arpa,master-3.ocp4.shinefire.com
ptr-record=164.31.168.192.in-addr.arpa,worker-1.ocp4.shinefire.com
ptr-record=165.31.168.192.in-addr.arpa,worker-2.ocp4.shinefire.com
srv-host=_etcd-server-ssl._tcp.ocp4.shinefire.com,etcd-1.ocp4.shinefire.com,2380,10
srv-host=_etcd-server-ssl._tcp.ocp4.shinefire.com,etcd-2.ocp4.shinefire.com,2380,10
srv-host=_etcd-server-ssl._tcp.ocp4.shinefire.com,etcd-3.ocp4.shinefire.com,2380,10
log-queries
```

> 注意： In OpenShift Container Platform 4.4 and later, you do not need to specify etcd host and SRV records in your DNS configuration.



客户端验证结果，例如：

```bash
~]# dig +noall +answer @192.168.31.100 api.ocp4.shinefire.com
api.ocp4.shinefire.com. 0       IN      A       192.168.31.160
~]# dig +noall +answer @192.168.31.100 api.ocp4.shinefire.com
api.ocp4.shinefire.com. 0       IN      A       192.168.31.160
~]# dig +noall +answer @192.168.31.100 -x 192.168.31.160
160.31.168.192.in-addr.arpa. 0  IN      PTR     apps.ocp4.shinefire.com.
160.31.168.192.in-addr.arpa. 0  IN      PTR     api-int.ocp4.shinefire.com.
160.31.168.192.in-addr.arpa. 0  IN      PTR     api.ocp4.shinefire.com.
160.31.168.192.in-addr.arpa. 0  IN      PTR     bastion.ocp4.shinefire.com.
```



### YUM源

本篇文章基于 RHEL8.4 的操作系统进行部署，YUM源直接使用 RHEL8.4 的 ISO 镜像提供即可。



### HTTP

公共的 HTTP 服务主要是用于为后续安装各节点时，提供 ignition 文件，coreOS 的依赖文件等





## 离线OpenShift镜像

### 安装Harbor

离线 Openshift 镜像的操作均在`mirror-ocp.ocp4.example.com`节点上面进行，在节点上部署`Harbor`仓库之后，直接离线安装OpenShift所需要的镜像。

部署 Harbor 仓库的操作这里就不写了，可以参考 [RHEL8部署Harbor](../../Harbor/RHEL8部署Harbor.md)



### 离线 OpenShift 镜像

#### 获取openshift client

目前选择使用的 OCP 版本是 4.8.12 stable版本，可以从这里下载客户端：

- https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable-4.8/

```bash
~]# wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable-4.8/openshift-client-linux-4.8.12.tar.gz
~]# tar xzvf openshift-client-linux-4.8.12.tar.gz
README.md
oc
kubectl
~]# mv oc kubectl /usr/local/bin/
```

#### 获取版本信息

解压出来的二进制文件放到基础节点的 `$PATH` 下，看下版本信息：

```bash
~]# oc adm release info quay.io/openshift-release-dev/ocp-release:4.8.12-x86_64
Name:      4.8.12
Digest:    sha256:c3af995af7ee85e88c43c943e0a64c7066d90e77fafdabc7b22a095e4ea3c25a
Created:   2021-09-15T05:24:54Z
OS/Arch:   linux/amd64
Manifests: 495

Pull From: quay.io/openshift-release-dev/ocp-release@sha256:c3af995af7ee85e88c43c943e0a64c7066d90e77fafdabc7b22a095e4ea3c25a

Release Metadata:
  Version:  4.8.12
  Upgrades: 4.7.21, 4.7.22, 4.7.23, 4.7.24, 4.7.25, 4.7.26, 4.7.28, 4.7.29, 4.7.30, 4.7.31, 4.8.2, 4.8.3, 4.8.4, 4.8.5, 4.8.6, 4.8.7, 4.8.9, 4.8.10, 4.8.11
  Metadata:
    url: https://access.redhat.com/errata/RHBA-2021:3511

Component Versions:
  kubernetes 1.21.1
  machine-os 48.84.202109100857-0 Red Hat Enterprise Linux CoreOS

Images:
  NAME                                           DIGEST
  aws-ebs-csi-driver                             sha256:a544af7ed353c5df13a66f12790ea7e920accaccac142925e0878e3340ce2110
  aws-ebs-csi-driver-operator                    sha256:388b19df5c9633fdd9eba6cbca732789575f28c52d0f336a1ee30f6b1c0460a8
  aws-machine-controllers                        sha256:5614c4f278566db1802436c24b61bb736c0a28b8edb4c5cf466e780e1c4a03c8
...

```

#### 离线 OpenShift 镜像

准备拉取镜像权限认证文件。从 `Red Hat OpenShift Cluster Manager` 站点的 **[Pull Secret 页面](https://cloud.redhat.com/openshift/install/pull-secret)** 下载 `registry.redhat.io` 的 `pull secret`

把下载的 txt 文件转出 json 格式：

```bash
~]# cat ./pull-secret.txt | jq . > pull-secret.json
```

JSON 内容如下：

```json
{
  "auths": {
    "cloud.openshift.com": {
      "auth": "b3Blbn...",
      "email": "shine_fire@qq.com"
    },
    "quay.io": {
      "auth": "b3Blbn...",
      "email": "shine_fire@qq.com"
    },
    "registry.connect.redhat.com": {
      "auth": "fHVoYy1wb...",
      "email": "shine_fire@qq.com"
    },
    "registry.redhat.io": {
      "auth": "fHVoYy1wb...",
      "email": "shine_fire@qq.com"
    }
  }
}
```

把本地仓库的用户密码转换成 `base64` 编码：

```bash
~]# echo -n 'admin:Harbor12345' | base64 -w0
YWRtaW46SGFyYm9yMTIzNDU=
```

然后在 `pull-secret.json` 里面加一段本地仓库的权限。第一行仓库域名和端口，第二行是上面的 `base64`，第三行随便填个邮箱：

```json
  "auths": {
...
    "mirror-ocp.ocp4.shinefire.com": {
      "auth": "YWRtaW46SGFyYm9yMTIzNDU=",
      "email": "you@example.com"
   },
...
```



设置环境变量：

```bash
~]# export OCP_RELEASE="4.8.12"
~]# export LOCAL_REGISTRY='mirror-ocp.ocp4.shinefire.com' 
~]# export LOCAL_REPOSITORY='ocp4/openshift4'
~]# export PRODUCT_REPO='openshift-release-dev'
~]# export LOCAL_SECRET_JSON='/root/pull-secret.json'
~]# export RELEASE_NAME="ocp-release"
~]# export ARCHITECTURE="x86_64"
~]# export REMOVABLE_MEDIA_PATH=/data/registry/ocp4
```

- **OCP_RELEASE** : OCP 版本，可以在**[这个页面](https://quay.io/repository/openshift-release-dev/ocp-release?tab=tags)**查看。如果版本不对，下面执行 `oc adm` 时会提示 `image does not exist`。
- **LOCAL_REGISTRY** : 本地仓库的域名和端口。
- **LOCAL_REPOSITORY** : 镜像存储库名称，使用 ocp4/openshift4，如果没有的话，可以自己在Harbor中创建一个名为`ocp4`的project，后面可能会需要用到（因为我也并没有实际测过...）
- `PRODUCT_REPO` 和 `RELEASE_NAME` 都不需要改，这些都是一些版本特征，保持不变即可。
- **LOCAL_SECRET_JSON** : 密钥路径，就是上面 `pull-secret.json` 的存放路径。
- **ARCHITECTURE**：系统的架构，按实际需求来即可，一般都是x86_64的
- **REMOVABLE_MEDIA_PATH**：自定义的一个导出镜像所在目录的路径，**没有的话记得创建该路径**，可以理解为你把 OpenShift 的镜像导出到一个临时目录（可移除设备）中，然后再把这个临时目录（可移除设备）放到你后面需要用到的内部镜像仓库中去供部署 OCP 使用。这个变量建议尽量定义一下吧，在openshift的一个solution中有看到因为没有定义这个变量从而导致了同步时出现报错的情况。我这里用的单独的一台外部Harbor仓库来离线 OpenShift 镜像的，所以是一定需要定义的，因为后面要使用到这个。可参考：https://docs.openshift.com/container-platform/4.8/installing/installing-mirroring-installation-images.html#installation-mirror-repository_installing-mirroring-installation-images



获取 imageContentSources 用于后面的 OCP 安装

```bash
~]# oc adm release mirror -a ${LOCAL_SECRET_JSON}  \
     --from=quay.io/${PRODUCT_REPO}/${RELEASE_NAME}:${OCP_RELEASE}-${ARCHITECTURE} \
     --to=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY} \
     --to-release-image=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY}:${OCP_RELEASE}-${ARCHITECTURE} --dry-run


info: Mirroring 136 images to mirror-ocp.ocp4.shinefire.com:443/ocp4/openshift4 ...
mirror-ocp.ocp4.shinefire.com:443/
  ocp4/openshift4
    blobs:
      quay.io/openshift-release-dev/ocp-release sha256:b663ebb342ea7360924a0aea1f142bb55075b6f7891275aad8d36760bca70bc6 1.732KiB
      quay.io/openshift-release-dev/ocp-release
......

Success
Update image:  mirror-ocp.ocp4.shinefire.com/ocp4/openshift4:4.8.12-x86_64
Mirror prefix: mirror-ocp.ocp4.shinefire.com/ocp4/openshift4
Mirror prefix: mirror-ocp.ocp4.shinefire.com/ocp4/openshift4:4.8.12-x86_64

To use the new mirrored repository to install, add the following section to the install-config.yaml:

imageContentSources:
- mirrors:
  - mirror-ocp.ocp4.shinefire.com/ocp4/openshift4
  source: quay.io/openshift-release-dev/ocp-release
- mirrors:
  - mirror-ocp.ocp4.shinefire.com/ocp4/openshift4
  source: quay.io/openshift-release-dev/ocp-v4.0-art-dev
......
```

加了 `--dry-run` 参数则代表只是测试一下，不会真正的去离线镜像到指定的仓库中。执行命令会得到很多信息输出，主要是要记录下 `imageContentSources ` 的这部分，这个后面安装的时候会需要填写到 `install-config.yaml` 中。



同步镜像到 REMOVABLE_MEDIA_PATH 指定的路径中：

```bash
~]# oc adm release mirror \
  -a ${LOCAL_SECRET_JSON} \
  --to-dir=${REMOVABLE_MEDIA_PATH}/mirror \
  quay.io/${PRODUCT_REPO}/${RELEASE_NAME}:${OCP_RELEASE}-${ARCHITECTURE}

......（略，一堆镜像的信息）
sha256:69ed52a54af7f30205a8d2e4d7f1906ab19328f34a8a0ed7253ff39aeed6c20a file://openshift/release:4.8.12-x86_64-baremetal-installer
sha256:a1ada2b6ed3e3f16c603f68b10a75b5939cac285df35cd40939c70cdd5398e86 file://openshift/release:4.8.12-x86_64-gcp-pd-csi-driver-operator
info: Mirroring completed in 2m57.55s (15.31MB/s)

Success
Update image:  openshift/release:4.8.12-x86_64

To upload local images to a registry, run:

    oc image mirror --from-dir=/data/registry/ocp4/mirror 'file://openshift/release:4.8.12-x86_64*' REGISTRY/REPOSITORY

Configmap signature file /data/registry/ocp4/mirror/config/signature-sha256-c3af995af7ee85e8.yaml created
```



将离线下来的镜像打包好，用于后续同步到内部镜像仓库中

```bash
~]# pwd
/data/registry
~]# tar czvf ocp4.tar.gz ocp4/
```



#### 提取openshift-install命令

为了保证安装版本一致性，需要从镜像库中提取 `openshift-install` 二进制文件，不能直接从 https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.8.12 下载，不然后面可能会有 `sha256` 匹配不上的问题。

```bash
~]# oc adm release extract \
  -a ${LOCAL_SECRET_JSON} \
  --command=openshift-install \
  "${LOCAL_REGISTRY}/${LOCAL_REPOSITORY}:${OCP_RELEASE}-${ARCHITECTURE}"
~]# ls openshift-install
openshift-install
```

如果提示 `error: image dose not exist`，说明拉取的镜像不全，或者版本不对。

把文件移动到 `$PATH` 并确认版本：

```bash
~]# mv openshift-install /usr/local/bin/
~]# openshift-install version
openshift-install 4.8.12
built from commit 450e95767d89f809cb1afe5a142e9c824a269de8
release image mirror-ocp.ocp4.shinefire.com/ocp4/openshift4@sha256:c3af995af7ee85e88c43c943e0a64c7066d90e77fafdabc7b22a095e4ea3c25a
```

最后把 openshift-install 保存下来，用于后续在离线环境中部署 OCP 使用。 



## 部署内部镜像仓库

内部镜像仓库部署在 registry-1.ocp4.shinefire.com 节点，并将 mirror-ocp.ocp4.example.com 节点同步下来的镜像导入到内部仓库中。



### Harbor部署

内部镜像仓库也要再部署一遍harbor仓库，此处略过



### 导入OpenShift镜像到内部镜像仓库

部署完毕内部的Harbor镜像仓库后，再将之前离线好的OpenShift镜像，同步到内部镜像仓库中，用于后续的部署



#### 创建 OCP Project

现在内部镜像仓库中创建一个 OCP 项目，将 OpenShift 离线镜像同步到此项目中

![image-20211004200622828](pictures/image-20211004200622828.png)

![image-20211004200638998](pictures/image-20211004200638998.png)



#### 定义环境变量

还是跟离线仓库用的环境变量基本一致

```bash
~]# export OCP_RELEASE="4.8.12"
~]# export LOCAL_REGISTRY='registry-1.ocp4.shinefire.com' 
~]# export LOCAL_REPOSITORY='ocp4/openshift4'
~]# export PRODUCT_REPO='openshift-release-dev'
~]# export LOCAL_SECRET_JSON='/root/pull-secret.json'
~]# export RELEASE_NAME="ocp-release"
~]# export ARCHITECTURE="x86_64"
~]# export REMOVABLE_MEDIA_PATH="/data/registry/ocp4"
```

**注意**：这里的 **LOCAL_REGISTRY** 要换成 registry-1.ocp4.shinefire.com 仓库的地址，我之前弄错了... 还用的原来的 mirror-ocp 把自己坑了一把



#### 导入离线镜像到内部镜像仓库

安装 openshift client，主要是为了有 oc 命令来导入镜像

```bash
~]# tar xzvf openshift-client-linux-4.8.12.tar.gz
README.md
oc
kubectl
~]# mv oc kubectl /usr/local/bin/
```

将之前离线好的镜像包导入到内部镜像仓库中

```bash
~]# tar xzf ocp4.tar.gz -C /data/registry/
~]# docker login registry-1.ocp4.shinefire.com
~]# oc image mirror \
  --from-dir=${REMOVABLE_MEDIA_PATH}/mirror "file://openshift/release:${OCP_RELEASE}*" \
  ${LOCAL_REGISTRY}/${LOCAL_REPOSITORY} 
```

导入完成后可以登录到 harbor web端查看 ocp4 项目里面的镜像来检查是否都有了

（此处略过界面查看）

导入完成后删除旧的资源

```bash
~]# rm -rf /data/registry/ocp4/
```



#### 检查导入的结果

安装jq

```bash
~]# yum install -y jq
```

导入镜像后，通过 `_catalog` 接口查看 _catalog

```bash
~]# curl -s -u admin:Harbor12345 -k https://registry-1.ocp4.shinefire.com/v2/_catalog | jq .
{
  "repositories": [
    "ocp4/openshift4"
  ]
}
```

通过 `tag/list` 接口查看所有 tag，如果能列出来一堆就说明是正常的：

```bash
~]# curl -s -u admin:Harbor12345 -k https://registry-1.ocp4.shinefire.com/v2/ocp4/openshift4/tags/list|jq .
{
  "name": "ocp4/openshift4",
  "tags": [
    "4.8.12-x86_64",
    "4.8.12-x86_64-aws-ebs-csi-driver",
    "4.8.12-x86_64-aws-ebs-csi-driver-operator",
    "4.8.12-x86_64-aws-machine-controllers",
    ......
    "4.8.12-x86_64-vsphere-csi-driver-syncer",
    "4.8.12-x86_64-vsphere-problem-detector"
  ]
}
```



## 配置 HAProxy

本环境使用 HAProxy 来实现负载均衡配置，以下配置均在 bastion.ocp4.shinefire.com 节点中进行。

### 安装HAProxy

haproxy主要用于负载master api 6443 22623，worker节点的router 80 443

```bash
~]# yum install -y haproxy
```

配置HAProxy

```bash
~]# cat /etc/haproxy/haproxy.cfg
global
    log         127.0.0.1 local2
    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
    maxconn     4000
    user        haproxy
    group       haproxy
    daemon

defaults
    mode                    http
    log                     global
    option                  tcplog
    option                  dontlognull
    option http-server-close
    # option forwardfor       except 127.0.0.0/8
    option                  redispatch
    retries                 3
    timeout http-request    10s
    timeout queue           1m
    timeout connect         10s
    timeout client          1m
    timeout server          1m
    timeout http-keep-alive 10s
    timeout check           10s
    maxconn                 3000

# 可选项,可以通过页面查看负载监控状态
frontend stats
    bind *:9000
    mode            http
    log             global
    maxconn 10
    stats enable
    stats hide-version
    stats refresh 30s
    stats show-node
    stats show-desc Stats for ocp4 cluster
    stats auth admin:ocp4
    stats uri /stats
    monitor-uri /healthz

listen api-server-6443
    bind *:6443
    mode tcp
    server bootstrap bootstrap.ocp4.shinefire.com:6443 check inter 1s backup
    server master-1 master-1.ocp4.shinefire.com:6443 check inter 1s
    server master-2 master-2.ocp4.shinefire.com:6443 check inter 1s
    server master-3 master-3.ocp4.shinefire.com:6443 check inter 1s

listen machine-config-server-22623
    bind *:22623
    mode tcp
    server bootstrap bootstrap.ocp4.shinefire.com:22623 check inter 1s backup
    server master-1 master-1.ocp4.shinefire.com:22623 check inter 1s
    server master-2 master-2.ocp4.shinefire.com:22623 check inter 1s
    server master-3 master-3.ocp4.shinefire.com:22623 check inter 1s

listen ingress-router-443
    bind *:443
    mode tcp
    balance source
    server worker-1 worker-1.ocp4.shinefire.com:443 check inter 1s
    server worker-2 worker-2.ocp4.shinefire.com:443 check inter 1s

listen ingress-router-80
    bind *:80
    mode tcp
    balance source
    server worker-1 worker-1.ocp4.shinefire.com:80 check inter 1s
    server worker-2 worker-2.ocp4.shinefire.com:80 check inter 1s
```

启动并设置为开机自启动

```bash
~]# systemctl enable haproxy.service --now
```

使用 netstat 命令检查端口，看看是否都处于监听状态

```bash
~]# netstat -nltup
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:9000            0.0.0.0:*               LISTEN      24703/haproxy
tcp        0      0 0.0.0.0:6443            0.0.0.0:*               LISTEN      24703/haproxy
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      24703/haproxy
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      1165/sshd
tcp        0      0 0.0.0.0:443             0.0.0.0:*               LISTEN      24703/haproxy
tcp        0      0 0.0.0.0:22623           0.0.0.0:*               LISTEN      24703/haproxy
tcp6       0      0 :::22                   :::*                    LISTEN      1165/sshd
udp        0      0 0.0.0.0:56951           0.0.0.0:*                           24696/haproxy
udp        0      0 127.0.0.1:323           0.0.0.0:*                           1049/chronyd
udp6       0      0 ::1:323                 :::*                                1049/chronyd
```





## 配置Bastion节点

### 部署oc命令

```bash
~]# tar xzvf openshift-client-linux-4.8.12.tar.gz
README.md
oc
kubectl
~]# mv oc kubectl /usr/local/bin/
~]# oc version
Client Version: 4.8.12
```



### 部署openshift-install

将上传到bastion中的 `openshift-install` 放到环境变量路径下使用

```bash
~]# chmod +x openshift-install
~]# mv openshift-install /usr/local/bin/
~]# openshift-install version
openshift-install 4.8.12
built from commit 450e95767d89f809cb1afe5a142e9c824a269de8
release image mirror-ocp.ocp4.shinefire.com/ocp4/openshift4@sha256:c3af995af7ee85e88c43c943e0a64c7066d90e77fafdabc7b22a095e4ea3c25a
```



### 配置 SSH 密钥用于后续登录 OpenShift 节点

#### 创建SSH密钥对

在安装过程中，我们会在基础节点上执行 OCP 安装调试和灾难恢复，因此必须在基础节点上配置 SSH key，`ssh-agent` 将会用它来执行安装程序。

基础节点上的 `core` 用户可以使用该私钥登录到 Master 节点。部署集群时，该私钥会被添加到 core 用户的 `~/.ssh/authorized_keys` 列表中。

```bash
~]# ssh-keygen -t rsa -b 4096 -N "" -f /root/.ssh/id_rsa
Generating public/private rsa key pair.
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:YuQvNqm4lukBrjwdKfKoo1iWhDSVuQvkLgAt+WnV4/c root@bastion.ocp4.shinefire.com
The key's randomart image is:
+---[RSA 4096]----+
| o .o.           |
|+.oo. o          |
|+= o....         |
|o+=. o. .        |
|=.o o +.S.       |
|+= = . +  E      |
|o+Bo. = .        |
|*+=+ o o         |
|B==..            |
+----[SHA256]-----+
```

> 注意：这里生成的密钥很重要，请及时保存好，以防丢失。

#### 查看公钥内容

查看公钥内容，后面需要添加到 install-config.yaml 安装配置文件中

```bash
~]# cat /root/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmBATHa2pREM2hnKp4HwIa6hpZvzHv7hpOooGQmi95eqLCldj8DVRkhzmRG/6bYJdo//sqURwTdBkc+/XTmd6BI/qVE6ZXqOUrNnYDbDo3k8e5hfv4nEeaEoqZDR6PNW68zGAPAuV0VMZSMQ7Ib4/YjU4bXiLc0uBppFN4vtJ5pV0hBFRM+XPsAfhJzx5KCNxkFDgdbHSSdEcljPtbPoG+7JAvzQh38lt2O1Frp18WwAgQnM0sH+aWRsEOW2+EcdGXRV2ruRJvHPm9HTqvgfd6IyYIteiIJA7gdlYrUvrjc42JNuky1N7bsp7QrEEuWET7/u2x7ub33a34kPkpmvDFkuy0Uwm8F27gO7TGDtS8VXfB5TyQAKGQQdtRXY0sVJXsmom12kTzS+i+5hsGzCmsq59Ln8Ogjxr6uLjYAF9fGt+Uw6E4YL6zujGF0ocFiiohVf3BUDOPgsufeztL5Y7cf5LFYV+y0iX4bL2Q54endf+wqfZRqpCagwZAmUbUn2WYFCVx9n8dqNXafEGm45QT3XEKMDwN9G6j72s3QvZzyvsBhBj1lO3b25kq/uOB0LeCUqLVJNrIGZtbZ+9FayPhNzrG80DrBWzMCpBPvi7kp0EwBBlUa8vl7p5+6SGO3708h8xCzzZgTF8h6MvcH3ySrklNQQl8vsPGqRNYNOjovw== root@bastion.ocp4.shinefire.com
```

### 查看内部仓库的CA证书内容

登录到 registry-1.ocp4.shinefire.com 节点中查看内部仓库的CA证书内容，后面需要添加到 install-config.yaml 安装配置文件中

```bash
~]# cat /etc/pki/ca-trust/source/anchors/myrootCA.crt
-----BEGIN CERTIFICATE-----
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
-----END CERTIFICATE-----
```

### 加密内部仓库的登录账户

将内部仓库的登录用户名和密码转成 base64 编码，后面需要添加到 install-config.yaml 安装配置文件中

```bash
~]# echo -n 'admin:Harbor12345'| base64 -w0
YWRtaW46SGFyYm9yMTIzNDU=
```



### 创建 install-config.yaml

使用 UPI 方式部署 OCP 集群，需要手动创建一个 install-config.yaml 的配置文件。



创建一个安装目录

```bash
~]# mkdir /root/ocp4-installation
~]# touch /root/ocp4-installation/install-config.yaml
```



自定义一个 install-config.yaml 

```yaml
apiVersion: v1
baseDomain: shinefire.com
compute:
- hyperthreading: Enabled
  name: worker
  replicas: 0
controlPlane:
  hyperthreading: Enabled
  name: master
  replicas: 3
metadata:
  name: ocp4
networking:
  clusterNetworks:
  - cidr: 10.254.0.0/16
    hostPrefix: 24
  networkType: OVNKubernetes
  serviceNetwork:
  - 172.30.0.0/16
platform:
  none: {}
pullSecret: '{"auths":{"registry-1.ocp4.shinefire.com": {"auth": "YWRtaW46SGFyYm9yMTIzNDU=","email": "noemail@localhost"}}}'
sshKey: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmBATHa2pREM2hnKp4HwIa6hpZvzHv7hpOooGQmi95eqLCldj8DVRkhzmRG/6bYJdo//sqURwTdBkc+/XTmd6BI/qVE6ZXqOUrNnYDbDo3k8e5hfv4nEeaEoqZDR6PNW68zGAPAuV0VMZSMQ7Ib4/YjU4bXiLc0uBppFN4vtJ5pV0hBFRM+XPsAfhJzx5KCNxkFDgdbHSSdEcljPtbPoG+7JAvzQh38lt2O1Frp18WwAgQnM0sH+aWRsEOW2+EcdGXRV2ruRJvHPm9HTqvgfd6IyYIteiIJA7gdlYrUvrjc42JNuky1N7bsp7QrEEuWET7/u2x7ub33a34kPkpmvDFkuy0Uwm8F27gO7TGDtS8VXfB5TyQAKGQQdtRXY0sVJXsmom12kTzS+i+5hsGzCmsq59Ln8Ogjxr6uLjYAF9fGt+Uw6E4YL6zujGF0ocFiiohVf3BUDOPgsufeztL5Y7cf5LFYV+y0iX4bL2Q54endf+wqfZRqpCagwZAmUbUn2WYFCVx9n8dqNXafEGm45QT3XEKMDwN9G6j72s3QvZzyvsBhBj1lO3b25kq/uOB0LeCUqLVJNrIGZtbZ+9FayPhNzrG80DrBWzMCpBPvi7kp0EwBBlUa8vl7p5+6SGO3708h8xCzzZgTF8h6MvcH3ySrklNQQl8vsPGqRNYNOjovw== root@bastion.ocp4.shinefire.com'

additionalTrustBundle: |
  -----BEGIN CERTIFICATE-----
  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
  -----END CERTIFICATE-----
imageContentSources:
- mirrors:
  - mirror-ocp.ocp4.shinefire.com/ocp4/openshift4
  source: quay.io/openshift-release-dev/ocp-release
- mirrors:
  - mirror-ocp.ocp4.shinefire.com/ocp4/openshift4
  source: quay.io/openshift-release-dev/ocp-v4.0-art-dev
```



备份 install-config.yaml ，备份这个文件很重要，因为安装的时候会消费掉这个文件，不备份就没有了。

```bash
~]# cp /root/ocp4-installation/install-config.yaml /root/install-config.yaml.bak
```



### 创建 manifest 与 ignition 配置文件

生成集群的kubernetes manifests

```bash
~]# openshift-install create manifests --dir=/root/ocp4-installation/
INFO Consuming Install Config from target directory
WARNING Making control-plane schedulable by setting MastersSchedulable to true for Scheduler cluster settings
INFO Manifests created in: /root/ocp4-installation/manifests and /root/ocp4-installation/openshift
~]# ls ocp4-installation/
manifests  openshift
```



修改生成的 `<installation_directory>/manifests/cluster-scheduler-02-config.yml` 文件，将 `mastersSchedulable` 改为 `false` ，让以后使用 OpenShift 平台的时候，不会把 Pod 调度到 Master 节点上。

```yaml
~]# vim /root/ocp4-installation/manifests/cluster-scheduler-02-config.yml
~]# cat /root/ocp4-installation/manifests/cluster-scheduler-02-config.yml
apiVersion: config.openshift.io/v1
kind: Scheduler
metadata:
  creationTimestamp: null
  name: cluster
spec:
  mastersSchedulable: false
  policy:
    name: ""
status: {}
```



创建 ignition 配置文件

```bash
~]# openshift-install create ignition-configs --dir=/root/ocp4-installation/
INFO Consuming Master Machines from target directory
INFO Consuming Worker Machines from target directory
INFO Consuming Common Manifests from target directory
INFO Consuming OpenShift Install (Manifests) from target directory
INFO Consuming Openshift Manifests from target directory
INFO Ignition-Configs created in: /root/ocp4-installation and /root/ocp4-installation/auth
```



检查创建结果

```bash
~]# tree /root/ocp4-installation
/root/ocp4-installation
├── auth
│   ├── kubeadmin-password
│   └── kubeconfig
├── bootstrap.ign
├── master.ign
├── metadata.json
└── worker.ign
```



### 上传 ignition 配置文件到 HTTP 服务器中

创建好的 ignition 配置文件全部需要上传到 httpd 服务器中，后面在使用 RHCOS 安装的时候，会需要访问 http server 来获取 ignition 配置来供各个节点使用。

本环境中使用 NUC 节点来当 httpd 服务器

```bash
[root@nuc ignition]# pwd
/var/www/html/ignition
[root@nuc ignition]# scp bastion.ocp4.shinefire.com:/root/ocp4-installation/*.ign ./
bootstrap.ign                                  100%  267KB  19.6MB/s   00:00
master.ign                                     100% 1720     3.0MB/s   00:00
worker.ign                                     100% 1720     2.9MB/s   00:00
[root@nuc ignition]# ll
total 276
-rw-r----- 1 root root 273215 Oct  5 19:31 bootstrap.ign
-rw-r----- 1 root root   1720 Oct  5 19:31 master.ign
-rw-r----- 1 root root   1720 Oct  5 19:31 worker.ign
[root@nuc ignition]# chmod 755 *
```

从 httpd 服务器中拉取 ignition 文件测试，验证可用性

```bash
[root@bastion ~]# wget http://192.168.31.100/ignition/worker.ign
--2021-10-05 19:31:40--  http://192.168.31.100/ignition/worker.ign
Connecting to 192.168.31.100:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 1720 (1.7K)
Saving to: ‘worker.ign’

worker.ign         100%[=============================>]   1.68K  --.-KB/s    in 0s

2021-10-05 19:31:40 (348 MB/s) - ‘worker.ign’ saved [1720/1720]
```



### 位置 chrony 时间服务（暂未配置，可选项仅供参考）

虽然配置时间服务是非必需的，不过有条件的话，也配置一下时间服务器会比较好，能让集群的各个节点更好的统一时间。

下面配置 chrony 时间服务的操作，摘自官方：https://docs.openshift.com/container-platform/4.8/installing/installing_bare_metal/installing-restricted-networks-bare-metal.html#installation-special-config-chrony_installing-restricted-networks-bare-metal

Create a Butane config including the contents of the `chrony.conf` file. For example, to configure chrony on worker nodes, create a `99-worker-chrony.bu` file.

```yaml
variant: openshift
version: 4.8.0
metadata:
  name: 99-worker-chrony 
  labels:
    machineconfiguration.openshift.io/role: worker 
storage:
  files:
  - path: /etc/chrony.conf
    mode: 0644
    overwrite: true
    contents:
      inline: |
        pool 0.rhel.pool.ntp.org iburst 
        driftfile /var/lib/chrony/drift
        makestep 1.0 3
        rtcsync
        logdir /var/log/chrony
```

Use Butane to generate a `MachineConfig` object file, `99-worker-chrony.yaml`, containing the configuration to be delivered to the nodes:

```bash
butane 99-worker-chrony.bu -o 99-worker-chrony.yaml
```

Apply the configurations in one of two ways:

- If the cluster is not running yet, after you generate manifest files, add the `MachineConfig` object file to the `<installation_directory>/openshift` directory, and then continue to create the cluster.

- If the cluster is already running, apply the file:

  ```bash
  oc apply -f ./99-worker-chrony.yaml



## 安装 RHCOS 启动 OCP 集群

### Bootstrap

直接通过iso启动进入系统，先用 nmcli 删除当前的网络

```bash
$ nmcli connection delete "xxx"
```

配置网络

```bash
$ sudo nmcli connection add con-name 'static-ip' ifname ens160 type Ethernet ip4 192.168.31.159/24 gw4 192.168.31.1 ipv4.dns 192.168.31.100 ipv4.method manual connection.autoconnect yes
$ sudo nmcli connection up static-ip 
```

配置好网络后进入系统，再使用命令指定 ignition 文件进行后面的安装

```bash
$ sudo coreos-installer install /dev/sda --copy-network --ignition-url http://192.168.31.100/ignition/bootstrap.ign --insecure-ignition
```



### Master 集群

直接通过iso启动进入系统，先用 nmcli 删除当前的网络

```bash
$ nmcli connection delete "xxx"
```

配置网络

```bash
$ sudo nmcli connection add con-name 'static-ip' ifname ens160 type Ethernet ip4 192.168.31.161/24 gw4 192.168.31.1 ipv4.dns 192.168.31.100 ipv4.method manual connection.autoconnect yes
$ sudo nmcli connection up static-ip 
```

配置好网络后进入系统，再使用命令指定 ignition 文件进行后面的安装

```bash
$ sudo coreos-installer install /dev/sda --copy-network --ignition-url http://192.168.31.100/ignition/master.ign --insecure-ignition
```







## Q&A

Q1：

之前一个离线部署的环境中，发现开箱即用的一些镜像并没有，例如openjdk，今天看到官方文档有下面这么一句话，我猜想之前离线部署的环境中没有开发相关的镜像和这个有关：

https://docs.openshift.com/container-platform/4.8/installing/installing_bare_metal/installing-restricted-networks-bare-metal.html#installation-restricted-network-limits_installing-restricted-networks-bare-metal

**Additional limits**

Clusters in restricted networks have the following additional limitations and restrictions:

- By default, **you cannot use the contents of the Developer Catalog** because you cannot access the required image stream tags.

A：



Q2：

oc image mirror 导入镜像到内部仓库时，遇到无法通过导入镜像到仓库的报错

error: unable to upload blob sha256:415b96ebc4e11337d8445b922ff276251de13e94c0482784ec9a1011b78dda9f to bastion.ocp4.shinefire.com/ocp4/openshift4: unauthorized: unauthorized to access repository: ocp4/openshift4, action: push: unauthorized to access repository: ocp4/openshift4, action: push

A：

提前 docker login 登录仓库后再进行导入操作



Q3：

关于 OpenShift 中各个节点的分区有什么要求吗？和传统的系统的文件系统分区是不是也有一些类似的需求呢？例如是否需要考虑后续的扩容的问题呢？

A：



Q4：

安装的时候去错误的镜像仓库拉镜像，我的预期应该是去我内部镜像仓库 registry-1.ocp4.shinefire.com 中拉取镜像来进行安装的，但是它默认到我离线公网镜像的那个仓库去 pull 镜像然后失败了

我怀疑和我 install-config.yaml 配置中定义的 imageContentSources 字段有关系

后来尝试修改了 install-config.yaml 配置中定义的 imageContentSources 字段，将imagesource改成内部的镜像仓库，依旧出现同样的报错。

```bash
bootstrap.ocp4.shinefire.com release-image-download.sh[1698]: Error: Error initializing source docker://mirror-ocp.ocp4.shinefire.com/ocp4/openshift4@sha256:c3af995af7ee85e88c43c943e0a64c7066d90e77fafdabc7b22a095e4ea3c25a: error pinging docker registry mirror-ocp.ocp4.shinefire.com: Get "https://mirror-ocp.ocp4.shinefire.com/v2/": dial tcp 192.168.31.158:443: connect: connection refused
bootstrap.ocp4.shinefire.com release-image-download.sh[1698]: Pull failed. Retrying mirror-ocp.ocp4.shinefire.com/ocp4/openshift4@sha256:c3af995af7ee85e88c43c943e0a64c7066d90e77fafdabc7b22a095e4ea3c25a...
bootstrap.ocp4.shinefire.com release-image-download.sh[1698]: time="2021-10-05T13:27:17Z" level=warning msg="failed, retrying in 1s ... (1/3). Error: Error initializing source docker://mirror-ocp.ocp4.shinefire.com/ocp4/openshift4@sha256:c3af995af7ee85e88c43c943e0a64c7066d90e77fafdabc7b22a095e4ea3c25a: error pinging docker registry mirror-ocp.ocp4.shinefire.com: Get \"https://mirror-ocp.ocp4.shinefire.com/v2/\": dial tcp 192.168.31.158:443: connect: connection refused"
```

A： 



Q5：

安装 OCP 集群的时候，节点使用的都是临时的 DNS ，后面要使用企业内部的公共 DNS 服务器了应该怎么办呢？

A：





## Reference

- [OpenShift Container Platform Versioning Policy](https://docs.openshift.com/container-platform/4.8/release_notes/versioning-policy.html)
- [Mirroring images for a disconnected installation](https://docs.openshift.com/container-platform/4.8/installing/installing-mirroring-installation-images.html)
- [Installation and update](https://docs.openshift.com/container-platform/4.8/architecture/architecture-installation.html#architecture-installation)





## Others

