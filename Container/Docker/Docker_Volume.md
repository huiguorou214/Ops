## Docker Volume





### Usages



#### 挂载Volume

指定Container中的路径挂载宿主机的`/var/lib/docker/volumes/xxx.../_data`目录

```bash
[root@docker-test ~]# docker run -d -P --name web_test1 -v /usr/local/apache2/htdocs/ httpd:latest
155ef92aa0f6a5f3282a3be52cb3ef201de2c4655365e29497ae0a087d954ceb
[root@docker-test ~]# docker inspect 155ef92aa0 |jq .[]."Mounts"
[
  {
    "Type": "volume",
    "Name": "7b5d720e9359ac55d3e45acd3e04936122d00beacbb0a36590e70da6855053b0",
    "Source": "/var/lib/docker/volumes/7b5d720e9359ac55d3e45acd3e04936122d00beacbb0a36590e70da6855053b0/_data",
    "Destination": "/usr/local/apache2/htdocs",
    "Driver": "local",
    "Mode": "",
    "RW": true,
    "Propagation": ""
  }
]
```



指定宿主机上的目录挂载到container的指定路径下：

```bash
[root@docker-test ~]# docker run -d -P --name web_test2 -v /opt/web_test2:/usr/local/apache2/htdocs/ httpd:latest
96cbb758f87f8b0ee75e15540a4d6205e2639b8778f79bac7ee8a9aff580dfdf
[root@docker-test ~]# docker inspect 96cbb7 |jq .[]."Mounts"
[
  {
    "Type": "bind",
    "Source": "/opt/web_test2",
    "Destination": "/usr/local/apache2/htdocs",
    "Mode": "",
    "RW": true,
    "Propagation": "rprivate"
  }
]
```



指定宿主机上的目录挂载到container的指定路径下，并设置为ro只读模式，默认情况是rw模式

**ro只读模式**，容器无法修改目录中的内容

```bash
[root@docker-test ~]# docker run -d -P --name web_test3 -v /opt/web_test3:/usr/local/apache2/htdocs/:ro httpd:latest
3ec3825e3ca53fcab2a9b47cb04cd373deb5046198bdda95d482097f325ca7de
[root@docker-test ~]# docker inspect 3ec382 |jq .[]."Mounts"                                  [
  {
    "Type": "bind",
    "Source": "/opt/web_test3",
    "Destination": "/usr/local/apache2/htdocs",
    "Mode": "ro",
    "RW": false,
    "Propagation": "rprivate"
  }
]

[root@docker-test ~]# docker exec -it 3ec3825 /bin/bash
root@3ec3825e3ca5:~# touch /usr/local/apache2/htdocs/file1
touch: cannot touch '/usr/local/apache2/htdocs/file1': Read-only file system
```



#### 删除Volume

数据卷是被设计用来持久化数据的，它的生命周期独立于容器，所以容器被删除后是不会自动删除volume的

如果在删除容器的时候想要一起删除volume，则需要加上 -v 参数，例如：

```bash
[root@docker-test ~]# docker rm -fv web_test1
```



#### 数据卷容器

数据卷容器用于容器之间的数据共享





