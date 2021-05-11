# AWX_Administration_Guide



## Users

用户权限类型：

- **Normal User**: Normal Users have **read and write** access limited to the resources (such as inventory, projects, and job templates) for which that user has been granted the appropriate roles and privileges.
- **System Auditor**: Auditors implicitly inherit the **read-only** capability for all objects within the Tower environment.
- **System Administrator**: A Tower System Administrator (also known as Superuser) has **full system administration privileges** for Tower – with full read and write privileges over the entire Tower installation. A System Administrator is typically responsible for managing all aspects of Tower and delegating responsibilities for day-to-day work to various Users. Assign with caution!



## Resources

Resources的管理简述。

- 普通用户不能自行添加资源，只能由管理员添加资源
- 普通用户被授权之后，可以根据权限访问/使用/修改资源
- 审计角色成员，能只读访问所有资源，但是不能做任何修改
- 系统管理级别成员，可以和admin一样做任何修改





## Integrate AD

