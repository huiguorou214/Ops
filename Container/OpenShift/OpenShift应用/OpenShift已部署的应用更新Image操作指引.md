# OpenShift已部署的应用更新Image操作指引

本文为 OpenShift 中对已经部署在使用的应用进行 Image 更新的操作指引，以 eureka 这个镜像为例进行说明



### 推送新版本的Image到镜像仓库

在开发人员交付新版本的Image之后，进入到该机器中，登录测试环境现在的镜像仓库

```bash
~]$ docker login -u core registry.ocp4.example.com:5000
```

将新版本的Image推送到OpenShift测试环境的镜像仓库中，推送操作如下：

```bash
~]$ docker tag ds-eureka-svr:1.1 registry.ocp4.example.com:5000/ds-test/ds-eureka-svr:1.1
~]$ docker push registry.ocp4.example.com:5000/ds-test/ds-eureka-svr:1.1
```



### 更新应用使用新版本的Image

新版本的 Image 推送到镜像仓库后，登录 bastion 节点，修改 deployment.yaml 文件的 Deployment 类型的 spec.template.spec.containers.image 的值，将image修改为新版本的 image 地址

例如修改原来的 registry.ocp4.example.com:5000/ds-test/ds-eureka-svr:latest 为 registry.ocp4.example.com:5000/ds-test/ds-eureka-svr:1.1

如下所示：

```yaml
---
apiVersion: v1
kind: Namespace
metadata: 
  name: ds-test

---
apiVersion: apps/v1
kind: Deployment
metadata: 
  name: ds-eureka-svr
  namespace: ds-test
spec:
  replicas: 1
  selector: 
    matchLabels:
      app: ds-eureka-svr
  template: 
    metadata: 
      labels:
        app: ds-eureka-svr
    spec: 
      containers: 
      - name: ds-eureka-svr
        image: registry.ocp4.example.com:5000/ds-test/ds-eureka-svr:1.1
        imagePullPolicy: Always
      ports: 
        containerPort: 8761

---
apiVersion: v1
kind: Service
metadata:
  name: eureka
  namespace: ds-test
spec: 
  selector: 
    app: ds-eureka-svr
  type: ClusterIP
  ports: 
    - name: http
      port: 8761
      targetPort: 8761

---
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: data
  namespace: ds-test
spec:
  host: eureka-ds-test.apps.ocp4.example.com
  port:
    targetPort: http
  to:
    kind: Service
    name: eureka
    weight: 100
  wildcardPolicy: None
```



配置文件修改完毕后，重新 apply 让新的配置生效

```bash
~]$ oc apply -f deployment-ds-eureka-svr.yaml
```



查看并记录新创建的 pod NAME

```bash
~]$ oc get pods -n ds-test
```



检查新创建的 pod 是否使用新版本的Image

```bash
~]$ oc describe pod ds-eureka-svr -n ds-test | grep Image
```

