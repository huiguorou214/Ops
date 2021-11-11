# OpenShift Deploy EFK



## 环境说明

OpenShift：4.8.12



## 安装 OpenShift Elasticsearch Operator

### 文字说明步骤

1. In the OpenShift Container Platform web console, click **Operators** → **OperatorHub**.
2. Choose **OpenShift Elasticsearch Operator** from the list of available Operators, and click **Install**.
3. Ensure that the **All namespaces on the cluster** is selected under **Installation Mode**.
4. Ensure that **openshift-operators-redhat** is selected under **Installed Namespace**.
   You must specify the `openshift-operators-redhat` namespace. The `openshift-operators` namespace might contain Community Operators, which are untrusted and could publish a metric with the same name as an OpenShift Container Platform metric, which would cause conflicts.
5. Select **Enable operator recommended cluster monitoring on this namespace**.
   This option sets the `openshift.io/cluster-monitoring: "true"` label in the Namespace object. You must select this option to ensure that cluster monitoring scrapes the `openshift-operators-redhat` namespace.
6. Select **stable-5.x** as the **Update Channel**.
7. Select an **Approval Strategy**.
   - The **Automatic** strategy allows Operator Lifecycle Manager (OLM) to automatically update the Operator when a new version is available.
   - The **Manual** strategy requires a user with appropriate credentials to approve the Operator update.
8. Click **Install**.
9. Verify that the OpenShift Elasticsearch Operator installed by switching to the **Operators** → **Installed Operators** page.
10. Ensure that **OpenShift Elasticsearch Operator** is listed in all projects with a **Status** of **Succeeded**.



### 图形操作步骤

Console界面检查

![image-20211109114836856](pictures/image-20211109114836856.png)



点击"OpenShift Elasticsearch Operator"进行安装

![image-20211111120151498](pictures/image-20211111120151498.png)



点击"Install"进行安装，点击"Installed Operators"查看安装结果，等待状态变成"Succeeded"即可

![image-20211111163921748](pictures/image-20211111163921748.png)







## Q&A

Q1：

在安装 Elasticsearch Operator 的时候遇到报错：

在拉取镜像的时候，集群尝试去公网官方地址拉取镜像，从而导致 pull image 失败。

```
Failed to pull image "registry.redhat.io/openshift-logging/elasticsearch-operator-bundle@sha256:6e05a9f3f276f1679d4b18a6e105b2222cefc1710ae7d54b46f00f86cca344c1": rpc error: code = Unknown desc = error pinging docker registry registry.redhat.io: Get "https://registry.redhat.io/v2/": dial tcp: lookup registry.redhat.io on 192.168.31.100:53: server misbehaving
```

全部日志如下：

```bash
[root@bastion efk-mirror]# oc project openshift-marketplace
Now using project "openshift-marketplace" on server "https://api.ocp4.shinefire.com:6443".
[root@bastion efk-mirror]# oc get events
LAST SEEN   TYPE      REASON                         OBJECT                                                                MESSAGE
7m21s       Normal    SuccessfulCreate               job/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06eafc06e   Created pod: a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06eaps26q
2m43s       Normal    SuccessfulCreate               job/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06eafc06e   Created pod: a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06ealh5bt
2m43s       Normal    Scheduled                      pod/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06ealh5bt   Successfully assigned openshift-marketplace/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06ealh5bt to master-1.ocp4.shinefire.com
2m42s       Normal    AddedInterface                 pod/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06ealh5bt   Add eth0 [10.254.0.22/24] from openshift-sdn
2m42s       Normal    Pulled                         pod/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06ealh5bt   Container image "quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:e3ad8432b849ce6785a8de6e2e079031a5a20c90a646ba239f8b844045b9280b" already present on machine
2m42s       Normal    Created                        pod/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06ealh5bt   Created container util
2m42s       Normal    Started                        pod/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06ealh5bt   Started container util
69s         Normal    Pulling                        pod/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06ealh5bt   Pulling image "registry.redhat.io/openshift-logging/elasticsearch-operator-bundle@sha256:6e05a9f3f276f1679d4b18a6e105b2222cefc1710ae7d54b46f00f86cca344c1"
69s         Warning   Failed                         pod/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06ealh5bt   Failed to pull image "registry.redhat.io/openshift-logging/elasticsearch-operator-bundle@sha256:6e05a9f3f276f1679d4b18a6e105b2222cefc1710ae7d54b46f00f86cca344c1": rpc error: code = Unknown desc = error pinging docker registry registry.redhat.io: Get "https://registry.redhat.io/v2/": dial tcp: lookup registry.redhat.io on 192.168.31.100:53: server misbehaving
69s         Warning   Failed                         pod/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06ealh5bt   Error: ErrImagePull
84s         Normal    BackOff                        pod/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06ealh5bt   Back-off pulling image "registry.redhat.io/openshift-logging/elasticsearch-operator-bundle@sha256:6e05a9f3f276f1679d4b18a6e105b2222cefc1710ae7d54b46f00f86cca344c1"
84s         Warning   Failed                         pod/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06ealh5bt   Error: ImagePullBackOff
7m22s       Normal    Scheduled                      pod/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06eaps26q   Successfully assigned openshift-marketplace/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06eaps26q to master-1.ocp4.shinefire.com
7m19s       Normal    AddedInterface                 pod/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06eaps26q   Add eth0 [10.254.0.21/24] from openshift-sdn
7m19s       Normal    Pulled                         pod/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06eaps26q   Container image "quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:e3ad8432b849ce6785a8de6e2e079031a5a20c90a646ba239f8b844045b9280b" already present on machine
7m19s       Normal    Created                        pod/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06eaps26q   Created container util
7m19s       Normal    Started                        pod/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06eaps26q   Started container util
5m49s       Normal    Pulling                        pod/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06eaps26q   Pulling image "registry.redhat.io/openshift-logging/elasticsearch-operator-bundle@sha256:6e05a9f3f276f1679d4b18a6e105b2222cefc1710ae7d54b46f00f86cca344c1"
5m49s       Warning   Failed                         pod/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06eaps26q   Failed to pull image "registry.redhat.io/openshift-logging/elasticsearch-operator-bundle@sha256:6e05a9f3f276f1679d4b18a6e105b2222cefc1710ae7d54b46f00f86cca344c1": rpc error: code = Unknown desc = error pinging docker registry registry.redhat.io: Get "https://registry.redhat.io/v2/": dial tcp: lookup registry.redhat.io on 192.168.31.100:53: server misbehaving
5m49s       Warning   Failed                         pod/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06eaps26q   Error: ErrImagePull
6m3s        Normal    BackOff                        pod/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06eaps26q   Back-off pulling image "registry.redhat.io/openshift-logging/elasticsearch-operator-bundle@sha256:6e05a9f3f276f1679d4b18a6e105b2222cefc1710ae7d54b46f00f86cca344c1"
6m3s        Warning   Failed                         pod/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06eaps26q   Error: ImagePullBackOff
54m         Normal    Scheduled                      pod/my-operator-catalog-tjzwg                                         Successfully assigned openshift-marketplace/my-operator-catalog-tjzwg to master-1.ocp4.shinefire.com
54m         Normal    AddedInterface                 pod/my-operator-catalog-tjzwg                                         Add eth0 [10.254.0.20/24] from openshift-sdn
54m         Normal    Pulling                        pod/my-operator-catalog-tjzwg                                         Pulling image "registry.ocp4.shinefire.com:8443/efk-mirror/efk-mirror-my-operator-my-operator-index:v4.8-202111"
54m         Normal    Pulled                         pod/my-operator-catalog-tjzwg                                         Successfully pulled image "registry.ocp4.shinefire.com:8443/efk-mirror/efk-mirror-my-operator-my-operator-index:v4.8-202111" in 73.912916ms
54m         Normal    Created                        pod/my-operator-catalog-tjzwg                                         Created container registry-server
54m         Normal    Started                        pod/my-operator-catalog-tjzwg                                         Started container registry-server
55m         Normal    Scheduled                      pod/my-operator-trgfr                                                 Successfully assigned openshift-marketplace/my-operator-trgfr to master-1.ocp4.shinefire.com
55m         Normal    AddedInterface                 pod/my-operator-trgfr                                                 Add eth0 [10.254.0.18/24] from openshift-sdn
55m         Normal    Scheduled                      pod/my-operator-xgbrs                                                 Successfully assigned openshift-marketplace/my-operator-xgbrs to master-1.ocp4.shinefire.com
55m         Normal    AddedInterface                 pod/my-operator-xgbrs                                                 Add eth0 [10.254.0.19/24] from openshift-sdn
55m         Normal    Pulling                        pod/my-operator-xgbrs                                                 Pulling image "registry.ocp4.shinefire.com:8443/efk-mirror/efk-mirror-my-operator-my-operator-index:v4.8-202111"
55m         Normal    Pulled                         pod/my-operator-xgbrs                                                 Successfully pulled image "registry.ocp4.shinefire.com:8443/efk-mirror/efk-mirror-my-operator-my-operator-index:v4.8-202111" in 3.203093796s
55m         Normal    Created                        pod/my-operator-xgbrs                                                 Created container registry-server
55m         Normal    Started                        pod/my-operator-xgbrs                                                 Started container registry-server
54m         Normal    Killing                        pod/my-operator-xgbrs                                                 Stopping container registry-server
55m         Warning   FailedToUpdateEndpointSlices   service/my-operator                                                   Error updating Endpoint Slices for Service openshift-marketplace/my-operator: failed to delete my-operator-7nkxl EndpointSlice for Service openshift-marketplace/my-operator: endpointslices.discovery.k8s.io "my-operator-7nkxl" not found
54m         Warning   FailedToUpdateEndpoint         endpoints/my-operator                                                 Failed to update endpoint openshift-marketplace/my-operator: Operation cannot be fulfilled on endpoints "my-operator": StorageError: invalid object, Code: 4, Key: /kubernetes.io/services/endpoints/openshift-marketplace/my-operator, ResourceVersion: 0, AdditionalErrorMsg: Precondition failed: UID in precondition: 244f1703-96a6-4b4b-ab19-20ad7de70e19, UID in object meta:
```

A：



Q2：

安装Elasticsearch Operator的时候，还是会一直去尝试在官网拉取镜像，发现如下message

```
unpack job not completed: Unpack pod(openshift-marketplace/a0d5082e2af00511c8ff1c5cefa240ac2f27b216bfe4acb8e74e0b06eaz8p7p) container(pull) is pending. Reason: ErrImagePull, Message: rpc error: code = Unknown desc = error pinging docker registry registry.redhat.io: Get "https://registry.redhat.io/v2/": dial tcp:lookup registry.redhat.io on 192.168.31.100:53: server misbehaving
```

Bundle unpacking failed. Reason: DeadlineExceeded, and Message: Job was

​    active longer than specified deadline



bundle contents have not yet been persisted to installplan status
