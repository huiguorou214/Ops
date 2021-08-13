### VMware

当前Prometheus监控VMware最常用的exporter所实现的监控指标清单。



**vm相关指标**

- vm 电源状态
- vm 启动时间
- vm cpu数量
- vm内存总量
- vm cpu最大可用量(hz)
- vm 模板



**vm guest相关指标**

- VM tools运行状态
- VM tools 版本号
- VM tools version status
- *vmware_vm_guest_disk_free*
- *vmware_vm_guest_disk_capacity*



**snapshots相关指标**

- 已存在的snapshot数量
- 创建snapshot的耗时



**Datastore相关指标**

- Datastore 容量大小
- Datastore 剩余空间大小
- VMWare Datastore uncommitted 
- VMWare Datastore provisoned
- 使用该Datastore的Host数量
- 使用该Datastore的vm数量
- Datastore 维护模式（normal / inMaintenance / enteringMaintenance）
- Datastore 类型（VMFS, NetworkFileSystem, NetworkFileSystem41, CIFS, VFAT, VSAN, VFFS）
- Datastore 是否可访问



**Host相关**

- Host 电源状态
- Host 待机模式 (entering / exiting / in / none)
- Host 连接状态 (connected / disconnected / notResponding)
- Host 维护模式状态
- Host 启动时间
- Host CPU 使用量(Mhz)
- Host CPU 总量(Mhz)
- Host CPU 数量
- Host 内存使用量(Mbytes)
- Host 内存总量(Mbytes)
- Host produce info
- Host hardware info
- Host 传感器状态 (0=red / 1=yellow / 2=green / 3=unknown)
- Host 传感器风扇转速
- Host 传感器感应温度
- Host 传感器电源电压
- Host 传感器电源电流
- Host 传感器电源功率
- Host 传感器冗余值 (1=ok / 0=ko)