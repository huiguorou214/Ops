# Install Ansible

## Author

```tex
Name:Shinefire
Blog:
E-mail:czy@clinux.cn
```



## Preface

本文档将会介绍介绍安装Ansible相关的一些操作，主要是提及到了在RHEL6与RHEL7中如何实现不同版本的ansible部署，因为少部分用户的生产环境中还存在着RHEL5的服务器，如果想使用Ansible来对RHEL5的服务器进行管理的话则需要Ansible2.3的版本，所以会有需要安装双版本的需求。

部署ansible主要是有两种方式，一种是直接yum安装，一种是使用pip来进行安装。



## Install Two Difference Versions Ansible Use Pip



### RHEL7 Install Ansible Use Two Difference Versions

1. 准备yum源

   系统的repo，epel repo等。

   如果网络情况允许则可以配置一个epel源来方便进行pip的安装，网络情况不允许的话则需要提前将相应需要的软件包离线下载好。

   从互联网同步pip源以及离线安装pip的方法：

   ```bash
   # mkdir ./pip-packages
   # pip download pip==19.2.2 -d ./pip-packages
   # pip download virtualenv virtualenvwrapper -d ./pip-packages
   # pip download ansible==2.3 -d ./pip-packages
   # pip download ansible==2.6 -d ./pip-packages
   # pip install --no-index --find-links=./pip-packages ansible==2.3
   ```

2. 安装相关的rpm包

   ```bash
   # yum install python2-pip python-devel gcc 
   ```

3. 升级pip

   ```bash
   # pip install --upgrade pip
   ```

   **注意：**如果是自己离线下载的相关的软件包，则可以通过 pip install --find-links 来指定路径安装，例如

   ```bash
   # pip install --no-index --find-links=./pip-packages --upgrade pip
   ```

4. 安装Python虚拟环境

   ```bash
   # pip install virtualenv virtualenvwrapper
   # source virtualenvwrapper.sh 
   ```

   如果想修改virtualenvwrapper.sh执行的变量，可以对修改 /root/.bashrc 文件并source生效

   ```bash
   # tail -n 2 /root/.bashrc
   export WORKON_HOME=$HOME/.virtualenvs
   source /usr/bin/virtualenvwrapper.sh
   # source .bashrc
   ```

5. 创建不同版本的Ansible虚拟环境

   ```bash
   # mkvirtualenv --no-download ansible2.3
   (ansible2.3) # pip install ansible==2.3 
   (ansible2.3) # ansible --version
   ansible 2.3.0.0
     config file = 
     configured module search path = Default w/o overrides
     python version = 2.7.5 (default, Aug 29 2016, 10:12:21) [GCC 4.8.5 20150623 (Red Hat 4.8.5-4)]
   # deactivate 
   
   # mkvirtualenv --no-download ansible2.6
   (ansible2.6) # pip install ansible==2.6
   (ansible2.6) # ansible --version
   ansible 2.6.0
     config file = None
     configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
     ansible python module location = /root/.virtualenvs/ansible2.6/lib/python2.7/site-packages/ansible
     executable location = /root/.virtualenvs/ansible2.6/bin/ansible
     python version = 2.7.5 (default, Aug 29 2016, 10:12:21) [GCC 4.8.5 20150623 (Red Hat 4.8.5-4)]
   ```



### RHEL6 Install Ansible Use Two Difference Versions

1. 配置好yum源

   如果网络情况允许则可以配置一个epel源来方便进行pip的安装，网络情况不允许的话则需要提前将相应需要的软件包离线下载好。

2. 安装需要的rpm包

   ```bash
   # yum --enablerepo=rhel-server-rhscl-6-rpms install python27-python-pip python27-python-devel gcc
   ```

3. 启动一个python2.7的会话并升级pip

   ```bash
   # scl enable python27 bash
   # pip install --upgrade pip
   ```

   **注意：**如果是自己离线下载的相关的软件包，则可以通过 pip install --find-links 来指定路径安装，例如

   ```bash
   # pip install --no-index --find-links=./pip-packages --upgrade pip
   ```

4. 安装Python虚拟环境

   ```bash
   # pip install virtualenv virtualenvwrapper
   # source virtualenvwrapper.sh 
   ```

   如果想修改virtualenvwrapper.sh执行的变量，可以对修改 /root/.bashrc 文件并source生效

   ```bash
   # tail -n 2 /root/.bashrc
   export WORKON_HOME=$HOME/.virtualenvs
   source /usr/bin/virtualenvwrapper.sh
   # source .bashrc
   ```

5. 创建不同版本的Ansible虚拟环境

   ```bash
   # mkvirtualenv --no-download ansible2.3
   (ansible2.3) # pip install ansible==2.3 
   (ansible2.3) # ansible --version
   ansible 2.3.0.0
     config file = 
     configured module search path = Default w/o overrides
     python version = 2.7.13 (default, Feb  8 2017, 06:30:30) [GCC 4.4.7 20120313 (Red Hat 4.4.7-16)]
   # deactivate 
   
   # mkvirtualenv --no-download ansible2.6
   (ansible2.6) # pip install ansible==2.6
   (ansible2.6) # ansible --version
   ansible 2.6.0
     config file = None
     configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
     ansible python module location = /root/.virtualenvs/ansible2.6/lib/python2.7/site-packages/ansible
     executable location = /root/.virtualenvs/ansible2.6/bin/ansible
     python version = 2.7.13 (default, Feb  8 2017, 06:30:30) [GCC 4.4.7 20120313 (Red Hat 4.4.7-16)]
   ```



### Ansible Switch Usage

1. scl切换到python27环境

   ```bash
   # scl enable python27 bash
   # python -V
   Python 2.7.13
   ```

2. workon连接到虚拟环境

   ```bash
   # source virtualenvwrapper.sh
   # workon ansible2.
   ansible2.3  ansible2.6  
   # workon ansible2.6
   (ansible2.6) #
   ```

3. pip show --file ansible查看ansible模块相关的信息

   ```bash
   (ansible2.6) # pip show --file ansible
   DEPRECATION: Python 2.7 will reach the end of its life on January 1st, 2020. Please upgrade your Python as Python 2.7 won't be maintained after that date. A future version of pip will drop support for Python 2.7. More details about Python 2 support in pip, can be found at https://pip.pypa.io/en/latest/development/release-process/#python-2-support
   Name: ansible
   Version: 2.6.0
   Summary: Radically simple IT automation
   Home-page: https://ansible.com/
   Author: Ansible, Inc.
   Author-email: info@ansible.com
   License: GPLv3+
   Location: /root/.virtualenvs/ansible2.6/lib/python2.7/site-packages
   Requires: paramiko, setuptools, jinja2, cryptography, PyYAML
   Required-by: 
   Files:
     ../../../bin/ansible
     ../../../bin/ansible-config
     ../../../bin/ansible-connection
     ../../../bin/ansible-console
     ../../../bin/ansible-doc
     ../../../bin/ansible-galaxy
     ../../../bin/ansible-inventory
     ../../../bin/ansible-playbook
     ../../../bin/ansible-pull
     ../../../bin/ansible-vault
   ```

4. 编辑一个 /etc/ansible/hosts 文件，并指定自定义的用户去执行ansible task

   ```bash
   (ansible2.6) # cat /etc/ansible/hosts
   [test]
   192.168.31.166 ansible_ssh_user=apt
   ```

5. 执行一个命令测试

   ```
   (ansible2.6) # ansible all -m command -a "date"
   192.168.31.166 | SUCCESS | rc=0 >>
   Tue Aug 13 03:47:21 PDT 2019
   ```

6. deactive退出当前虚拟环境

   ```bash
   (ansible2.6) # deactivate
   # 
   ```



### Problems

**problem1**

in the RHEL7, if you exec the `source virtualenvwrapper.sh` , it will tell me this:

```
# source virtualenvwrapper.sh 
mktemp: failed to create file via template ‘/tmp/virtualenvwrapper-initialize-hook-XXXXXXXXXX’: No space left on device
touch: cannot touch ‘’: No such file or directory
ERROR: virtualenvwrapper could not create a temporary file name.
```

**solution**

```
# Set architecture flags
export ARCHFLAGS="-arch x86_64"
# Ensure user-installed binaries take precedence
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/share/python:$PATH

export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv

export WORKON_HOME=~/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh

# Load .bashrc if it exists
#test -f ~/.bashrc && source ~/.bashrc
```