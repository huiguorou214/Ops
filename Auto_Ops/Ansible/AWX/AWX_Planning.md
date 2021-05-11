# AWX Planning

[TOC]

## 一、部署规划

### AWX Server

需要使用docker来进行部署

#### Environment

| items       | value               |
| ----------- | ------------------- |
| OS Version  | CentOS7.8           |
| hostname    | awx.cn.wal-mart.com |
| IP          |                     |
| AWX Version |                     |
| Docker-CE   |                     |
| Python      |                     |
| Git Version |                     |

ssh key

### 客户端

**satellite管理的机器**

通过原有的Ansible服务器运行playbook传输awx的key来建立ssh互信。

**CentOS主机**

存量主机：通过原有的Ansible服务器运行playbook传输awx的key来建立ssh互信

新增主机：通过在模板/镜像中加入AWX主机的key



## 二、AWX的优势

### 背景

在当前的环境中，使用Ansible Engine来作为自动化运维管理平台。在使用Ansible Engine来进行管理的过程中，遇到了以下一些问题：

- 不同的成员在使用过程中，存在各自在自己的用户目录下创建使用playbook的情况；
- 无法控制成员对playbook的修改与使用；
- 不同成员执行playbook时，会使用不同的inventory，会导致inventory变得更为复杂，也不便于管控；
- 不同成员开发可能会开发功能类似的playbook，导致不必要的浪费；

### AWX

在使用AWX之后，通过AWX平台化管理使团队在使用ansible的行为更加规范，通过团队协作更进一步提高团队的自动化运维效率。

以下方法来体现：

- 将所有的playbook存放在AWX平台进行集中管理，避免成员间分散使用且在不知情的情况下重复开发功能类似的playbook；
- 在AWX平台中，通过基于role来进行权限控制，对不同的成员/组控制对不同playbook的使用；
- 将所有的inventory主机名清单集中存放在AWX中，通过分类分组进行管理与维护，在执行playbook时可以直接选择一份或者多份主机名清单进行快速调用；
- 通过AWX的job功能，能看到其他成员所运行的job以及状态，能够让不同的成员之间通过awx平台更直观的发现其他成员在执行job的情况和协助解决执行job中遇到的问题；
- 通过日志记录功能，在遇到问题时，可以通过查看谁在哪个时间点做了什么操作来快速的定位问题；



## 三、规范指引

用户在AWX中的使用规范通过权限控制与用户使用规范手册两个方面来进行约束。

### 3.1 用户使用规范

#### 用户权限管理

普通用户只能使用playbook，不能做任何修改，也不能上传playbook，上传内容需要管理员来审核。

### 3.2 资源共享规范

#### playbook

##### 流程规范

1. 内容，功能评审，可以设置几个指标来考虑审核playbook；
2. 由管理员从git或者本地添加到平台中；
3. 其他成员只有使用的功能而无法对playbook进行修改；
4. 成员在使用过程中遇到的异常时，可以请求开发成员及时在AWX进行排错解决问题；
5. playbook中存在的异常及优化建议都应该及时向开发成员/管理员反馈，让开发成员在时间范围内对问题进行修复或功能优化；
6. 由管理员在AWX平台对playbook进行迭代更新；

##### 代码规范

1. 需要在README中注明版本号、开发成员、完成日期、功能说明、使用说明、适用范围、注意事项等；
2. playbook中的变量需要有解释说明；
3. 尽量以实现单一功能为目标开发，便于后续在AWX平台中更灵活的组合多个playbook来使用；
4. task必须尽量使用ansible自带的module来替代自己的shell命令；
5. playbook命名规范；

#### inventory

1. Inventory权限控制，都可以基于role权限控制来实现管理；
2. inventory分类，参照主机名分类的规则，**所属环境 ---- 所属应用 ---- 功能**。