# Install KVM

### 环境说明

| items    | value     |
| -------- | --------- |
| 主机     | NUC8I7BEH |
| 操作系统 | RHEL7.7   |
| memory   | 32G       |



### 安装步骤

1. 查看CPU是否支持虚拟化技术

   ```bash
   [root@nuc ~]# egrep '(vmx|svm)' /proc/cpuinfo
   ```

2. 配置yum源

   略

3. 安装相关rpm

   ```bash
   [root@nuc ~]# yum install qemu-kvm libvirt virt-install virt-manager
   ```

   quem-kvm：qemu模拟器

   libvirt：提供libvirtd daemon来管理虚拟机和控制hypervisor

   virt-install：用来创建虚拟机的命令行工具

   virt-manager：图形界面管理工具

4. 启动libvirtd

   ```bash
   [root@nuc ~]# systemctl enable libvirtd --now 
   ```

5. 查看

   a.直接使用`systemctl status libvirtd`即可查看相关服务是否已经在运行

   b.可以试试`virt-manager`命令，看是否可以成功打开管理界面

6. 其他的具体使用方法留在下一章描述



### 参考文档

