title: innobackupex实现MySQL远程备份
tags:
  - innobackupex
  - MySQL
categories:
  - innobackupex
  - MySQL
author: yifan
date: 2019-02-28 16:55:00
---
# 一、了解innobackupex
## 1、mysqldump
- mysql逻辑备份工具，作用于服务器本地，不需要额外安装插件
- 可以单表备份，备份为sql文件形式、方便，可以编辑、再压缩，在多个场景通用
- 可通过shell命令实现定时备份，但备份时如果用户有操作，容易造成脏数据
- 将数据库备份到服务器本地sql文件，属于逻辑备份，不受数据库引擎限制
- 只能（全库或单表的）全量备份，恢复的话只能覆盖原有数据，或者恢复到新的表中，再手动处理
- 单线程，数据量大时备份耗时较长，且锁表容易引对不支持事务的表造成影响

## 2、mysqlhotcopy
- 需要安装perl-DBD-mysql包，只能运行、备份在服务器本地
- 文件的快速备份，属于物理备份，恢复时只需要复制文件到目录下替换源文件
- 只支持MyISAM引擎的MySQL数据库备份

<!-- more -->
## 3、innobackupex
- 属于物理备份，需要安装额外的插件，支持全量备份&增量备份
- 备份、恢复速度快，支持远程、并发、限速备份，支持加密传输到本地
- 支持 MyISAM （会锁表，似乎不支持增量？）跟 InnoDB
- 备份文件比`mysqldump`所导出的`sql`文件的要大很多

# 二、安装
>注意innobackup版本与mysql版本，innobackup2.2不支持mysql5.7+
##1、查看最新版本：https://www.percona.com/downloads/XtraBackup/LATEST/

![upload successful](/images/pasted-64.png)

## 2、开始安装
```
[root@localhost ~]# yum -y install https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.12/binary/redhat/7/x86_64/percona-xtrabackup-24-2.4.12-1.el7.x86_64.rpm
```

![upload successful](/images/pasted-65.png)

# 三、配置远程免密登录
> 如果要实现远程备份，必须配置远程免密登录，否则备份过程会没有报错，但是一直卡死在‘log scanned up to’，导致无法继续备份
180920 17:15:39 >> log scanned up to (1023762231)
180920 17:15:40 >> log scanned up to (1023762231)
180920 17:15:41 >> log scanned up to (1023762231)
....
但如果log scanned up to后面括号中的数值有变动，则并未卡死，仍在备份中

- 生成秘钥，如果已经生成过，则跳过这一步
```
ll ~/.ssh/   //如果已有rsa文件，则是已生成
ssh-keygen -t rsa
```
一路回车，不需要其他信息
- 添加公钥到远程主机
```
ssh-copy-id -i ~/.ssh/id_rsa.pub 用户名@主机IP
```
> 会提示输入远程主机用户名对应的密码，必须输入不能留空
最后会提示通过‘ssh 用户名@IP’命令确认是否成功开启免密登录

![upload successful](/images/pasted-66.png)

# 四、备份

### 定时备份
> 定时通过innobackupex备份数据库、scp传送到指定
```
#!/bin/bash

cd /home

if [ ! -d "crontab" ];then
mkdir crontab
else
echo "文件夹已经存在"
fi

cd crontab
date=`date +%Y%m%d`
echo `date +%Y%m%d-%H%M`：开始备份 >> backup_db.log

echo "------ start backup db ------"

ssh root@39.108.123.165 \ "mkdir /home/backup/database/`date +%Y%m%d`"

echo `date +%Y%m%d-%H%M`：创建目录-$date >> backup_db.log

innobackupex --defaults-file=/etc/my.cnf --no-lock --user 'root' --password 'password123' --stream=tar ./ | ssh root@192.1168.2.100 \ "cat - > /home/backup/database/`date +%Y%m%d`/`date +%H-%M`-backup.tar"

echo `date +%Y%m%d-%H%M`：备份结束 >> backup_db.log

echo "------ end backup db ------"
```

# 五、还原

> 注意: 还原的服务器上也要安装innobackupex

## 1、全量还原
### 1）解压tar包到目录/backup/full/05-00-backup中
```
mkdir -p /backup/full/05-00-backup
tar -xvf 05-00-backup.tar -C /backup/full/05-00-backup
```
### 2）停止mysql服务，并移除mysql目录下的文件，当然可以先打包备份下以防万一
```
service mysqld stop //停止mysql服务
zip -r /var/lib/mysql.zip /var/lib/mysql   //备份下
rm -rf /var/lib/mysql/* //移除文件
```

> mysql目录并不一定是`/var/lib/mysql/`，可以运行innobackupex看下目录所在
[root@localhost ~]# innobackupex
xtrabackup: recognized server arguments: --datadir=/var/lib/mysql 
190116 16:37:40 innobackupex: Missing argument
  可以看到`--datadir=/var/lib/mysql`，也有安装lnmp的mysql位置在`/usr/local/mysql/var`
### 3）开始恢复（apply-log），应用备份文件，回滚未提交的事务
```
innobackupex --defaults-file=/etc/my.cnf --user=root --password=hello12345 --use-memory=1G --apply-log /backup/full/05-00-backup
```
> --use-memory=1G是为了加快速度，apply-log之后目标文件下的文件已经准备就绪

```
innobackupex --defaults-file=/etc/my.cnf --user=root --password=hello12345 --copy-back /backup/full/05-00-backup
```
### 4）重新设定mysql文件夹及子文件用户群组为mysql
```
chown -R mysql:mysql /var/lib/mysql/
```
### 5）启动MySQL
```
service mysqld start
```