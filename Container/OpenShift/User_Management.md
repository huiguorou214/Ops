# User Management

> 本章主要介绍OpenShift中如何进行用户管理

## Author

```
Name:Shinefire
Blog:https://github.com/shine-fire/Ops_Notes
E-mail:shine_fire@outlook.com
```



## 修改默认的kubeadmin用户密码

OpenShift在创建好之后，会默认创建一个`kubeadmin`用户，并且会生成一个默认的密码在kubeadmin文件中，在有需要的情况下，如何来修改这个`kubeadmin`用户的密码呢？

在OpenShift中，`kubeadmin`用户是自动生成的用户且并不能被编辑，所以解决办法最好是再创建一个新用户并赋予最高的`cluster-admin`权限，在创建完成之后移除`kubeadmin`用户。

建议在移除`kubeadmin`用户之前，先测试好新建的管理员用户，因为移除`kubeadmin`用户是不可逆操作。



### Create a user





### Cluster role binding

The `cluster-admin` role is required to perform administrator level tasks on the OpenShift Container Platform cluster, such as modifying cluster resources.

Prerequisites

- You must have created a user to define as the cluster admin.

Procedure

- Define the user as a cluster admin:

  ```bash
  $ oc adm policy add-cluster-role-to-user cluster-admin <user>
  ```



### Removing the kubeadmin user

After you define an identity provider and create a new `cluster-admin` user, you can remove the `kubeadmin` to improve cluster security.

> **WARNING**: If you follow this procedure before another user is a `cluster-admin`, then OpenShift Container Platform must be reinstalled. It is not possible to undo this command.

Prerequisites

- You must have configured at least one identity provider.
- You must have added the `cluster-admin` role to a user.
- You must be logged in as an administrator.

Procedure

- Remove the `kubeadmin` secrets:

  ```bash
  $ oc delete secrets kubeadmin -n kube-system
  ```



## References

- [How to change the password for kubeadmin in OpenShift?](https://access.redhat.com/solutions/5309141)
- [Removing the kubeadmin user](https://docs.openshift.com/container-platform/4.5/authentication/remove-kubeadmin.html#removing-kubeadmin_removing-kubeadmin)

