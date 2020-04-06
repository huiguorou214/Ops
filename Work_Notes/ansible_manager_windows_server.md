# Ansible管理Windows Server

## 一、Windows Server被管理的前提条件

1. Windows Server 2003 

   无法被ansible管理

2. Windows Server 2008 被管理的前提条件

   - 系统版本为 Windows Server 2008 R2 SP1及以上
   - 升级到.NET Framework 4.0版本以上
   - 升级到Powershell 3.0版本以上
   - 开启powershell脚本的运行支持
   - 开启WinRM
   - 开放5986端口

3. Windows Server 2012/2016 被管理的前提条件

   - 开启powershell脚本的运行支持
   - 开启WinRM
   - 开放5986端口

## 二、Windows Server 2008 R2 配置被ansible管理

配置Windows Server 2008 R2被ansible接管的几个前提条件：.NET Framework 4.0版本以上，Powershell 3.0版本以上，开启WinRM，以下为一个测试用例：

1. 下载 `.NET Framework 4.5.1` 和 Powershell 3.0（**此步骤的方式需机器能够联网下载，如果不能联网请直接看第2步**）

   下载地址：  
   [.NET Framework 4.5.1](https://dotnet.microsoft.com/download/thank-you/net451>) 下载后的包名为：`NDP451-KB2859818-Web`  

   [Powershell3.0](<https://www.microsoft.com/en-us/download/details.aspx?id=34595>)    下载`Windows6.1-KB2506143-x64.msu`这个包即可

2. 下载 `.NET Framework 4.5` 离线安装包和Powershell

   下载地址：

   [.NET Framework 4.6.1](https://www.microsoft.com/en-us/download/confirmation.aspx?id=40779)

   [Powershell3.0](<https://www.microsoft.com/en-us/download/details.aspx?id=34595>)下载`Windows6.1-KB2506143-x64.msu`这个包即可

3. 运行 .net framework 升级包升级

4. 运行 Windows6.1-KB2506143-x64.msu 升级包升级powershell到 3.0 版本，**升级完毕后需要重启**  

5. 检查是否成功安装

   检查.NET Framework，可以到控制面板-->程序与功能中检查

   检查Powershell版本，可以在powershell中执行`$PSVersionTable`命令查看。

6. 开启powershell的脚本运行支持  

   1.管理员身份启动powershell，执行命令：`set-executionpolicy remotesigned`  
   2.HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PowerShell\1\ShellIds\ScriptedDiagnostics 中的 ExecutionPolicy的数据改为`remotesigned`

7. 配置winrm

   下载脚本：https://github.com/ansible/ansible/blob/devel/examples/scripts/ConfigureRemotingForAnsible.ps1  
   在powershell中运行脚本  
   ![1562314741328](ansible_manager_windows_server.assets/1562314741328.png)

8. 查看winrm配置文件是否正确

   在powershell中输入 `winrm get winrm/config`  
   查看Auth中Basic设置是否为true，service中AllowUnencrypted设置是否为true  
   如果不为ture则需要进行配置

   ```
   > winrm set winrm/config/service '@{AllowUnencrypted="true"}'
   > winrm set winrm/config/service/auth '@{Basic="true"}'
   ```

9. 开启防火墙端口5986端口可被访问

   一般在执行完上面的脚本后，会自动打开这个端口了。



## 三、Windows Server 2012/2016 配置被ansible管理

1. 开启powershell的脚本运行支持  

   1.管理员身份启动powershell，执行命令：`set-executionpolicy remotesigned`  
   2.HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PowerShell\1\ShellIds\ScriptedDiagnostics 中的 ExecutionPolicy的数据改为`remotesigned`

2. 下载脚本：https://github.com/ansible/ansible/blob/devel/examples/scripts/ConfigureRemotingForAnsible.ps1  
   在powershell中运行脚本  

   ```powershell
   .\ConfigureRemotingForAnsible.ps1
   ```

3. 查看winrm配置文件是否正确

   在powershell中输入 `winrm get winrm/config`  
   查看Auth中Basic设置是否为true，service中AllowUnencrypted设置是否为true  
   如果不为ture则需要进行配置

   ```
   > winrm set winrm/config/service '@{AllowUnencrypted="true"}'
   > winrm set winrm/config/service/auth '@{Basic="true"}'
   ```

4. 开启防火墙端口5986端口可被访问

   一般在执行完上面的脚本后，会自动打开这个端口了。

## 四、CentOS7 安装使用Ansible管理Windows Server

### 4.1 安装与使用ansible

- 安装epel源

  ```bash
  [root@apt-2 ~]# yum -y install epel-release
  [root@apt-2 ~]# yum clean all 
  [root@apt-2 ~]# yum makecache
  ```

- yum安装一些必要包，kerberos，pywinrm

  ```bash
  [root@apt-2 ~]# yum -y install python2-pip gcc libgcc python-kerberos
  [root@apt-2 ~]# pip install http://github.com/diyan/pywinrm/archive/master.zip#egg=pywinrm
  ```

- 配置 /etc/ansible/hosts

  配置方式：  

  ```yaml
  [windows]
  192.168.31.6
  [windows:vars]
  ansible_user=administrator
  ansible_password=123456
  ansible_port=5986
  ansible_connection=winrm
  ansible_winrm_server_cert_validation=ignore
  ```

  要注意的是，端口方面ssl即https方式的使用5986，http使用5985


### 4.2 ansible模块使用测试

1. win_ping

   ```bash
   $ ansible windows -m win_ping
   192.168.1.11 | SUCCESS => {
       "changed": false, 
       "ping": "pong"
   }
   ```

### 