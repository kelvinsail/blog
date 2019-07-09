title: CentOS 编译安装nodejs
tags:
  - CentOS
  - nodejs
categories:
  - CentOS
  - nodejs
author: yifan
date: 2019-04-29 10:15:00
---
---
# 访问`https://nodejs.org/dist/`查看最新版本
这里以`v9.9.0`为例
# 开始安装`v9.9.0`
```
yum install gcc gcc-c++ //检查是否已安装编译所需的软件包
wget https://nodejs.org/dist/v9.9.0/node-v9.9.0.tar.gz
tar zxvf node-v9.9.0.tar.gz 
cd node-v9.9.0
./configure
make && make install //耗时会比较久
```
<!-- more -->
> npm也可以通过`yum install epel-release nodejs`快速安装，但是版本比较旧；也可以下载已经编译好得版本，解压后使用；

# 运行`node -v` & `npm -v` 检查是否安装成功
> 如果提示`/usr/bin/npm: No such file or directory`，则是因为没有创建链接
# 创建连接、运行
- 查找npm安装位置
```
# whereis npm
npm: /usr/local/bin/npm
# /usr/local/bin/npm -v
5.6.0
# /usr/local/bin/node -v
v9.9.0
```
## 创建软连接
```
# ln -s /usr/local/bin/npm /usr/bin/npm
# ln -s /usr/local/bin/node /usr/bin/node
```
## 运行`-v`查看版本
```
# npm -v
5.6.0
# node -v
v9.9.0
```