# Ansible map



## 简介

ansible中的filter：map，其实是jinja2中的filter



还有一种常用的方法，就是attribute=key的用法

```
---
- hosts: controller
  tasks:
  - name: get ifconfig
    shell: ifconfig {{ item }} | awk '/inet/{print $2}'
    register: ifout
    with_items:
      - 'br-ex'
      - 'br-mgmt'
  - debug: var=ifout.results|map(attribute='stdout')|list
#######################################
TASK [debug] *******************************************************************
ok: [192.168.10.3] => {
    "ifout.results|map(attribute='stdout')|list": [
        "172.16.20.3", 
        "192.168.10.3"
    ]
}
ok: [192.168.10.4] => {
    "ifout.results|map(attribute='stdout')|list": [
        "172.16.20.4", 
        "192.168.10.4"
    ]
}
```



## 参考文献

- ansible中的map https://www.cnblogs.com/wangl-blog/p/9111370.html