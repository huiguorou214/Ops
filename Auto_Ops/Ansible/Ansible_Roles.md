# Ansible Roles 





tasks目录
    角色需要执行的主任务文件放置在此目录，默认的主任务文件名为main.yml，当调用roles时，默认会执行main.yml文件中的任务。也可以将其他需要执行的任务文件通过include的方式包含在tasks/main.yml中
    
handlers目录
    当角色需要调用handlers时，默认会在此目录中的main.yml文件中查找对应的handler
    
defaults目录
    角色会使用到的变量可以写入到此目录中的main.yml文件中，通常，defaults/main.yml文件中的变量都用于设置默认值，以便在你没有设置对应变量时，变量有默认的值可以使用，定义在defaults/main.yml文件中的变量的优先级是最低的

vars目录
    角色会使用到的变量可以写入到此目录中的main.yml。/vars/main.yml与/defaults/main.yml的区别在于优先级，vars/main.yml的优先级非常高。如果你只是想提供一个默认配置，则而已把变量定义在defaults/main.yml中，如果想确保别人在调用roles时使用你指定的值，则可以将变量定义在vars/main.yml中。
    
meta目录
    如果你想要赋予角色一些元数据，则可以将元数据写入到meta/main.yml中，这些元数据用于描述角色的相关属性，例如作者信息、角色主要作用等等，你也可以在meta/main.yml中定义这个文件依赖于哪些其他角色，或者改变角色的默认调用设定

templates目录
    角色相关的模板文件可以放置在此目录中，当使用角色相关的模板时，如果没有指定路径，会默认从此目录中查找对应名称的模板文件。
    
files目录
    角色可能会用到的一些其他文件可以放置在此目录中，比如，当你定义nginx角色时，需要配置https，那么相关的证书文件就可以放置在此目录中。





## 参考文献

朱双印-Roles：https://www.zsythink.net/archives/3063

