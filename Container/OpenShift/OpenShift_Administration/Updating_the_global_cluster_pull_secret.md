# Updating the global cluster pull secret

在特别的一种情况下，比如说要替换镜像仓库的时候，可以参考此文档对 OpenShift 安装时候设置的镜像仓库进行替换。



You can update the global pull secret for your cluster by either replacing the current pull secret or appending a new pull secret.

> Cluster resources must adjust to the new pull secret, which can temporarily limit the usability of the cluster.



Prerequisites

- You have access to the cluster as a user with the `cluster-admin` role.

Procedure

1. Optional: To append a new pull secret to the existing pull secret, complete the following steps:

   1. Enter the following command to download the pull secret:

      ```bash
      $ oc get secret/pull-secret -n openshift-config --template='{{index .data ".dockerconfigjson" | base64decode}}' ><pull_secret_location> 
      ```

      > Provide the path to the pull secret file

   2. Enter the following command to add the new pull secret:

      ```bash
      $ oc registry login --registry="<registry>" \ 
      --auth-basic="<username>:<password>" \ 
      --to=<pull_secret_location> 
      ```

      > - Provide the new registry
      > - Provide the credentials of the new registry
      > - Provide the path to the pull secret file.

      Alternatively, you can perform a manual update to the pull secret file.

2. Enter the following command to update the global pull secret for your cluster:

   ```bash
   $ oc set data secret/pull-secret -n openshift-config --from-file=.dockerconfigjson=<pull_secret_location> 
   ```

   > Provide the path to the new pull secret file.

   This update is rolled out to all nodes, which can take some time depending on the size of your cluster.

   > **As of OpenShift Container Platform 4.7.4, changes to the global pull secret no longer trigger a node drain or reboot.**





## reference

- https://docs.openshift.com/container-platform/4.8/post_installation_configuration/cluster-tasks.html#images-update-global-pull-secret_post-install-cluster-tasks