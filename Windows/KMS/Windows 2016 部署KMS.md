# 基于 Windows Server 2016 部署 KMS



## 前提

### KMS 密钥准备

KMS Server 的部署需要专用的 KMS KEY 来激活，激活后可为 Client 提供激活的功能。



### 机器选择

KMS 服务器的系统版本，决定了客户端的注册能力，Server 的版本越高，Client 能用来注册的系统也支持更高的版本，具体可以参考：

https://docs.microsoft.com/zh-cn/windows-server/get-started/kms-activation-planning#activation-versions



### 补丁更新

在服务器装机完成，并且加域后请务必将所有补丁打到最新，否则会面临报错。

具体的各版本需要做的补丁更新可以参考官方文档：

https://docs.microsoft.com/zh-cn/windows-server/get-started/kms-activation-planning#kms-host-required-updates



## 基于 Windows Server 2016 部署 KMS Server

### 大纲

KMS 激活的流程如图 3 所示，并遵循以下顺序：

1. 管理员使用 VAMT 控制台配置 KMS 主机并安装 KMS 主机密钥。
2. Microsoft 验证 KMS 主机密钥，然后 KMS 主机开始侦听请求。
3. KMS 主机更新 DNS 中的资源记录以使客户端能够找到 KMS 主机。 （如果你的环境不支持 DNS 动态更新协议，则需手动添加 DNS 记录。）
4. 通过 GVLK（通用批量许可密钥） 配置的客户端使用 DNS 查找 KMS 主机。
5. 客户端将一个数据包发送到 KMS 主机。
6. KMS 主机记录有关请求客户端的信息（通过使用客户端 ID）。 客户端 ID 用于维持客户端的计数并检测同一计算机何时再次请求激活。 客户端 ID 仅用于确定是否满足激活阈值。 ID 不会永久存储或传输到 Microsoft。 如果重新启动 KMS，客户端 ID 收集将再次启动。
7. 如果 KMS 主机具有与 GVLK 中的产品匹配的 KMS 主机密钥，KMS 主机将向客户端发送回一个数据包。 此数据包包含从该 KMS 主机请求激活的计算机数量的计数。
8. 如果计数超过要激活的产品的激活阈值，则激活客户端。 如果尚未满足激活阈值，客户端将会重试。



### 安装系统

安装一台 Windows Server 2016 操作系统，（略）



### 加入AD域

新建的 KMS Server 服务器需要先加入 AD 域中，操作略过



### 防火墙开通





## 客户端激活

### 安装客户端系统

客户端操作系统安装的时候，应该将通用批量证书密钥导入到系统中，这样后续就可以自动去寻找KMS。

官方的通用批量证书密钥：https://docs.microsoft.com/zh-cn/windows-server/get-started/kms-client-activation-keys#generic-volume-license-keys-gvlk













## 待看





## Reference

- 官方文档，批量激活：https://docs.microsoft.com/zh-cn/windows/deployment/volume-activation/volume-activation-windows-10
- Windows 2019 Server : How to Install Volume Activation Tool/Deploy Windows and Office KMS Keys：https://www.youtube.com/watch?v=giiSJkpGBIg
- 搭建内网Windows Server 2016的KMS激活服务器 https://www.azurew.com/windows/windows-server-2016/5284.html
- 部署windows 2016 KMS批量激活 https://blog.51cto.com/u_117295/1947269

