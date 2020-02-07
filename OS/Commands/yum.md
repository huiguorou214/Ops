# yum



## yum的主要命令

```
List of Commands:
check          Check for problems in the rpmdb
check-update   Check for available package updates
clean          Remove cached data
deplist        List a package's dependencies
downgrade      downgrade a package
erase          Remove a package or packages from your system
groups         Display, or use, the groups information
history        Display, or use, the transaction history
info           Display details about a package or group of packages
install        Install a package or packages on your system
list           List a package or groups of packages
makecache      Generate the metadata cache
provides       Find what package provides the given value
reinstall      reinstall a package
repolist       Display the configured software repositories
search         Search package details for the given string
shell          Run an interactive yum shell
swap           Simple way to swap packages, instead of using shell
update         Update a package or packages on your system
update-minimal Works like upgrade, but goes to the 'newest' package match which fixes a problem that affects your system
updateinfo     Acts on repository update information
upgrade        Update packages taking obsoletes into account
version        Display a version for the machine and/or available repos.
```



## yum deplist

deplist用来查看指定rpm包所需要的依赖包



## yum groups

groups用来查看一些与groups相关的信息

- yum groups list   列出gropus
- yum groups list hidden  列出所有的groups（包括隐藏的）
- yum groups info