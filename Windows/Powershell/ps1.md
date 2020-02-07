# powershell 脚本



> 本章节主要是讲一些powershell脚本相关的基础



---

### 开启支持脚本执行

在windows中，基本上都是默认不支持powershell脚本运行的，所以我们需要先开启支持，只有管理员才能修改

查看脚本执行策略，可以通过：

```powershell
PS G:\powershell> Get-ExecutionPolicy
Restricted
```

修改策略：

```powershell
PS G:\powershell> Set-ExecutionPolicy Unrestricted

执行策略更改
执行策略可帮助你防止执行不信任的脚本。更改执行策略可能会产生安全风险，如 https:/go.microsoft.com/fwlink/?LinkID=135170 中的
about_Execution_Policies 帮助主题所述。是否要更改执行策略?
[Y] 是(Y)  [A] 全是(A)  [N] 否(N)  [L] 全否(L)  [S] 暂停(S)  [?] 帮助 (默认值为“N”): y
```



可更改的策略选项有如下几种：

```powershell
PS G:\powershell> [System.Enum]::GetNames([Microsoft.PowerShell.ExecutionPolicy])
Unrestricted
RemoteSigned
AllSigned
Restricted
Default
Bypass
Undefined
```



---

### 执行脚本 

在powershell中，执行ps脚本，一般是你输入脚本的名字，tab补全即可，补全结果实际上就和在Linux中使用 `.` 加上绝对路径来执行一个脚本差不多

```powershell
PS G:\powershell\20190701> echo "get-date" > test.ps1
PS G:\powershell\20190701> .\test.ps1
2019年7月1日 11:45:55
```



---

