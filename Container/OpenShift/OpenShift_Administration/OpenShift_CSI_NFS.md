# OpenShift CSI NFS

项目地址：https://github.com/kubernetes-csi/csi-driver-nfs



## 公网拉取相关镜像

因为安装 CSI Driver 的过程中，需要几个相关的镜像才能启动，但是这几个镜像在国内网络环境拉取可能会遇到困难，这里我是直接在腾讯云申请了一台新加坡的 CentOS 8.2 操作系统的机器先进行相关的镜像拉取后保存回本地，再用于后续的使用。



image list，本镜像清单仅限于当前我在该项目中的 yaml 文件里看到的镜像版本

- k8s.gcr.io/sig-storage/csi-provisioner:v2.2.2
- k8s.gcr.io/sig-storage/csi-node-driver-registrar:v2.3.0
- k8s.gcr.io/sig-storage/livenessprobe:v2.4.0
- mcr.microsoft.com/k8s/csi/nfs-csi:latest



安装 docker 并 pull 相关的镜像

```bash
~]# yum install -y yum-utils
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum makecache
yum -y install docker-ce
systemctl start docker
docker pull k8s.gcr.io/sig-storage/csi-provisioner:v2.2.2
docker pull k8s.gcr.io/sig-storage/csi-node-driver-registrar:v2.3.0
docker pull k8s.gcr.io/sig-storage/livenessprobe:v2.4.0
docker pull mcr.microsoft.com/k8s/csi/nfs-csi:latest
```



检查 pull 结果

```bash
[root@VM-0-4-centos ~]# docker images
REPOSITORY                                        TAG         IMAGE ID      CREATED       SIZE
mcr.microsoft.com/k8s/csi/nfs-csi                 latest      18da93b294e7  6 weeks ago   161 MB
k8s.gcr.io/sig-storage/livenessprobe              v2.4.0      42363933b3cb  2 months ago  18.4 MB
k8s.gcr.io/sig-storage/csi-node-driver-registrar  v2.3.0      368ee7d6e60f  2 months ago  20 MB
k8s.gcr.io/sig-storage/csi-provisioner            v2.2.2      e18077242e6d  5 months ago  57.6 MB
```



打包所有的镜像

```bash
~]# docker save mcr.microsoft.com/k8s/csi/nfs-csi:latest  k8s.gcr.io/sig-storage/livenessprobe:v2.4.0 k8s.gcr.io/sig-storage/csi-node-driver-registrar:v2.3.0 k8s.gcr.io/sig-storage/csi-provisioner:v2.2.2 | gzip > nfs-csi-all-iamges.tar.gz
~]# ls
nfs-csi-all-iamges.tar.gz
```

注意：我之前用 podman 工具来做的话，这种一起打包的方法似乎会有问题，所以如果用 podman 的话，建议单独打包。



将压缩包上传到离线环境中的 bastion 节点后解压

```bash
~]# ls nfs-csi-all-iamges.tar.gz
~]# gunzip -c nfs-csi-all-iamges.tar.gz | docker load
~]# docker images
REPOSITORY                                         TAG       IMAGE ID       CREATED        SIZE
mcr.microsoft.com/k8s/csi/nfs-csi                  latest    18da93b294e7   6 weeks ago    157MB
k8s.gcr.io/sig-storage/livenessprobe               v2.4.0    42363933b3cb   2 months ago   17.2MB
k8s.gcr.io/sig-storage/csi-node-driver-registrar   v2.3.0    368ee7d6e60f   2 months ago   18.7MB
k8s.gcr.io/sig-storage/csi-provisioner             v2.2.2    e18077242e6d   5 months ago   56.4MB
```



在内网 Harbor 镜像仓库创建项目 `csi-driver-nfs` 用于保存这些 image。

将导入的 image 上传到内网镜像仓库中。

```bash
[root@bastion ~]# docker tag mcr.microsoft.com/k8s/csi/nfs-csi:latest registry.ocp4.shinefire.com:8443/csi-driver-nfs/nfs-csi:latest
[root@bastion ~]# docker push registry.ocp4.shinefire.com:8443/csi-driver-nfs/nfs-csi:latest

[root@bastion ~]# docker tag k8s.gcr.io/sig-storage/livenessprobe:v2.4.0 registry.ocp4.shinefire.com:8443/csi-driver-nfs/livenessprobe:v2.4.0
[root@bastion ~]# docker push registry.ocp4.shinefire.com:8443/csi-driver-nfs/livenessprobe:v2.4.0

[root@bastion ~]# docker tag k8s.gcr.io/sig-storage/csi-node-driver-registrar:v2.3.0 registry.ocp4.shinefire.com:8443/csi-driver-nfs/csi-node-driver-registrar:v2.3.0
[root@bastion ~]# docker push registry.ocp4.shinefire.com:8443/csi-driver-nfs/csi-node-driver-registrar:v2.3.0

[root@bastion ~]# docker tag k8s.gcr.io/sig-storage/csi-provisioner:v2.2.2 registry.ocp4.shinefire.com:8443/csi-driver-nfs/csi-provisioner:v2.2.2
[root@bastion ~]# docker push registry.ocp4.shinefire.com:8443/csi-driver-nfs/csi-provisioner:v2.2.2
```

说明：Harbor镜像仓库的项目可以任意取名，你创建Project的命名也可以用其他的名称都行，只是你需要与后面调用镜像的时候保持一致。





## 离线上传GitHub中该项目到bastion节点

离线该项目步骤：略



上传项目的包到bastion节点中

```bash
~]# ls csi-driver-nfs-master.zip
csi-driver-nfs-master.zip
```



解压

```bash
~]# unzip csi-driver-nfs-master.zip
~]# ls csi-driver-nfs-master
CHANGELOG  cloudbuild.yaml  code-of-conduct.md  deploy      docs    go.sum  LICENSE   OWNERS          pkg        RELEASE.md     SECURITY_CONTACTS  vendor
charts     cmd              CONTRIBUTING.md     Dockerfile  go.mod  hack    Makefile  OWNERS_ALIASES  README.md  release-tools  test
~]# ls csi-driver-nfs-master/deploy/
csi-nfs-controller.yaml  csi-nfs-driverinfo.yaml  csi-nfs-node.yaml  example  install-driver.sh  rbac-csi-nfs-controller.yaml  uninstall-driver.sh
```



## 安装NFS CSI driver

修改 csi-nfs-controller.yaml 中的镜像路径，将默认的官方镜像地址替换成本地镜像仓库中的镜像地址，修改后的结果如下：

```bash
[root@bastion deploy]# grep image csi-nfs-controller.yaml
          image: registry.ocp4.shinefire.com:8443/csi-driver-nfs/csi-provisioner:v2.2.2
          image: registry.ocp4.shinefire.com:8443/csi-driver-nfs/livenessprobe:v2.4.0
          image: registry.ocp4.shinefire.com:8443/csi-driver-nfs/nfs-csi:latest
          imagePullPolicy: IfNotPresent
```

修改 csi-nfs-node.yaml 中的镜像路径，将默认的官方镜像地址替换成本地镜像仓库中的镜像地址，修改后的结果如下：

```bash
[root@bastion deploy]# grep image csi-nfs-node.yaml
          image: registry.ocp4.shinefire.com:8443/csi-driver-nfs/livenessprobe:v2.4.0
          image: registry.ocp4.shinefire.com:8443/csi-driver-nfs/csi-node-driver-registrar:v2.3.0
          image: registry.ocp4.shinefire.com:8443/csi-driver-nfs/nfs-csi:latest
          imagePullPolicy: "IfNotPresent"
```



安装 NFS CSI driver

```bash
[root@bastion csi-driver-nfs-master]# ls
CHANGELOG  cloudbuild.yaml  code-of-conduct.md  deploy      docs    go.sum  LICENSE   OWNERS          pkg        RELEASE.md     SECURITY_CONTACTS  vendor
charts     cmd              CONTRIBUTING.md     Dockerfile  go.mod  hack    Makefile  OWNERS_ALIASES  README.md  release-tools  test
[root@bastion csi-driver-nfs-master]# ./deploy/install-driver.sh master local
use local deploy
Installing NFS CSI driver, version: master ...
serviceaccount/csi-nfs-controller-sa created
clusterrole.rbac.authorization.k8s.io/nfs-external-provisioner-role created
clusterrolebinding.rbac.authorization.k8s.io/nfs-csi-provisioner-binding created
csidriver.storage.k8s.io/nfs.csi.k8s.io created
deployment.apps/csi-nfs-controller created
daemonset.apps/csi-nfs-node created
NFS CSI driver installed successfully.
```



检查安装结果，查看所有的 pod 是否都都处于 running 状态

```bash
[root@bastion csi-driver-nfs-master]# oc get po -n kube-system -o wide
NAME                                  READY   STATUS    RESTARTS   AGE    IP               NODE                          NOMINATED NODE   READINESS GATES
csi-nfs-controller-69649555b6-gql2h   3/3     Running   0          100s   192.168.31.161   master-1.ocp4.shinefire.com   <none>           <none>
csi-nfs-controller-69649555b6-tc4hc   3/3     Running   0          100s   192.168.31.163   master-3.ocp4.shinefire.com   <none>           <none>
csi-nfs-node-8hrlj                    3/3     Running   0          100s   192.168.31.162   master-2.ocp4.shinefire.com   <none>           <none>
csi-nfs-node-8jcgw                    3/3     Running   0          100s   192.168.31.161   master-1.ocp4.shinefire.com   <none>           <none>
csi-nfs-node-gnf5g                    3/3     Running   0          100s   192.168.31.163   master-3.ocp4.shinefire.com   <none>           <none>
```



## 部署 StorageClass

strangeclass 的 yaml 文件路径：

csi-driver-nfs-master/deploy/example/storageclass-nfs.yaml

```bash
[root@bastion ~]# ls csi-driver-nfs-master/deploy/example/storageclass-nfs.yaml
csi-driver-nfs-master/deploy/example/storageclass-nfs.yaml
```



检查 nfs server 共享的路径

```bash
~]# showmount -e nuc.shinefire.com
Export list for nuc.shinefire.com:
/nfs/ocp/csi *
```

**说明：**请根据实际情况配置提供 NFS Server 共享，本环境已有，NFS Server 的配置这里不提及，如果有 NAS 来提供共享目录也一样的道理。



修改 storageclass-nfs.yaml 后的结果

```yaml
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: nfs-csi
provisioner: nfs.csi.k8s.io
parameters:
  server: nuc.shinefire.com
  share: /nfs/ocp/csi
reclaimPolicy: Retain
volumeBindingMode: Immediate
mountOptions:
  - hard
  - nfsvers=4.1
```

参数说明：

- parameters.server：指定提供NFS共享存储的服务器地址
- parameters.share：指定共享路径
- reclaimPolicy：指定回收策略，pvc删除后保留则是`Retain`，pvc 删除后也一并删除则是`Delete`
- mountOptions.nfsvers：这个默认用的是4.1版本，这个需要根据实际情况进行调整，比如你的 NFS Server 如果最高就只支持v3的话，这个就必须要修改为3，否则在后面创建 pvc 时会因为 mount 失败从而导致 Pending。使用此命令可以检查 NFS Server 所兼容的版本：` rpcinfo -p NFS_Server_IP`



部署 storageclass

```bash
~]# oc create -f csi-driver-nfs-master/deploy/example/storageclass-nfs.yaml
~]# oc get sc
NAME      PROVISIONER      RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
nfs-csi   nfs.csi.k8s.io   Retain          Immediate           false                  46s
```



测试动态提供持久卷

```bash
~]# oc create -f csi-driver-nfs-master/deploy/example/pvc-nfs-csi-dynamic.yaml
persistentvolumeclaim/pvc-nfs-dynamic created
~]# oc get pvc
NAME              STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc-nfs-dynamic   Bound    pvc-911344a9-1365-4de1-8552-19d10a0ac080   10Gi       RWX            nfs-csi        2s
~]# oc get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                         STORAGECLASS   REASON   AGE
pvc-911344a9-1365-4de1-8552-19d10a0ac080   10Gi       RWX            Retain           Bound    kube-system/pvc-nfs-dynamic   nfs-csi                 5s
```

说明：如果通过结果看到自动创建了pv，则说明 storageclass 配置完成。



测试删除 pvc 后的 pv 依旧保留

```bash
~]# oc delete -f csi-driver-nfs-master/deploy/example/pvc-nfs-csi-dynamic.yaml
persistentvolumeclaim "pvc-nfs-dynamic" deleted
~]# oc get pvc
No resources found in kube-system namespace.
~]# oc get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM                         STORAGECLASS   REASON   AGE
pvc-911344a9-1365-4de1-8552-19d10a0ac080   10Gi       RWX            Retain           Released   kube-system/pvc-nfs-dynamic   nfs-csi                 112s
```

说明：通过删除 pvc 后，检查 pv 的结果可以发现，pv 处于 `Released` 状态，依旧保留。



## Q&A

Q1：

如果在创建 csi nfs 的 controller 和 node 的时候，部分 pod 分配到 master 节点上的话，会导致 pv 也会创建在 master 节点上，让 master 节点尝试去 NFS Server 去挂载共享存储之类的吗？因为 master 节点并不会连通 NAS 网络所以如果会有这种可能性的话，那就可能会导致异常问题出现了。

A：

