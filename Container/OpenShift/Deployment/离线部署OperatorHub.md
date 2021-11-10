# 离线部署 OperatorHub



思路说明：

1. skopeo同步官方的operator-index到本地镜像仓库中，例如：

   ```bash
   skopeo copy \
       docker://registry.redhat.io/redhat/redhat-operator-index:v4.8 \
       docker://quay.io/wangzheng422/operator-catalog:redhat-${var_major_version}-$var_date

2. 如果有定制需求就对官方的index image进行裁剪，因为默认会有很多，如果你不想要那么多就裁剪掉一些，参考：https://docs.openshift.com/container-platform/4.8/operators/admin/olm-restricted-networks.html#olm-pruning-index-image_olm-restricted-networks

3. 使用 `oc image mirror` 命令将 index image 离线到本地镜像仓库中

4. 使用 `oc adm catalog mirror` 命令将所有镜像离线到本地

5. 将离线好的文件打包带到离线环境中

6. 再次使用 `oc adm catalog mirror` 命令将打包好的文件导入到离线环境中

 

## 离线 index image 到本地镜像仓库



裁剪镜像

```bash
opm index prune \
  -f registry.redhat.io/redhat/redhat-operator-index:v4.8 \
  -p elasticsearch-operator,cluster-logging \
  -t registry-1.ocp4.shinefire.com/my-operator/my-redhat-operator-index:v4.8-202110
```

推送镜像到镜像仓库

```bash
podman push registry-1.ocp4.shinefire.com/my-operator/my-redhat-operator-index:v4.8-202110
```


离线裁剪后的镜像到本地

```bash
oc adm catalog mirror -a /root/pull-secret.json \
registry-1.ocp4.shinefire.com/operator-index/my-redhat-operator-index:v4.8-202110 \
file:///ocp4812-operator/openshift-efk \
--insecure \
--index-filter-by-os='linux/amd64'
```





## 离线指定的 Operator 到本地目录下

这个和离线 OpenShift4 安装镜像比较类似，需要先找一台能够联网的机器，指定需要的版本的 index 镜像，然后程序会根据 index 镜像中的镜像清单，一个个的离线到本地目录中，就可以打包用于后续放入到离线环境中导入到离线的 OpenShift 环境中使用了。

注意：记得提前准备好300G的剩余空间，一共要两百多G的大小，之前由于空间不够，扩容了几次才搞定的...  另外还需要考虑打包，空间需求会更多



创建保存用的目录

```bash
[root@mirror-ocp ~]# mkdir -p /operatorhub/
```

使用 oc 命令离线所有的官方镜像，这个要等很久才会开始，先不要着急...

```bash
oc adm catalog mirror -a /root/pull-secret.json \
registry.redhat.io/redhat/redhat-operator-index:v4.8 \
file:///operatorhub \
--insecure \
--index-filter-by-os='linux/amd64' \
--max-components=5
```

命令执行后的输出示例：

```bash
[root@mirror-ocp ~]# oc adm catalog mirror \
> registry.redhat.io/redhat/redhat-operator-index:v4.8 \
> file:///operatorhub/redhat-operators -a /root/pull-secret.json \
> --insecure \
> --index-filter-by-os='linux/amd64'
src image has index label for database path: /database/index.db
using database path mapping: /database/index.db:/tmp/612318678
W1018 20:12:16.187983    3260 manifest.go:442] Chose linux/amd64 manifest from the manifest list.
wrote database to /tmp/612318678
using database at: /tmp/612318678/index.db
...

```





## Q&A



Q1： 

离线镜像的时候参考的官方的离线到本地的命令来进行，但是最后出错误了，理论上是没有下载完全的，错误提示信息如下：

```
[root@mirror-ocp ~]# oc adm catalog mirror -a /root/pull-secret.json registry.redhat.io/redhat/redhat-operator-index:v4.8 file:///operatorhub --insecure --index-filter-by-os='linux/amd64'
...
sha256:88fd8428423fb5db2c8c3e757d7c8e8e627be4a8036321089f91ac2446dd0e50 file://operatorhub/redhat/redhat-operator-index/amq7/amq-online-1-standard-controller:46ad0df3
sha256:73627b56a996337effd0c35e1a73c12257492bb8ba0b3c0c6d0822392e085212 file://operatorhub/redhat/redhat-operator-index/amq7/amq-online-1-standard-controller:9b87761c
sha256:1e65603c267a572602d47f9d3ee01fec481c8d7b869de01e6112a148e0b7a3fc file://operatorhub/redhat/redhat-operator-index/fuse7/fuse-ignite-upgrade
sha256:5e3e9d565510c1a12351f89f912e21f318ee0d7ed52fc8cca6051a6dbf3a6e6d file://operatorhub/redhat/redhat-operator-index/fuse7/fuse-console-operator-bundle:fc35daa2
sha256:7e3ff1800f8fd8090b8d3d54816e30f0f737d548fc7ac3d920058f91ccbe7427 file://operatorhub/redhat/redhat-operator-index/openshift-gitops-1-tech-preview/gitops-rhel8-operator
sha256:8a5447d9bc05b2dbbc80a95319232fd730619e6173e7e09a865ca11cb20e9fab file://operatorhub/redhat/redhat-operator-index/openshift-gitops-1-tech-preview/gitops-rhel8-operator
sha256:e2e2c2455adc8e051482981e796a2f6be3dd7f763ab2271aa827887bd7e8ba00 file://operatorhub/redhat/redhat-operator-index/fuse7/fuse-ignite-upgrade:b371e8c7
sha256:c819f6d20d0e845d14dfb76e656c388f5239ff2620fcb7419592f1dccc933968 file://operatorhub/redhat/redhat-operator-index/openshift-gitops-1-tech-preview/gitops-rhel8-operator:fe037cb
sha256:67ea7fd20920d8b2397a37058f4d08c1b878a2b46bee9f38d086ea763d5f5bd1 file://operatorhub/redhat/redhat-operator-index/openshift-gitops-1-tech-preview/gitops-rhel8-operator:b96f9c3c
uploading: file://operatorhub/redhat/redhat-operator-index/openshift4/poison-pill-manager-rhel8-operator sha256:3d31a22f1fd5263f7233fb97b10ae1d3a6a6e3826bf72f5a1233651632fdae9d 19.71MiB
sha256:bb808e896f5a4fbaa681a350cfae4d848711d5719d89539783d4c7786eb8b817 file://operatorhub/redhat/redhat-operator-index/openshift4/poison-pill-manager-rhel8-operator
sha256:bb50656ebf36ef22fe180e38e55c49189037264a0c65ff69484e5c4174961ddf file://operatorhub/redhat/redhat-operator-index/openshift4/poison-pill-manager-rhel8-operator
sha256:9f13fdfa24273ac6a1d32b79a1cb38a55bde22a96356746a0fafe84306974ce4 file://operatorhub/redhat/redhat-operator-index/openshift4/poison-pill-manager-rhel8-operator:a1f10c90
sha256:58d3d4737dfc4c5184f6b6f15da87c914143cdfb729bdf7b3bf4df89a196077d file://operatorhub/redhat/redhat-operator-index/openshift4/poison-pill-manager-rhel8-operator:c438e87b

info: Mirroring completed in 14.21s (4.281MB/s)
error mirroring image: one or more errors occurred
wrote mirroring manifests to manifests-redhat-operator-index-1634594897

To upload local images to a registry, run:

        oc adm catalog mirror file://operatorhub/redhat/redhat-operator-index:v4.8 REGISTRY/REPOSITORY

```







