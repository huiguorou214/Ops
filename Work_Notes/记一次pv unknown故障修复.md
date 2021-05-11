在PV上重复创建分区的异常问题修复

### 问题现象

使用pvs命令发现之前做成了PV的设备`/dev/sdc`变成了`[unknown]`的这种异常情况出现在了系统中。

![1608714510647](%E8%AE%B0%E4%B8%80%E6%AC%A1pv%20unknown%E6%95%85%E9%9A%9C%E4%BF%AE%E5%A4%8D.assets/1608714510647.png)

这个异常情况会影响到后续分区的读写，并且在测试环境中复现了此异常情况，发现测试环境进行重启后发现无法进入正常启动系统。

### 问题原因

由于之前的不规范操作，将`/dev/sdc`设备在未分区的情况下直接制作成pv并加入到了vg中使用，导致查看磁盘设备的时候，难以发现`/dev/sdc`设备已经是被使用了。所以误导了这次对`/dev/sdc`重复进行分区并划分了`/dev/sdc1`分区的误操作发生。

### 解决方案

由于操作人员在分区后就马上发现了异常，没有进行后续对分区的格式化，所以实际上还没有影响到数据的，可以使用下面的方案来尝试修复异常。

1. 使用fdisk将之前的`/dev/sdc1`分区删除

2. 使用partprobe命令刷新分区表

   ```bash
   # partprobe
   ```

3. 重启或者停止`lvm2-lvmetad.service`，让系统再次执行磁盘扫描查找所有相关物理卷，并读取卷组元数据的操作。

   ```bash
   # systemctl restart lvm2-lvmetad.service
   ```

   服务详情说明：https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/7/html/logical_volume_manager_administration/metadatadaemon

4. 再次使用pvs检查，看`[unknown]`是否已经变成了正常的`/dev/sdc`

   ```bash
   # pvs
   ```