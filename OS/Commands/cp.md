# cp



## 作用

复制文件、目录以及文件的属性等



## 语法

```
用法：cp [选项]... [-T] 源文件 目标文件
　或：cp [选项]... 源文件... 目录
　或：cp [选项]... -t 目录 源文件...
Copy SOURCE to DEST, or multiple SOURCE(s) to DIRECTORY.

Mandatory arguments to long options are mandatory for short options too.
  -a, --archive                 等于-dR --preserve=all
      --attributes-only 仅复制属性而不复制数据      --backup[=CONTROL           为每个已存在的目标文件创建备份
  -d                            等于--no-dereference --preserve=links
  -f, --force                  if an existing destination file cannot beopened, remove it and try again (this optionis ignored when the -n option is also used)
  -i, --interactive            prompt before overwrite (overrides a previous -n option)
  -l, --link                   hard link files instead of copying
  -p                            等于--preserve=模式,所有权,时间戳
      --preserve[=属性列表      保持指定的属性(默认：模式,所有权,时间戳)，如果可能保持附加属性：环境、链接、xattr 等
  -R, -r, --recursive           递归复制目录及其子目录内的所有内容
      --reflink[=WHEN]          控制克隆/CoW 副本。请查看下面的内如。
      --remove-destination      尝试打开目标文件前先删除已存在的目的地文件 (相对于 --force 选项)
      --sparse=WHEN             控制创建稀疏文件的方式
      --strip-trailing-slashes  删除参数中所有源文件/目录末端的斜杠
  -s, --symbolic-link           只创建符号链接而不复制文件
  -S, --suffix=后缀             自行指定备份文件的后缀
  -t,  --target-directory=目录  将所有参数指定的源文件/目录复制至目标目录
  -T, --no-target-directory     将目标目录视作普通文件
  -u, --update                  只在源文件比目标文件新，或目标文件不存在时才进行复制
  -v, --verbose         显示详细的进行步骤
  -x, --one-file-system 不跨越文件系统进行操作
  -Z                           set SELinux security context of destinationfile to default type
      --context[=CTX]          like -Z, or if CTX is specified then set theSELinux or SMACK security context to CTX
      --help            显示此帮助信息并退出
      --version         显示版本信息并退出
```



## example

- 取消交互强行覆盖的方式

  有一种情况是即使你加了 -rf 参数进行递归覆盖，也会提示你确认的，默认的cp是加了 -i 参数的，所以可以使用 -n 参数或者 \cp 来完全实现非交互的cp方式

  ```
  [root@apt ~]# alias | grep cp
  alias cp='cp -i'
  [root@apt ~]# cp -n /etc/passwd /tmp/
  [root@apt ~]# \cp /etc/passwd /tmp/
  ```


- 给 /etc/passwd 文件做一个硬链接，可以看到inode号是一样的，并且 /etc/passwd 的属性中，inode链接数变成了2

  ```bash
  [root@apt ~]# cp -l /etc/passwd /tmp/
  [root@apt ~]# ll /etc/passwd
  -rw-r--r-- 2 root root 1360 7月   3 10:35 /etc/passwd
  [root@apt ~]# ls -i /etc/passwd  /tmp/passwd 
  1190497 /etc/passwd  1190497 /tmp/passwd
  ```

- 复制的时候把文件的属性也一同拷贝

  ```bash
  [root@apt ~]# cp -a /etc/passwd /tmp/
  ```

- 复制文件，只有源文件较目的文件的修改时间新时，才复制文件

  ```bash
  cp -u file1 file2
  ```



## 参考博客

- Linux的cp命令 <http://www.cnblogs.com/xd502djj/archive/2011/11/25/2263562.html>