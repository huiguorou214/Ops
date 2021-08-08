## Ansible when中的模糊匹配



例如对于`php7.2.xx`和`php7.4.xx`的版本需要分别进行不同的操作，但是想通过对7.2.*类似这样来进行匹配的话，直接使用when的==是不行的

可以考虑使用jinja2的startswith()方法来实现，例如：when PHP_Version.startwith('7.2')

来匹配版本号为7.2开头的