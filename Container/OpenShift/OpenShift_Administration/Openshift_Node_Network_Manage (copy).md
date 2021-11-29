# OpenShift 节点网络配置



## 部署 Kubernetes NMState Operator

### web部署流程

1. 选择 **Operators** → **OperatorHub**。
2. 在 **All Items** 下的搜索字段中，输入 `nmstate` 并点击 **Enter** 来搜索 Kubernetes NMState Operator。
3. 点 Kubernetes NMState Operator 搜索结果。
4. 点 **Install** 打开 **Install Operator** 窗口。
5. 在 **Installed Namespace** 下，确保命名空间是 `openshift-nmstate`。如果组合框中没有 `openshift-nmstate`，点 **Create Namespace**，在对话框的 **Name** 字段中输入 `openshift-nmstate` **并按 Create**。
6. 点 **Install** 安装 Operator。
7. Operator 安装完成后，点 **View Operator**。
8. 在 **Provided APIs 下**，点 **Create Instance** 打开对话框以创建 `kubernetes-nmstate` 实例。
9. 在对话框的 **Name** 字段中，确保实例的名称是 `nmstate.`
10. 接受默认设置并点 **Create** 创建实例。



## 观察节点的网络状态

### 资源类型介绍

OpenShift Container Platform 使用 [`nmstate`](https://nmstate.github.io/) 来报告并配置节点网络的状态。这样就可以通过将单个配置清单应用到集群来修改网络策略配置，例如在所有节点上创建 Linux 桥接。



节点网络由以下对象监控和更新：

- `NodeNetworkState`

  报告该节点上的网络状态。

- `NodeNetworkConfigurationPolicy`

  描述节点上请求的网络配置。您可以通过将 `NodeNetworkConfigurationPolicy` 清单应用到集群来更新节点网络配置，包括添加和删除接口。

- `NodeNetworkConfigurationEnactment`

  报告每个节点上采用的网络策略。

OpenShift Container Platform 支持使用以下 nmstate 接口类型：

- Linux Bridge
- VLAN
- bond
- Ethernet

> 注意
>
> 如果您的 OpenShift Container Platform 集群使用 OVN-Kubernetes 作为默认 Container Network Interface（CNI）供应商，则无法将 Linux 网桥或绑定附加到主机的默认接口，因为 OVN-Kubernetes 的主机网络拓扑发生了变化。作为临时解决方案，您可以使用连接到主机的二级网络接口，或切换到 OpenShift SDN 默认 CNI 供应商。



### NodeNetworkState

列出集群中的所有 `NodeNetworkState` 对象：

```bash
[root@bastion ~]# oc get nns
NAME                          AGE
master-1.ocp4.shinefire.com   5m7s
master-2.ocp4.shinefire.com   5m16s
master-3.ocp4.shinefire.com   5m11s
```



## 更新节点的网络配置

通过使用 `NodeNetworkConfigurationPolicy` 资源类型可以用来更新节点网络配置和从节点中添加或者删除接口。



### 配置Ethernet类型静态IP

编写一个yaml文件

```yaml
apiVersion: nmstate.io/v1beta1
kind: NodeNetworkConfigurationPolicy
metadata:
  name: master-1-enp0s8-nncp
spec:
  nodeSelector:
    kubernetes.io/hostname: master-1.ocp4.shinefire.com
  desiredState:
    interfaces:
    - name: enp0s8
      description: NAS Network
      type: ethernet
      state: up
      ipv4:
        address:
        - ip: 192.168.31.222
          prefix-length: 24
        enabled: true
```

部分配置参数说明：

- metadata.name：指定创建后的资源类型的名称，这个可以自定义命名
- spec.nodeSelector：通过选择器来匹配不同的节点，我这里是直接使用 kubernetes.io/hostname 来指定具体的 node，因为是要给指定的 node 单独配置网卡的网络
- spec.desiredState.interfaces.name：指定网卡名称
- spec.desiredState.interfaces.description：描述信息，自定义即可



运行并检查结果，运行命令如下

```bash
[root@bastion ~]# oc create -f master-1-enp0s8-nncp.yaml
nodenetworkconfigurationpolicy.nmstate.io/master-1-enp0s8-nncp created
[root@bastion ~]# oc get nncp
NAME                   STATUS
master-1-enp0s8-nncp   SuccessfullyConfigured
[root@bastion ~]# oc get nnce
NAME                                               STATUS
master-1.ocp4.shinefire.com.master-1-enp0s8-nncp   SuccessfullyConfigured
master-2.ocp4.shinefire.com.master-1-enp0s8-nncp   NodeSelectorNotMatching
master-3.ocp4.shinefire.com.master-1-enp0s8-nncp   NodeSelectorNotMatching
```

登录到节点中查看结果，类似输出

```bash
[root@bastion ~]# ssh core@master-1.ocp4.shinefire.com ip a | grep enp0s8 -A4
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:8a:db:ad brd ff:ff:ff:ff:ff:ff
    inet 192.168.31.222/24 brd 192.168.31.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
```

可以看到已经成功配置了指定网卡的静态IP地址、



重启系统测试，从结果中可以看到重启后网络配置依然是能够持久生效的

```
[root@bastion ~]# ssh core@master-1.ocp4.shinefire.com sudo reboot
Connection to master-1.ocp4.shinefire.com closed by remote host.
[root@bastion ~]# ssh core@master-1.ocp4.shinefire.com ip a | grep enp0s8 -A4
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:8a:db:ad brd ff:ff:ff:ff:ff:ff
    inet 192.168.31.222/24 brd 192.168.31.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
```


