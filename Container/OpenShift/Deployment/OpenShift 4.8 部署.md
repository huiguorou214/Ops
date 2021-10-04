# Deployment UPI OpenShift 4.8.12



## Introduction

#### UPI（UserProvisioned Infrastructure）

离线环境安装的方案	



## Architecture

### Host List

服务器规划如下：

- 一台离线OpenShift镜像节点，用于专门连接公网离线部署需要的镜像，后面再将离线好的镜像导入到集群中的私有镜像仓库节点使用
- 三个控制平面节点，安装 `Etcd`、控制平面组件和 `Infras` 基础组件。
- 两个计算节点，运行实际负载。
- 一个引导主机，执行安装任务，集群部署完成后可删除。
- 一个bastion节点，用于部署负载均衡、私有镜像仓库。
- 一个基础节点nuc，用于准备提到安装OpenShift的离线资源，同时用来部署 DNS

| Hostname                     | IP             | Hardware     | Role            |
| ---------------------------- | -------------- | ------------ | --------------- |
| mirror-ocp.ocp4.example.com  | 192.168.31.158 | 4C/8G/120GB  | 离线镜像的仓库  |
| bastion.ocp4.shinefire.com   | 192.168.31.160 | 4C/8G/120GB  | OpenShift客户端 |
| registry.ocp4.shinefire.com  | 192.168.31.160 | 4C/8G/120GB  | 内部镜像仓库    |
| api.ocp4.shinefire.com       | 192.168.31.160 | 4C/8G/120GB  | HAProxy         |
| api-int.ocp4.shinefire.com   | 192.168.31.160 | 4C/8G/120GB  |                 |
| bootstrap.ocp4.shinefire.com | 192.168.31.159 | 4C/16G/120GB | bootstrap       |
| master-1.ocp4.shinefire.com  | 192.168.31.161 | 4C/16G/120GB | master节点      |
| etcd-1.ocp4.shinefire.com    | 192.168.31.161 | 4C/16G/120GB | etcd节点        |
| master-2.ocp4.shinefire.com  | 192.168.31.162 | 4C/16G/120GB | master节点      |
| etcd-2.ocp4.shinefire.com    | 192.168.31.162 | 4C/16G/120GB | etcd节点        |
| master-3.ocp4.shinefire.com  | 192.168.31.163 | 4C/16G/120GB | master节点      |
| etcd-3.ocp4.shinefire.com    | 192.168.31.163 | 4C/16G/120GB | etcd节点        |
| worker-1.ocp4.shinefire.com  | 192.168.31.164 | 2C/8G/120GB  | worker节点      |
| apps.ocp4.shinefire.com      | 192.168.31.164 | 2C/8G/120GB  | 入口地址        |
| worker-2.ocp4.shinefire.com  | 192.168.31.165 | 2C/8G/120GB  | worker节点      |
| nuc.shinefire.com            | 192.168.31.100 | N/A          | YUM/DNS/httpd   |

Each cluster machine must meet the following **minimum requirements**:

| Machine       | Operating System | vCPU | Virtual RAM | Storage |
| :------------ | :--------------- | :--- | :---------- | :------ |
| Bootstrap     | RHCOS            | 4    | 16 GB       | 120 GB  |
| Control plane | RHCOS            | 4    | 16 GB       | 120 GB  |
| Compute       | RHCOS            | 4    | 16 GB       | 120 GB  |



### Softwares List

| 软件名称              | 软件包名                            |
| --------------------- | ----------------------------------- |
| RHEL8.4 DVD           | rhel-server-8.4-x86_64-dvd.iso      |
|                       |                                     |
| 镜像仓库软件          | harbor-offline-installer-v2.3.2.tgz |
| Registry仓库镜像      |                                     |
| Openshift客户端oc命令 | openshift-client-linux-4.8.2.tar.gz |
| Openshift安装程序     |                                     |
| CoreOS引导光盘        |                                     |
| CoreOS远程部署内核    |                                     |



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



## 基础环境设施提供说明

### DNS

公共 DNS 是由 dnsmasq 部署的，这里就只介绍一下具体配置的内容，具体的部署方法可以自行检索

配置的解析条目如下：

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
- **LOCAL_REPOSITORY** : 镜像存储库名称，使用 ocp4/openshift4。
- `PRODUCT_REPO` 和 `RELEASE_NAME` 都不需要改，这些都是一些版本特征，保持不变即可。
- **LOCAL_SECRET_JSON** : 密钥路径，就是上面 `pull-secret.json` 的存放路径。
- **ARCHITECTURE**：系统的架构，按实际需求来即可，一般都是x86_64的
- **REMOVABLE_MEDIA_PATH**：自定义的一个导出镜像所在目录的路径，**没有的话记得创建该路径**，这个变量建议尽量定义一下吧，在openshift的一个solution中有看到因为没有定义这个变量从而导致了同步时出现报错的情况。

在 Harbor 中创建一个项目 `ocp4` 用来存放同步过来的镜像，我这里是直接其他的机器使用firefox打开 `mirror-ocp.ocp4.shinefire.com` 登录到harbor web端进行创建项目，注意创建项目的时候项目名称要跟上面设置环境变量中使用的名称一致。

![image-20211004200622828](pictures/image-20211004200622828.png)

![image-20211004200638998](pictures/image-20211004200638998.png)



最后一步就是同步镜像，这一步的动作就是把 `quay` 官方仓库中的镜像，同步到本地仓库，如果失败了可以重新执行命令，整体内容大概 `5G`。

```bash
~]# docker login -u admin mirror-ocp.ocp4.shinefire.com
Password:
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded

~]# oc adm release mirror -a ${LOCAL_SECRET_JSON}  \
     --from=quay.io/${PRODUCT_REPO}/${RELEASE_NAME}:${OCP_RELEASE}-${ARCHITECTURE} \
     --to=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY} \
     --to-release-image=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY}:${OCP_RELEASE}-${ARCHITECTURE}


info: Mirroring 136 images to mirror-ocp.ocp4.shinefire.com:443/ocp4/openshift4 ...
mirror-ocp.ocp4.shinefire.com:443/
  ocp4/openshift4
    blobs:
      quay.io/openshift-release-dev/ocp-release sha256:b663ebb342ea7360924a0aea1f142bb55075b6f7891275aad8d36760bca70bc6 1.732KiB
      quay.io/openshift-release-dev/ocp-release sha256:356f18f3a935b2f226093720b65383048249413ed99da72c87d5be58cc46661c 1.75KiB
      quay.io/openshift-release-dev/ocp-release sha256:bad13c6cb503cb9839b77ccec1082e22a6ac16ae5d274326f56189f24777a190 516.9KiB
      quay.io/openshift-release-dev/ocp-release sha256:695b973747ed33954b33cdf3e56293a749f13204d95f357781fb770f4e7c43cd 1.776MiB
      quay.io/openshift-release-dev/ocp-release sha256:38801d26e88e7f7b8ef47729624c003d1c0ff2520cb98b1599c18685c8b0c643 10.66MiB
      quay.io/openshift-release-dev/ocp-release sha256:4212b4f2843445c5db775b98761572a9b70023c336df8629bbdf50e090e704fd 21.23MiB
      quay.io/openshift-release-dev/ocp-release sha256:296e14ee24149e14d573a1fbf5b5a625c7bb0cc22f5b2a8b180e833258187948 79.5MiB
    blobs:
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:356f18f3a935b2f226093720b65383048249413ed99da72c87d5be58cc46661c 1.75KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:b607c47c5c472e4b329edea1d5ea813e9f2c471b0b0f80adc316ca225659a2d8 1.817KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:be420045953f40ee51ee8feb1ecba4d5cec9b06bd86f5a21eb49f7bdb6354900 1.835KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:10bb8c62ee7d49be2bab45cacd50164c1ed926cf1b92bc4cebc709f7a08f099f 3.147KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:a3569474917a2436fc87026ad2780a058f03eb1044bce2a8cf0760f75133c545 4.64KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:e90b0429080a9c93c83c5ceb98ecd8afa1318d777595e945c1717d37dd41cbab 5.548KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:08a154cce494f0eb066b3a514b3140bdffd149c2843053ae881bee5084561713 5.668KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:f7d09b54520c8950b4f5adc8111b27143c285d16c24eb5d13714bb2e87e280ff 5.671KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:3bd179ac38c8d1120469e6b5ae82945dc22d765f876cc3f2c0e43dc14d2d0cad 5.69KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:23309c8658a21d29fc0360696d6cf4e0e354d503f9f6b1aefdfde4316b84248b 5.693KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:bf828502d2385836b84a25b72831104002171f085e3acedd290c481cbf4fa0c9 5.709KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:b33d9ec88b75d46e93298c4357744172c8b994af0dd39958382244218ef73731 5.734KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:a68c5f20ff4137492610c1e021ebeb92414e4645ff0bee3f718654bbba5c2194 5.737KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:3cccbad0c1fb8c0694bfd91bf934e4c10f912c671e2e273a4fe2244d02ca48c6 5.742KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:dfd1e2430556eb4a9de83031a82c62c06debca6095dd63553ed38bd486374ac8 5.746KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:5398b9528117f74ea2c97f8f88cbaf31b78a00f00df97e85e7123fc3f5693ce6 5.752KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:97f07bf43ceedd69dd9a50224399bd72c6a1130eff78f87194539dd2f3a85689 5.754KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:5891d88a98159ed6080e6a29cec927613fcfb2a27d267c5ebf0fedeacf09f82b 5.766KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:ce9c50dcb38c76e3f4c5afe1a3674914c28c7c718d55128a13137838658e1e5b 5.776KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:a6b543231829e4d18d9c156f9e351625b7599085d57a2cc570fa68db7cbdeff6 5.804KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:f5e35e2b8fee5d7cb8fa5febcc3e7f0218f6a8b49c5a6402fbf5d1da24c6b97f 5.805KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:a792f162d4546b58e1addef8ae67ed4fc94dfb43fcd0be1412f9a21896edcd3c 5.809KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:4ba95dcbf27d7c30cea0af7f4339b46d8900ac3bf2502497952beb6413a95549 5.81KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:90fbee5420377c94e18befe5698724ec2381b7d931313bb60f58292e058349e5 5.81KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:05f8df7fdf9f6a398927cdbfd1fe44f767d17a063580581a2fcbc25bd2dca6e4 5.824KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:483386eb24b22b45af8ff411d2e99c9852f53d777985006466758a7df80b4cf1 5.829KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:86522cf966bb24552de12e4acd3b5d9e35648e387395b28ffd78ee5fd036b4df 5.835KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:d6dfad6fcb99ddb70b744997d67977007816a978c05598f631d691bad3fd8c64 5.837KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:26a948b6f4750867028fe924721586bd7cad7026233334dd47b327eb6ff93d33 5.841KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:7e3b6237532dd883023e16c4d0c65ffafb5635498c0c6e933947d8cab334b2be 5.841KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:0cbf9d799205679573144bf0fc221f9cf2c2703d326030849e08ae0429029359 5.842KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:6bacea6fb6ed5da48dd91600988cdf6b2b886ff20eeeddd4f5304338b6d8dd9b 5.843KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:7b298893e47789cfd914a56522ff368a5b16d3b0a42683ee6b320ab431b9c689 5.848KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:6c040a3e2dd8ae3be552330d0a99f3503ea19c89b3641e7cac7f65c111de0158 5.852KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:6674dd4e2c314d224ece110cd6103babb4269901180ff12759161ff9f8f2e71e 5.854KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:79fe418fc0f356846ac5730bf9e9b49d3d8bdc36d4e55c10d5aa98b85c8d638a 5.854KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:46da5b77611de81cabb3271fc994027231ea16ed20c9d606537173a65d364d23 5.859KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:bf703a1fc3e6648fc7bd4ac86d860ed2f032f0f468bab408ed898bc220c0b3a1 5.865KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:071317c10daf50c1ed7ca5bd5cb59220992aeedafc0bcc2bd5cd54891efde520 5.866KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:1a9b7eeb653a5da9b0d239f1a94ae842fd001210938ff28a48bcfc53744f8b2d 5.869KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:f44e1a988183b0e4335e8148fe551b2f839904fb790bfe93b8564c54e55b6c2c 5.878KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:7d6b9eb08a790335fe8a0e7324bf2fa4e473eef20d1da116117b4e104cbc8225 5.883KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:13bab3007eace396d7fa3f0c0cddd0e75d817bf1665fdc740435c20b7229cda9 5.884KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:053f8b89fe841d27adcf083495fe0213ef7e474232e4140b305450bb61489fb3 5.886KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:1962224a8b0127f2de9dc0455b7c45611a7b34025e397c1e896977a4d0ad1ce9 5.888KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:8f6d53ea05f935f54b89c05b89e95ccb714c16480eb2c52e0c8ce7ede14a8dc3 5.891KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:c33d13e56b41c869699ec36d6a2d3c32b7e71ec0106b619fd0fa8f36596d7eb7 5.892KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:aa936aa3d762c5bc04a96f0b7d53c23812e294670c84887976c116b7bdd3138a 5.893KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:4478cab2f84eb586d13213592148ac112192ce7f96cfa7f59a6d018bd6887c0b 5.896KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:edea173ce885d92455d27067b182935f7d8343b2c2e1ad773f9460030951b346 5.897KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:10a6b6291b588f3cca507b11d4e455089f74d4d7c9f3d457dc9cd435f44503cc 5.899KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:d1139f7ddb0cec8caea207fe31120d6c73fc3c27ae519c348465e2f35c42b837 5.9KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:22a5e29f587da5d9e5b980e2ca5b06bf7b42bfd2f99e4c646ed646da7e0c19b9 5.903KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:53c29bae524b09d45fa894db7c06809a9e399cc82b4bd82e970667028d224045 5.904KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:1226f01ac9eec7619039fd90126aed17774446a8bb3cae992d2afeee6438d0af 5.906KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:9c2dd8b09eb6d89edcaaa080e6c37874b6bbda5025de7c4e1a17bafb7343631b 5.906KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:a14be24b5e628174f4d794929a105b0fd402acf2cd0c32c74e2834bf46c78088 5.907KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:b845a93e461e57a1614c90d2cf38e605250f4291c2d246dea612757cc1cd4927 5.907KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:c50bc0a8e3eacaebf8af032a1e8a4c06a57ab2579d053398d911ce6a32527329 5.907KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:211b94eeea8d8cc0679f2d66b3ac76d069f251d90659bdbdde6b647dda008f12 5.916KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:ba9f1d271c6ca04631ff1235abacfda5d4e0835005f9838d51075de93b780b04 5.921KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:441e793655a073a6023672cf0dd5bfc04332587abcb5f17827c178259c4cebb7 5.922KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:4e46568cff7ef8216c9640d33da56b6c98089967b9cd8e60722f3406ae892fbb 5.922KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:4e73c196b4f632155282f86a88b5b4fc304f360f2eb405bd68228d6ab59779fc 5.922KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:fe289feaa6be93d34df3a03256bcccb91c19d0fb6c17e3fdd217fa8b89eb13bf 5.926KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:25d5052cc94e0ae351a1568755acf033cbf5e48e0e7002197a870a2c86714061 5.932KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:de195e3670ad1b3dd892d5a289aa83ce12122001faf02a56facb8fa4720ceaa3 5.934KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:aeee3c4eb8828bef375fa5f81bf524e84d12a0264c126b0f97703a3e5ebc06a8 5.935KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:9955af4a354330ab0c405e2a53e12cfa37b129ab696eec6a33a96a2efaa5624d 5.938KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:a0e918aaebe585451de6c3d14d616cb86a8fa19ae667be9f30d1fbb29f6dedb0 5.947KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:f086b35b977977f5d5cabebaad3563ee13bb141c2d385d19c6d6009918f27b3d 5.954KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:0eeb88f6550863b513706c6ffbc44341ad1dd5879bc8ecd2d366c631c8923b02 5.959KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:d816746f248e4c424cdfb2fffbd085d85132e8ca91ddfcbbb2ddb888ce263c5a 5.962KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:cff589aeea6987cc930d31ded12417f87c62b8fff496023e7513c21b5ebff432 5.964KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:fa0c3be3cf19f5891831c06ba9be772e3e18488e7718c24742305d15c43ad09b 5.964KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:db391ca63a6a19a33d66763220a60c79e92907257ff5632f4768192233cdfca1 5.965KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:473e85071ca923d2a435e67a8c95a125df132b6d16e45f23aaab5e06ea96a8fc 5.969KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:cc4192e60fe2089320f2d0b17bc00655d49b933844b8a37c555717805f267cb0 5.97KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:19e06022ac02bfe5e46336b3fe57351cbfcfdae1cc25774f0ddd3df6921b2446 5.975KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:3ff987e05050b419004d119fcb734e14d5363dc32f04ed07ac2757e005ba8635 5.977KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:f2ef2f43ce931f0b0ab31ac156587af9c381f6a24bc05b5e55304cef7b21eca7 5.977KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:3fcedfd64174f046042307d8d8a1ab7a3c03eff88201266f89745379745d60c3 5.98KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:c7dbf8655b94a464b0aa15734fbd887bec8cdda46bbb3580954bf36961b4ac78 5.981KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:706d67771a9ea2ca217a40f4e4ac0fa0642bfbba05a56c2eff94ebbf27ed2e11 5.982KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:e68a4ccb85c2d330932c5209ff5f1e0ed749657792da6fa8cedabfb45ac0a750 5.987KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:895678904b0d54ec8d615a6deb0944048027d2796a04be14002bbff9fce7a968 5.989KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:698c1931ae0c54607e4f7264d1fd6938fd04f12014cbf9a38a602bdd6703e8d6 5.994KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:6a1a937882578e83b4708d7417789a9ba3bb9078b093dd5140c348aef5b9e7fd 5.997KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:33b3f9e5d55b3c9648f5c7cb113c5e3776ff47cac3cc1664fc88f6cf75ee968f 6KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:924a3ba574a40aa064341280e9834d1064e20e384203095cc1032a27f2db22b6 6.001KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:3018b89e16da2893fde072a25fb8cae330bd52c7f2dda30551be00a4d253fa07 6.003KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:fe07435da7414ad67ce4911311ae3c07f0cc151d870de25ae799da882dee3be4 6.008KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:18773cf453ca68742cc743c9236573434675ad8e7e19bfd493922ee587ed3525 6.01KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:6547f345ad4c5243ea3a6462f7dd0a6a28890595b1b79a44e505d3f441df9caf 6.011KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:5e0f6ac95e34f389a90d1c1fe5d8eb566dc2dbd7454892fe6b41a5f4bea70a92 6.013KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:29154bc9ca2b0b585061c9c77a80aec37c2a5e791b3328ca9463174d065040e9 6.023KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:2a6c3a46617a8a2186903e532a70dac2d87c289ace5c6504a5c8a791a0a795a5 6.023KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:6b7a77494fbe9b8e6826f8cdd217c9061af5d32906501ea55331c75ad1c5fcce 6.03KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:1dad4868597baa05bb3f52aefbc4d8df36a8d99da1db408c6f572d998c77d2d1 6.032KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:786e8e76f808107a29ad6e5c6bb2bd5df89447e080eb01ed3dcdc881bdc8dbb7 6.035KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:318543180bc641023adcf38f03c5be3922429803a2cfffeb12a2ddf24f75c407 6.038KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:357fb7bbfd0411f52bd2cecfd1f50bda71f531b88840c8695e7e7ce729e85e9d 6.066KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:855e29af898ecf3afecfc4d03359e65aa6496b440f378a4096cb443fae15f07e 6.068KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:79199cc26e8210d9b44ef6196760958a05343cac9dfa6b14ac07530e72d2e3ef 6.071KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:84662f87c5dc488c63e488e72b4ed4c00bcb05aaa9b5fa13a0296745c5da4bde 6.073KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:9e48067c855d426e9b4d7a6e1b120873659647787cced515dd8ce364bd7bb9f5 6.086KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:02b271f022adff8af72f5871884279e41d16368a9e041c7e3ff1a310db9709c6 6.093KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:bee317c68f9c5a9719ff0365e3be56f8a0c50a8fd8643875f539589cf0c997b2 6.106KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:7d260cc673c0ea09957af6fbbb85f1ccf28eb4647a1ba93fb90f8e12c17992ea 6.107KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:a48fd51397307f4eba7062e918cd440cb16ce4d80c90ff6eb328678903001673 6.113KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:331ab433a14329dfe76bfc43e977f52b49344f8af76038d33860069ac097b134 6.127KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:8ccf944d71dc7302b4cad40d6c54a4a793c3421a6f56539a3cd91f5a48eb7e8b 6.128KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:81c1808554f407f731d50a17864efa503eaf515060802cb1dd852327b363ce19 6.146KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:e16c7489ad73e2a4124d0d7590f314c0e36bfeb25bdc6aabedae51bc3edd3729 6.146KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:def397f9e006d5f4c745efb9abacd4d71e3bd354c53d9697995c0cd5203ad7b2 6.147KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:ee5817d159500cb0bfa578637a1908201f6115a1f772d4b26b7257d1f6c029eb 6.148KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:ec55495023553da9edebd177201295449fb3f32fd4adeeeadbe1601143ce1a8d 6.171KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:f06f4f9a83819c754c73d35b3069d31336272737601380003f5c4348e3a80daa 6.188KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:e9f833475b35a2c3de55cbbcbf89a8a8a072d45d636f68ae8024da83ec5cec0a 6.215KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:9dcbbeaa59c5b424c5b9974c792e2e8ab1fd56e713982300eb78b47990d1f58c 6.216KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:6429b98c9995d6d52ad88f30ed4f6556df3492ea3eb85981596c75f3b9e10b08 6.231KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:118428ab3d93433da0a814e7267ce28c009041632850fe2a13e29931106d48db 6.233KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:69864e18118f2d24875951e17c078f21a402deeebb12d62eab9c3e49646e27b6 6.242KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:cc16477f88f706c830a136a275d274b60331858d22a63b49f68b682ef83cf364 6.286KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:5777058f34d33ac28a18d33e0192143ba194d71dea8c42bd1cb6d4b596ad849b 6.322KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:8c251a078360df29a2f81a1b603b1455a4df391660b714c279049cf29938858d 6.349KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:cfaab7fea8e69cefb426012174a915cbe64588ce89fc6291a44cd024bc0c2f66 6.438KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:7800ae09180ffd263ece4f807229e55d5e98f102af2846b30d488cdf82ed0441 6.495KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:ee5292ff23296bb367e37e87e2611edc0b4eb972253f19527af043c0eb9e9c47 6.532KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:b32abb13f6deabe80a42baa510ab9a1ec6a5e2425da1e65807289b593e779f9b 6.568KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:1c3065ee7e568e96dd7b2aebd841e6f2ed26732145224dda28d97cca6083a997 6.586KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:6c425964d4a7a2dd3a4f91b99e6f5d900688db6054dff8fb144cb1ef7393f11e 6.59KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:3535a83950452abac8bee5c3c0b94ae75beb28de3c3df1b30e9ec39f6e95d3b0 6.603KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:6dc28ef69baace6a9656b208c0dc578fa8d42706bca2ed4b03c183f4edfea106 6.665KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:7cd4db3fd9614716bcda41c0fc7be63261d7c2b6194d9baaa589e715d1b610f7 6.715KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:2732cd58d19ff317c7169e1473c7339ba692d94bf00a7b37f4c756a93c373b79 6.719KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:50e73a9203f01b4e3c60abe29d4644f7fd190a0890712fdb4e4320fc199cff7c 6.941KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:a7ac59c81a070c974d93784c15edad684fab7d16ae828748c92813bf753804d7 7.359KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:5d149b021a272cd59d6e874fe08e977afb207a82fd953a86db2c538287103ff6 7.44KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:85cc9df2faa5a2c0b17e0d33c210e86e0992c794847f555d794ab27ffacc3848 11.65KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:73c7d3ebde4f810bc281b01868d714128aabe2d417da6c37c114ef8502e196c2 374.5KiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:695b973747ed33954b33cdf3e56293a749f13204d95f357781fb770f4e7c43cd 1.776MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:74b661d230b84d8fa9cd5942e80bd672c2533df63baabc6f858d82768b315bd2 2.716MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:bcf10f2c6fd1fae6acdb86e0b0fed3c400c53358f110ee76968d5aaa5020a7c9 3.436MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:535d6736ead26052d779c87aae04cbe93be06ec9341d993658dfce92b565ea74 4.802MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:782031e9eccd0aa39bad4ba77c8779781d50ff221f999a267dd4664790c8dd32 4.964MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:f2408871587c55e88feaf165eed5bd3252b031da35e74b0dfa0d0e14f80ae905 5.293MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:121dfb1fa8daa5b9ecaf1b93e0119896694f546ec6aa65e10265f30e14d5d851 6.016MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:78d484c0b6c1b950f313723f34c655ba7b081815f9533749362c2aab6e66a079 6.804MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:03aaf3d7c1f692cced5606d6c006d5023a91d4101a0cac09494af666b13f3b5d 7.519MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:1595672a20336984a40f1e7963be32d7b566f9136c46143c7d064a22d134da18 7.767MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:8fbf062ee1651e21baa138b5f685cb0200c8cc38f39434486540528b6a751f3c 8.436MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:595ab5cfb298be0f7f45088cc19582385b0da390f3a5ca984e889e01b87da28f 8.705MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:beaebbebb2eb4746017572e13b096e0a2632e2f92a1035009dc1e7c6bde7b4b6 8.919MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:64686b926ff50b93d191e933334f4d2f23e7ec18d4b548e34b36ee044ae0af26 9.381MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:c5bc616ce43aeaff92646ce378cb15dc26e9d26d7b2577fa22fc4cae7bc90b9e 9.534MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:38801d26e88e7f7b8ef47729624c003d1c0ff2520cb98b1599c18685c8b0c643 10.66MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:f22296b5d706abde5b8b4078728bba0786d6d922aeedcbbddeffc11c79a32eba 11.25MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:3d90785b887dfc02c0b8e1e988e8b0d125508815c210372c036b13f98392adab 11.39MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:f18172f4d4b0a55336a256b2b0ee217f1beab352056c7cb3969be2ece7704325 11.85MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:7c6a209786a2fcf2f1953d27fe91553eaa166379eb5528d4c43dfe3f11101792 12.45MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:1550de8e775b759e09744f681d3e6c2e23b47b071345e59bafee133679f0538e 13.01MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:673eca089f36f23cb4b1dc6ddea26810dbb6dcc30e2856e11ceb5ed9f3c4fbb7 13.43MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:8b77c61e6f0803ebda8c5a655bc5027358e399139374df5a01ccb115d5c9e1de 14.19MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:bf60c0a6f9525f3b8f4cc4e38218ea289dd7311f4d95c9241f3545bd4e704faa 14.23MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:3be1e419f353d0611aa7948c1b7fea97aecf07f4a7c51496bed05de915f59a36 14.41MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:207f403b15d54e4f1ea9c5ae187c222eb53b43cc706b1e88bd2eb845a9e75b0d 14.61MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:0dbf45ca5c35b358c0026ff72a03ca196ed22f530fc5b3fd38c33e78097079f7 16.12MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:0ca5017ad7b2f3aeef83be17afd9ef77d6b5c1abbeebfc1ddc9a5371cb14b407 16.6MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:3fac5e5a79dfd5710c73f4c301601b0ab72abb2185ea4be5b220ba7b0c5e6431 16.7MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:af5484ecc7d6e9fa5e4d196deb7a5ac61904406ed9d591806676304229dbebb5 17.16MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:b23512dc1056f62ffabe54bbedc7002916f8de03c5fb19be3494cf717f8e6ee2 17.43MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:a73eda22a3e91974b5bad2950d56ad9ae358e79a7884073a764452a2e139db84 17.48MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:37e83547355ff2a4594e27b23c47718695e5a7ad7790d25fb25c914ab656f6f9 17.98MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:e56d63f5a9448bf0d40064fcdab90d62e3ca1962e3eda6342a24ce48c5d2af28 18.15MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:4908099c9a642f00faff4d9068c1a948c98d6a35d8d9de44797c069d0b43f8ab 18.18MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:fc85be720c1f4cc1c477cc40d27e7ac916bb4b942a1d4af6d0bf08518c52b2d0 18.26MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:ad24c6921da039e4851ec2ab4910b58c3e1d5957fd37c2eac319d33e54fe7893 18.75MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:0fde0b31c9aefdbbd77271c07b4797cba3d987b04d1158821197bd3c5d88d93b 19.74MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:b5d44ab7d47f3401b97c0c69d628675b0ab6c2de0c08c4182d203f471528039b 19.79MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:5de8d37c8ca14306d6c9b47b3fea0ab1f3e2f5b2213a9e4c9227e6082722f11b 20MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:7002d57d5d20819e9fe70ef717089f4635d63eb63c3d72a51ca6a692af437211 20.19MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:897bc4019efd9740225d74cc081b1ed55491212605a5777bb8265ce6444c6593 20.99MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:4212b4f2843445c5db775b98761572a9b70023c336df8629bbdf50e090e704fd 21.23MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:36b17c918365d487474f6f0509ab05ef904918c97f9ba38b78559c9440c85bdc 21.24MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:b49020a0a5ce20b9fcdbf5de9ab029f55859bc911b01e2e5078cdfad20bac86c 21.35MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:0a5ad326c1844fcc5c941dd41141bf8fac2206f925f0b5d5cc93359e7eb42c6a 22.19MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:f99847c4e73195a93dabc647205d3af1bf9443d87688e9bb37952d39ff216c32 22.69MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:4d7f49fc64fb16803ac47d6e13844282a9fe21cceb723cbe25b96aa54edc8a67 22.83MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:019da7a93f841246533103cfaa0141bc265a8101469996288c8c7bb68586e8e9 23.77MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:5451e2aca8aa21ef551e8eaa09038b962db6bb4608f4eb22531e1f657eb08726 23.89MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:fa3306a8091f5d4a7d1d968de185e54943739ed796a7dccaf43347617502bf6e 24.32MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:d80029e58a7ed07c3f87faf7a3945d37efa3a33a35e23a57758934c2842f259b 24.37MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:bfda8c8b70618cfbab3730e77a4b19fb0bdf7e26803dd580d579423823a0b80b 24.91MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:47de5b5fcbdc385505105a6bbf5a982d3e63899839b33bb688cdab7104e558aa 25.04MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:c592e5db2954e1eb5752109c1ac8006502e98cd4e3c46b6ee3a9c6f33b5f1b75 25.13MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:4eb3e139d667c985732b5fec4a3ef992d58dd011304eda499f9614c4e3b3aeff 25.49MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:80c62a021c80aa24974ab52bce7dad295cc4f12431cbe5248eba3a143ee9f6c6 25.66MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:12c7ce4637ee091ba33c3f899a17ac991605aa62338522c8fb1bbb43a3f4dc43 26.04MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:c56fba84085f6ff95e8cab42627553d519f9b9722aab9f74048eb15bb26baff3 26.91MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:320d5f332fe9062f2ee28fae5b4cf2528cc3916495096c8f125a2ee4d350dc45 27.05MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:6420713e41f05494b5b2eff4ca63974d38ae01392cebfd6f999f5f1ae15d60a6 28.18MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:9c2684600d037917b745fdfeef5ca84df0fd6708b7640b52acf647fc136fb2ed 28.35MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:b722b731778ec86eda51efc43cc216f811db4e04045e3e3f2d387c7a2ccd1c23 28.35MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:98f0c8976838ffc28ada4755a2e3097b8a91971894140b5b1d59bfa6777be0ad 28.6MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:65380e2d0fdf7702f0ca7abc2b7dc265be413d580e97e5b08a1f31caffbcc158 28.6MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:d3444bfdca6c6c2a4e02c8ca151c9673d316dafdf4332d0e484a1890a639683e 28.62MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:0954d0adf2997f692626c9e139486173af7d7dc049cacf31ec10d5814d07fd3f 28.62MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:364c3fcc9f7cd8af2ad3e55151663ef51f507fc64528a6e67f27b9753f3d5017 28.65MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:c0427315d411458a595082f26c9c17d34c2a4c55fd35771434f3132c49817ef0 28.66MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:2af47eb93c78e736f6f31abc2334d6655f7441c24fa1655b552ad5355bf41676 28.69MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:d78f4e1abbd0cfff30bb2fe6b52b220494af078c8e0a61f4b12f49e2e2b8104d 28.7MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:51545d835b5222d4d7eaf8b17da27dd6ae8bc40756690ae07783ef6287b2b141 28.74MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:e6b1ebb70d7a7e5986f2d449b75f9fd5bf0ef04eba94ae472f39e5c60b92c76f 28.78MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:13ec0d1ae78fec359d099736e153b682392b363fd41951f31bc577efef0bc9a0 28.84MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:52273224825d821f57cb5b0a3868e65154cc2208f7b86bf27333700d8099c490 29MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:742d5f921fe7420c0e16a8ebc024ad0607629daa604a6acd942bd850759faf55 29.1MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:33581368c68905c53deee57b6405465491c2ed59aa014b65d2e4ac189cdb43c0 29.21MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:e6375460dac1376d7dba0fc6e7e59716ea7b7a3a9e3878fea5a96823fa45a68d 29.5MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:b93261120650db265a8920fbc17714f5de7172d66d7d88256e6b108eb7179755 30.1MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:2287666894d7fb727a612cdabd8fce2a90527f12d580f60100fc108891cec568 30.11MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:9339563c0d67683effd1547583062527d068cc25d9c279c2df060a3c3a35749d 30.37MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:d0dcfd8322dec586df6807aea609fc3b8b38096bd5bac482de84e3d1c69bc89c 30.74MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:c62c4995c299243b6faa067179c4796de191aa919e0a23be41cd0a236a57210d 30.84MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:fff0331806b6cc7ef9abb338c0af1d970bdcc68687d79d6d503e595c440390e4 32.22MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:f3231de729756d933e5e085f8f10e15c9636b879b3e6f66fa592b0006ace33e6 32.36MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:815605104e7b31dc24d4bc067bba756fd130837a26564c17890b4c3a982eea0a 32.56MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:9b734350a7da06c98d779e26637855428288107574aa0f8e8133c5b34b005793 33.83MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:10d44c968390b86bbf42fb1919462e13c3df4d17b719ee8fdfee12d6f925dc9a 35.24MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:bf9ba89109baeb6280e79602027b4ee1c462ffc18fd1cd3932f73acab39eb5ab 37.29MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:faed83ea7cc1780bec587bd99306f6663556d7d6c29ebd9e1d86e4331f61d339 37.69MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:8618f66bd9bb679cc40967db98a424233431dbfc6d28131eebfea38dbf422489 38.34MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:8dc98fe5c6ce963832fb8dbc55597eac96e9d78986b85b6d55d290b2625ac2a7 38.45MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:4b85eebe5857ea056b9ae217947ae9cc4727cd5083acc5abd609a9c0966465be 40.07MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:9f396eada395398547d5651687177a4857e2d77fe8735219a7960890af5062f9 40.18MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:ef1ba58ae74ffa0a99838fe4037ed29dee4d74dc15ea75772a61b7071df75a4e 41.1MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:734bf6aa5d59da0a4e10ac77f6154f814cf1b24990ac2821ab6640aab78c88ec 41.98MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:11cacec21d18eeb84bea40be10e3193cbb9f788d5737285e3a9ce3ec13b3d4e6 44.54MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:fd3001e9bdbb6a9f45dcf0004be73fe4adc538a6b0d8434a966a32752d8836a3 45.3MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:b649d8772186a14880115144a6ceccf6ad4db62ae44aca11b19dd77d679208c9 45.67MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:7cf5ad0714ab240a9bdad9fb25ecae95cd255c1fa44c7f90cb52935dfc9ab3fa 49.09MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:050c9bac154f73bd936655011774771cc2488fca95d00fff58c8c2379ff4a73c 50.28MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:b0941af135a6544ec89748cfdf38240050fbbc911662d8594854e10f1df77fef 51.45MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:5b955a8ec0b15ae10d3d68094987820ff719caf164eede01cfc045f3e15db779 55.47MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:cc0e27de62c0823bdef0c381a09704f57753c70edb06685b4cad0898d71af25f 59.36MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:13c9b013e7e01618b449af050391c15167015dc8a10c4f703630f88314106599 61.99MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:296e14ee24149e14d573a1fbf5b5a625c7bb0cc22f5b2a8b180e833258187948 79.5MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:5aa281259a39428fdff9e912a28d81e347b1a5a73e2e644595344e3a2693e383 80.58MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:e717095b574df978046946c48316857dced2cc1757021203da3f8a1217173ad4 82.24MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:8a3cdefbe9ffe3d43e46ee5951aced025a9e4462c86c1d569ae2e667caccbc03 83.91MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:26e26281614325af20bb2525fde52117decdcfe0ea37db03545c24fcb3b89a4c 85.63MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:012b48dc232cbc1be08069f3cbb3765788d7a142c2d2ad13f126405a10728a5e 86.39MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:3c7c7c14c0a390e37185463752714ca83f5f3d490c13c0e1557398e2adff5a5e 86.58MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:a9072b432b768e098b9904df4f2b9ea334aa79a69bce284382da97108b549760 92.43MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:71119c0cd690a7c36de046d789a9f9be665709903212d73fa86cfb2021033672 94.22MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:64d90ff5b86ce3353d277eca3309c2bab5c8c17e146a6c7346433d5c4b6cdfcc 98.28MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:15b4efe80da722eb2c918a7c202b6f2bcfbd034b54134654f9010e8c9f96cd46 103.6MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:a29d582c9ea353c5d5a2aeefc1100b023a95185a805136b45056bb74a730bd02 104MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:645e062cfb2bb1821b607f8e73e769ac8dc14b4ba99fa1eb5c21c439e3d0631e 105.5MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:083b02cec36f3ce64bdf2b0e9cc9900d74ffe2443f9830b699be026433a41787 107.8MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:0a2b348e561788da66bc3d6ae4a36b89c50931d1820073d2da5339ac9ab1b644 110MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:b17182efab64269e552efaf9b6939a101c0a38b52b2fcd1df629150017369c59 118.1MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:23a392681fad9df4ec014ea529b792d614c3657278f4654bc8892ef290beb710 119.6MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:8751b93827ee933aae18ab2e023a02d677407831a5662db8e4b3a90797941df9 119.9MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:16618fe3d988eb286935800a46811b1c9a3be5571b3bb7e1992735648b829858 123.8MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:8ce503a1fda842bbf5bf324307ad9280e69e5fd7538e009a583344a044a8a8d1 132.1MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:f7d423da485944e0e9babc8d973fc85c98148f80ebdd262f673d4525590d7f4d 150.4MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:9b7509f3ddaf32596021552cec965efad9eadd2054dfdc8b24ba4b1109873c1a 151.8MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:cef9a8b7b7b36022df6ec9a1125c8856746674be0fa9091fa17819f7e7c00695 232.3MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:416d518f4ec9c11231187dd50df5bcbc6a118fc90011c537ae07d01585674156 252MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:0f5118ab96ad7da9303d16e8c99d94670f15bbe65a6990ddca36d3bf42281996 309MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:c4064ac99837e48971b6572b0bac402d7c686c2fa394920d4a19826c7f1c69b3 314.9MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:dfbc1f8d9999b035567aaaed72329f4daacc786cc0eb361f7f6c2fc75913da3f 419.3MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:5ff0f5a23544352bd8bcc05bb83c8e595fd090098c8dd3105c6a284f4ec99b15 431.8MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:87544fc65baf51135fe3f2e0ca3da767290d3385f3cd6c6e25638d8f9f56f78c 433MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:c79f7c73d5d67f643c45c2372084c000ffeb1df0b15726ebf5a877267d293eab 435.8MiB
      quay.io/openshift-release-dev/ocp-v4.0-art-dev sha256:193fd52e3f7b7a13c7b3ea8e3fc7fd0cd8f54b19d836e0c38c540d6aec07dfaf 1.04GiB
    manifests:
      sha256:01a6999c135a6f673593aa58b47192b91724b7f4dd7c27d2c96d3775a7e59302 -> 4.8.12-x86_64-csi-driver-nfs
      sha256:0232699d0f100d7e2e1e8f9e18e1760477fb62081382dac6fb8183a16ac28f76 -> 4.8.12-x86_64-cluster-kube-scheduler-operator
      sha256:03308edf0505b338901453121032897fb4de56c73c3eed0ffc437baccbdbae51 -> 4.8.12-x86_64-jenkins-agent-nodejs
      sha256:03dc4dd87f6e52ad54718f31de9edfc763ce5a001d5bdff6c95fe85275fb64de -> 4.8.12-x86_64-ovn-kubernetes
      sha256:04b6d47c7f1691425784c4bafa20be1ab2dc650ab4b849f9b771cffc9059d410 -> 4.8.12-x86_64-openstack-cinder-csi-driver
      sha256:0773e6f33cb2bcd27a5a49f368c1636c9fbb4e94bc4d5fcd4b8e871dca879665 -> 4.8.12-x86_64-service-ca-operator
      sha256:07797bd0a1a7f87cabc38783053bfbd2572cc2ed7bb6956e755d22b61b313f27 -> 4.8.12-x86_64-network-tools
      sha256:0f29a46e7addf4320f071896762c10d787693c71354c67081167d26cfb52249c -> 4.8.12-x86_64-cluster-version-operator
      sha256:0f8928732f2e0808912b89be143081b69e2e4115b8d374f90115e9c316a9cc53 -> 4.8.12-x86_64-libvirt-machine-controllers
      sha256:125c9397c6555aaeaf6b34aad34fcc292d37ded418f758319f6ebb7f256d1de4 -> 4.8.12-x86_64-tools
      sha256:17224684395f36958dd2bed949a32b1de9b4fae77e093c4c8e9e8b2d90f52a9e -> 4.8.12-x86_64-csi-snapshot-validation-webhook
      sha256:19b8b49b291604d63d0cfe049057c88a23e3666bdcf5d3b0a28a27ed169a0cfd -> 4.8.12-x86_64-thanos
      sha256:1fc824854c9b38b93629b518a560dd402d90adab94c9bc05eb3bb3a873657f94 -> 4.8.12-x86_64-kube-storage-version-migrator
      sha256:1fec937521df496277f7f934c079ebf48baccd8f76a5bfcc793e7c441976e6b5 -> 4.8.12-x86_64-multus-cni
      sha256:22da737e5783cc6d3451de3cdf2c6f67ab952d512010514242e5609196d34771 -> 4.8.12-x86_64-cluster-config-operator
      sha256:2323c6a39b099ef025a288c26dff2a8a123a3d631703ec3cc50fc455d37045a1 -> 4.8.12-x86_64-csi-livenessprobe
      sha256:272d2259952b888e4a1c3777a5d8a5a7d5d5f102b6eb80085fc7e139a79ee151 -> 4.8.12-x86_64-container-networking-plugins
      sha256:2ce3388269a3d82e9735601d37f9368f0de982c94288e69a9f4e627b3cc0d8ac -> 4.8.12-x86_64-vsphere-csi-driver
      sha256:2eb2cfcb3dc91dc5ce23830098197f84f2f2e5f16c8f8c04e5e9c4c19c9bf6c2 -> 4.8.12-x86_64-prometheus-config-reloader
      sha256:2f01cbc10e811d4f7d51e15382a2f5e2cac19c0547298d3f386649c7701bca97 -> 4.8.12-x86_64-deployer
      sha256:3011b730cd6732536ce7e6668782379471a582af674a718c2fd253681a83a1fa -> 4.8.12-x86_64-mdns-publisher
      sha256:304bcd8b9ed5429c532a5a626f6fc6a3414794539b800efdb86d7fbe548fb122 -> 4.8.12-x86_64-prometheus-alertmanager
      sha256:368b58074f706ceb0613198e2f89d2be793a830afce049c1f248e9e88c31cc88 -> 4.8.12-x86_64-vsphere-csi-driver-syncer
      sha256:3724ad2a530dc2b2b41b90fe0b22d3c2f7aec3f5e7beb0d7d2c08ba37154620d -> 4.8.12-x86_64-multus-networkpolicy
      sha256:375accf00738738a4015918e76f7d1fae0cfce5bed8db76d877a856ff376f592 -> 4.8.12-x86_64-jenkins
      sha256:388b19df5c9633fdd9eba6cbca732789575f28c52d0f336a1ee30f6b1c0460a8 -> 4.8.12-x86_64-aws-ebs-csi-driver-operator
      sha256:3f7e9a414f3240d757cedd57e9b0aa6efc120d42a0c664551d3351c5e2e08d3b -> 4.8.12-x86_64-oauth-apiserver
      sha256:45ae205bc2481746a93c09aea4cf2dcb30673cb7caf0a9014da0cc6cb515f0ba -> 4.8.12-x86_64-network-metrics-daemon
      sha256:4774774181cbb6f21e864edfe431d3b4db4cbca8dfdb294ea3399d4c646a2a43 -> 4.8.12-x86_64-grafana
      sha256:49e09fbb038d7189ed74ccdb5f8864f3de9a2495f3cad73fa4d393b5cd252c98 -> 4.8.12-x86_64-machine-config-operator
      sha256:4b11f909dbc6b3c706d2c5a29eadd44c7b0da362381bc58c490076f389ec035f -> 4.8.12-x86_64-vsphere-csi-driver-operator
      sha256:4d21d50136a3e4fb0c117866ea347812cb65def93a2f328b7e9089ae4067f601 -> 4.8.12-x86_64-installer
      sha256:5614c4f278566db1802436c24b61bb736c0a28b8edb4c5cf466e780e1c4a03c8 -> 4.8.12-x86_64-aws-machine-controllers
      sha256:5b085b45359fa4425a34beaf9885a98069279ff2ffc7fb06936d3512b9830855 -> 4.8.12-x86_64-oauth-server
      sha256:5c87355e99730f74204a07ccb985f8587d92c4c26d63598fee1fb2c2beec2b57 -> 4.8.12-x86_64-ironic-hardware-inventory-recorder
      sha256:622d9bb3fe4e540054f54ec260a7e3e4f16892260658dbe32ee4750c27a94158 -> 4.8.12-x86_64-etcd
      sha256:63bb64b835021efb40ee5ef2b68a80ff0cbd1c8d2484bde0ca68660a14284c47 -> 4.8.12-x86_64-openstack-cinder-csi-driver-operator
      sha256:64587c4a4c72ee88cdd9549b13f27052a4f819b6954cf7dcf73614475118fc4e -> 4.8.12-x86_64-multus-route-override-cni
      sha256:665cf10f337ef00b17f58b36a8cc2c0129f9c0e93241e4d8866ef8ac55c58f24 -> 4.8.12-x86_64-cluster-authentication-operator
      sha256:66fa2d7a5b2be88b76b5a8fa6f330bc64b57ce0fa9b8ea29e96a4c77df90f7cd -> 4.8.12-x86_64-cluster-kube-apiserver-operator
      sha256:6700c31c913ee08c376400900269c7768b289a6a04c12fd734a6552419f14890 -> 4.8.12-x86_64-baremetal-operator
      sha256:680c8ad5468b7888732168f8aee525afe91f9057e3a32e3254ea96a4b1868a6b -> 4.8.12-x86_64-coredns
      sha256:68f95ced4b75fb6fb3f1abc241b2c05652bae8ba84f10a0ae1c7a209ec223a2c -> 4.8.12-x86_64-machine-os-content
      sha256:69ed52a54af7f30205a8d2e4d7f1906ab19328f34a8a0ed7253ff39aeed6c20a -> 4.8.12-x86_64-baremetal-installer
      sha256:6e7553eb98d936a50e40c5163b6b77f1cc48a411aa76fdde6be6e8bb90d3635c -> 4.8.12-x86_64-baremetal-runtimecfg
      sha256:6ead7ac9e80d73c20afdc6d26a436bbd2570d190259cce6e2d6dd6a8a7ab8a86 -> 4.8.12-x86_64-ovirt-machine-controllers
      sha256:70ffc0ed147222ab1bea6207af5415f11450c86a9de2979285ba1324f6e904c2 -> 4.8.12-x86_64-cluster-network-operator
      sha256:7165e684e6334d4146cf36c5edfdbad44f9530b315cdb601613a736dc59b19d5 -> 4.8.12-x86_64-openstack-machine-controllers
      sha256:7272db7e73a126c7adf4bb7a69edc21fdc7b9c6f3607f1fb6c0f8e03685b8882 -> 4.8.12-x86_64-openshift-state-metrics
      sha256:736f0f5744455e94fbcd220c347dba50d4de6c03ee104189ba54ccc43b654136 -> 4.8.12-x86_64-console
      sha256:74033e9a8ecab44316478a907126b9b7ef50729e799291fa082c70d43e9f2aa0 -> 4.8.12-x86_64-ironic
      sha256:75e440cb63e29b1fb4ca6497519f9a0f110954f8cac2d5c4d1c0a36cee225cbb -> 4.8.12-x86_64-cluster-autoscaler-operator
      sha256:761c22906a24a17400567ae91bb04296c198d5c4718f6ee05636230545ebe192 -> 4.8.12-x86_64-cluster-dns-operator
      sha256:79b3bf61bf5afa0280ff40778604e921db91f85b7903f175ddbd9255f9d63594 -> 4.8.12-x86_64-sdn
      sha256:7ab6d02fdf89c09a8dc6c69a94a8dc47c978f9f43c3f23b772a47aa442ba3aab -> 4.8.12-x86_64-gcp-machine-controllers
      sha256:7b7edfdb1dd3510c1a8d74144ae89fbe61a28f519781088ead1cb5e560158657 -> 4.8.12-x86_64-kube-rbac-proxy
      sha256:7cd63f172d374925543894328c4ca679bdb1d7fc93f232ca5afd377c4bf1898e -> 4.8.12-x86_64-docker-registry
      sha256:7dc53eee9be2e98780366886193b11d777a69b060520d3f29eabcbfa4f21be9f -> 4.8.12-x86_64-azure-disk-csi-driver
      sha256:7e7de4d2bcf209fdc260953051183b9fe091fc0bb1f49579b62a9e7c5a0dde08 -> 4.8.12-x86_64-cluster-storage-operator
      sha256:7f32736ded0b2c6f909d6b42d0fdf573248037e21188373160bfa1456f7bf045 -> 4.8.12-x86_64-cluster-autoscaler
      sha256:80d0fcaf10fd289e31383062293cadb91ca6f7852a82f864c088679905f67859 -> 4.8.12-x86_64-cluster-policy-controller
      sha256:81ca517d87104dcc4be3fa201e4ec60c34102e0a92ae582e52fa687796f74d22 -> 4.8.12-x86_64-csi-snapshot-controller
      sha256:840b01a11d4d8e53830abee2ff761669031212f96d134d971989e60633385ece -> 4.8.12-x86_64-vsphere-problem-detector
      sha256:86bcb22c994bddfc23b37ac7f12b851b1fb67a8ed7df0f07e87e8be6dbff04ad -> 4.8.12-x86_64-cluster-update-keys
      sha256:910bda573b8def997c263d08d256a7704800b5878399934b356d0dc3b47561f9 -> 4.8.12-x86_64-cluster-samples-operator
      sha256:92fed33f66b728216958e475fc5c4892426209470006d030c58e88f3bcc992ae -> 4.8.12-x86_64-ironic-ipa-downloader
      sha256:93c3c234d6398802fd46296580b9d2449c3523c98e351d79d1f2ba7a89899370 -> 4.8.12-x86_64-ovirt-csi-driver
      sha256:94fd4c40102bb4eacfec63267a4507a8c38c7a3925705494ff52d099c0d1df5f -> 4.8.12-x86_64-oauth-proxy
      sha256:95b0422c5b7d4499cbe0c81544345ae7c5e703427eba0f4c91dd59434ca56f83 -> 4.8.12-x86_64-egress-router-cni
      sha256:95b74af46670bf15dd7e399691cd8e688197c668038f3e9588cc7417150381db -> 4.8.12-x86_64-cluster-openshift-apiserver-operator
      sha256:990ee41f317dd67750d2539a8aab5be330aa327552fe14afddd267033048f427 -> 4.8.12-x86_64-cluster-kube-storage-version-migrator-operator
      sha256:9912ce5effe1b73d2844c4899054d957631cda8889493f28ef6dd6f9b6683d19 -> 4.8.12-x86_64-prometheus-operator
      sha256:995ca0b9f00a3b9395dc3e4f25ad07560fc62c7fc7830af1b52894546cc8f778 -> 4.8.12-x86_64-prom-label-proxy
      sha256:99d4f55d6eabcc84cd1b6704f4cea7146c944e2495d91fb38e244424792ff970 -> 4.8.12-x86_64-operator-registry
      sha256:9d3689cf1fe7f4079fda0ab97f350ceaf074244c8ff85389fc61bf68991a0fb1 -> 4.8.12-x86_64-cli
      sha256:9f3fc6eb24713fe12015d7918d8d8b4aac5a5d786840411c6cf9f2f2a376c1be -> 4.8.12-x86_64-openshift-apiserver
      sha256:a1ada2b6ed3e3f16c603f68b10a75b5939cac285df35cd40939c70cdd5398e86 -> 4.8.12-x86_64-gcp-pd-csi-driver-operator
      sha256:a1e91c80d94e6fae1e012fab6f7a900e0ca2c9a733b602fbd519b3b3aed93304 -> 4.8.12-x86_64-azure-machine-controllers
      sha256:a34d35d308a939473276db8fc2aa70c2059256f6dbd532e4e687561a313621ae -> 4.8.12-x86_64-cluster-etcd-operator
      sha256:a3564602dcc7db9bff70848673a191aad8bf2635a14f350926d329a06344f17d -> 4.8.12-x86_64-insights-operator
      sha256:a3d8f145fc7dee99e80603bebc17d9190887a440dfbb397124c435f24afeb806 -> 4.8.12-x86_64-csi-driver-manila
      sha256:a4b4fb54744931415da610347eeaeb4f3c9492ff0e0114f0198bd7221df09034 -> 4.8.12-x86_64-ironic-machine-os-downloader
      sha256:a544af7ed353c5df13a66f12790ea7e920accaccac142925e0878e3340ce2110 -> 4.8.12-x86_64-aws-ebs-csi-driver
      sha256:a78317ddf28e9a002c4eae1e78da78f02f1568bec427f828b1748348d4c23d2e -> 4.8.12-x86_64-kube-proxy
      sha256:ad1c816b900f133f94afa1da76ea53bd9fb5fa57c99fd397112232e3bf4bc9c2 -> 4.8.12-x86_64-cluster-image-registry-operator
      sha256:ade9fd2997dc3acb3c9baf22aa29a03f5960d61c75b624b288c245d6652baabb -> 4.8.12-x86_64-aws-pod-identity-webhook
      sha256:b050d3b9b1351a96ec32c6d9aa8901589a79054c4e4ed541abac09af381afb2d -> 4.8.12-x86_64-cluster-machine-approver
      sha256:b46882372a55697fe8e4c24e42a8b3a64c5793e52a24ce80845a6a0b2645ab48 -> 4.8.12-x86_64-kuryr-cni
      sha256:b8f32a7049b38936ba7811feb78e2df9932885c84a3635537f6b37fc19f3000d -> 4.8.12-x86_64-openshift-controller-manager
      sha256:bac8f2ca677d73f8f11e8dd1e0cccfb3fbc24fe5feea953de5c73e342ac46d22 -> 4.8.12-x86_64-csi-external-provisioner
      sha256:bb5c296b4a6125f475906f457cdf2ffd35d3d70d333073a7735c2dfb29225d6d -> 4.8.12-x86_64-driver-toolkit
      sha256:bbbc1f4ede57cc2ef1b728d0f5da22da4660660bbaeedc38756f66d2c50f91f9 -> 4.8.12-x86_64-baremetal-machine-controllers
      sha256:bcee3fc7e08740ae4f62a25470ef27ab58a915ad2c122fd199e58792068e8c45 -> 4.8.12-x86_64-cluster-openshift-controller-manager-operator
      sha256:beedfd2ac53e25eb38a69a93b186bc962c31377d1c8ad671b83ee7b548ee678a -> 4.8.12-x86_64-ovirt-csi-driver-operator
      sha256:c17581091fe49d1c9c136b6c303951cfa9ca20b2d130f9cc6c4403603d4038a5 -> 4.8.12-x86_64-haproxy-router
      sha256:c3af995af7ee85e88c43c943e0a64c7066d90e77fafdabc7b22a095e4ea3c25a -> 4.8.12-x86_64
      sha256:c3efec55fe9de11734c9bb7d0ab6946aebc3c5e17ab12bd6728f0e7d72b18db5 -> 4.8.12-x86_64-multus-admission-controller
      sha256:c5167925646fe59f499ed1f33aaec96aeaec8aae2f58028b0bb197d084d6e9e6 -> 4.8.12-x86_64-machine-api-operator
      sha256:c66752a386f99edef8a209cd92afa7cff7d4829f93e5b1575c770ebc8d3d83fc -> 4.8.12-x86_64-operator-marketplace
      sha256:c9789da019b7c796b42e0df1a4119a2e44083916b2dff6773a02e16e6ec5c73f -> 4.8.12-x86_64-azure-disk-csi-driver-operator
      sha256:cb06daffca709eeb4c41e4b8678dda8bfa3822604a2108aa2add9dc6cce9e368 -> 4.8.12-x86_64-cluster-bootstrap
      sha256:cb25169a9c9e9d03ae15a47c302edc80864bb80ae946a8ccfaf7af0af9d9dea1 -> 4.8.12-x86_64-installer-artifacts
      sha256:cc10efb518418f8786e4feea7d4769cbed6bb18875b7dc27f5048c704717d8eb -> 4.8.12-x86_64-cluster-node-tuning-operator
      sha256:cd17c1c32271aecb21d2e9e667460a0589ec8028bff508e647160e7000f92fc9 -> 4.8.12-x86_64-csi-node-driver-registrar
      sha256:ce2d821de20f8bcf644da617cca04a552392716298433992439b5dd1c3301bac -> 4.8.12-x86_64-kuryr-controller
      sha256:d029cbfd3741dad3d383f32dd83decc156ab37f494acd7fee633dc13f7830afe -> 4.8.12-x86_64-cluster-monitoring-operator
      sha256:d0955ecbc19c87f99852178c85573b8eb9bb87f662c5397889283c1e7531ea1f -> 4.8.12-x86_64-telemeter
      sha256:d0bc2f38c925c8473f2c3ad0d95b623f53248f66df24f62377cbc6e109fa3e6a -> 4.8.12-x86_64-ironic-inspector
      sha256:d2c141b248c8c56f1f1c0d98c7b89982266010fda9f3ecf1de9b2a5cc6a3c70d -> 4.8.12-x86_64-prometheus
      sha256:d2fd1fa259a04433b8aafa445158428bb183df6a705f849f24f1fa92fde8d7a6 -> 4.8.12-x86_64-csi-external-resizer
      sha256:d346f5faeb46066e3ef90453305fdb7c1013faa0c7d52d7d531917748a9e4bd9 -> 4.8.12-x86_64-cluster-csi-snapshot-controller-operator
      sha256:d48600e686833363738cd85ad32f4bf0c205fc34edb326263bfb83fd9217236a -> 4.8.12-x86_64-cluster-kube-controller-manager-operator
      sha256:d4d7c03002d07d5b06ef970dc37d3981a0c5aa40aba9bf919c2be58d18f96b4d -> 4.8.12-x86_64-cloud-credential-operator
      sha256:d71614838c41b551af51a59df8860dad2b644c3050355ff5097709c0655215b4 -> 4.8.12-x86_64-keepalived-ipfailover
      sha256:d98a1641108217f77be0dd7c99f80bdc26a51080c1894781645f7bb6e36a9e6a -> 4.8.12-x86_64-jenkins-agent-base
      sha256:db10d2aa9d3232f486bd19884f82f90fbc06ac94937cf9b16661e29c9d59c952 -> 4.8.12-x86_64-cli-artifacts
      sha256:db6fee94df626956eb185f4e33e1becae7c91bf2d6995abf21da160ab83b0e9e -> 4.8.12-x86_64-k8s-prometheus-adapter
      sha256:dcf2d7efc49da58fd7a9427ae9162cc5d4e3fb433db6a34c7416fcdce75d3722 -> 4.8.12-x86_64-console-operator
      sha256:e00057f4e3a9dc86a10a5569f7655efa7c82ef48fbba54d0869606014b4e16c7 -> 4.8.12-x86_64-multus-whereabouts-ipam-cni
      sha256:e08e6d58713e4918010086b6217e3f90a1c6de013c8c6dc5a1e10e9b676f6a0b -> 4.8.12-x86_64-tests
      sha256:e27e35f8d976bbaf3373cbe7d9eaa522b826cae44e01c2e76e617a1dec3a102c -> 4.8.12-x86_64-pod
      sha256:e32faf30edc70b014cfaf317f54a99f940e052586579613ad256094802fb3f1f -> 4.8.12-x86_64-docker-builder
      sha256:e3ad8432b849ce6785a8de6e2e079031a5a20c90a646ba239f8b844045b9280b -> 4.8.12-x86_64-operator-lifecycle-manager
      sha256:e3b54a445db4bcf97ad6fef54e39a6da3b055e137c86eade9cfd815854b20c09 -> 4.8.12-x86_64-must-gather
      sha256:e46e40656359858c997638ad5f85a5f2d43271f1af70cfb0027aa7dde468a0d8 -> 4.8.12-x86_64-cluster-baremetal-operator
      sha256:e6014962554e59906458d73e708d20950b5331c555b5271eeab3c949ed9eb747 -> 4.8.12-x86_64-jenkins-agent-maven
      sha256:e8390e699eb839ffa5a9291a16d5e31c52a2ac4c454f9d4a6286d4107e82efd1 -> 4.8.12-x86_64-gcp-pd-csi-driver
      sha256:e9626d4daf60aef98f38fd0b12149aa06d61c8fc96ffabd16c8e4fb214924bdd -> 4.8.12-x86_64-kube-state-metrics
      sha256:e9d74912b478ef7c42933c63f6f32779ac6cbc693deded67fbd080a7c9e37a4a -> 4.8.12-x86_64-cluster-ingress-operator
      sha256:e9de94a775df9cd6f86712410794393aa58f07374f294ba5a7b503f9fb23cf42 -> 4.8.12-x86_64-hyperkube
      sha256:ea89725b80554fb5a0841462584bfa21668d1b877749672e52e32daf1818fc5c -> 4.8.12-x86_64-csi-driver-manila-operator
      sha256:ee08dba2811e77188ecc91abd84a8ec885b9a8c4c0dfcfeb765e94abfb5a6df5 -> 4.8.12-x86_64-configmap-reloader
      sha256:f033dac5278710d8df21981212b78126c874310aca9ec9a12fac4a8561eac64c -> 4.8.12-x86_64-ironic-static-ip-manager
      sha256:f2b94b90908d8c4449707076227a01426f49cc1ab94d8a59ba56c80b23d08ea2 -> 4.8.12-x86_64-csi-external-attacher
      sha256:f48b5b49d1288fb483db66f545dc20cc5b0265254d39a383a2a81f07099afba9 -> 4.8.12-x86_64-csi-external-snapshotter
      sha256:f5d3601de8421baa8f5adb2a0301aa31d0667a35052f1a70e170a5382e446d7b -> 4.8.12-x86_64-prometheus-node-exporter
  stats: shared=5 unique=274 size=8.584GiB ratio=0.99

phase 0:
  mirror-ocp.ocp4.shinefire.com:443 ocp4/openshift4 blobs=279 mounts=0 manifests=136 shared=5

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


To use the new mirrored repository for upgrades, use the following to create an ImageContentSourcePolicy:

apiVersion: operator.openshift.io/v1alpha1
kind: ImageContentSourcePolicy
metadata:
  name: example
spec:
  repositoryDigestMirrors:
  - mirrors:
    - mirror-ocp.ocp4.shinefire.com/ocp4/openshift4
    source: quay.io/openshift-release-dev/ocp-release
  - mirrors:
    - mirror-ocp.ocp4.shinefire.com/ocp4/openshift4
    source: quay.io/openshift-release-dev/ocp-v4.0-art-dev
```

`oc adm release mirror` 命令执行完成后会输出下面类似的信息，保存下来，将来会用在 `install-config.yaml` 文件中：

```yaml
imageContentSources:
- mirrors:
  - mirror-ocp.ocp4.shinefire.com/ocp4/openshift4
  source: quay.io/openshift-release-dev/ocp-release
- mirrors:
  - mirror-ocp.ocp4.shinefire.com/ocp4/openshift4
  source: quay.io/openshift-release-dev/ocp-v4.0-art-dev
```

用于离线的镜像仓库缓存好镜像之后，通过 `tag/list` 接口查看所有 tag，如果能列出来一堆就说明是正常的：

```bash
~]# curl -s -u admin:Harbor12345 -k https://mirror-ocp.ocp4.shinefire.com/v2/ocp4/openshift4/tags/list|jq .
{
  "name": "ocp4/openshift4",
  "tags": [
    "4.8.12-x86_64",
    "4.8.12-x86_64-aws-ebs-csi-driver",
    "4.8.12-x86_64-aws-ebs-csi-driver-operator",
    "4.8.12-x86_64-aws-machine-controllers",
    "4.8.12-x86_64-aws-pod-identity-webhook",
    "4.8.12-x86_64-azure-disk-csi-driver",
    "4.8.12-x86_64-azure-disk-csi-driver-operator",
    "4.8.12-x86_64-azure-machine-controllers",
    "4.8.12-x86_64-baremetal-installer",
    "4.8.12-x86_64-baremetal-machine-controllers",
    "4.8.12-x86_64-baremetal-operator",
    "4.8.12-x86_64-baremetal-runtimecfg",
    "4.8.12-x86_64-cli",
    "4.8.12-x86_64-cli-artifacts",
    "4.8.12-x86_64-cloud-credential-operator",
    "4.8.12-x86_64-cluster-authentication-operator",
    "4.8.12-x86_64-cluster-autoscaler",
    "4.8.12-x86_64-cluster-autoscaler-operator",
    "4.8.12-x86_64-cluster-baremetal-operator",
    "4.8.12-x86_64-cluster-bootstrap",
    "4.8.12-x86_64-cluster-config-operator",
    "4.8.12-x86_64-cluster-csi-snapshot-controller-operator",
    "4.8.12-x86_64-cluster-dns-operator",
    "4.8.12-x86_64-cluster-etcd-operator",
    "4.8.12-x86_64-cluster-image-registry-operator",
    "4.8.12-x86_64-cluster-ingress-operator",
    "4.8.12-x86_64-cluster-kube-apiserver-operator",
    "4.8.12-x86_64-cluster-kube-controller-manager-operator",
    "4.8.12-x86_64-cluster-kube-scheduler-operator",
    "4.8.12-x86_64-cluster-kube-storage-version-migrator-operator",
    "4.8.12-x86_64-cluster-machine-approver",
    "4.8.12-x86_64-cluster-monitoring-operator",
    "4.8.12-x86_64-cluster-network-operator",
    "4.8.12-x86_64-cluster-node-tuning-operator",
    "4.8.12-x86_64-cluster-openshift-apiserver-operator",
    "4.8.12-x86_64-cluster-openshift-controller-manager-operator",
    "4.8.12-x86_64-cluster-policy-controller",
    "4.8.12-x86_64-cluster-samples-operator",
    "4.8.12-x86_64-cluster-storage-operator",
    "4.8.12-x86_64-cluster-update-keys",
    "4.8.12-x86_64-cluster-version-operator",
    "4.8.12-x86_64-configmap-reloader",
    "4.8.12-x86_64-console",
    "4.8.12-x86_64-console-operator",
    "4.8.12-x86_64-container-networking-plugins",
    "4.8.12-x86_64-coredns",
    "4.8.12-x86_64-csi-driver-manila",
    "4.8.12-x86_64-csi-driver-manila-operator",
    "4.8.12-x86_64-csi-driver-nfs",
    "4.8.12-x86_64-csi-external-attacher",
    "4.8.12-x86_64-csi-external-provisioner",
    "4.8.12-x86_64-csi-external-resizer",
    "4.8.12-x86_64-csi-external-snapshotter",
    "4.8.12-x86_64-csi-livenessprobe",
    "4.8.12-x86_64-csi-node-driver-registrar",
    "4.8.12-x86_64-csi-snapshot-controller",
    "4.8.12-x86_64-csi-snapshot-validation-webhook",
    "4.8.12-x86_64-deployer",
    "4.8.12-x86_64-docker-builder",
    "4.8.12-x86_64-docker-registry",
    "4.8.12-x86_64-driver-toolkit",
    "4.8.12-x86_64-egress-router-cni",
    "4.8.12-x86_64-etcd",
    "4.8.12-x86_64-gcp-machine-controllers",
    "4.8.12-x86_64-gcp-pd-csi-driver",
    "4.8.12-x86_64-gcp-pd-csi-driver-operator",
    "4.8.12-x86_64-grafana",
    "4.8.12-x86_64-haproxy-router",
    "4.8.12-x86_64-hyperkube",
    "4.8.12-x86_64-insights-operator",
    "4.8.12-x86_64-installer",
    "4.8.12-x86_64-installer-artifacts",
    "4.8.12-x86_64-ironic",
    "4.8.12-x86_64-ironic-hardware-inventory-recorder",
    "4.8.12-x86_64-ironic-inspector",
    "4.8.12-x86_64-ironic-ipa-downloader",
    "4.8.12-x86_64-ironic-machine-os-downloader",
    "4.8.12-x86_64-ironic-static-ip-manager",
    "4.8.12-x86_64-jenkins",
    "4.8.12-x86_64-jenkins-agent-base",
    "4.8.12-x86_64-jenkins-agent-maven",
    "4.8.12-x86_64-jenkins-agent-nodejs",
    "4.8.12-x86_64-k8s-prometheus-adapter",
    "4.8.12-x86_64-keepalived-ipfailover",
    "4.8.12-x86_64-kube-proxy",
    "4.8.12-x86_64-kube-rbac-proxy",
    "4.8.12-x86_64-kube-state-metrics",
    "4.8.12-x86_64-kube-storage-version-migrator",
    "4.8.12-x86_64-kuryr-cni",
    "4.8.12-x86_64-kuryr-controller",
    "4.8.12-x86_64-libvirt-machine-controllers",
    "4.8.12-x86_64-machine-api-operator",
    "4.8.12-x86_64-machine-config-operator",
    "4.8.12-x86_64-machine-os-content",
    "4.8.12-x86_64-mdns-publisher",
    "4.8.12-x86_64-multus-admission-controller",
    "4.8.12-x86_64-multus-cni",
    "4.8.12-x86_64-multus-networkpolicy",
    "4.8.12-x86_64-multus-route-override-cni",
    "4.8.12-x86_64-multus-whereabouts-ipam-cni",
    "4.8.12-x86_64-must-gather",
    "4.8.12-x86_64-network-metrics-daemon",
    "4.8.12-x86_64-network-tools",
    "4.8.12-x86_64-oauth-apiserver",
    "4.8.12-x86_64-oauth-proxy",
    "4.8.12-x86_64-oauth-server",
    "4.8.12-x86_64-openshift-apiserver",
    "4.8.12-x86_64-openshift-controller-manager",
    "4.8.12-x86_64-openshift-state-metrics",
    "4.8.12-x86_64-openstack-cinder-csi-driver",
    "4.8.12-x86_64-openstack-cinder-csi-driver-operator",
    "4.8.12-x86_64-openstack-machine-controllers",
    "4.8.12-x86_64-operator-lifecycle-manager",
    "4.8.12-x86_64-operator-marketplace",
    "4.8.12-x86_64-operator-registry",
    "4.8.12-x86_64-ovirt-csi-driver",
    "4.8.12-x86_64-ovirt-csi-driver-operator",
    "4.8.12-x86_64-ovirt-machine-controllers",
    "4.8.12-x86_64-ovn-kubernetes",
    "4.8.12-x86_64-pod",
    "4.8.12-x86_64-prom-label-proxy",
    "4.8.12-x86_64-prometheus",
    "4.8.12-x86_64-prometheus-alertmanager",
    "4.8.12-x86_64-prometheus-config-reloader",
    "4.8.12-x86_64-prometheus-node-exporter",
    "4.8.12-x86_64-prometheus-operator",
    "4.8.12-x86_64-sdn",
    "4.8.12-x86_64-service-ca-operator",
    "4.8.12-x86_64-telemeter",
    "4.8.12-x86_64-tests",
    "4.8.12-x86_64-thanos",
    "4.8.12-x86_64-tools",
    "4.8.12-x86_64-vsphere-csi-driver",
    "4.8.12-x86_64-vsphere-csi-driver-operator",
    "4.8.12-x86_64-vsphere-csi-driver-syncer",
    "4.8.12-x86_64-vsphere-problem-detector"
  ]
}
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



## 部署内部镜像仓库

内部镜像仓库部署在 bastion.ocp4.shinefire.com 节点，并将 mirror-ocp.ocp4.example.com 节点同步下来的镜像导入到内部仓库中。





























## Reference

- [OpenShift Container Platform Versioning Policy](https://docs.openshift.com/container-platform/4.8/release_notes/versioning-policy.html)
- [Mirroring images for a disconnected installation](https://docs.openshift.com/container-platform/4.8/installing/installing-mirroring-installation-images.html)
- [Installation and update](https://docs.openshift.com/container-platform/4.8/architecture/architecture-installation.html#architecture-installation)

