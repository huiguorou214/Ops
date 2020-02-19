# date

## 介绍

此命令主要用于查看或者修改等管理操作系统时间的操作

## 语法

### 常用format

```
%Y  YYYY格式的年份（Year）
%m  mm格式的月份（），01-12
%d   dd格式的日期（day of month），01-31
%H   HH格式的小时数（），00-23
%M  MM格式的分钟数（），00-59
%S   SS格式的秒数（），00-59
%F   YYYY-mm-dd格式的完整日期（Full date），同%Y-%m-%d
%T   HH-MM-SS格式的时间（Time），同%H:%M:%S
%s   自1970年以来的秒数。C函数time(&t) 或者Java中 System.currentTimeMillis()/1000, new Date().getTime()/1000
%w   星期几，0-6，0表示星期天
%u   星期几，1-7，7表示星期天
```


注意以上格式是可以任意组合的，还可以包括非格式串，比如 date "+今天是%Y-%d-%m，现在是$H:%M:%S"

## example

设置当前日期时间，只有root用户才能执行，执行完之后还要执行 clock -w 来同步到硬件时钟。
mm为月份，dd为日期，HH为小时数，MM为分钟数，YYYY为年份，SS为秒数。
格式：date mmddHHMM
格式：date mmddHHMMYYYY
格式：date mmddHHMM.SS
格式：date mmddHHMMYYYY.SS

## 需求-实现

如何查看现在的时间（就是从1970-01-01到现在的总秒数）
date +%s

如何查看未来某个时间点的总秒数（比如2017-12-01要开服，那我怎么查看那一天的秒数）
date  +%s  --date='YYMMDD'
date  +%s  --date='20171201'


几种常见的日期显示格式
date +%F    
    2018-01-02
date +%Y%m%d
    20180102

指定1970年以来的秒数
 date -d '1970-01-01 1251734400 sec utc'      （2009年 09月 01日 星期二 00:00:00 CST）
 date -d '1970-01-01 1314177812 sec utc'      （2011年 08月 24日 星期三 17:23:32 CST）

## 参考博客

http://www.cnblogs.com/diyunpeng/archive/2011/11/20/2256538.html   我使用过的Linux命令之date - 显示、修改系统日期时间