## OOM

> 本章主要是对OOM(out of memory)相关的一些知识做一个详细的了解与记录



## Author

```
Name: Shinefire
Blog: https://github.com/shine-fire/Ops_Notes
E-mail: shine_fire@outlook.com
```



## Introduction

内存溢出(Out Of Memory，简称OOM)是指应用系统中存在无法回收的内存或使用的内存过多，最终使得程序运行要用到的内存大于能提供的最大内存。此时程序就运行不了，系统会提示内存溢出，有时候会自动关闭软件，重启电脑或者软件后释放掉一部分内存又可以正常运行该软件，而由系统配置、数据流、用户代码等原因而导致的内存溢出错误，即使用户重新执行任务依然无法避免



## OOM异常场景





For additional information about the OOM killer please see the following artciles:
\- [How to troubleshoot Out of memory (OOM) killer in Red Hat Enterprise Linux?](https://access.redhat.com/solutions/2612861)
\- [How does the OOM-Killer select a task to kill?](https://access.redhat.com/solutions/66458)

## References

- [内存溢出百度百科](https://baike.baidu.com/item/%E5%86%85%E5%AD%98%E6%BA%A2%E5%87%BA/1430777)
- [Wiki Out of memory](https://en.wikipedia.org/wiki/Out_of_memory)
- [How to troubleshoot Out of memory (OOM) killer in Red Hat Enterprise Linux?](https://access.redhat.com/solutions/2612861)
- [How does the OOM-Killer select a task to kill?](https://access.redhat.com/solutions/66458)

