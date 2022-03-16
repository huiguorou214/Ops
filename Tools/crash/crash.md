# crash



## Author

```
Name: Shinefire
Blog: https://github.com/shine-fire/Ops_Notes
E-mail: shine_fire@outlook.com
```



## Introduction

项目 github 地址： https://github.com/crash-utility/crash

当 linux 系统内核发生崩溃的时候，可以通过 kdump 等方式收集内核崩溃之前的内存，生成一个转储文件 vmcore。内核开发者通过分析该 vmcore 文件就可以诊断出内核崩溃的原因，从而进行操作系统的代码改进。那么 crash 就是一个被广泛使用的内核崩溃转储文件分析工具，掌握 crash 的使用技巧，对于定位问题有着十分重要的作用。



## 分析 core dump

### 安装 crash 套件

安装 crash 包

```
yum install crash
```



安装 kernel-debuginfo

In addition to **crash**, it is also necessary to install the **kernel-debuginfo** package that corresponds to your running kernel, which provides the data necessary for dump analysis. To install **kernel-debuginfo** we use the `debuginfo-install` command as `root`:

```bash
yum install kernel-debuginfo-$(uname -r)
```

相当于下面的这个命令（尽量不要使用下面的命令，除非是本机生成的vmcore，因为如果和vmcore里面的kernel版本对不上的话，后面也可能打不开）

```bash
debuginfo-install kernel
```

**说明：**这一步执行会自动安装一个debug的包，这个包的所在 repository 是 `rhel-7-server-debug-rpms` ，还挺大的，所以如果想要安装的话，还需要订阅这个源或者拿到这个源里面所提供的rpm包用 yum 来安装会比较方便。



### 打开一个vmcore

安装好crash套件后，用下面的命令打开一个vmcore

```bash
crash /usr/lib/debug/lib/modules/3.10.0-1160.el7.x86_64/vmlinux vmcore
```

输出预期类似如下：

```bash
]# crash /usr/lib/debug/lib/modules/3.10.0-1160.el7.x86_64/vmlinux vmcore

crash 7.2.3-11.el7_9.1
Copyright (C) 2002-2017  Red Hat, Inc.
Copyright (C) 2004, 2005, 2006, 2010  IBM Corporation
Copyright (C) 1999-2006  Hewlett-Packard Co
Copyright (C) 2005, 2006, 2011, 2012  Fujitsu Limited
Copyright (C) 2006, 2007  VA Linux Systems Japan K.K.
Copyright (C) 2005, 2011  NEC Corporation
Copyright (C) 1999, 2002, 2007  Silicon Graphics, Inc.
Copyright (C) 1999, 2000, 2001, 2002  Mission Critical Linux, Inc.
This program is free software, covered by the GNU General Public License,
and you are welcome to change it and/or distribute copies of it under
certain conditions.  Enter "help copying" to see the conditions.
This program has absolutely no warranty.  Enter "help warranty" for details.

GNU gdb (GDB) 7.6
Copyright (C) 2013 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-unknown-linux-gnu"...

WARNING: kernel relocated [362MB]: patching 87292 gdb minimal_symbol values

      KERNEL: /usr/lib/debug/lib/modules/3.10.0-1160.el7.x86_64/vmlinux
    DUMPFILE: vmcore  [PARTIAL DUMP]
        CPUS: 64
        DATE: Fri Nov 19 10:51:00 2021
      UPTIME: 11 days, 13:19:37
LOAD AVERAGE: 0.94, 0.87, 0.86
       TASKS: 9147
    NODENAME: hybrid01
     RELEASE: 3.10.0-1160.el7.x86_64
     VERSION: #1 SMP Tue Aug 18 14:50:17 EDT 2020
     MACHINE: x86_64  (2300 Mhz)
      MEMORY: 127.6 GB
       PANIC: "BUG: unable to handle kernel NULL pointer dereference at 0000000000000520"
         PID: 114745
     COMMAND: "Container Monit"
        TASK: ffff921d86754200  [THREAD_INFO: ffff921d8ea7c000]
         CPU: 9
       STATE: TASK_RUNNING (PANIC)

crash>
```

如果 vmlinux 对应的 kernel 版本号和 vmcore 的不一致，可能就会导致报错无法进行 debug

类似如下：

```bash
]# crash /usr/lib/debug/lib/modules/3.10.0-1160.45.1.el7.x86_64/vmlinux /root/Downloads/sosreport_analyse/202111/202111\ cjhx/vmcore

crash 7.2.3-11.el7_9.1
Copyright (C) 2002-2017  Red Hat, Inc.
Copyright (C) 2004, 2005, 2006, 2010  IBM Corporation
Copyright (C) 1999-2006  Hewlett-Packard Co
Copyright (C) 2005, 2006, 2011, 2012  Fujitsu Limited
Copyright (C) 2006, 2007  VA Linux Systems Japan K.K.
Copyright (C) 2005, 2011  NEC Corporation
Copyright (C) 1999, 2002, 2007  Silicon Graphics, Inc.
Copyright (C) 1999, 2000, 2001, 2002  Mission Critical Linux, Inc.
This program is free software, covered by the GNU General Public License,
and you are welcome to change it and/or distribute copies of it under
certain conditions.  Enter "help copying" to see the conditions.
This program has absolutely no warranty.  Enter "help warranty" for details.

GNU gdb (GDB) 7.6
Copyright (C) 2013 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-unknown-linux-gnu"...

WARNING: kernel relocated [362MB]: patching 87388 gdb minimal_symbol values

crash: page excluded: kernel virtual address: ffffffffffffffff  type: "possible"
WARNING: cannot read cpu_possible_map
crash: page excluded: kernel virtual address: ffffffffffffffff  type: "present"
WARNING: cannot read cpu_present_map
crash: page excluded: kernel virtual address: ffffffffffffffff  type: "online"
WARNING: cannot read cpu_online_map
crash: page excluded: kernel virtual address: ffffffffffffffff  type: "active"
WARNING: cannot read cpu_active_map
WARNING: kernel version inconsistency between vmlinux and dumpfile

crash: page excluded: kernel virtual address: ffffffffffffffff  type: "cpu_present_map"
crash: page excluded: kernel virtual address: ffffffffffffffff  type: "cpu_present_map"
crash: cannot determine thread return address
Segmentation fault
```







### 常用命令







## Q&A

Q1：

有时候用 dis 出来的结果是带了文件行数的

```
crash> dis -rl ffffffff81053b65 | tail -n 7
/usr/src/debug/kernel-2.6.32-131.0.15.el6/linux-2.6.32-131.0.15.el6.x86_64/kernel/sched.c: 3942
0xffffffff81053b50 <find_busiest_group+1456>:   mov    -0x120(%rbp),%r8
0xffffffff81053b57 <find_busiest_group+1463>:   mov    -0x58(%rbp),%rax
0xffffffff81053b5b <find_busiest_group+1467>:   xor    %edx,%edx
0xffffffff81053b5d <find_busiest_group+1469>:   mov    0x8(%r8),%ecx
0xffffffff81053b61 <find_busiest_group+1473>:   shl    $0xa,%rax
0xffffffff81053b65 <find_busiest_group+1477>:   div    %rcx
```

但是有的情况下，dis 打出来的结果是没有说明哪个文件和具体行数的（以下为一个第三方的module导致的panic的分析）

```
crash> dis -rl ffffffffc069e28c
0xffffffffc069e250 <q_getname>: nopl   0x0(%rax,%rax,1) [FTRACE NOP]
0xffffffffc069e255 <q_getname+5>:       push   %rbp
0xffffffffc069e256 <q_getname+6>:       mov    $0x1000,%edx
0xffffffffc069e25b <q_getname+11>:      mov    $0xd0,%esi
0xffffffffc069e260 <q_getname+16>:      mov    %rsp,%rbp
0xffffffffc069e263 <q_getname+19>:      push   %r13
0xffffffffc069e265 <q_getname+21>:      push   %r12
0xffffffffc069e267 <q_getname+23>:      mov    %rdi,%r12
0xffffffffc069e26a <q_getname+26>:      mov    -0x2991abd1(%rip),%rdi        # 0xffffffff96d836a0
0xffffffffc069e271 <q_getname+33>:      push   %rbx
0xffffffffc069e272 <q_getname+34>:      callq  0xffffffff95df7430 <kmem_cache_alloc_trace>
0xffffffffc069e277 <q_getname+39>:      test   %rax,%rax
0xffffffffc069e27a <q_getname+42>:      mov    %rax,%rbx
0xffffffffc069e27d <q_getname+45>:      je     0xffffffffc069e3d0 <q_getname+384>
0xffffffffc069e283 <q_getname+51>:      mov    %gs:0x10e30,%rax
0xffffffffc069e28c <q_getname+60>:      cmpq   $0xffffffffffffffff,-0x3fb8(%rax)
```

这是为什么呢？



​                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               







## References

- [linux系统奔溃之vmcore：kdump 的亲密战友 crash](https://cloud.tencent.com/developer/article/1645411)
- [RHEL7 Analyzing a core dump](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/kernel_administration_guide/kernel_crash_dump_guide#chap-analyzing-a-core-dump)



## Doc Changelogs

- 

