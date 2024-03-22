#! /bin/bash

today=`/bin/date '+%Y-%m-%d'`
yesterday=`/bin/date -d '1 day ago' +%Y-%m-%d`
fileHead=$(date -d "yesterday 13:00" '+%m%d')

###源目标目录
source_dir="/data/boomboy/boomboy_svr5/log"

###目标目录
destination_dir="/data1/boomboy/tw.wx/svr5"

###判断目标目录是否创建文件夹

if [ ! -d "$destination_dir/$yesterday" ]; then

 mkdir -p "$destination_dir/$yesterday"

fi

###开始拷贝

mv "$source_dir/boomboy_svr.log.$fileHead"* "$destination_dir/$yesterday"