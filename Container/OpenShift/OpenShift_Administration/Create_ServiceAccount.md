# OpenShift 创建 ServiceAccount 操作指引



## 文档说明

本文档是在 OpenShift 中创建一个用于调用 API 接口使用的 ServiceAccount 的操作指引



## 操作步骤

下面以在 ds-test 项目中创建一个名为 ds-viewer 用户为例，实际创建时请根据实际需求命名。



在 ds-test namespace 中创建一个 ServiceAccount

```bash
~]$ oc create sa -n ds-test ds-viewer
```



查看创建后的结果

```bash
~]$ oc describe sa ds-viewer -n ds-test
Name:                ds-viewer
Namespace:           ds-test
Labels:              <none>
Annotations:         <none>
Image pull secrets:  ds-viewer-dockercfg-8qwzp
Mountable secrets:   ds-viewer-token-4phzz
                     ds-viewer-dockercfg-8qwzp
Tokens:              ds-viewer-token-4phzz
                     ds-viewer-token-sst8x
Events:              <none>
```



创建一个在 ds-test 这个 namespace 中对 pod 资源拥有 get 和 list权限的名为 ds-viewer-role 的 role

```bash
~]$ oc create role ds-viewer-role --verb=get,list --resource=pod -n ds-test
```



为新建的用户 ds-viewer 绑定 ds-viewer-role 角色

```bash
~]$ oc policy add-role-to-user ds-viewer-role --role-namespace=ds-test -z ds-viewer -n ds-test
```



获取 token 详情

```bash
~]$ oc sa get-token ds-viewer -n ds-test
eyJhbGciOiJSUzI1NiIsImtpZCI6IkpUbVRwczhHVWhoT3otZURxcEZTVUJvZ2tJNENlYlZXV3dqUXpXTXNsRk0ifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkcy10ZXN0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImRzLXZpZXdlci10b2tlbi00cGh6eiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJkcy12aWV3ZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiI3MGRhZjUxZC01MzM3LTQzMmMtOGRlYy0yMzUwOGZmZWUwYzQiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6ZHMtdGVzdDpkcy12aWV3ZXIifQ.YPZDsGwXP4GUkmcj8CrqmWxQcfsLwp1zyqsg_Uw3CXlppT9A4kfPpLuTVyt6Ma0map5X9g2m-YEmZz7yH7uEs0CUFFumWO9HlX-FEsrTLEdUzc9Q_t48WZGm1HmCLFUlv9NN4zxPXNwS8fd4bEIjvsL8XSPqFF2fd47obExLSaq8cIjuL5OnuYknL8z179lRzTeyDQW49YwuD9FgUTf0vEnJEX4_ayg10SQ8bEw0sd0tVLVCyGtPfoYlsgr_cV1e0X0bsxdw7KZlFNySdf68Wax6EY5Nt0vXvqIKwXNX9e3y6Vjh9cLmmoZsXfdaZnb5LHvSfhgkRYoXAOQBUs6zYg
```

记录查看到的 token 这一长串字符提供给开发人员调用 API 使用即可



## 其他说明

关于 ServiceAccount ，如果删除了 namespace 的话，会一起把 namespace 内的所有 ServiceAccount 一并删除。
