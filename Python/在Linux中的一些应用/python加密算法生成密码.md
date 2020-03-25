# 使用Python的模块来生成加密密码

在平时设置密码的情况下，一般不能直接使用明文来写密码，所以需要用到加密密码的方式来进行生成密码，以下介绍使用Python的passlib、getpass库来生成密码的方式。

## 操作步骤

一、安装passlib，建议使用2.7版本以上的Python

```bash
pip install passlib
```

二、生成密码

**Python3.X**系列版本使用如下命令（**sha512加密算法**）

```bash
python -c "from passlib.hash import sha512_crypt; import getpass; print (sha512_crypt.encrypt(getpass.getpass()))"
```

**Python3.X**系列版本使用如下命令（**普通加密算法**）

```bash
python -c 'import crypt; print (crypt.crypt("redhat123","dba"))'
```

**Python2.X**系列版本使用如下命令（**sha512加密算法**）

```bash
python -c "from passlib.hash import sha512_crypt; import getpass; print sha512_crypt.encrypt(getpass.getpass())"
```

**Python2.X**系列版本使用如下命令（**普通加密算法**）

```bash
python -c 'import crypt; print (crypt.crypt("redhat123","dba"))'
```