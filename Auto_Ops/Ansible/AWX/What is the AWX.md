# What is the AWX Project

## AWX介绍

### AWX是什么

Ansible AWX 是 Anisble Tower 的开源版本。和 Ansible Tower 一样，是团队协作的运维工具，它具备集中调度，可视化，基于角色的访问控制能力。

![1597045504998](AWX%E8%87%AA%E5%8A%A8%E5%8C%96%E7%AE%A1%E7%90%86%E5%B9%B3%E5%8F%B0.assets/1597045504998.png)

### Views

一些图形界面：https://docs.ansible.com/ansible-tower/latest/html/userguide/main_menu.html



在Ansible基础上，提供如下具体面向业务逻辑运维功能：

- WebUI管控界面
- 基于角色权限的控制使用，集成LDAP等
- 定时执行特定任务
- 实时job结果更新
- 日常操作审计记录
- 操作结果通知
- RESTful API，二次开发



awx本身的使用规范，统一管理，避免了在平常使用ansible中可能出现不同的成员重复开发问题，降低了ansible的使用成本。

awx的job结果也能让不同的成员之间通过awx平台更直观的发现和解决其他成员在执行job的情况和执行job中遇到的问题。

awx平台中资源的使用规范化，例如playbook规范化，在编写好的playbook中应该要有类似readme之类的详细说明信息，来达到让其他人更加方便的使用已有的playbook，通过协同办公来提高运维的效率。





## 要求

### 虚拟机一台

信息如下

- FQDN：awx.shinefire.com

### 系统要求

The system that runs the AWX service will need to satisfy the following requirements：

- At least 4GB of memory
- At least 2 cpu cores
- At least 20GB of space
- Running Docker, Openshift, or Kubernetes
- If you choose to use an external PostgreSQL database, please note that the minimum version is 10+.



## Support



## Other

### 关于AWX升级

AWX不支持直接升级，但是可以使用tower-cli工具将数据迁移到不同版本的AWX中。

### AWX FAQ

https://www.ansible.com/products/awx-project/faq

