# Ansible培训知识点记录



[TOC]



### Ansible的优点





### ansible的并发数建议值

forks，第一看你控制多有多少资源，配置如何，是不是只用来跑ansible，跑死不影响其他应用的；另外看执行对象有多少，任务数，任务类型，线程执行方式等等

### ssh_args

ssh_args =  -o ControlMaster=auto  –o ControlPersist=5d
control_path = %(directory)s/%%r@%%h:%%p
可以复用之前已经建立的连接 ，不用每次再重复输入密码，control_path 指定了这个连接的 socket 保存的路径 

### 如何理解 **ANSIBLE_PIPELINING** 

这个参数应该是通过执行许多可能的模块而不进行实际的文件传输，可以减少在远程服务器上执行模块所需的网络操作数量，减少ssh操作数量，提高ansible在远程主机上执行模块的效率

### requiretty

sudoers中的Defaults选项requiretty要求只有拥有tty的用户才能使用sudo。可以通过visudo编辑配置文件，禁用这个选项

### ansible插件是什么

 https://blog.csdn.net/yongchaocsdn/article/details/79271870 

### paramiko

paramiko是用python语言写的一个模块，遵循SSH2协议，支持以加密和认证的方式，进行远程服务器的连接

### SSH长连接

### yum模块的installed和latest

installed检查到安装就OK了，latest会检查是否安装了目前的源里最新的版本