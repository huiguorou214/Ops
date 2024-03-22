#! /bin/bash

today=`/bin/date '+%Y-%m-%d'`
yesterday=`/bin/date -d '1 day ago' +%Y-%m-%d`
fileHead=$(date -d "yesterday 13:00" '+%m%d')


###源目标目录
work9="/data/boomboy/boomboy_svr9/log"
work10="/data/boomboy/boomboy_svr10/log"

###目标目录
destination_dir9="/data1/boomboy/tw.wx/svr9"
destination_dir10="/data1/boomboy/tw.wx/svr10"

###判断目标目录是否创建文件夹

if [ ! -d "$destination_dir9/$yesterday" ]; then

 mkdir -p "$destination_dir9/$yesterday"

fi

###开始拷贝svr9

mv "$work9/boomboy_svr.log.$fileHead"* "$destination_dir9/$yesterday"


###判断目标目录是否创建文件夹

if [ ! -d "$destination_dir10/$yesterday" ]; then

 mkdir -p "$destination_dir10/$yesterday"

fi

###开始拷贝svr10

mv "$work10/boomboy_svr.log.$fileHead"* "$destination_dir10/$yesterday"
