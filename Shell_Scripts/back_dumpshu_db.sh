#!/bin/bash

USERNAME="fkdzz_log_admin"
PASSWORD="j1IjeRnbzZjbES5S"
HOST="rm-bp12vmqc1197u80sq.mysql.rds.aliyuncs.com"
DATABASE="tw.wx"
OUTPUT_DIR="/data/tw.wx"
OPTIONS="--no-schemas"

YESTERDAY=$(date -d "yesterday" +"%Y-%m-%d")
today=$(date +%Y-%m-%d)

###表文件
TABLES="${YESTERDAY}_chargeunlock,${YESTERDAY}_item,${YESTERDAY}_login,${YESTERDAY}_money"

###进入目录
cd ${OUTPUT_DIR}

###创建日期
mkdir ${today}

###开始导库中的表
mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$OUTPUT_DIR" $OPTIONS

###拷贝sql文件到目录
mv *.sql  "${OUTPUT_DIR}/${today}"

###压缩备份库文件
tar czvf "${today}".shu_db.tar.gz  "${today}"

###删除文件夹
rm -rf "${today}"
