title: CentOS Lnmp更改PHP版本
tags: []
categories: []
date: 2019-05-09 09:19:00
---
# 进入LNMP安装目录
```
[root@iZwz93t5hvwgq7l1r5y8cmZ lnmp1.5]# ls
addons.sh  conf     init.d      License  lnmp1.5.tar.gz  pureftpd.sh  src    uninstall.sh       upgrade.sh
ChangeLog  include  install.sh  lnmp1.5  lnmp.conf       README       tools  upgrade1.x-1.5.sh
```
# 更改`upgrade.sh`权限为755
```
chmod 777 upgrade.sh
```
# 安装PHP
## 运行命令进行升级
```
./upgrade.sh php
```
<!-- more -->
- 但如果lnmp安装的是lnmpa，则会提示
```
+-----------------------------------------------------------------------+
|            Upgrade script for LNMP V1.4, Written by Licess            |
+-----------------------------------------------------------------------+
|     A tool to upgrade Nginx,MySQL/Mariadb,PHP for LNMP/LNMPA/LAMP     |
+-----------------------------------------------------------------------+
|           For more information please visit https://lnmp.org          |
+-----------------------------------------------------------------------+
Current Stack: lnmpa, please run: ./upgrade.sh phpa
```
- 改为运行 `./upgrade.sh phpa`即可
## 根据提示，查找并输入`php`版本号
```
+-------+
|                            Upgrade scripss                            |
+-----------------------------------------------------------------------+
|     A tool to upgrade Nginx,MySQL/Mariadb,PHP for LNMP/LNMPA/LAMP     |
+-----------------------------------------------------------------------+
|           For more information please visit https://lnmp.org          |
+-----------------------------------------------------------------------+
Current PHP Version:7.1.18
You can get version number from http://www.php.net/
Please enter a PHP Version you want: 
```

## 官网上最新的版本号为`7.3`，但是我们以`php7.2`为例
> 顺带提一下，php版本不是越高越好，要看与当前的项目框架是否兼容，php7.2的语法校验比7.1严格很多，一些老项目可能会不兼容7.2有很多报错，别问我问什么知道...这里我是要从7.2降级回7.1
<div align=center>
<img width="70%" src="/images/WX20190509-094832.png"/>
</div>

## 服务器下载php压缩包太慢
> 如果遇到下载速度太慢的情况，可以停止命令，然后手动下载然后将压缩包上传到`lnmp1.5//src/`目录，在重新执行`./upgrade.sh php`

# lnmp支持升级、更改版本的内容
```
./upgrade.sh {nginx|mysql|mariadb|m2m|php|phpa|phpmyadmin}
```