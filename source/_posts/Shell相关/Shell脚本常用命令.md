title: Shell脚本常用命令
author: yifan
tags:
  - shell
categories:
  - Shell
date: 2019-07-12 21:04:00
---
# 遍历目录文件
```
files=$(ls $dir)
for filename in $files
do
 // 操作
done
```
<!-- more -->
# 时间日期
## 获取当前时间并格式化
time="$(date '+%Y-%m-%d %H:%M:%S')"

## 获取近几天的日期
```
dname1="$(date -d -1day +%Y%m%d)"	//昨天
dname1="$(date -d -2day +%Y%m%d)"	//前天
dname2="$(date -d -3day +%Y%m%d)"	//大前天
dname1="$(date -d 1day +%Y%m%d)"	//明天
dname1="$(date -d 2day +%Y%m%d)"	//后天
dname1="$(date -d 3day +%Y%m%d)"	//大后天
```

# 路径
## 获取当前绝对路径
```
work_path=$(dirname $(readlink -f $0))
echo $work_path
```

# 远程
## 普通SSH
```
ssh root@192.168.2.2
```
## 带秘钥文件SSH
```
chmod 600 /key.dat
ssh -o port=8922 -i '/key.dat' root@192.168.2.2
```

## SCP拉取文件
```
scp root@192.168.2.2:/* '本地目录'
```

# 链接&发送操作
## 数据库操作
```
mysql -uroot -p${password} <<EOF
use ${dbname};
INSERT INTO ${dbname}.sync_record_history(type, start_time, source, created_at)
VALUES ('$type', '$(date "+%Y-%m-%d %H:%M:%S")','$dir/$filename','$(date "+%Y-%m-%d %H:%M:%S")');
EOF
```

## SSH远程操作
```
chmod 600 /key.dat
ssh root@192.168.2.2 <<EOF
// ...输出操作，但不能执行脚本
EOF
```
