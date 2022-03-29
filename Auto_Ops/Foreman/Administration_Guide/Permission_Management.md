# Foreman Permission Manage

> 本章主要介绍Foreman中的权限管理

## Author

```
Name:Shinefire
Blog:https://github.com/shine-fire/Ops_Notes
E-mail:shine_fire@outlook.com
```

## Introduction

Foreman通过基于roles来进行访问权限控制，所以想要赋予用户/组不同的权限，只需要分配不同的role给用户/组即可。



## Roles说明

| Ansible Roles  Manager           |                                                              |
| -------------------------------- | ------------------------------------------------------------ |
| Ansible Tower   Inventory Reader | 请求Asible Tower动态Inventory项的权限                        |
| Auditor                          | 仅查看审计日志的权限                                         |
| Bookmarks   manager              | 管理search bookmarks和更新所有公共bookmarks的权限，一般与Viewer role一起用 |
| Compliance   manager             | 赋予非管理员用户所有的合规性权限                             |
| Compliance   viewer              | 策略配置读取、查看结果和下载报表的权限                       |
| Create ARF   report              |                                                              |
| Default role                     | 默认会分配给所有用户的角色                                   |
| Edit host                        | 更新hosts信息的权限                                          |
| Edit partition   tables          | 管理分区表的权限                                             |
| Manager                          | 管理员角色，可执行更改配置外的全部操作                       |
| Organization   admin             | 管理organization之前的所有权限                               |
| Register hosts                   |                                                              |
| Remote Execution   Manager       | 管理job templates、远程操作、取消jobs和查看审计日志的权限    |
| Remote Execution   User          | 执行远程操作的权限                                           |
| Site manager                     | 主要是查看权限，已经对于机器架构方面的管理权限               |
| System admin                     | 能够管理所有资源的管理员角色                                 |
| Tasks Manager                    | 管理tasks的权限                                              |
| Tasks Reader                     | 查看tasks的权限                                              |



## 为用户和组添加roles





## 自定义Role

Foreman中





## Remote Execution Permission

参考官网：https://docs.theforeman.org/3.2/Managing_Hosts/index-foreman-el.html#permissions-for-remote-execution_managing-hosts

You can control which users can run which jobs within your infrastructure, including which hosts they can target. The remote execution feature provides two built-in roles:

- **Remote Execution Manager**: This role allows access to all remote execution features and functionality.
- **Remote Execution User**: This role only allows running jobs; it does not provide permission to modify job templates.

manager 即可执行也可以修改 job template，Execution user则是只能运行不能修改。





## References

