# OpenShift 节点重启后的处理方式



## 背景说明

直接在虚拟化平台重启了一台 worker 节点，这种情况下，如果不做任何处理，被重启的节点会处于一个 NotReady 的状态

```bash
[root@bastion ~]# oc get nodes
NAME                          STATUS     ROLES    AGE   VERSION
master-1.ocp4.shinefire.com   Ready      master   30h   v1.21.1+d8043e1
master-2.ocp4.shinefire.com   Ready      master   31h   v1.21.1+d8043e1
master-3.ocp4.shinefire.com   Ready      master   31h   v1.21.1+d8043e1
worker-1.ocp4.shinefire.com   Ready      worker   30h   v1.21.1+d8043e1
worker-2.ocp4.shinefire.com   NotReady   worker   30h   v1.21.1+d8043e1
```



## 处理方式

处理单个节点重启其实跟处理集群重启的方法是基本一致的，可以参考官方的操作指引来进行

官方文档：https://docs.openshift.com/container-platform/4.5/backup_and_restore/graceful-cluster-restart.html#graceful-restart_graceful-restart-cluster



1. 确认 CSRs 的状态

   ```bash
   [root@bastion ~]# oc get csr
   NAME        AGE    SIGNERNAME                                    REQUESTOR                                                                   CONDITION
   csr-b5gfg   53m    kubernetes.io/kube-apiserver-client-kubelet   system:serviceaccount:openshift-machine-config-operator:node-bootstrapper   Pending
   csr-bqm8c   68m    kubernetes.io/kube-apiserver-client-kubelet   system:serviceaccount:openshift-machine-config-operator:node-bootstrapper   Pending
   csr-dpqk6   83m    kubernetes.io/kube-apiserver-client-kubelet   system:serviceaccount:openshift-machine-config-operator:node-bootstrapper   Pending
   csr-ts474   37m    kubernetes.io/kube-apiserver-client-kubelet   system:serviceaccount:openshift-machine-config-operator:node-bootstrapper   Pending
   csr-vnh78   22m    kubernetes.io/kube-apiserver-client-kubelet   system:serviceaccount:openshift-machine-config-operator:node-bootstrapper   Pending
   csr-vqpts   7m5s   kubernetes.io/kube-apiserver-client-kubelet   system:serviceaccount:openshift-machine-config-operator:node-bootstrapper   Pending

2. 可以看到此时有一些 csr 是处于 Pending 状态的，将所有的 Pending 状态的 csr 进行 approved 操作

   ```bash
   [root@bastion ~]# oc adm certificate approve csr-b5gfg
   certificatesigningrequest.certificates.k8s.io/csr-b5gfg approved
   [root@bastion ~]#  oc adm certificate approve csr-bqm8c
   certificatesigningrequest.certificates.k8s.io/csr-bqm8c approved
   [root@bastion ~]#  oc adm certificate approve csr-dpqk6
   certificatesigningrequest.certificates.k8s.io/csr-dpqk6 approved
   [root@bastion ~]#  oc adm certificate approve csr-ts474
   certificatesigningrequest.certificates.k8s.io/csr-ts474 approved
   [root@bastion ~]#  oc adm certificate approve csr-vnh78
   certificatesigningrequest.certificates.k8s.io/csr-vnh78 approved
   [root@bastion ~]#  oc adm certificate approve csr-vqpts
   certificatesigningrequest.certificates.k8s.io/csr-vqpts approved

3. 确认 approve 后的 csr 状态

   ```bash
   [root@bastion ~]# oc get csr
   NAME        AGE   SIGNERNAME                                    REQUESTOR                                                                   CONDITION
   csr-b5gfg   53m   kubernetes.io/kube-apiserver-client-kubelet   system:serviceaccount:openshift-machine-config-operator:node-bootstrapper   Approved,Issued
   csr-bqm8c   69m   kubernetes.io/kube-apiserver-client-kubelet   system:serviceaccount:openshift-machine-config-operator:node-bootstrapper   Approved,Issued
   csr-dpqk6   84m   kubernetes.io/kube-apiserver-client-kubelet   system:serviceaccount:openshift-machine-config-operator:node-bootstrapper   Approved,Issued
   csr-ts474   38m   kubernetes.io/kube-apiserver-client-kubelet   system:serviceaccount:openshift-machine-config-operator:node-bootstrapper   Approved,Issued
   csr-vnh78   23m   kubernetes.io/kube-apiserver-client-kubelet   system:serviceaccount:openshift-machine-config-operator:node-bootstrapper   Approved,Issued
   csr-vqpts   8m    kubernetes.io/kube-apiserver-client-kubelet   system:serviceaccount:openshift-machine-config-operator:node-bootstrapper   Approved,Issued

4. 再次检查节点状态可以看到已经恢复成 Ready 状态了

   ```bash
   [root@bastion ~]# oc get nodes
   NAME                          STATUS   ROLES    AGE   VERSION
   master-1.ocp4.shinefire.com   Ready    master   30h   v1.21.1+d8043e1
   master-2.ocp4.shinefire.com   Ready    master   31h   v1.21.1+d8043e1
   master-3.ocp4.shinefire.com   Ready    master   31h   v1.21.1+d8043e1
   worker-1.ocp4.shinefire.com   Ready    worker   30h   v1.21.1+d8043e1
   worker-2.ocp4.shinefire.com   Ready    worker   30h   v1.21.1+d8043e1
   ```