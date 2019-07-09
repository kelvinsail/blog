title: CentOS 安装imagick
tags:
  - CentOS
  - imagick
categories:
  - CentOS
author: yifan
date: 2018-09-14 10:54:00
---
---
#1、安装ImageMagick
##1) 下载源码
```
wget http://www.imagemagick.org/download/ImageMagick.tar.gz
```

![upload successful](/images/pasted-25.png)
<!-- more -->
##2) 开始编译、安装
```
tar -xzvf ImageMagick.tar.gz
cd ImageMagick-7.0.8-11
./configure --prefix=/usr/local/imagemagick
make && make install
```

##3) 创建连接（非必要，如果需要在运行convert命令处理图片可以添加）
```
cd /usr/bin
ln -s /usr/local/imagemagick/bin/convert convert
```

##4) 检查是否安装成功
```
/usr/local/imagemagick/bin/convert -version
或者 convert -version
```
![upload successful](/images/pasted-29.png)
#2、安装php扩展imagick
##1） 下载源码
```
//最新版本2017年2月1号发布，3.4.3.......
wget http://pecl.php.net/get/imagick-3.4.3.tgz
```

![upload successful](/images/pasted-26.png)
##2）解压、编译安装
```
tar -xzvf imagick-3.4.3.tgz
cd imagick-3.4.3
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config --with-imagick=/usr/local/imagemagick
make && make install
```

![upload successful](/images/pasted-27.png)
##3) 更改php.ini加入so文件
打开/usr/local/php/etc/php.ini
在末尾加入：extension = imagick.so

##4) 重启php，检查是否安装成功
```
php -m | grep imagick
```
![upload successful](/images/pasted-28.png)
