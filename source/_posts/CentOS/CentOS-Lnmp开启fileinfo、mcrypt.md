title: CentOS Lnmp开启fileinfo、mcrypt
tags:
  - CentOS
  - Lnmp
  - fileinfo
  - mcrypt
categories:
  - CentOS
  - Lnmp
author: yifan
date: 2018-08-02 18:33:00
---
---
# 一、开启fileinfo
## 1、进入lnmp安装文件夹根目录：`/root/lnmp1.5/src/`
## 2、解压php安装包：`tar -jxvf php-7.0.30.tar.bz2`
## 3、进入php安装文件目录：`cd php-7.0.30`
## 4、进入fileinfo文件夹：`cd ext/fileinfo`
<!-- more -->
## 5、执行：`/usr/local/php/bin/phpize`

![upload successful](/images/pasted-54.png)

## 6、执行：`./configure --with-php-config=/usr/local/php/bin/php-config`

![upload successful](/images/pasted-55.png)

## 7、执行：`make && make install`

![upload successful](/images/pasted-56.png)

## 8、更改php.ini加入so文件
打开`/usr/local/php/etc/php.ini`
在末尾加入：`extension = fileinfo.so`

## 9、重启lnmp
执行：`lnmp restart`

## 10、phpinfo()检查是否开启

![upload successful](/images/pasted-57.png)


# 二、手动安装、开启mcrypt
```
ErrorException: Function mcrypt_enc_get_key_size() is deprecated in /home/wwwroot/···
```
> 升php之后，出现上述错误，因为从php7.1+ 开始，php默认不安装mcrypt，但是php包中还是会有mcrypt代码提供编译安装，可以自行手动编译打包安装；
> 但从php7.2开始，mcrypt已经从安装包中移除，只能使用pecl安装

## 1、PHP7.1+安装
### 1）编译打包安装，以php7.1.26为例（7.2+参考步骤2）：
```
cd /php-7.1.26/ext/mcrypt
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install
```

## 2、PHP7.2安装过程
### 1）下载、安装必要插件
```
yum install libmcrypt libmcrypt-devel mcrypt mhash //安装必要的工具
wget http://pecl.php.net/get/mcrypt-1.0.1.tgz //下载源码
tar xzvf mcrypt-1.0.1.tgz && cd mcrypt-1.0.1 //解压并进入目录
```

### 2) 开始安装
```
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install
```

## 3、编辑`php.ini`
> PHP7.1，将`;mcrypt.modes_dir=`改为`mcrypt.modes_dir=/usr/lib64/php/modules`
> PHP7.2，需要手动加入
> ```
> extension = mcrypt.so
> mcrypt.modes_dir=/usr/lib64/php/modules
> ```

## 4、检查是否已安装完毕
重启php、apache、nginx等
运行`php -m`查看是否已经加载mcrypt模块
```
# php -m
[PHP Modules]
bcmath
//前后省略···
libxml
mbstring
mcrypt
mysqli
mysqlnd
openssl
//前后省略···
```

## 5、修改代码
`mcrypt_enc_get_key_size()`需要改为`@mcrypt_enc_get_key_size()`
通过`@`符号使代码强制运行起来，不然还是会报deprecated错误