# ipcs自动清除



## 问题描述

一执行crontab就会把应用的队列清空，一跑脚本就会把ipcs的队列清空。



## 解决方案1：

1. 修改 /etc/systemd/logind.conf文件，把RmoveIPC的值改为no
2. 重启systemd-logind服务，systemctl restart systemd-logind.service
3. 再验证

