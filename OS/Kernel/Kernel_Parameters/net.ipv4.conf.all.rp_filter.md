# net.ipv4.conf.all.rp_filter



### 内核参数作用





### 系统默认值





### 在某些场景下的建议值



### References

- 理解net.ipv4.conf.all.rp_filter https://zhuanlan.zhihu.com/p/129784373
  这篇博客主要是提到了多个网卡的单独配置和all的关系，即all和单个网卡，只要有一个设置为1则会开启，如果想要单独开启某一个网卡并关闭其他网卡，所以如果只想关闭一个接口的 rp filter，应该把 net.ipv4.conf.all.rp_filter 调整为0，并开启其他接口的 rp filter，再调整目标接口的 rp filter 为0.

