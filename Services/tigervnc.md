# TigerVNC

> 本章节介绍RHEL7中推荐的tigervnc工具，来搭建一个vnc server端。

## Author

```
Name:Shinefire
Blog:https://github.com/shine-fire/Ops_Notes
E-mail:shine_fire@outlook.com
```

## 一、原理介绍

待补充



## 二、使用步骤

### 2.1 vncserver方式使用

2.1.1 安装tigervnc-server

```bash
# yum install tigervnc-server
```

2.2 查看默认配置文件

```bash
[root@my_test ~]# cat /usr/lib/systemd/system/vncserver@.service
[Unit]
Description=Remote desktop service (VNC)
After=syslog.target network.target

[Service]
Type=forking

# Clean any existing files in /tmp/.X11-unix environment
ExecStartPre=/bin/sh -c '/usr/bin/vncserver -kill %i > /dev/null 2>&1 || :'
ExecStart=/usr/sbin/runuser -l <USER> -c "/usr/bin/vncserver %i"
PIDFile=/home/<USER>/.vnc/%H%i.pid
ExecStop=/bin/sh -c '/usr/bin/vncserver -kill %i > /dev/null 2>&1 || :'

[Install]
WantedBy=multi-user.target
```

2.3 修改配置文件

先把文件拷贝到系统服务目录下面，便于制作成可用systemd管理的服务。

```bash
[root@my_test ~]# cp /usr/lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@.service
```



直接使用vncserver命令启动服务

```bash
[root@my_test ~]# vncserver 

You will require a password to access your desktops.

Password:
Verify:
Would you like to enter a view-only password (y/n)? y
Password:
Verify:

New 'my_test.shinefire.com:1 (root)' desktop is my_test.shinefire.com:1

Creating default startup script /root/.vnc/xstartup
Creating default config /root/.vnc/config
Starting applications specified in /root/.vnc/xstartup
Log file is /root/.vnc/my_test.shinefire.com:1.log
```

查看startup脚本

```bash
[root@my_test ~]# cat /root/.vnc/xstartup 
#!/bin/sh

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
/etc/X11/xinit/xinitrc
# Assume either Gnome or KDE will be started by default when installed
# We want to kill the session automatically in this case when user logs out. In case you modify
# /etc/X11/xinit/Xclients or ~/.Xclients yourself to achieve a different result, then you should
# be responsible to modify below code to avoid that your session will be automatically killed
if [ -e /usr/bin/gnome-session -o -e /usr/bin/startkde ]; then
    vncserver -kill $DISPLAY
fi
```

查看/etc/X11/xinit/xinitrc

```bash
[root@my_test xinit]# cat /etc/X11/xinit/xinitrc
#!/bin/sh
# 
### ...
#

. /etc/X11/xinit/xinitrc-common

# The user may have their own clients they want to run.  If they don't,
# fall back to system defaults.
if [ -f $HOME/.Xclients ]; then
    exec $CK_XINIT_SESSION $SSH_AGENT $HOME/.Xclients || \
    exec $CK_XINIT_SESSION $SSH_AGENT $HOME/.Xclients
elif [ -f /etc/X11/xinit/Xclients ]; then
    exec $CK_XINIT_SESSION $SSH_AGENT /etc/X11/xinit/Xclients || \
    exec $CK_XINIT_SESSION $SSH_AGENT /etc/X11/xinit/Xclients
else
    # Failsafe settings.  Although we should never get here
    # (we provide fallbacks in Xclients as well) it can't hurt.
    [ -x /usr/bin/xsetroot ] && /usr/bin/xsetroot -solid '#222E45'
    [ -x /usr/bin/xclock ] && /usr/bin/xclock -geometry 100x100-5+5 &
    [ -x /usr/bin/xterm ] && xterm -geometry 80x50-50+150 &
    [ -x /usr/bin/twm ] && /usr/bin/twm
fi
```



## References



