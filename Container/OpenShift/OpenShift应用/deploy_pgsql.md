# 部署基于postgresql相关的应用

对于postgres镜像，可以考虑使用statefulset加上pv来做





## Q&A

Q1：

在Docker中运行postgres镜像是指定`POSTGRES_PASSWORD`这个变量变量即可正常运行起来的。

但是在openshift里面如果直接创建一个postgres的pod的话，传递了密码变量也会直接报错

```
chmod: changing permissions of '/var/lib/postgresql/data': Operation not permitted
chmod: changing permissions of '/var/run/postgresql': Operation not permitted
The files belonging to this database system will be owned by user "1000610000".
This user must also own the server process.

The database cluster will be initialized with locale "en_US.utf8".
The default database encoding has accordingly been set to "UTF8".
The default text search configuration will be set to "english".

Data page checksums are disabled.

fixing permissions on existing directory /var/lib/postgresql/data ... initdb: error: could not change permissions of directory "/var/lib/postgresql/data": Operation not permitted
```

A：

参考：https://github.com/docker-library/postgres/issues/361







## Reference

- [chmod: changing permissions of 'var/lib/postgresql/data': Permission denied](https://github.com/docker-library/postgres/issues/116)
- [chown: changing ownership of ‘/var/lib/postgresql/data’: Operation not permitted, when running in kubernetes with mounted "/var/lib/postgres/data" volume](https://github.com/docker-library/postgres/issues/361)

