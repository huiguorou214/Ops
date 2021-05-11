# Create VM



## virt-install

在kvm服务器中可以virt-install命令来创建虚拟机



```bash
virt-install --name awx12 --boot vd,cdrom,menu=on --ram 4096 --vcpus=4 --os-variant=centos7 --accelerate --cdrom=/ISO/centos7/CentOS-7-x86_64-DVD-2003.iso -x "http://192.168.31.100/ks/rhel7/ks.cfg" --disk path=/var/lib/libvirt/images/awx12.img,size=30,bus=virtio --bridge=virbr0,model=virtio --autostart 
```

## References

- 命令行利用KVM创建虚拟机(virt-install) https://blog.51cto.com/tianhao936/1343767
- centos7上使用virt-install命令创建kvm虚拟机 https://blog.51cto.com/11555417/2341874
