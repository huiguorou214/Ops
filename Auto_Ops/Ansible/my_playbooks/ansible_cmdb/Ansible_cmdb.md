# Ansible CMDB



## Author

```tex
Name:Shinefire
Blog:
E-mail:czy@clinux.cn
```



## Install ansible_cmdb

使用pip install可以直接安装

```bash
# pip install ansible-cmdb
```

## Use ansible_cmdb

1. 创建playbook目录

   ```bash
   # mkdir -p /playbook/ansible_cmdb
   ```

2. 编写inventory

   ```bash
   # cat /playbook/ansible_cmdb/inventory 
   [test]
   local ansible_connection=local
   ```

3. 编写ansible.cfg

   ```bash
   # cat /playbook/ansible_cmdb/ansible.cfg 
   [defaults]
   fact_caching = jsonfile
   fact_caching_connection = /tmp/ansible-cmdb
   fact_caching_timeout = 600
   forks = 50
   host_key_checking = false
   ```

4. 编写site.yml

   ```yaml
   # cat /playbook/ansible_cmdb/site.yml 
   ---
   - hosts: all
     gather_facts: true
     
     tasks: 
     - name: Generate the cmdb html for all group 
       local_action:
         module: shell
         _raw_params: 'ansible-cmdb -t html_fancy_split -f /tmp/ansible-cmdb/'
         chdir: /var/www/html/
       run_once: yes
   ```

5. 执行playbook

   ```bash
   # cd /playbook/ansible_cmdb
   # ansible-playbook -i inventory site.yml 
   ```

6. 浏览器进入web端查看

   http://IP/cmdb/

7. 总结

   ansible_cmdb的主要作用是通过ansible先对目标机器进行系统数据信息收集，再通过转化格式的形式来展示数据，gather_facts: true这一步即是完成数据收集，后续再通过ansible-cmdb命令来完成形式的转化。

   一般采用`html_fancy_split`模板，可以直接在web端展示很多服务器信息，其他人只要在自己的浏览器中输入URL也可以方便的查看CMDB信息。

## Other

官方文档：https://ansible-cmdb.readthedocs.io/en/latest/usage/

github：https://github.com/fboender/ansible-cmdb