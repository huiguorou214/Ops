## Docker Compose



[TOC]

### Docker Compose 介绍





### Docker Compose 安装

二进制安装：

下载地址：https://github.com/docker/compose/releases

pip安装：

```bash
pip install docker-compose
```



### Docker Compose 基本使用示例

这里是用了大佬博客的一个示例来学习实践，用docker-compose来编排两个容器，实现一个Python脚本提供的web访问界面。



创建一个编写一个py脚本示例，用来在后面启动Python容器使用。

```bash
[root@docker-server1 ~]# mkdir composetest
[root@docker-server1 ~]# cd composetest
[root@docker-server1 composetest]# cat app.py
import time

import redis
from flask import Flask


app = Flask(__name__)
cache = redis.Redis(host='redis', port=6379)


def get_hit_count():
    retries = 5
    while True:
        try:
            return cache.incr('hits')
        except redis.exceptions.ConnectionError as exc:
            if retries == 0:
                raise exc
            retries -= 1
            time.sleep(0.5)


@app.route('/')
def hello():
    count = get_hit_count()
    return 'Hello World! I have been seen {} times.\n'.format(count)

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
```



编写一个Dockerfile

```bash
[root@docker-server1 composetest]# cat Dockerfile
FROM python:3.4-alpine
ADD . /code
WORKDIR /code
RUN pip install -r requirements.txt
CMD ["python", "app.py"]
```



编写requirements.txt

```bash
[root@docker-server1 composetest]# cat requirements.txt
flask
redis
```



编写docker-compose.yaml

```YAML
[root@docker-server1 composetest]# cat docker-compose.yml
version: '3'
services:
  web:
    build: .
    ports:
     - "5000:5000"
  redis:
    image: "redis:alpine"
```



通过Docker Compose构建并启动服务

```bash
[root@docker-server1 composetest]# docker-compose up -d
```



可以通过`docker-compose ps`命令来查看运行的容器，容器的名字与构建容器的目录以及yaml文件里面的image name有关

```bash
[root@docker-server1 composetest]# docker-compose  ps
       Name                      Command               State                Ports
----------------------------------------------------------------------------------------------
composetest_redis_1   docker-entrypoint.sh redis ...   Up      6379/tcp
composetest_web_1     python app.py                    Up      0.0.0.0:5000->5000/tcp,:::5000-
                                                               >5000/tcp
[root@docker-server1 composetest]# docker-compose ps
       Name                      Command               State                Ports
----------------------------------------------------------------------------------------------
composetest_redis_1   docker-entrypoint.sh redis ...   Up      6379/tcp
composetest_web_1     python app.py                    Up      0.0.0.0:5000->5000/tcp,:::5000-
                                                               >5000/tcp
```



浏览器查看结果

![image-20210820111959406](pictures/image-20210820111959406.png)



### Docker Compose 常用命令说明

常用命令：

- docker-compose start
- docker-compose stop
- docker-compose restart
- docker-compose build
- docker-compose up



### Docker Compose 文件详解

#### 主要参数



#### 示例









### Docker Compose 应用实践 





### References

- [一文掌握Docker Compose](https://www.cnblogs.com/breezey/p/9426085.html#docker-compose%E4%BB%8B%E7%BB%8D)