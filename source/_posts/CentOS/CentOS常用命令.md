---
title: CentOS常用命令
tags:
  - CentOS
  - CentOS命令
categories:
  - CentOS
toc: false
author: yifan
date: 2019-05-17 10:17:00
---

# 系统
## 查看系统版本
```
cat /etc/redhat-release
```

## 其他软件包版本查看
```
supervisord -v
php -v 
mysql -V 
java -version
```
<!-- more -->
## 关机/重启
```
reboot //重启
shutdown -r now //立刻重启(root用户使用)
shutdown -r 10 //过10分钟自动重启(root用户使用)
shutdown -r 20:35 //在时间为20:35时候重启(root用户使用)
```

# 文件操作
## 文件夹
### 创建
```
mkdir dirpath
```
### 自动创建全路径
```
mkdir -p dirpath
```
## 文件
### 复制
```
cp filepath newfilepath
```
### 复制并强制覆盖
```
/bin/cp -rf filepath newfilepath
```
## 查找
```
find ./ -name "filename"
```
## 移动
```
mv filepath newfilepath
mv -r dirpath newdirpath
mv dirorfile newdirorfile //也可用来给文件或文件夹重命名
```


# Crontab定时任务
## 查看当前用户的定时任务
```
crontab -l
```
## 编辑当前用户的定时任务
```
crontab -e
```
## 编辑全局定时任务
```
vim /etc/crontab
```
> 在该配置文件中，可以与`crontab -e`一样配置执行定时任务，但可以指定执行crontab任务的用户

```
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed

# 分 时 日期 月份 星期几 用户名 要执行的命令
```
# 网络
## 端口

```
netstat -tnlp
```
## IP
```
ip a //或addr或address
```
# 进程
## ps
```
ps -ef
```
## ps查看进程数量
```
ps -ef | wc -l 
```

## top
### 列表查看进程信息
```
top
```
### 按用户查看
```
top -u mysql
```

### 按进程pid查看
```
pidof mysqld
# 5310 //输出mysqld进程的pid
top -p 5310 //按进程pid查看
top -p 5310,5311,5312 //多个进程pid以','隔开
```

### 查看端口占用情况
```
lsof -i tcp:80
```

###  杀死进程
#### kill（杀死进程）
```
kill 信号 pid

```
- 常用信号值
 - -2：通知进程停止执行，也就是`ctrl+c`
 - -9：立即强制停止进程
 - -15：预设的信号，以正常的程序通知进程停止执行
 - -l：列出所有可用的信号
 
#### killall（通过进程名杀死进程）
```
killall 选项 名称
```
- 常用选项
 - -e：对长名称进行精确匹配；
 - -l：忽略大小写的不同；
 - -p：杀死进程所属的进程组；
 - -i：交互式杀死进程，杀死进程前需要进行确认；
 - -l：打印所有已知信号列表；
 - -q：如果没有进程被杀死。则不输出任何信息；
 - -r：使用正规表达式匹配要杀死的进程名称；
 - -s：用指定的进程号代替默认信号“SIGTERM”；
 - -u：杀死指定用户的进程。

# 开机启动项
## 查看启动项
```
systemctl list-unit-files //查看所有项，包括禁用的
systemctl list-unit-files | grep enable //查看已启用的开机项
```
## 设置开机启动
```
systemctl is-enabled supervisor.service //查看是否开机启动
systemctl enable supervisor.service //设置开机启动
systemctl disable supervisor.service //禁止开机启动
```


# 磁盘
## 查看磁盘使用情况
```
df -h
```
## 统计文件夹、文件大小
```
du -s ./*
```


# 内存
```
free -h
```


# 压缩/解压

## zip压缩
## 压缩目录
```
zip -r 压缩后的文件.zip 要压缩的文件夹路径
```
## 排除文件、文件夹
```
zip -r 压缩后的文件.zip 要压缩的文件夹路径 -x "要压缩的文件夹路径/logs/*" -x "要压缩的文件夹路径/images/*" 
```

## unzip解压

# Nginx

## 查看版本
```
nginx -v
```
## 重载配置
```
nginx -s reload
```

# Apache
## 查看版本
```
/usr/local/apache/bin/httpd -v
```
## 重启
```
service httpd restart
```
# pm2
## 进程操作
```
pm2 start [name|file|ecosystem|id..] //运行项目并加入管理
pm2 restart [id|name|all|json|stdin...] //重载项目
pm2 stop [id|name|all|json|stdin...] //停止项目
```

## 查看应用列表
```
pm2 list
```

## 将项目加入pm2
```
pm2 start app.js
```

## 保存并加入开机启动
```
pm2 startup
pm2 save
```