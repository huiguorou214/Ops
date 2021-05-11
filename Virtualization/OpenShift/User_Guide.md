# User Guide

### 用户管理

#### 用户登录

登录到默认的openshift中：

```
$ oc login -u USERNAME -p PASSWORD
```

登录到指定的openshift中：

```
$ oc login https://api.apps.prod01.gd.bank-of-china.com:6443 -u USERNAME -p PASSWORD
```



#### 用户登出

```
$ oc logout
```



#### 查看当前用户

```
$ oc whoami
```



### 集群节点管理

#### 查看集群节点信息

```
$ oc get nods
```



#### 查看节点资源使用率

查看所有节点的资源使用率

```
$ oc adm top nodes
```

输出示例：

```
NAME       CPU(cores)   CPU%      MEMORY(bytes)   MEMORY%
node-1     297m         29%       4263Mi          55%
node-0     55m          5%        1201Mi          15%
master-0   178m         8%        2584Mi          16%
```



查看容器的资源使用情况

查看当前project中的pod资源使用情况

```
$ oc adm top pods
```

查看指定project中的pod资源使用情况

```
$ oc adm top pods -n openshift-console
```

查看所有pods的资源使用情况

```
$ oc adm top pods -A
```



#### 登录节点

在bastion节点中可以免密登陆各个master和node节点的core用户

```
$ ssh core@node01
```



### project管理

#### 查询project

查看当前所在的project

```
$ oc project
```

查看所有的project(会在当前所在的project名称前面显示一个*符号)

```
$ oc projects
```



#### 创建project

创建一个名为`hello-openshift`的project

```
$ oc new-project hello-openshift
```



#### 删除project

删除名为`hello-openshift`的project

```
$ oc delete project hello-openshift
```



#### 切换project

切换到`openshift-config`这个project中

```
$ oc project openshift-config
```



### 容器管理

#### 查看容器列表

查看当前project中的pod

```
$ oc get pod
```

查看指定project中的pod，例如查看`openshift-console`这个project中的pod

```bash
$ oc get pod -n openshift-console
```

查看整个openshift平台中的所有pod

```
$ oc get pod -A
```



#### 查看容器配置信息

查看指定pod的配置信息

```
$ oc describe pod/console-2938edse83-dcc72
```



#### 扩缩容容器数量

可以根据实际需求增加或者减少容器的数量以适应业务需求

获取deployment信息

```
$ oc get deployment
```

edit pod对应的deployment修改`spec: replicas`参数来指定pod数量为2

```
$ oc edit deployment/console
spec: 
  replicas: 2
```

查看修改后的pod数量

```
$ oc get pods 
```



### 标签管理

#### 给节点打标签

查看节点master01中的所有标签

```
$ oc describe node master-0.prod01.gd.bank-of-china.com
```

查看Labels部分即是master01中当前包含的标签



为节点master01修改标签

```
$ oc edit node master-0.prod01.gd.bank-of-china.com
```

修改`Labels:`部分的内容即可为节点增加新的标签或者删除现有的标签



#### 给容器打标签

查看pod中的所有标签

```
$ oc describe pod console-34589sdf-sdlkfjd
```

查看Labels部分即是该容器中当前包含的标签



为节点master01修改标签

```
$ oc edit pod console-34589sdf-sdlkfjd
```

修改Labels部分的内容即可为pod增加新的标签或者删除现有的标签



### 容器部署管理

#### 从镜像部署容器





