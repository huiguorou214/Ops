## 使用普通用户来执行task

在使用ansible的时候，有时候可能会需要特定的用户来执行某个task，这种时候就可以用下面的方法来进行



ansible命令

```bash
# ansible -i inventory localhost -b --become-user apt -m shell -a "whoami"
localhost | CHANGED | rc=0 >>
apt
```



ansible-playbook中

```yaml
---
- name: test other user exec playbook
  shell: whoami
  become: yes
  become_user: apt
```

