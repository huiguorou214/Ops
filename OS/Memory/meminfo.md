##  /proc/meminfo 详解

> 本章是以rhel7的操作系统中对 /proc/meminfo 这个文件内容的一个理解，



## Author

```
Name: Shinefire
Blog: https://github.com/shine-fire/Ops_Notes
E-mail: shine_fire@outlook.com
```



## meminfo是什么

/proc/meminfo这个文件主要是用来保存系统内存相关的各项数据，可以通过这个文件来直观的查看系统内存的使用情况

另外也可以在一些排故的情况中，使用meminfo文件来帮助故障排查。



## meminfo字段详解

meminfo文件示例：

```
MemTotal:       32811608 kB
MemFree:          345668 kB
MemAvailable:   16259092 kB
Buffers:              28 kB
Cached:         17371904 kB
SwapCached:        46932 kB
Active:         19873608 kB
Inactive:       10647484 kB
Active(anon):   11843584 kB
Inactive(anon):  2987032 kB
Active(file):    8030024 kB
Inactive(file):  7660452 kB
Unevictable:       19260 kB
Mlocked:           18836 kB
SwapTotal:       4194300 kB
SwapFree:        3158576 kB
Dirty:                48 kB
Writeback:             0 kB
AnonPages:      13140756 kB
Mapped:           107292 kB
Shmem:           1672292 kB
Slab:             756652 kB
SReclaimable:     629752 kB
SUnreclaim:       126900 kB
KernelStack:        6576 kB
PageTables:        47460 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    20600104 kB
Committed_AS:   26984944 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      643216 kB
VmallocChunk:   34358423548 kB
Percpu:             2016 kB
HardwareCorrupted:     0 kB
AnonHugePages:    122880 kB
CmaTotal:              0 kB
CmaFree:               0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:      482172 kB
DirectMap2M:    16160768 kB
DirectMap1G:    16777216 kB
```











## References



