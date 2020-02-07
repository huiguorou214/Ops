# Powershell  基础用法

> 因为工作需要，所以要来学习一点powershell的知识，主要是通过和Linux的shell做做对比，来进行快速的入门。



---

### Powershell 历史版本与支持的

[Differences between PowerShell versions](https://4sysops.com/wiki/differences-between-powershell-versions/)



----

### Powershell 的安装  

  

----

### Powershell 的升级



---

### PowerShell 中的一些概念



#### 别名

powershell中的别名，是因为在powershell中一些命令，会比较长，其实命令的名字就是很直观的告诉你它的意思，有点像我们平时自己定义比较直白的一个变量的感觉。

别名则是这样的长命令的一个简称，类似于给原命令做了一个链接一样，有了这个别名，就可以减少我们的输入量了，用法是和原来的命令一样的

例如创建一个文件的命令 `nwe-item` 它的别名就是 `ni`



**如何查看别名**

如果你觉得一条命令很长，想知道它的别名，则可以使用 `get-alias -definition` 命令来查看

```powershell
PS C:\Windows\system32> Get-Alias -Definition New-Item

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Alias           ni -> New-Item
```



具体更多与别名相关的内容可以点击下面这篇博客学习：

[Powershell 别名](https://www.pstips.net/powershell-alias.html)



之前使用 get-help 命令就可以查看到一个命令的别名

```powershell
PS G:\powershell\20190701> Get-Help New-Item

别名
    ni
```

注意：更新了一下help之后，再使用 get-help 我也没有看到别名了...



---

### Powershell 软件的基础用法



**复制光标选中内容**

在使用鼠标光标选中需要辅助的内容之后，按下 `Enter` 键即可完成复制



**粘贴内容**

如果需要在PS中粘贴已复制内容，可以直接鼠标右键（和CRT一样的操作），或者`Ctrl+V`即可完成粘贴



**快捷键**

| **ALT+F7**           | 清除命令的历史记录                                           |
| -------------------- | ------------------------------------------------------------ |
| **PgUp PgDn**        | 显示当前会话的第一个命令和最后一个命令                       |
| **Enter**            | 执行当前命令                                                 |
| **End**              | 将光标移至当前命令的末尾                                     |
| **Del**              | 从右开始删除输入的命令字符                                   |
| **Esc**              | 清空当前命令行                                               |
| **F2**               | 自动补充历史命令至指定字符 (例如历史记录中存在Get-Process，按F2，提示"Enter char to copy up to"，键入‘s’，自动补齐命令:Get-Proce) |
| **F4**               | 删除命令行至光标右边指定字符处                               |
| **F7**               | 对话框显示命令行历史记录                                     |
| **F8**               | 检索包含指定字符的命令行历史记录                             |
| **F9**               | 根据命令行的历史记录编号选择命令，历史记录编号可以通过F7查看 |
| **左/右方    向键**  | 左右移动光标                                                 |
| **上/下方向键**      | 切换命令行的历史记录                                         |
| **Home**             | 光标移至命令行最左端                                         |
| **Backspace**        | 从右删除命令行字符                                           |
| **Ctrl+C**           | 取消正在执行的命令                                           |
| **Ctrl+左/右方向键** | 在单词之间移动光标                                           |
| **Ctrl+Home**        | 删除光标最左端的所有字符                                     |
| **Tab**              | 自动补齐命令或者文件名                                       |





---

### Powershell帮助文档



**help**

help类似于linux中的  --help

```powershell
PS G:\powershell\20190701> help New-Item

名称
    New-Item

语法
    New-Item [-Path] <string[]>  [<CommonParameters>]

    New-Item [[-Path] <string[]>]  [<CommonParameters>]

别名
    ni

备注
    Get-Help 在此计算机上找不到该 cmdlet 的帮助文件。它仅显示部分帮助。
        -- 若要下载并安装包含此 cmdlet 的模块的帮助文件，请使用 Update-Help。
        -- 若要联机查看此 cmdlet 的帮助主题，请键入: "Get-Help New-Item -Online" 或
           转到 https://go.microsoft.com/fwlink/?LinkID=113353。
```



**get-help**

目前用着好像和help命令没啥区别... 之后有不一样的感觉再来补充，搜了一下，也没有看到什么说这两个命令区别的东西

备注

    若要查看示例，请键入: "get-help New-Item -examples".
    有关详细信息，请键入: "get-help New-Item -detailed".
    若要获取技术信息，请键入: "get-help New-Item -full".
    有关在线帮助，请键入: "get-help New-Item -online"


**update-help**

更新帮助文件，有的命令的帮助文件，可能找不到或者显示部分之类的，powershell会提醒你 `若要下载并安装包含此 cmdlet 的模块的帮助文件，请使用 Update-Help`



**Get-Help Command -Online**

这个命令可以联机查看我们想看的 Command 的帮助文件

`若要联机查看此 cmdlet 的帮助主题，请键入: "Get-Help New-Item -Online"`





---

### Powershell 基本命令的使用



**路径中涉及到空格的都需要引号囊括起来**

例：

```powershell
PS G:\> cd '.\windows server 2003 R2\'
```



**列出当前目录下所有文件**

ls 命令

```powershell
PS G:\powershell> ls


    目录: G:\powershell


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----        2019/6/30     20:16                20190630
```



**切换目录**

cd命令即可，和linux用起来差不多

```powershell
PS C:\Users\shinefire> cd G:\powershell\
PS G:\powershell>
```



cd ..   返回上级目录



**创建文件**

New-Item 文件名字.文件格式 -type file 

file 这里如果不填，也可以用 Tab 自动补全，除了file也还有其他几种类型可以选，例如目录directory

```powershell
PS G:\powershell\20190701> New-Item test.txt -Type file

    目录: G:\powershell\20190701

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----         2019/7/1      8:55              0 test.txt
```



一次性创建多个文件，需要用逗号隔开文件名

```powershell
PS G:\powershell\20190701> New-Item file1.txt,file2.txt -Type File

    目录: G:\powershell\20190701

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----         2019/7/1      9:00              0 file1.txt
-a----         2019/7/1      9:00              0 file2.txt
```



**删除文件**

rm 命令即可删除文件



**创建目录**

mkdir 命令即可，和Linux也一样的用

```powershell
PS G:\powershell> mkdir 20190701
    目录: G:\powershell

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----         2019/7/1      8:44                20190701

PS G:\powershell> ls
    目录: G:\powershell
    
Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----        2019/6/30     20:16                20190630
d-----         2019/7/1      8:44                20190701
```



一次性创建多个目录的用法是和 new-item 一样的。



**删除目录**

rmdir 可直接删除空目录

在目录下还有文件的情况下，PS是直接会出现一个提示的，看了就会

```powershell
PS G:\powershell> rmdir .\20190630\

确认
G:\powershell\20190630\ 处的项具有子项，并且未指定 Recurse 参数。如果继续，所有子项均将随该项删除。是否确实要继续?
[Y] 是(Y)  [A] 全是(A)  [N] 否(N)  [L] 全否(L)  [S] 暂停(S)  [?] 帮助 (默认值为“Y”): y
```



**复制文件**

powershell官方的方式应该是用 copy-item，不过我们依然可以使用Linux的风格来做。

cp



**复制目录**

cp -r 



**移动文件**

mv 命令

```powershell
PS G:\powershell> ls -R
    目录: G:\powershell
Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----         2019/7/1     11:02                20190701
d-----         2019/7/1     11:02                test
    目录: G:\powershell\test
Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----         2019/7/1     11:02              0 file1.txt

PS G:\powershell> mv .\test\file1.txt .\20190701\
PS G:\powershell> ls -R
    目录: G:\powershell
Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----         2019/7/1     11:02                20190701
d-----         2019/7/1     11:02                test
    目录: G:\powershell\20190701
Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----         2019/7/1     11:02              0 file1.txt
```





**移动目录**

mv 命令，和Linux一样操作即可



**清屏**

Ctrl+L



**查看时间**

Get-Date

```powershell
PS G:\powershell> Get-Date
2019年7月1日 11:11:26
```



**查找文件**



---

### Powershell 变量

> 本章节主要是讲一点powershell中的变量
>
> 更多变量相关的资料：<https://www.pstips.net/powershell-online-tutorials



#### 定义变量

在powershell中，定义一个变量，还需要在变量前面加上一个 `$` 符号才行，调用变量的时候也需要 `$`

```powershell
PS G:\powershell\20190701> cat .\test.ps1
# 定义变量，注释也是用#号，有无空格都能定义变量
$a = 10
$b=20
$msg="文字"

# 输出变量
$a
$b
$msg

PS G:\powershell\20190701> .\test.ps1
10
20
文字
```



#### 变量的赋值

赋值操作符为“=”，几乎可以把任何数据赋值给一个变量，甚至一条cmdlet命令，因为Powershell支持对象，对象可以包罗万象。

```
PS G:\powershell\20190701> cat .\test.ps1
$czy=Get-Date
$czy
PS G:\powershell\20190701> .\test.ps1

2019年7月1日 11:55:50
```



#### 交换变量的值

要交换两个变量的值，传统的程序语言至少需要三步，并且还需定义一个中间临时变量。在powershell中，交换两个变量的值，这个功能变得非常简单。

```powershell
PS C:\test> $value1=10
PS C:\test> $value2=20
PS C:\test> $value1,$value2=$value2,$value1
PS C:\test> $value1
20
PS C:\test> $value2
10
```



#### 验证变量是否存在

使用 `Test-Path` 可以查看一个变量是否已经被定义

```powershell
PS G:\powershell\20190701> $czy=1995
PS G:\powershell\20190701> ls variable:czy
Name                           Value
----                           -----
czy                            1995

PS G:\powershell\20190701> Test-Path variable:czy
True
PS G:\powershell\20190701> Test-Path variable:czyUnknow
False
```



#### 自动化变量

Powershell 自动化变量 是那些一旦打开Powershell就会自动加载的变量。
这些变量一般存放的内容包括

1. **用户信息**：例如用户的根目录$home
2. **配置信息**:例如powershell控制台的大小，颜色，背景等。
3. **运行时信息**：例如一个函数由谁调用，一个脚本运行的目录等。



具体相关内容可以查看：<https://www.pstips.net/powershell-automatic-variables.html>



#### 变量的作用域

##### 设置单个变量的作用域

到目前为止，看到的变量作用域的改变都是全局的，能不能针对某个具体变量的作用域做一些个性化的设置。

**$global**
全局变量，在所有的作用域中有效，如果你在脚本或者函数中设置了全局变量，即使脚本和函数都运行结束，这个变量也任然有效。

**$script**
脚本变量，只会在脚本内部有效，包括脚本中的函数，一旦脚本运行结束，这个变量就会被回收。

**$private**
私有变量，只会在当前作用域有效，不能贯穿到其他作用域。

**$local**
默认变量，可以省略修饰符，在当前作用域有效，其它作用域只对它有只读权限。



打开Powershell控制台后，Powershell会自动生成一个新的全局作用域。如果增加了函数和脚本，或者特殊的定义，才会生成其它作用域。在当前控制台，只存在一个作用域，通过修饰符访问，其实访问的是同一个变量：

```
PS> $logo="www.pstips.net"
PS> $logo
www.pstips.net
PS> $private:logo
www.pstips.net
PS> $script:logo
www.pstips.net
PS> $private:logo
www.pstips.net
PS> $global:logo
www.pstips.net
```

更多作用域相关的内容可以查看：<https://www.pstips.net/powershell-scope-of-variables.html>



---

### Powershell 数组



#### 创建数组

```powershell
PS C:Powershell> $nums=2,0,1,2
PS C:Powershell> $nums
2
0
1
2
```

```powershell
PS C:Powershell> $nums=1..5
PS C:Powershell> $nums
1
2
3
4
5
```



#### 访问数组

具体可以访问：<https://www.pstips.net/powershell-addressing-array-elements.html>

数组的元素可以使用索引寻址，第一个元素的索引为0，第i个元素的索引为i-1，最后一个元素的索引为Count-1，但是Powershell为了使用方便，直接可以将 -1 作为最后的一个元素的索引。

```powershell
PS C:Powershell> $books="元素1","元素2","元素3"
PS C:Powershell> $books[0]
元素1
PS C:Powershell> $books[1]
元素2
PS C:Powershell> $books[1,2]
元素2
元素3
PS C:Powershell> $books[($book.Count-1)]
元素3
PS C:Powershell> $books[-1]
元素3
```

P.S.这个也和Python里面的切片用起来差不多



#### 删除数组中的元素

要删除第三个元素可是使用：

```powershell
PS C:Powershell> $num=1..4
PS C:Powershell> $num
1
2
3
4
PS C:Powershell> $num=$num[0..1]+$num[3]
PS C:Powershell> $num
1
2
4
```

*P.S. 感觉这种用法好奇怪，没有del之类的吗？*



#### 复制数组

数组属于引用类型，使用默认的的赋值运算符在两个变量之间赋值只是复制了一个引用，两个变量共享同一份数据。这样的模式有一个弊病如果其中一个改变也会株连到另外一个。所以复制数组最好使用Clone()方法，除非有特殊需求。

```powershell
PS C:Powershell> $chs=@("A","B","C")
PS C:Powershell> $chsBak=$chs
PS C:Powershell> $chsBak[1]="H"
PS C:Powershell> $chs
A
H
C
PS C:Powershell> $chs.Equals($chsBak)
True
PS C:Powershell> $chsNew=$chs.Clone()
PS C:Powershell> $chsNew[1]="Good"
PS C:Powershell> $chs.Equals($chsNew)
False
PS C:Powershell> $chs
A
H
C
```



---

### 哈希表

感觉powershell里面这个哈希表就和Python的字典差不多...

```powershell
PS C:Powershell> $stu=@{ Name = "小明";Age="12";sex="男" }
PS C:Powershell> $stu

Name                           Value
----                           -----
Name                           小明
Age                            12
sex                            男
```

更多用法：<https://www.pstips.net/powershell-using-hash-tables.html>



---

### 管道与重定向

详细内容查看：<https://www.pstips.net/using-the-powershell-pipeline.html>



```powershell
PS> ls | Sort-Object -Descending Name | Select-Object Name,Length,LastWriteTime | ConvertTo-Html | Out-File ls.html
```

上面的例子属于面向对象的管道，每个命令的末尾可以使用新的命令对上个命令的结果做进一步处理，除非管道是以输出命令结束的。就像Sort-Object一样，对文件的列表进行排序，需要告诉它排序的关键字，按照升序还是降序。ls的返回值为一个数组，数组中的每一个元素都是一个对象，对象的每一个属性都可以作为Sort-Object的排序关键字。但是排序时必须指定一个具体的关键字，因为Powershell所传递的对象可能有很多属性。不像普通的文本，对象的信息都是结构化的，因此也使得Powershell的管道变得更加强大和方便。







