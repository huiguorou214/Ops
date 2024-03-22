#! /bin/bash

today=`/bin/date '+%Y-%m-%d'`
yesterday=`/bin/date -d '1 day ago' +%Y-%m-%d`
fileHead=$(date -d "yesterday 13:00" '+%m%d')


###源目标目录
work2="/data/immortalboy1/immortalboy_svr/log"

###目标目录
destination_dir2="/data1/tw.game/svr2"

###判断目标目录是否创建文件夹

if [ ! -d "$destination_dir2/$yesterday" ]; then

 mkdir -p "$destination_dir2/$yesterday"

fi

###开始拷贝svr2

mv "$work2/immortalboy_svr.log.$fileHead"* "$destination_dir2/$yesterday"
