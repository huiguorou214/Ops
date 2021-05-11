# ramdisk

> 本章主要介绍如何对ramdisk/ramfs进行一个快速的简单上手使用，适用于个人或者公司内部非常简易的传输文件使用。

## Author

```
Name:Shinefire
Blog:https://github.com/shine-fire/Ops_Notes
E-mail:shine_fire@outlook.com
```

## Introduction



## Make ramdisk

### mkinitrd

为当前正在使用的内核重新制作ramdisk文件：

```bash
# mkinitrd /boot/initramfs-$(uname -r).img $(uname -r)
```

> /boot/ 目录下即生成后的文件名，这个可以自定义，不过最好是包含这个内核的版本信息，便于区别。

### dracut

为当前正在使用的内核重新制作ramdisk文件：

```bash
# dracut /boot/initramfs-$(uname -r).img $(uname -r)
```

> /boot/ 目录下即生成后的文件名，这个可以自定义，不过最好是包含这个内核的版本信息，便于区别。



## References

