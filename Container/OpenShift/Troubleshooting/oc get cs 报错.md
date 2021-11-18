

## 问题描述

在使用 `oc get cs` 命令的时候发现有一个报错，报错内容如下

```bash
[root@bastion ~]# oc get cs
W1115 20:54:13.866311 2166789 warnings.go:70] v1 ComponentStatus is deprecated in v1.19+
NAME                 STATUS      MESSAGE                                                                                       ERROR
controller-manager   Unhealthy   Get "http://127.0.0.1:10252/healthz": dial tcp 127.0.0.1:10252: connect: connection refused
scheduler            Healthy     ok
etcd-3               Healthy     {"health":"true"}
etcd-0               Healthy     {"health":"true"}
etcd-1               Healthy     {"health":"true"}
etcd-2               Healthy     {"health":"true"}
```

发现 controller-manager 是 **Unhealthy** 的状态







