# Ansible handler



## handler的作用

handler也类似于task，定义了一些任务，但是handler定义的任务是需要满足了一定的条件才会触发的。  
例如，一个ansible脚本是对nginx的配置文件进行改动，并且重启nginx  
第一次运行这个ansible脚本的时候是会改动nginx的配置文件并且重启nginx服务，但是如果是第二次执行这个ansible脚本的话，就不会再去修改配置文件，但是依然会重启nginx服务，这是我们不想看到的。使用handler即可解决这样的问题，handler设置为重启nginx服务，但是是要改动了nginx配置文件之后才会触发。

脚本示例：

```yaml
---
- hosts: test70
  remote_user: root
  tasks:
  - name: Modify the configuration
    lineinfile:
      path=/etc/nginx/conf.d/test.zsythink.net.conf
      regexp="listen(.*) 8080(.*)"
      line="listen\1 8088\2"
      backrefs=yes
      backup=yes
    notify:
      restart nginx
 
  handlers:
  - name: restart nginx
    service:
      name=nginx
      state=restarted
```



## handler的运行顺序

handler的默认运行顺序为定义handler的顺序，而不是被调用的顺序。  
实际上默认情况下，在**所有的task执行完毕之后才会执行handler**，而不是执行完某个task就立即执行handler。

如果想要执行完task立即执行handler，需要使用meta模块。

示例：

```yaml
---
- hosts: test70
  remote_user: root
  tasks:
  - name: task1
    file: path=/testdir/testfile
          state=touch
    notify: handler1
  - name: task2
    file: path=/testdir/testfile2
          state=touch
    notify: handler2
 
  - meta: flush_handlers
 
  - name: task3
    file: path=/testdir/testfile3
          state=touch
    notify: handler3
 
  handlers:
  - name: handler1
    file: path=/testdir/ht1
          state=touch
  - name: handler2
    file: path=/testdir/ht2
          state=touch
  - name: handler3
    file: path=/testdir/ht3
          state=touch
```







