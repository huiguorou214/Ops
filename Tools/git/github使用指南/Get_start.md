# Github Start

> 本章主要介绍如何如何上手github来对自己的repository进行创建与更新

## Author

```
Name:Shinefire
Blog:https://github.com/shine-fire/Ops_Notes
E-mail:shine_fire@outlook.com
```



## Push

用户需要将自己开发的好的Ansible Playbook代码push到github中，让后续AWX直接从github中调用使用，这里介绍两种方法来将开发好的代码push到github中，第一种则是在自己的linux系统中命令行来进行操作，第二种是直接在github的web管理端操作。

如果是在自己的linux系统中开发Ansible playbook的情况，建议使用第一种方法，在Linux系统命令行来对github进行管理，有利于提高效率，并且不会受到web端上传文件数量的限制。

以下为两种操作步骤介绍

### linux command

1. 在github web端创建repository
2. 获取repository的web URL
3. 在Linux系统命令行中创建一个用于自己保存代码的目录，并用git clone命令将新建的repository到本地
4. 进入到clone到本地的repository目录中新建一个测试文件
5. 使用git命令将做了修改的文件push到github中
6. 在github web端检查修改结果

### github web

github web端的操作步骤如下：

1. web端创建repository

2. 上传代码文件到github中

3. 更新代码

   更新代码时，也跟上传代码文件类似，点击upload files后，选择要上传的文件即可，本地更新过的文件会自动覆盖旧文件以实现更新

4. 检查结果





## References

