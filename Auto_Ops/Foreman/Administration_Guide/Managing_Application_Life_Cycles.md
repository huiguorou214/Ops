# Managing Application Life Cycles











## Content View





注意事项：

参考官方：[Resolving Package Dependencies](https://docs.theforeman.org/3.2/Content_Management_Guide/index-katello.html#Resolving_Package_Dependencies_content-management)

If you add a filter that excludes some packages that are required and the Content View has dependency resolution enabled, Foreman ignores the rules you create in your filter in favor of resolving the package dependency.

依赖解决的功能优先级会高于 content 的 filter 功能，如果勾选了依赖功能，会优先为了解决一些能解决的依赖功能而取消会有影响的 filter rule。 







## 多个 Foreman Servers 的 Content 同步方法

参考：[Synchronizing Content Between Foreman servers](https://docs.theforeman.org/3.2/Content_Management_Guide/index-katello.html#Synchronizing_Content_Between_Servers_content-management)









## References

- Managing Application Life Cycles：https://docs.theforeman.org/3.2/Content_Management_Guide/index-katello.html#Creating_an_Application_Life_Cycle_content-management

