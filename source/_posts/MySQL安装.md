---
title: MySQL安装
tags:
  - MySQL
categories:
  - MySQL
toc: false
date: 2020-06-11 22:10:14
---

# Centos
## 安装wget

<!-- more -->
```
[root@localhost ~]# yum install wget
已加载插件：fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirrors.aliyun.com
 * epel: mirror01.idc.hinet.net
 * extras: mirrors.aliyun.com
 * updates: mirrors.aliyun.com
正在解决依赖关系
--> 正在检查事务
---> 软件包 wget.x86_64.0.1.14-15.el7_4.1 将被 安装
--> 解决依赖关系完成

依赖关系解决

=====================================================================================================
 Package             架构                  版本                            源                   大小
=====================================================================================================
正在安装:
 wget                x86_64                1.14-15.el7_4.1                 base                547 k

事务概要
=====================================================================================================
安装  1 软件包

总下载量：547 k
安装大小：2.0 M
Is this ok [y/d/N]: y
Downloading packages:
wget-1.14-15.el7_4.1.x86_64.rpm                                               | 547 kB  00:00:00
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  正在安装    : wget-1.14-15.el7_4.1.x86_64                                                      1/1
  验证中      : wget-1.14-15.el7_4.1.x86_64                                                      1/1

已安装:
  wget.x86_64 0:1.14-15.el7_4.1

完毕！
```

## 安装MySQL软件源
```
[root@localhost ~]# wget http://repo.mysql.com/mysql57-community-release-el7-10.noarch.rpm
--2018-08-09 23:20:07--  http://repo.mysql.com/mysql57-community-release-el7-10.noarch.rpm
正在解析主机 repo.mysql.com (repo.mysql.com)... 223.119.242.56
正在连接 repo.mysql.com (repo.mysql.com)|223.119.242.56|:80... 已连接。
已发出 HTTP 请求，正在等待回应... 200 OK
长度：25548 (25K) [application/x-redhat-package-manager]
正在保存至: “mysql57-community-release-el7-10.noarch.rpm”

100%[===========================================================>] 25,548      --.-K/s 用时 0.03s

2018-08-09 23:20:07 (992 KB/s) - 已保存 “mysql57-community-release-el7-10.noarch.rpm” [25548/25548])
```
```
[root@localhost ~]# sudo rpm -Uvh mysql57-community-release-el7-10.noarch.rpm
警告：mysql57-community-release-el7-10.noarch.rpm: 头V3 DSA/SHA1 Signature, 密钥 ID 5072e1f5: NOKEY
准备中...                          ################################# [100%]
正在升级/安装...
   1:mysql57-community-release-el7-10 ################################# [100%]
```
## 开始安装MySQL服务端
```

[root@localhost ~]#  yum install -y mysql-community-server
已加载插件：fastestmirror
mysql-connectors-community                                                    | 2.5 kB  00:00:00
mysql-tools-community                                                         | 2.5 kB  00:00:00
mysql57-community                                                             | 2.5 kB  00:00:00
(1/3): mysql-tools-community/x86_64/primary_db                                |  45 kB  00:00:00
(2/3): mysql-connectors-community/x86_64/primary_db                           |  25 kB  00:00:00
(3/3): mysql57-community/x86_64/primary_db                                    | 152 kB  00:00:00
Loading mirror speeds from cached hostfile
 * base: mirrors.aliyun.com
 * epel: mirror01.idc.hinet.net
 * extras: mirrors.aliyun.com
 * updates: mirrors.aliyun.com
正在解决依赖关系
--> 正在检查事务
---> 软件包 mysql-community-server.x86_64.0.5.7.23-1.el7 将被 安装
--> 正在处理依赖关系 mysql-community-common(x86-64) = 5.7.23-1.el7，它被软件包 mysql-community-server-5.7.23-1.el7.x86_64 需要
--> 正在处理依赖关系 mysql-community-client(x86-64) >= 5.7.9，它被软件包 mysql-community-server-5.7.23-1.el7.x86_64 需要
--> 正在处理依赖关系 perl(strict)，它被软件包 mysql-community-server-5.7.23-1.el7.x86_64 需要
--> 正在处理依赖关系 perl(Getopt::Long)，它被软件包 mysql-community-serve

·········省略

  验证中      : 1:mariadb-libs-5.5.56-2.el7.x86_64                                             33/33

已安装:
  mysql-community-libs.x86_64 0:5.7.23-1.el7     mysql-community-libs-compat.x86_64 0:5.7.23-1.el7
  mysql-community-server.x86_64 0:5.7.23-1.el7

作为依赖被安装:
  mysql-community-client.x86_64 0:5.7.23-1.el7      mysql-community-common.x86_64 0:5.7.23-1.el7
  perl.x86_64 4:5.16.3-292.el7                      perl-Carp.noarch 0:1.26-244.el7
  perl-Encode.x86_64 0:2.51-7.el7                   perl-Exporter.noarch 0:5.68-3.el7
  perl-File-Path.noarch 0:2.09-2.el7                perl-File-Temp.noarch 0:0.23.01-3.el7
  perl-Filter.x86_64 0:1.49-3.el7                   perl-Getopt-Long.noarch 0:2.40-3.el7
  perl-HTTP-Tiny.noarch 0:0.033-3.el7               perl-PathTools.x86_64 0:3.40-5.el7
  perl-Pod-Escapes.noarch 1:1.04-292.el7            perl-Pod-Perldoc.noarch 0:3.20-4.el7
  perl-Pod-Simple.noarch 1:3.28-4.el7               perl-Pod-Usage.noarch 0:1.63-3.el7
  perl-Scalar-List-Utils.x86_64 0:1.27-248.el7      perl-Socket.x86_64 0:2.010-4.el7
  perl-Storable.x86_64 0:2.45-3.el7                 perl-Text-ParseWords.noarch 0:3.29-4.el7
  perl-Time-HiRes.x86_64 4:1.9725-3.el7             perl-Time-Local.noarch 0:1.2300-2.el7
  perl-constant.noarch 0:1.27-2.el7                 perl-libs.x86_64 4:5.16.3-292.el7
  perl-macros.x86_64 4:5.16.3-292.el7               perl-parent.noarch 1:0.225-244.el7
  perl-podlators.noarch 0:2.5.1-3.el7               perl-threads.x86_64 0:1.87-4.el7
  perl-threads-shared.x86_64 0:1.43-6.el7

替代:
  mariadb-libs.x86_64 1:5.5.56-2.el7

完毕！

```

## 启动MySQL
```
service mysqld start
```
## 重新设置mysql root账号
```
 [root@localhost ~]# sudo grep 'temporary password' /var/log/mysqld.log
2019-01-10T10:02:21.971876Z 1 [Note] A temporary password is generated for root@localhost: fQv3YsS-RjZA
```
## 登录mysql root账号
```
 [root@localhost ~]# mysql -uroot -pfQv3YsS-RjZA
```
> mysql默认账号密码强度有一定要求，如果是测试环境或本地环境想设置简单密码，则需要先调整密码强度设置

## 调整密码长度要求
```
mysql> set global validate_password_length=0;
```
## 调整密码强度检查等级，0/LOW、1/MEDIUM、2/STRONG
```
mysql> set global validate_password_policy=0;
```
## 设置密码为123456
```
mysql> set password for 'root'@'localhost' = password('123456');
```
## 设置root允许远程登录
```
mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
```
## 刷新缓存并退出
```
mysql> flush privileges;
mysql> exit
```

# Windows
## 下载（以5.7.29为例，下载x64的zip包）
在历史版本中选择5.7.29[历史版本](https://downloads.mysql.com/archives/community/)
![image.png](/images/2020/06/15/7cd632e0-aea9-11ea-8730-812c8aa7bada.png)

或者最新版
[最新版本](https://dev.mysql.com/downloads/mysql/)
![image.png](/images/2020/06/11/67499040-abeb-11ea-b272-f9510041fa93.png)


## 安装
- 解压到目标路径
- 在mysql跟目录下创建`my.ini`配置文件，写入配置
```
[client]
# 设置mysql客户端默认字符集
default-character-set=utf8
 
[mysqld]
# 设置3306端口
port = 3306
# 设置mysql的安装目录
basedir=D:\\路径\\mysql-5.7.29-winx64
# 设置 mysql数据库的数据的存放目录，MySQL 8+ 不需要以下配置，系统自己生成即可，否则有可能报错
datadir=D:\\路径\\mysql-5.7.29-winx64\\data
# 允许最大连接数
max_connections=20
# 服务端使用的字符集默认为8比特编码的latin1字符集
character-set-server=utf8
# 创建新表时将使用的默认存储引擎
default-storage-engine=INNODB
```

- 右键以管理员身份打开命令行工具（必须是管理员身份运行！！）
- 进入`mysql/bin`文件夹下
- 运行命令`mysqld --initialize --console`初始化mysql
![image.png](/images/2020/06/11/f20c7b70-abeb-11ea-b272-f9510041fa93.png)
- 初始化成功之后，会输出随机密码，先记下
- 再运行命令安装`mysqld install`
成功后输出`Service successfully installed.`
- 开启mysql服务`net start mysql`
- 关闭mysql服务`net stop mysql`

## 忘记密码
- 关闭mysql服务
- 打开`my.ini`配置文件
- 在`[mysqld]`节点下输入`skip-grant-tables`
- 启动mysql服务
- 运行`mysql -u root -p`，不用输入密码，直接回车以root进入mysql命令行
- 运行命令修改密码
```
mysql> use mysql;
Database changed
mysql> update mysql.user set authentication_string=password('12345678') where user='root' and host = 'localhost';
Query OK, 1 row affected, 1 warning (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 1
```
- 刷新缓存并离开
```
mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)

mysql> quit
Bye
```
- 关闭mysql、删除`[mysqld]`节点下的`skip-grant-tables`
- 重新启动，即可再以root身份进入mysql

# 异常报错

## 1862: Your password has expired.
- 命令行以root进入mysql
- 运行命令，设置密码并刷新缓存即可
```
mysql> set password=password('12345678');
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)

mysql> exit
Bye
```