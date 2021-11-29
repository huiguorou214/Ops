# OpenShift 节点网络配置



## 背景

在 OpenShift 4.8 的环境中，集群的节点使用的操作系统为 RHCOS ，因为集群需要使用 NAS 来提供存储使用，而 NAS 网络在环境中需要通过额外一张网卡配置网络后才可以访问的，于是尝试加入第二张网卡后使用 nmcli 命令来配置网络。

但是在配置之后，发现了一个新的问题，那就是节点在重启之后，第二个网络会丢失，也就是无法永久性的进行配置，

在查阅资料文档之后，得知 RHCOS 类似于是固定基础设施，登录上去做的任何操作都会被视为临时修改，重启后都会失效的，所以必须从集群中对指定的节点做操作才能永久性有效，类似于为节点配置时间服务时，也需要通过 `machineconfig `的方法来配置。

对于节点的网络配置，目前是看到有两种方式，一种是 `machineconfig `的方式，另外一种则是通过使用 `Kubernetes NMState Operator` 来对节点的网络进行管理，

关于 NMState ，在 openshift 4.8 的官方文档中提到一句，就是说目前 `Kubernetes NMState Operator` 仅仅是一项技术预览功能，可能会存在一些功能缺陷并且不会得到红帽官方支持，不推荐在生产环境中使用，不过这里就先使用 NMState 来尝鲜了。



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

检查 `NodeNetworkState` 对象以查看该节点上的网络。为了清楚，这个示例中的输出已被重新编辑：

```bash
[root@bastion ~]# oc get nns master-1.ocp4.shinefire.com -oyaml
```

输出示例：

```yaml
apiVersion: nmstate.io/v1beta1
kind: NodeNetworkState
metadata:
  creationTimestamp: "2021-11-26T04:38:09Z"
  generation: 1
  name: master-1.ocp4.shinefire.com
  ownerReferences:
  - apiVersion: v1
    kind: Node
    name: master-1.ocp4.shinefire.com
    uid: 370ff67b-c35b-45e7-9917-4a9377ff4091
  resourceVersion: "1198366"
  uid: 05d418be-d7db-4f73-a0b8-2fe7a3a67112
status:
  currentState:
    interfaces:
    - ipv4:
        address: []
        enabled: false
      ipv6:
        address: []
        enabled: false
      mac-address: 8E:D8:41:3E:80:4E
      mtu: 1450
      name: br0
      state: down
      type: ovs-interface
    - ethernet:
        auto-negotiation: true
        duplex: full
        speed: 1000
      ipv4:
        address:
        - ip: 192.168.31.161
          prefix-length: 24
        dhcp: false
        enabled: true
      ipv6:
        address:
        - ip: fe80::2a3c:886a:702f:7d72
          prefix-length: 64
        auto-dns: true
        auto-gateway: true
        auto-route-table-id: 0
        auto-routes: true
        autoconf: true
        dhcp: true
        enabled: true
      lldp:
        enabled: false
      mac-address: 08:00:27:07:CB:51
      mtu: 1500
      name: enp0s3
      state: up
      type: ethernet
    - ethernet:
        auto-negotiation: true
        duplex: full
        speed: 1000
      ipv4:
        address: []
        enabled: false
      ipv6:
        address: []
        enabled: false
      lldp:
        enabled: false
      mac-address: 08:00:27:8A:DB:AD
      mtu: 1500
      name: enp0s8
      state: down
      type: ethernet
    - ipv4:
        address:
        - ip: 127.0.0.1
          prefix-length: 8
        enabled: true
      ipv6:
        address:
        - ip: ::1
          prefix-length: 128
        enabled: true
      mac-address: "00:00:00:00:00:00"
      mtu: 65536
      name: lo
      state: up
      type: unknown
    - ipv4:
        address: []
        enabled: false
      ipv6:
        address: []
        enabled: false
      mac-address: 72:83:54:98:EC:DC
      mtu: 1500
      name: ovs-system
      state: down
      type: ovs-interface
    - ipv4:
        address:
        - ip: 10.254.0.1
          prefix-length: 24
        enabled: true
      ipv6:
        address:
        - ip: fe80::a43c:86ff:fe48:ca87
          prefix-length: 64
        enabled: true
      mac-address: A6:3C:86:48:CA:87
      mtu: 1450
      name: tun0
      state: up
      type: ovs-interface
    - ipv4:
        address: []
        enabled: false
      ipv6:
        address:
        - ip: fe80::c8ad:e4ff:fe1a:4e6c
          prefix-length: 64
        enabled: true
      lldp:
        enabled: false
      mac-address: CA:AD:E4:1A:4E:6C
      mtu: 65000
      name: vxlan_sys_4789
      state: down
      type: vxlan
      vxlan:
        base-iface: ""
        destination-port: 4789
        id: 0
        remote: ""
    routes:
      config:
      - destination: 0.0.0.0/0
        metric: 100
        next-hop-address: 192.168.31.1
        next-hop-interface: enp0s3
        table-id: 254
      - destination: 10.254.0.0/16
        metric: 0
        next-hop-address: 0.0.0.0
        next-hop-interface: tun0
        table-id: 254
      - destination: 172.30.0.0/16
        metric: 0
        next-hop-address: 0.0.0.0
        next-hop-interface: tun0
        table-id: 254
      running:
      - destination: fe80::/64
        metric: 100
        next-hop-address: '::'
        next-hop-interface: enp0s3
        table-id: 254
      - destination: fe80::/64
        metric: 256
        next-hop-address: '::'
        next-hop-interface: vxlan_sys_4789
        table-id: 254
      - destination: fe80::/64
        metric: 256
        next-hop-address: '::'
        next-hop-interface: tun0
        table-id: 254
      - destination: 0.0.0.0/0
        metric: 100
        next-hop-address: 192.168.31.1
        next-hop-interface: enp0s3
        table-id: 254
      - destination: 10.254.0.0/16
        metric: 0
        next-hop-address: 0.0.0.0
        next-hop-interface: tun0
        table-id: 254
      - destination: 172.30.0.0/16
        metric: 0
        next-hop-address: 0.0.0.0
        next-hop-interface: tun0
        table-id: 254
      - destination: 192.168.31.0/24
        metric: 100
        next-hop-address: 0.0.0.0
        next-hop-interface: enp0s3
        table-id: 254
  lastSuccessfulUpdateTime: "2021-11-26T04:38:09Z"
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





## References

- https://docs.openshift.com/container-platform/4.8/virt/node_network/virt-updating-node-network-config.html#virt-example-nmstate-multiple-interfaces_virt-updating-node-network-config

