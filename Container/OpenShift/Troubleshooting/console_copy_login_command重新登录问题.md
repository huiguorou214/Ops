# OpenShift Copy Login Command 重新登录问题





## 问题描述

在使用非 kubeadmin 用户登录 console 后，点击右上角的用户按钮 --> 选择 `Copy login command` 的时候，会再打开一个登录窗口再次提示登录，只有再次登录成功后，才可以获取到该用户的 token。





## 解决方案

比对两个登录 url 

在默认登录 OpenShift Console 的时候，url 是下面这样的最后的 `state` 是随机字符串的：

```
https://oauth-openshift.apps.ocp4.shinefire.com/oauth/authorize?client_id=console&redirect_uri=https%3A%2F%2Fconsole-openshift-console.apps.ocp4.shinefire.com%2Fauth%2Fcallback&response_type=code&scope=user%3Afull&state=957f5cba
```

在点击 `Copy login command` 的时候打开的新登录界面，url是固定下面这样的

```
https://oauth-openshift.apps.ocp4.shinefire.com/oauth/authorize?client_id=openshift-browser-client&redirect_uri=https%3A%2F%2Foauth-openshift.apps.ocp4.shinefire.com%2Foauth%2Ftoken%2Fdisplay&response_type=code
```

解码：

```
https://oauth-openshift.apps.ocp4.shinefire.com/oauth/authorize?client_id=openshift-browser-client&redirect_uri=https://oauth-openshift.apps.ocp4.shinefire.com/oauth/token/display&response_type=code
```



https://oauth-openshift.apps.ocp4.shinefire.com/oauth/token/request

https://oauth-openshift.apps.ocp4.shinefire.com/oauth/token/display





个人理解：

这可能意味着，在使用 `Copy login command` 的时候，相当于是进行的一个新的操作，即获取用户的 token，从而需要重新登录来选定用户，其实这一步更像是你虽然是用当前的用户A点击的 `Copy login command` ，但是你后续可以自行决定使用哪个用户的token，而这个选择的过程就是新打开的登录界面。



参考：

https://access.redhat.com/solutions/4936491