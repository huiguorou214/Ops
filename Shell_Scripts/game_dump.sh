#!/bin/bash

#参数
USERNAME="fkdzz_log_admin"
PASSWORD="j1IjeRnbzZjbES5S"
HOST="rm-bp12vmqc1197u80sq.mysql.rds.aliyuncs.com"
DATABASE="tw.game"
OUTPUT_DIR="/data/tw.game"
#OPTIONS="--no-schemas"

#日期
YESTERDAY=$(date -d "yesterday" +"%Y-%m-%d")
TODAY=$(date +%Y-%m-%d)

#需要导出的表
TABLES="${YESTERDAY}_chargeunlock,${YESTERDAY}_item,${YESTERDAY}_login,${YESTERDAY}_money,${YESTERDAY}_box,${YESTERDAY}_charge,${YESTERDAY}_channel,${YESTERDAY}_chicken,${YESTERDAY}_fish,${YESTERDAY}_patch,${YESTERDAY}_pworld,${YESTERDAY}_room,"

#输出目录
OUTPUT_DATE_DIR="${OUTPUT_DIR}/${TODAY}"
ARCHIVE_NAME="${TODAY}.shu_db.tar.gz"
ARCHIVE_PATH="/data1/boomboy/shushu_db/tw.game"

#日志文件
LOG_FILE="${OUTPUT_DIR}/export_log.txt"

#记录日志信息
log() {
    local timestamp
    timestamp=$(date +"[%Y-%m-%d %H:%M:%S]")
    echo "${timestamp} $1" >> "$LOG_FILE"
}

#创建目录
mkdir -p "$OUTPUT_DATE_DIR"

# 导出数据库表
log "正在导出数据库表..."
    /usr/local/bin/mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$OUTPUT_DATE_DIR" 

if [ $? -eq 0 ]; then
    log "导出成功完成."
    
    # 创建压缩存档
    log "创建压缩..."
    tar czvf "${ARCHIVE_NAME}" -C "${OUTPUT_DIR}" "${TODAY}"

    if [ $? -eq 0 ]; then
        log "存档创建成功."
        
        # 将存档移动到目标
        log "正在移动存档..."
        mv "${ARCHIVE_NAME}" "${ARCHIVE_PATH}"
        
        log "移动存储文件到 $ARCHIVE_PATH."
    else
        log "存档创建失败."
    fi

    #清理临时文件
    log "正在清理临时文件..."
    rm -rf "${OUTPUT_DATE_DIR}"
else
    log "导出失败."
fi

