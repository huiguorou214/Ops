# Inventory管理



## 批量导入inventory

批量导入inventory有以下几种方法：

- 从project中批量导入
- 命令行批量导入
- 本地inventory文件批量导入



### 从Project中导入



### 命令行批量导入

### 1.1.1 批量导入hosts

在AWX中新建一个INVENTORY：

![img](file:///C:/Users/ADMINI~1/AppData/Local/Temp/msohtmlclip1/01/clip_image002.gif)

Ansible AWX支持使用自带的命令行工具awx-manage从本地的inventory文件中批量导入主机。

连接到awx_task容器中执行相应的命令，如下：

```bash
$ sudo docker exec -it awx_task awx-manage inventory_import   --source=/var/lib/awx/projects/inventories/inventory_test   --inventory-name "Import Inventory Test"
```



![img](file:///C:/Users/ADMINI~1/AppData/Local/Temp/msohtmlclip1/01/clip_image004.gif)

![img](file:///C:/Users/ADMINI~1/AppData/Local/Temp/msohtmlclip1/01/clip_image006.gif)

在AWX中检查导入后的结果，查看INVENTORY的HOSTS内容，如下图可见已经批量添加成功：

![img](file:///C:/Users/ADMINI~1/AppData/Local/Temp/msohtmlclip1/01/clip_image008.gif)



## 集成Foreman

Ansible AWX可以通过集成Foreman/Satellite，从而可以直接同步主机清单资源到AWX中，供后续执行template调用inventory使用。





## References

- awx中批量导入主机 [http://www.jiangjiang.space/2019/04/04/awx%e4%b8%ad%e6%89%b9%e9%87%8f%e5%af%bc%e5%85%a5%e4%b8%bb%e6%9c%ba/](http://www.jiangjiang.space/2019/04/04/awx中批量导入主机/)
- ansible tower 实战使用详解 https://kionf.com/2018/11/21/tower-useage/
- Satellite and Ansible Tower integration part 1: Inventory integration https://www.redhat.com/zh/blog/satellite-and-ansible-tower-integration-part-1-inventory-integration
- Satellite and Ansible Tower Integration part 2: Provisioning callbacks https://www.redhat.com/zh/blog/satellite-and-ansible-tower-integration-part-2-provisioning-callbacks?source=bloglisting&page=8