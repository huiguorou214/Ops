# Ansible Vault

## Ansible Valut 用法

ansible-vault 只要用于配置文件加密，可以加密或解密，具体使用方式如下：

```
Usage: ansible-vault [create|decrypt|edit|encrypt|encrypt_string|rekey|view] [options] [vaultfile.yml]
```

可以看到有很多子命令：

- create: 创建一个新文件，并直接对其进行加密
- decrypt: 解密文件
- edit: 用于编辑 ansible-vault 加密过的文件
- encrypy: 加密文件
- encrypt_strin: 加密字符串，字符串从命令行获取
- view: 查看经过加密的文件

## Ansible Vault 应用

### 如何在playbook中对生成的inventory实现加密





## 参考文献

- Ansible 加密模块 Vault https://blog.51cto.com/steed/2432427