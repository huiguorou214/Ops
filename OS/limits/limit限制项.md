# Title

> 本章主要介绍rhel中的ulimit所限制的shell启动进程所占用的资源类型。

## Author

```
Name:Shinefire
Blog:https://github.com/shine-fire/Ops_Notes
E-mail:shine_fire@outlook.com
```

## 资源类型

### 查看资源限制

ulimit用于限制 shell 启动进程所占用的资源，`ulimit -a`可用来查询所有限制的资源类型的设置值。

例如：

```bash
[root@nuc ~]# ulimit -a
core file size          (blocks, -c) 0
data seg size           (kbytes, -d) unlimited
scheduling priority             (-e) 0
file size               (blocks, -f) unlimited
pending signals                 (-i) 127418
max locked memory       (kbytes, -l) 64
max memory size         (kbytes, -m) unlimited
open files                      (-n) 1024
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) 819200
real-time priority              (-r) 0
stack size              (kbytes, -s) 8192
cpu time               (seconds, -t) unlimited
max user processes              (-u) 127418
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited
```

### ulimit查看的资源类型与ulimit设置项对应表

| limits设置项 | ulimit显示项         |
| ------------ | -------------------- |
|              | core file size       |
|              | data seg size        |
|              | scheduling priority  |
|              | file size            |
|              | pending signals      |
|              | max locked memory    |
|              | max memory size      |
| nofile       | open files           |
|              | pipe size            |
|              | POSIX message queues |
|              | real-time priority   |
|              | stack size           |
|              | cpu time             |
| nproc        | max user processes   |
|              | virtual memory       |
|              | file locks           |



### core file size



### data seg size



### scheduling priority



### file size



### pending signals



### max locked memory



### max memory size



### open files

文件打开数，

### pipe size



### POSIX message queues



### real-time priority



### stack size



### cpu time



### max user processes

用户可以开启进程/线程的最大数目

### virtual memory



### file locks



## References

- 如何验证 ulimit 中的资源限制？如何查看当前使用量？https://feichashao.com/ulimit_demo/

