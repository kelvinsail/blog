---
title: MySQL安装
tags:
  - MySQL
categories:
  - MySQL
toc: false
originContent: |+
  # Windows
  ## 下载（以5.7.29为例，下载x64的zip包）
  [下载页面](https://dev.mysql.com/downloads/mysql/)
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

date: 2020-06-11 22:10:14
---


# Windows
## 下载（以5.7.29为例，下载x64的zip包）
[下载页面](https://dev.mysql.com/downloads/mysql/)
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

