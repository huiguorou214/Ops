#!/bin/bash

# Set common variables
USERNAME="fkdzz_log_admin"
PASSWORD="j1IjeRnbzZjbES5S"
HOST="rm-bp12vmqc1197u80sq.mysql.rds.aliyuncs.com"
DATABASE="tw.yh"
OUTPUT_DIR="/data"
OPTIONS="--no-schemas"

#指定日期
DATES=("2023-09-12")

#需要导出的表
for DATE in "${DATES[@]}"; do
  TABLES="${DATE}_chargeunlock,${DATE}_item,${DATE}_login,${DATE}_money"

  #创建日期
  DATE_DIR="$OUTPUT_DIR/$DATE"
  mkdir -p "$DATE_DIR"

  #开始导出数据
  mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$DATE_DIR" $OPTIONS

  #压缩文件
  TAR_FILE="$DATE.shu_db.tar.gz"
  tar czvf "$TAR_FILE" -C "$DATE_DIR" .

  #拷贝文件到目录
  mv "$TAR_FILE" "/data1/boomboy/shushu_db/tw.yh/"

  #删除文件
  rm -rf "$DATE_DIR"
  rm -rf "$TAR_FILE"
done

#指定日期
DATES=("2023-09-11")

#需要导出的表
for DATE in "${DATES[@]}"; do
  TABLES="${DATE}_chargeunlock,${DATE}_item,${DATE}_login,${DATE}_money"

  #创建日期
  DATE_DIR="$OUTPUT_DIR/$DATE"
  mkdir -p "$DATE_DIR"

  #开始导出数据
  mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$DATE_DIR" $OPTIONS

  #压缩文件
  TAR_FILE="$DATE.shu_db.tar.gz"
  tar czvf "$TAR_FILE" -C "$DATE_DIR" .

  #拷贝文件到目录
  mv "$TAR_FILE" "/data1/boomboy/shushu_db/tw.yh/"

  #删除文件
  rm -rf "$DATE_DIR"
  rm -rf "$TAR_FILE"
done

#指定日期
DATES=("2023-09-10")

#需要导出的表
for DATE in "${DATES[@]}"; do
  TABLES="${DATE}_chargeunlock,${DATE}_item,${DATE}_login,${DATE}_money"

  #创建日期
  DATE_DIR="$OUTPUT_DIR/$DATE"
  mkdir -p "$DATE_DIR"

  #开始导出数据
  mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$DATE_DIR" $OPTIONS

  #压缩文件
  TAR_FILE="$DATE.shu_db.tar.gz"
  tar czvf "$TAR_FILE" -C "$DATE_DIR" .

  #拷贝文件到目录
  mv "$TAR_FILE" "/data1/boomboy/shushu_db/tw.yh/"

  #删除文件
  rm -rf "$DATE_DIR"
  rm -rf "$TAR_FILE"
done

#指定日期
DATES=("2023-09-09")

#需要导出的表
for DATE in "${DATES[@]}"; do
  TABLES="${DATE}_chargeunlock,${DATE}_item,${DATE}_login,${DATE}_money"

  #创建日期
  DATE_DIR="$OUTPUT_DIR/$DATE"
  mkdir -p "$DATE_DIR"

  #开始导出数据
  mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$DATE_DIR" $OPTIONS

  #压缩文件
  TAR_FILE="$DATE.shu_db.tar.gz"
  tar czvf "$TAR_FILE" -C "$DATE_DIR" .

  #拷贝文件到目录
  mv "$TAR_FILE" "/data1/boomboy/shushu_db/tw.yh/"

  #删除文件
  rm -rf "$DATE_DIR"
  rm -rf "$TAR_FILE"
done

#指定日期
DATES=("2023-09-08")

#需要导出的表
for DATE in "${DATES[@]}"; do
  TABLES="${DATE}_chargeunlock,${DATE}_item,${DATE}_login,${DATE}_money"

  #创建日期
  DATE_DIR="$OUTPUT_DIR/$DATE"
  mkdir -p "$DATE_DIR"

  #开始导出数据
  mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$DATE_DIR" $OPTIONS

  #压缩文件
  TAR_FILE="$DATE.shu_db.tar.gz"
  tar czvf "$TAR_FILE" -C "$DATE_DIR" .

  #拷贝文件到目录
  mv "$TAR_FILE" "/data1/boomboy/shushu_db/tw.yh/"

  #删除文件
  rm -rf "$DATE_DIR"
  rm -rf "$TAR_FILE"
done

#指定日期
DATES=("2023-09-07")

#需要导出的表
for DATE in "${DATES[@]}"; do
  TABLES="${DATE}_chargeunlock,${DATE}_item,${DATE}_login,${DATE}_money"

  #创建日期
  DATE_DIR="$OUTPUT_DIR/$DATE"
  mkdir -p "$DATE_DIR"

  #开始导出数据
  mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$DATE_DIR" $OPTIONS

  #压缩文件
  TAR_FILE="$DATE.shu_db.tar.gz"
  tar czvf "$TAR_FILE" -C "$DATE_DIR" .

  #拷贝文件到目录
  mv "$TAR_FILE" "/data1/boomboy/shushu_db/tw.yh/"

  #删除文件
  rm -rf "$DATE_DIR"
  rm -rf "$TAR_FILE"
done

#指定日期
DATES=("2023-09-06")

#需要导出的表
for DATE in "${DATES[@]}"; do
  TABLES="${DATE}_chargeunlock,${DATE}_item,${DATE}_login,${DATE}_money"

  #创建日期
  DATE_DIR="$OUTPUT_DIR/$DATE"
  mkdir -p "$DATE_DIR"

  #开始导出数据
  mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$DATE_DIR" $OPTIONS

  #压缩文件
  TAR_FILE="$DATE.shu_db.tar.gz"
  tar czvf "$TAR_FILE" -C "$DATE_DIR" .

  #拷贝文件到目录
  mv "$TAR_FILE" "/data1/boomboy/shushu_db/tw.yh/"

  #删除文件
  rm -rf "$DATE_DIR"
  rm -rf "$TAR_FILE"
done

#指定日期
DATES=("2023-09-05")

#需要导出的表
for DATE in "${DATES[@]}"; do
  TABLES="${DATE}_chargeunlock,${DATE}_item,${DATE}_login,${DATE}_money"

  #创建日期
  DATE_DIR="$OUTPUT_DIR/$DATE"
  mkdir -p "$DATE_DIR"

  #开始导出数据
  mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$DATE_DIR" $OPTIONS

  #压缩文件
  TAR_FILE="$DATE.shu_db.tar.gz"
  tar czvf "$TAR_FILE" -C "$DATE_DIR" .

  #拷贝文件到目录
  mv "$TAR_FILE" "/data1/boomboy/shushu_db/tw.yh/"

  #删除文件
  rm -rf "$DATE_DIR"
  rm -rf "$TAR_FILE"
done

#指定日期
DATES=("2023-09-04")

#需要导出的表
for DATE in "${DATES[@]}"; do
  TABLES="${DATE}_chargeunlock,${DATE}_item,${DATE}_login,${DATE}_money"

  #创建日期
  DATE_DIR="$OUTPUT_DIR/$DATE"
  mkdir -p "$DATE_DIR"

  #开始导出数据
  mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$DATE_DIR" $OPTIONS

  #压缩文件
  TAR_FILE="$DATE.shu_db.tar.gz"
  tar czvf "$TAR_FILE" -C "$DATE_DIR" .

  #拷贝文件到目录
  mv "$TAR_FILE" "/data1/boomboy/shushu_db/tw.yh/"

  #删除文件
  rm -rf "$DATE_DIR"
  rm -rf "$TAR_FILE"
done

#指定日期
DATES=("2023-09-03")

#需要导出的表
for DATE in "${DATES[@]}"; do
  TABLES="${DATE}_chargeunlock,${DATE}_item,${DATE}_login,${DATE}_money"

  #创建日期
  DATE_DIR="$OUTPUT_DIR/$DATE"
  mkdir -p "$DATE_DIR"

  #开始导出数据
  mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$DATE_DIR" $OPTIONS

  #压缩文件
  TAR_FILE="$DATE.shu_db.tar.gz"
  tar czvf "$TAR_FILE" -C "$DATE_DIR" .

  #拷贝文件到目录
  mv "$TAR_FILE" "/data1/boomboy/shushu_db/tw.yh/"

  #删除文件
  rm -rf "$DATE_DIR"
  rm -rf "$TAR_FILE"
done


#指定日期
DATES=("2023-09-02")

#需要导出的表
for DATE in "${DATES[@]}"; do
  TABLES="${DATE}_chargeunlock,${DATE}_item,${DATE}_login,${DATE}_money"

  #创建日期
  DATE_DIR="$OUTPUT_DIR/$DATE"
  mkdir -p "$DATE_DIR"

  #开始导出数据
  mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$DATE_DIR" $OPTIONS

  #压缩文件
  TAR_FILE="$DATE.shu_db.tar.gz"
  tar czvf "$TAR_FILE" -C "$DATE_DIR" .

  #拷贝文件到目录
  mv "$TAR_FILE" "/data1/boomboy/shushu_db/tw.yh/"

  #删除文件
  rm -rf "$DATE_DIR"
  rm -rf "$TAR_FILE"
done

#指定日期
DATES=("2023-09-01")

#需要导出的表
for DATE in "${DATES[@]}"; do
  TABLES="${DATE}_chargeunlock,${DATE}_item,${DATE}_login,${DATE}_money"

  #创建日期
  DATE_DIR="$OUTPUT_DIR/$DATE"
  mkdir -p "$DATE_DIR"

  #开始导出数据
  mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$DATE_DIR" $OPTIONS

  #压缩文件
  TAR_FILE="$DATE.shu_db.tar.gz"
  tar czvf "$TAR_FILE" -C "$DATE_DIR" .

  #拷贝文件到目录
  mv "$TAR_FILE" "/data1/boomboy/shushu_db/tw.yh/"

  #删除文件
  rm -rf "$DATE_DIR"
  rm -rf "$TAR_FILE"
done

#指定日期
DATES=("2023-08-31")

#需要导出的表
for DATE in "${DATES[@]}"; do
  TABLES="${DATE}_chargeunlock,${DATE}_item,${DATE}_login,${DATE}_money"

  #创建日期
  DATE_DIR="$OUTPUT_DIR/$DATE"
  mkdir -p "$DATE_DIR"

  #开始导出数据
  mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$DATE_DIR" $OPTIONS

  #压缩文件
  TAR_FILE="$DATE.shu_db.tar.gz"
  tar czvf "$TAR_FILE" -C "$DATE_DIR" .

  #拷贝文件到目录
  mv "$TAR_FILE" "/data1/boomboy/shushu_db/tw.yh/"

  #删除文件
  rm -rf "$DATE_DIR"
  rm -rf "$TAR_FILE"
done


#指定日期
DATES=("2023-08-30")

#需要导出的表
for DATE in "${DATES[@]}"; do
  TABLES="${DATE}_chargeunlock,${DATE}_item,${DATE}_login,${DATE}_money"

  #创建日期
  DATE_DIR="$OUTPUT_DIR/$DATE"
  mkdir -p "$DATE_DIR"

  #开始导出数据
  mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$DATE_DIR" $OPTIONS

  #压缩文件
  TAR_FILE="$DATE.shu_db.tar.gz"
  tar czvf "$TAR_FILE" -C "$DATE_DIR" .

  #拷贝文件到目录
  mv "$TAR_FILE" "/data1/boomboy/shushu_db/tw.yh/"

  #删除文件
  rm -rf "$DATE_DIR"
  rm -rf "$TAR_FILE"
done


#指定日期
DATES=("2023-08-29")

#需要导出的表
for DATE in "${DATES[@]}"; do
  TABLES="${DATE}_chargeunlock,${DATE}_item,${DATE}_login,${DATE}_money"

  #创建日期
  DATE_DIR="$OUTPUT_DIR/$DATE"
  mkdir -p "$DATE_DIR"

  #开始导出数据
  mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$DATE_DIR" $OPTIONS

  #压缩文件
  TAR_FILE="$DATE.shu_db.tar.gz"
  tar czvf "$TAR_FILE" -C "$DATE_DIR" .

  #拷贝文件到目录
  mv "$TAR_FILE" "/data1/boomboy/shushu_db/tw.yh/"

  #删除文件
  rm -rf "$DATE_DIR"
  rm -rf "$TAR_FILE"
done

#指定日期
DATES=("2023-08-28")

#需要导出的表
for DATE in "${DATES[@]}"; do
  TABLES="${DATE}_chargeunlock,${DATE}_item,${DATE}_login,${DATE}_money"

  #创建日期
  DATE_DIR="$OUTPUT_DIR/$DATE"
  mkdir -p "$DATE_DIR"

  #开始导出数据
  mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$DATE_DIR" $OPTIONS

  #压缩文件
  TAR_FILE="$DATE.shu_db.tar.gz"
  tar czvf "$TAR_FILE" -C "$DATE_DIR" .

  #拷贝文件到目录
  mv "$TAR_FILE" "/data1/boomboy/shushu_db/tw.yh/"

  #删除文件
  rm -rf "$DATE_DIR"
  rm -rf "$TAR_FILE"
done

#指定日期
DATES=("2023-08-27")

#需要导出的表
for DATE in "${DATES[@]}"; do
  TABLES="${DATE}_chargeunlock,${DATE}_item,${DATE}_login,${DATE}_money"

  #创建日期
  DATE_DIR="$OUTPUT_DIR/$DATE"
  mkdir -p "$DATE_DIR"

  #开始导出数据
  mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$DATE_DIR" $OPTIONS

  #压缩文件
  TAR_FILE="$DATE.shu_db.tar.gz"
  tar czvf "$TAR_FILE" -C "$DATE_DIR" .

  #拷贝文件到目录
  mv "$TAR_FILE" "/data1/boomboy/shushu_db/tw.yh/"

  #删除文件
  rm -rf "$DATE_DIR"
  rm -rf "$TAR_FILE"
done

#指定日期
DATES=("2023-08-26")

#需要导出的表
for DATE in "${DATES[@]}"; do
  TABLES="${DATE}_chargeunlock,${DATE}_item,${DATE}_login,${DATE}_money"

  #创建日期
  DATE_DIR="$OUTPUT_DIR/$DATE"
  mkdir -p "$DATE_DIR"

  #开始导出数据
  mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$DATE_DIR" $OPTIONS

  #压缩文件
  TAR_FILE="$DATE.shu_db.tar.gz"
  tar czvf "$TAR_FILE" -C "$DATE_DIR" .

  #拷贝文件到目录
  mv "$TAR_FILE" "/data1/boomboy/shushu_db/tw.yh/"

  #删除文件
  rm -rf "$DATE_DIR"
  rm -rf "$TAR_FILE"
done

#指定日期
DATES=("2023-08-25")

#需要导出的表
for DATE in "${DATES[@]}"; do
  TABLES="${DATE}_chargeunlock,${DATE}_item,${DATE}_login,${DATE}_money"

  #创建日期
  DATE_DIR="$OUTPUT_DIR/$DATE"
  mkdir -p "$DATE_DIR"

  #开始导出数据
  mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$DATE_DIR" $OPTIONS

  #压缩文件
  TAR_FILE="$DATE.shu_db.tar.gz"
  tar czvf "$TAR_FILE" -C "$DATE_DIR" .

  #拷贝文件到目录
  mv "$TAR_FILE" "/data1/boomboy/shushu_db/tw.yh/"

  #删除文件
  rm -rf "$DATE_DIR"
  rm -rf "$TAR_FILE"
done

#指定日期
DATES=("2023-08-24")

#需要导出的表
for DATE in "${DATES[@]}"; do
  TABLES="${DATE}_chargeunlock,${DATE}_item,${DATE}_login,${DATE}_money"

  #创建日期
  DATE_DIR="$OUTPUT_DIR/$DATE"
  mkdir -p "$DATE_DIR"

  #开始导出数据
  mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$DATE_DIR" $OPTIONS

  #压缩文件
  TAR_FILE="$DATE.shu_db.tar.gz"
  tar czvf "$TAR_FILE" -C "$DATE_DIR" .

  #拷贝文件到目录
  mv "$TAR_FILE" "/data1/boomboy/shushu_db/tw.yh/"

  #删除文件
  rm -rf "$DATE_DIR"
  rm -rf "$TAR_FILE"
done

#指定日期
DATES=("2023-08-23")

#需要导出的表
for DATE in "${DATES[@]}"; do
  TABLES="${DATE}_chargeunlock,${DATE}_item,${DATE}_login,${DATE}_money"

  #创建日期
  DATE_DIR="$OUTPUT_DIR/$DATE"
  mkdir -p "$DATE_DIR"

  #开始导出数据
  mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$DATE_DIR" $OPTIONS

  #压缩文件
  TAR_FILE="$DATE.shu_db.tar.gz"
  tar czvf "$TAR_FILE" -C "$DATE_DIR" .

  #拷贝文件到目录
  mv "$TAR_FILE" "/data1/boomboy/shushu_db/tw.yh/"

  #删除文件
  rm -rf "$DATE_DIR"
  rm -rf "$TAR_FILE"
done

#指定日期
DATES=("2023-08-22")

#需要导出的表
for DATE in "${DATES[@]}"; do
  TABLES="${DATE}_chargeunlock,${DATE}_item,${DATE}_login,${DATE}_money"

  #创建日期
  DATE_DIR="$OUTPUT_DIR/$DATE"
  mkdir -p "$DATE_DIR"

  #开始导出数据
  mydumper -u "$USERNAME" -p "$PASSWORD" -h "$HOST" -l 99999999 -B "$DATABASE" -T "$TABLES" -o "$DATE_DIR" $OPTIONS

  #压缩文件
  TAR_FILE="$DATE.shu_db.tar.gz"
  tar czvf "$TAR_FILE" -C "$DATE_DIR" .

  #拷贝文件到目录
  mv "$TAR_FILE" "/data1/boomboy/shushu_db/tw.yh/"

  #删除文件
  rm -rf "$DATE_DIR"
  rm -rf "$TAR_FILE"
done

