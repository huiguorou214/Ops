# Foreman Introduction



## High-level overview

- Discover, provision and upgrade your entire bare-metal infrastructure
- Create and manage instances in virtualization environment and across private and public clouds
- Install operating systems via PXE, local media or from templates or images
- Control and gather reports from your configuration management software
- Group your hosts and manage them in bulk, regardless of location
- Review historical changes for auditing or troubleshooting
- Web user interface, JSON REST API and CLI for Linux
- Extend as needed via a robust plugin architecture



## Foreman 补丁管理的原理

Foreman 本身只是一些 Puppet 模块的集合总称。

确实有点包工头的味了，主要是通过所包含的各个组件模块，来实现各种各样的功能。

补丁管理的功能也不例外，补丁管理功能的实现，其实是由 Katello 插件来实现的。





## References

- [Red Hat Subscription Management](https://access.redhat.com/documentation/en-us/red_hat_subscription_management/1)