title: Mac安装极简环境Valet
tags:
  - Mac
  - Valet
categories:
  - Mac
  - Valet
author: yifan
date: 2018-12-26 18:41:00
---

## 一、什么是Valet
Valet是适用于Mac极简主义者的Laravel开发环境。不需要Vagrant, 也不用配置/etc/hosts。甚至可以使用本地隧道协议共享站点到外网。

Laravel Valet将Mac配置为在机器启动时始终在后台运行[Nginx](https://www.nginx.com/)。然后，使用[DnsMasq](https://en.wikipedia.org/wiki/Dnsmasq)，Valet代理域上的所有请求以指向安装在本地计算机上的站点。

> 最好后缀名改为*.test，防止chrome直接重定向到https，另外，梯子不能开全局，不然也会导致*.test无法访问

换句话说，Valet是一个超快的Laravel开发环境，使用大约7 MB的RAM。Valet不是Vagrant或Homestead的完全替代品，但如果只需要极简的环境、极佳的速度，或者在内存有限的设备上工作，它会是一个很好的选择。
<!-- more -->
## 二、安装
### 1、更新 Homebrew 到最新版本
```
update brew
```

> 如果没有安装HomeBrew的话，需要先安装
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
### 2、安装Composer
```
brew services list
brew install composer
```
在国内的话最好安装完composer后，将源切换到国内镜像
```
composer config -g repo.packagist composer https://packagist.phpcomposer.com
```
此外，php版本最好为7.0+
### 3、开始安装
运行
```
composer global require laravel/valet 
```
### 4、更新配置
```
vi ~/.bash_profile
```
确认~/.composer/vendor/bin是否添加到环境变量中，如果没有，则自行添加
```
echo 'export PATH=~/.composer/vendor/bin:$PATH' >> ~/.bash_profile
source ~/.bash_profile
```

### 5、安装并启动Valet
```
 valet install 
```
会开始配置并安装 Valet 和 DnsMasq，如果没有安装Nginx，它也会自动安装
但如果运行后报错：Unable to determine linked PHP
```
 $ valet install
Stopping nginx...
Installing nginx configuration...
Installing nginx directory...
Updating PHP configuration...

In Brew.php line 182:

  Unable to determine linked PHP.
```

确保已经安装了php7.0+或者自带php版本就已经是7.0+的话运行
```
ln -s /usr/local/opt/php71/bin/php /usr/local/bin/php
```
再重新运行valet install
### 6、更改域名后缀为test
```
valet domain test
```

测试：ping *.test
```
$ ping *.test
PING *.test (127.0.0.1): 56 data bytes
64 bytes from 127.0.0.1: icmp_seq=0 ttl=64 time=0.021 ms
64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.078 ms
^C
--- *.test ping statistics ---
2 packets transmitted, 2 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 0.021/0.050/0.078/0.029 ms
```