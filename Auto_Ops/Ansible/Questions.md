# Questions

**question**：

各种操作系统版本，ansible版本情况下ansible连接客户端的方式及原理等，

answer：



**question**：

在inventory文件中，组下面的主机中间空行会有影响吗？例如：

```
[TEST]
10.0.0.1

10.0.0.2
```

answer：没影响，还是会把10.0.0.2纳入到这个group里



**question**：

在inventory中，一个主机同时属于两个组的时候，如果一个操作对两个组都生效，并且这个操作会冲突，那么以谁为准？

answer：



**question**：

通过ansible操作客户端机器的时候，如何才能直接使用客户端机器设置的环境变量？

我参考了博客：https://blog.csdn.net/u010871982/article/details/78525367 里面提到了login shell与non-login shell，我根据里面的方式进行测试，在client端的"/etc/profile"中加入了"export AAA=$((AAA+1))"，在"/etc/bashrc"中加入了"export AAA=$((AAA+10))"，客户端已经生效了的

[root@ansible-client1 ~]# echo $AAA
11

但是如果通过ansible-server端来操作的话，查看"echo $AAA"还是无效，如下：  
[root@ansible-server playbooks]# ansible -i inventory all -m command  -a "echo $AAA"  
192.168.31.72 | CHANGED | rc=0 >>  
[root@ansible-server playbooks]# ansible -i inventory all -m shell  -a "echo $AAA"  
192.168.31.72 | CHANGED | rc=0 >>

answer：

在playbook里面可以直接用，但是如果是在ad-hoc里面的话，需要加上转义符才能生效，不然直接解析server端的变量去了...

[root@ansible-server playbooks]# ansible -i inventory all -a "echo \$AAA"  
192.168.31.72 | CHANGED | rc=0 >>  
10



：

answer：



**question**：

如果remote_user为非root用户的时候，通过sudo来使用root的环境变量好像并不能达到和root一样的效果，这种情况该如何处理比较合适呢？

ansible-client机器中，给一个非root的普通用户apt加了sudoers配置项："apt     ALL=(ALL)       ALL"

直接在ansible-client机器中使用apt用户进行一个root中设置好的变量输出，能够输出成功

```
[root@ansible-client1 sudoers.d]# sudo echo $AAA
11
```

但是如果在ansible-server中的playbook中，写了相关的变量输出的话是不行的，

answer：



**question**：

differences follow：

include_tasks
include
import
import_tasks

answer：





**question**：

answer：