# Foreman Ansible

> 在Foreman中使用Ansible来对客户端机器进行批量管理



## Installation

### Plugin

如果需要使用ansible插件则需要使用`foreman-installer`安装器把ansible需要的插件一起安装上

```bash
# foreman-installer --enable-foreman-plugin-ansible --enable-foreman-proxy-plugin-ansible
```

### Ansible callback

```bash
# /etc/ansible/ansible.cfg
[defaults]
callback_whitelist = foreman

[callback_foreman]
url = 'https://foreman.example.com'
ssl_cert = /etc/foreman-proxy/ssl_cert.pem
ssl_key = /etc/foreman-proxy/ssl_key.pem
verify_certs = /etc/foreman-proxy/ssl_ca.pem
```



