#!/bin/bash

# Set common variables
USERNAME="fkdzz_log_admin"
PASSWORD="j1IjeRnbzZjbES5S"
HOST="rm-bp12vmqc1197u80sq.mysql.rds.aliyuncs.com"
DATABASE="tw.wx"
OUTPUT_ROOT_DIR="/data1/boomboy/shushu_db/tw.wx"

# 错误处理
function handle_error {
  echo "Error: $1"
  exit 1
}

# 循环浏览不同日期
for DATE in "2023-08-23"; do
  OUTPUT_DIR="$OUTPUT_ROOT_DIR/$DATE"
  
  # 检查输出目录是否存在并清理
  if [ -d "$OUTPUT_DIR" ]; then
    rm -rf "$OUTPUT_DIR"
  fi
  
  #创建输出目录
  mkdir -p "$OUTPUT_DIR" || handle_error "Failed to create directory $OUTPUT_DIR"

  TABLES="${DATE}_chargeunlock,${DATE}_item,${DATE}_login,${DATE}_money"

  # 开始备份数据
  mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$OUTPUT_DIR" $OPTIONS || handle_error "mydumper command failed"
  
  # 压缩文件
  tar czvf "${DATE}_shu_db.tar.gz" -C "$OUTPUT_ROOT_DIR" "$DATE" || handle_error "Failed to create archive"
  
  # 拷贝文件
  mv "${DATE}_shu_db.tar.gz" "$OUTPUT_ROOT_DIR" || handle_error "Failed to move archive to $OUTPUT_ROOT_DIR"
done

