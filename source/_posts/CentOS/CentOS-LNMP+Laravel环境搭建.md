title: CentOS LNMP + Laravel环境搭建
tags:
  - CentOS
  - LNMP
  - Laravel
categories:
  - CentOS
  - LNMP
  - Laravel
author: yifan
date: 2018-02-06 22:39:00
---
# 1.安装vim、screen、wget；
```
yum install vim screen wget
```
# 2.开始安装LNMP一键包
- 开启screen会话，命名lnmp，在会话里开始安装LNMP；
<!-- more -->
```
screen –S lnmp
wget -c http://soft.vpser.net/lnmp/lnmp1.4.tar.gz && tar zxf lnmp1.4.tar.gz && cd lnmp1.4 && ./install.sh lnmp
```
- 如果想让会话推到后台继续运行，ctrl+a+d；
- 如果连接、会话中断，重新打开会话；
```
screen –R lnmp
```
# 3.选择MySQL版本，设置密码；

![upload successful](/images/pasted-77.png)

# 4.确认是否安装InnoDB；

![upload successful](/images/pasted-78.png)

# 5.选择PHP版本；

![upload successful](/images/pasted-79.png)

# 6.选择MemoryAlloc工具；

![upload successful](/images/pasted-80.png)

# 7.等待安装完成
# 8.安装完成后，进入mysql，开启mysql远程授权
```
mysql –uroot -p
use mysql;
grant all privileges on *.* to '账号名'@'%' identified by '密码' with grant option;
flush privileges;
```
## 9.检查防火墙，没有安装/启用则跳过；
## 10.配置sftp，重启sshd服务；
## 11.安装composer
```
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer
composer config -g repo.packagist composer https://packagist.phpcomposer.com
```
## 12.安装laravel
- 通过Composer安装
```
composer global require "laravel/installer"
```
- 添加环境，否则命令行输入【laravel】会提示找不到命令：
```
vim /etc/profile
```
- 在最后一行添加并保存（注意路径在安装时有输出）：
```
export PATH="$PATH:/root/.config/composer/vendor/bin"
```
- 刷新文件
```
source /etc/profile
```
## 13.确认laravel可执行路径的权限为777
- 进入路径文件夹：
```
cd /root/.config/composer/vendor/laravel/installer/
```
- 查看文件及权限：
```
ls -l
```
- 修改文件权限：
```
chmod 777 laravel
```
## 14. 确认`laravel`命令可执行 

## 15. 其他问题
- 部署LNMPA之后访问站点提示`You don't have permission to access /on this server.`，执行命令：
 ```chmod o+x  /home/项目名```