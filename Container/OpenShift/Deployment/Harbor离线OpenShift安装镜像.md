# Harbor 离线 OperatorHub 镜像操作指引

本文档主要介绍了，在使用`harbor`之后，如何离线`OpenShift`镜像的操作



## 准备离线安装介质

### 获取openshift client

目前使用的 OCP 版本是 4.8.12，可以从这里下载客户端：

- https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.8.12/

```bash
~]# wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.8.12/openshift-client-linux-4.8.12.tar.gz
~]# tar xzvf openshift-client-linux-4.8.12.tar.gz
README.md
oc
kubectl
~]# mv oc kubectl /usr/local/bin/
```



### 配置下载信息

准备拉取镜像权限认证文件。从 `Red Hat OpenShift Cluster Manager` 站点的 **[Pull Secret 页面](https://cloud.redhat.com/openshift/install/pull-secret)** 下载 `registry.redhat.io` 的 `pull secret`。

```bash
# 把下载的 txt 文件转出 json 格式，如果没有 jq 命令，通过 epel 源安装
[root@bastion ~]# cat ./pull-secret.txt | jq . > pull-secret.json
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
    "harbor-server1.shinefire.com": {
      "auth": "YWRtaW46SGFyYm9yMTIzNDU="
      "email" "youremail@shinefire.com"
   },
...
```

设置环境变量：

```bash
$ export OCP_RELEASE="4.8.12-x86_64"
$ export LOCAL_REGISTRY='harbor-server1.shinefire.com' 
$ export LOCAL_REPOSITORY='ocp4/openshift4'
$ export PRODUCT_REPO='openshift-release-dev'
$ export LOCAL_SECRET_JSON='/root/pull-secret.json'
$ export RELEASE_NAME="ocp-release"
```

- **OCP_RELEASE** : OCP 版本，可以在**[这个页面](https://quay.io/repository/openshift-release-dev/ocp-release?tab=tags)**查看。如果版本不对，下面执行 `oc adm` 时会提示 `image does not exist`。
- **LOCAL_REGISTRY** : 本地仓库的域名和端口。
- **LOCAL_REPOSITORY** : 镜像存储库名称，使用 ocp4/openshift4。
- `PRODUCT_REPO` 和 `RELEASE_NAME` 都不需要改，这些都是一些版本特征，保持不变即可。
- **LOCAL_SECRET_JSON** : 密钥路径，就是上面 `pull-secret.json` 的存放路径。

在 Harbor 中创建一个名为 `ocp4` 的 project 用来存放同步过来的镜像，创建project的步骤省略，注意创建项目的时候项目名称要跟上面设置环境变量中使用的名称一致



### 离线 OpenShift 镜像

最后一步就是登录到镜像仓库并同步镜像，这一步的动作就是把 `quay` 官方仓库中的镜像，同步到本地仓库，如果失败了可以重新执行命令，整体内容大概 `5G`。

```bash
[root@harbor-server1 ~]# docker login harbor-server1.shinefire.com
Authenticating with existing credentials...
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded

[root@harbor-server1 ~]# oc adm release mirror -a ${LOCAL_SECRET_JSON}      --from=quay.io/${PRODUCT_REPO}/${RELEASE_NAME}:${OCP_RELEASE}      --to=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY}      --to-release-image=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY}:${OCP_RELEASE}
info: Mirroring 136 images to harbor-server1.shinefire.com/ocp4/openshift4 ...
harbor-server1.shinefire.com/
```



### 离线 OperatorHub 

首先在 Harbor 中创建一个 `devinfra` 项目，然后构建 RedHat Operators 的 `catalog image`, 保存为 `bastion.openshift4.example.com:8443/devinfra/redhat-operators:v1`

```bash
~]# oc adm catalog build \
  -a ${LOCAL_SECRET_JSON} \
  --appregistry-endpoint https://quay.io/cnr \
  -a ${LOCAL_SECRET_JSON} \
  --appregistry-endpoint https://quay.io/cnr \
  --from=registry.redhat.io/openshift4/ose-operator-registry:v4.8 \
  --appregistry-org redhat-operators \
  --to=harbor-server1.shinefire.com/devinfra/redhat-operators:v1

using registry.redhat.io/openshift4/ose-operator-registry:v4.8 as a base image for buildingINFO[0039] loading Bundles                               dir=/tmp/cache-186747622/manifests-901447879
INFO[0039] directory                                     dir=/tmp/cache-186747622/manifests-901447879 file=manifests-901447879 load=bundles
INFO[0039] directory                                     dir=/tmp/cache-186747622/manifests-901447879 file=3scale-operator load=bundles
INFO[0039] directory                                     dir=/tmp/cache-186747622/manifests-901447879 file=3scale-operator-u85hgk8m load=bundles
INFO[0039] directory                                     dir=/tmp/cache-186747622/manifests-901447879 file=0.3.0 load=bundles
INFO[0039] found csv, loading bundle                     dir=/tmp/cache-186747622/manifests-901447879 file=3scale-operator.v0.3.0.clusterserviceversion.yaml load=bundles
INFO[0039] loading bundle file                           dir=/tmp/cache-186747622/manifests-901447879/3scale-operator/3scale-operator-u85hgk8m/0.3.0 file=3scale-operator.v0.3.0.clusterserviceversion.yaml load=bundle name=3scale-operator.v0.3.0
```

这个 catalog image 相当于 `RedHat Operators` 的一个目录，通过 `catalog image` 可以找到  `RedHat Operators` 的所有镜像。而且 catalog image 使用 `sha256 digest` 来引用镜像，能够确保应用有稳定可重复的部署。



批量创建这些需要的 project，不然后面会提示没有发现会报错

```bash
[root@harbor-server1 ~]# cat create_projects.sh
#!/bin/bash

url="https://harbor-server1.shinefire.com"
user="admin"
passwd="Harbor12345"

for project in `ls /tmp/cache-186747622/manifests-901447879/`; do curl -u "${user}:${passwd}" -X POST -H "Content-Type: application/json" "${url}/api/v2.0/projects" -d "{\"project_name\": \"${project}\", \"metadata\": {\"public\": \"true\"}, \"storage_limit\": -1}"; done

[root@harbor-server1 ~]# sh create_projects.sh
```

说明：这里的这个路径，是上一部构建时的日志里面会提到的，这里面包含了所有的project的名称。不过实际测试发现还是会有不包含在这里面的project，可以根据后面同步镜像时的提示自己创建。



然后使用 catalog image 同步 `RedHat Operators` 的所有镜像到私有仓库：

```bash
~]# oc adm catalog mirror \
  -a ${LOCAL_SECRET_JSON} \
  harbor-server1.shinefire.com/devinfra/redhat-operators:v1 \
  harbor-server1.shinefire.com
```





### Q&A

Q1

在同步 operatorhub 创建项目的时候遇到这个报错：

```
W0921 03:56:02.171323   53211 builder.go:141] error building database: [error checking provided apis in bundle submariner.v0.8.2: error decoding CRD: no kind "CustomResourceDefinition" is registered for version "apiextensions.k8s.io/v1" in scheme "github.com/operator-framework/operator-registry/pkg/registry/bundle.go:15", error adding operator bundle submariner.v0.8.2//: error decoding CRD: no kind "CustomResourceDefinition" is registered for version "apiextensions.k8s.io/v1" in scheme "github.com/operator-framework/operator-registry/pkg/registry/bundle.go:15", error loading package into db: [FOREIGN KEY constraint failed, no default channel specified for submariner]]
```

A：



Q2

在同步 OperatorHub 镜像的时候遇到一个问题

```
error: unable to push manifest to harbor-server1.shinefire.com/openshift-service-mesh/kiali-rhel8-operator: manifest blob unknown: blob unknown to registry
info: Mirroring completed in 20.37s (7.676MB/s)
error mirroring image: one or more errors occurred while uploading images
```

不过目前还没看出这个报错会带来什么样的问题

A：



## Reference

- [离线OperatorHub制作并同步对应的应用镜像](https://www.jianshu.com/p/bddeb66aa696)
- 

