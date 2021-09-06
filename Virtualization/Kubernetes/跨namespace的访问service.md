# 跨namespace的service访问







核心：使用externalName来实现跨namespace的service访问

```bash
[root@k8s-master cross_ns]# cat svc_ExternalName_visit.yaml 
# 实现 myns 名称空间的pod，访问 mytest 名称空间的Service：myapp-clusterip2
apiVersion: v1
kind: Service
metadata:
  name: myapp-clusterip1-externalname
  namespace: myns
spec:
  type: ExternalName
  externalName: myapp-clusterip2.mytest.svc.cluster.local
  ports:
  - name: http
    port: 80
    targetPort: 80
---
# 实现 mytest 名称空间的Pod，访问 myns 名称空间的Service：myapp-clusterip1
apiVersion: v1
kind: Service
metadata:
  name: myapp-clusterip2-externalname
  namespace: mytest
spec:
  type: ExternalName
  externalName: myapp-clusterip1.myns.svc.cluster.local
  ports:
  - name: http
    port: 80
    targetPort: 80
```





## References

- [Kubernetes K8S之Pod跨namespace名称空间访问Service服务](https://cloud.tencent.com/developer/article/1718427)

