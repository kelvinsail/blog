title: Laravel - Hello World
tags:
  - PHP
  - Laravel
categories:
  - PHP
  - Laravel
author: yifan
date: 2018-02-07 16:57:00
---
---
1、将所需的[URL](http://test.kelvinsail.com)解析地址指向本地虚拟机ip；
2、创建Laravel新项目
进入“/home/wwwroot/”目录下，通过：
```
laravel new test.kelvinsail.com
```
创建一个新的laravel项目，这样可以提前安装好所有代码依赖，不用再通过composer install来安装； 
- 但提示：

 > "The Process class relies on proc_open, which is not available on your PHP installation."
<!-- more -->
![upload successful](/images/pasted-3.png)

- 原因是php.ini文件中，“proc_open”函数被禁用
打开"/usr/local/php/etc/php.ini"，搜索"disable_functions"，检查项里是否有proc_open、proc_get_status两个函数，删除；
```
vim /usr/local/php/etc/php.ini
```

![upload successful](/images/pasted-4.png)
- 重新创建项目
```
laravel new --force test.kelvinsail.com
```

![upload successful](/images/pasted-5.png)

也可以下载[Github的Laravel仓库](https://github.com/laravel/laravel/archive/master.zip)上的开源项目，zip直接下载后，通过ftp上传到wwwroot目录中，进入项目根目录直接通过命令安装
```
composer install
```
也可以通过composer来安装
```
$ composer create-project laravel/laravel 项目名 --prefer-dist
```
- 安装后访问url，如果出现错误
> RuntimeException No application encryption key has been specified.

则是根目录.env没有创建或刷新，需要在项目根目录，创建.env 文件并写入：
```
APP_NAME=Laravel
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_LOG_LEVEL=debug
APP_URL=http://localhost

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=homestead
DB_USERNAME=homestead
DB_PASSWORD=secret

BROADCAST_DRIVER=log
CACHE_DRIVER=file
SESSION_DRIVER=file
SESSION_LIFETIME=120
QUEUE_DRIVER=sync

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_DRIVER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null

PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=
```
- 在项目下执行，重新生成APP_KEY并写入到.env文件中
```
php artisan key:generate
```
- 安装成功
![upload successful](/images/pasted-6.png)
- 确认文件权限、所有者
```
cd /home/wwwroot/
chown -R www:www ./*
chmod -R 755 ./*
lnmp restart
```
3、添加vhost
- 可以手动添加vhost，但要先确定nginx的路径；
- 如果是lnmp环境，也可以通过lnmp直接添加：
```
lnmp vhost add test.kelvinsail.com
```

![upload successful](/images/pasted-7.png)
- 添加vhost后直接打开test.kelvinsail.com，显示403，打开“/usr/local/nginx/conf/vhost/test.kelvinsail.com.conf”编辑
```
server
    {
        listen 80;
        #listen [::]:80;
        server_name test.kelvinsail.com;
        index index.html index.htm index.php default.html default.htm default.php;
        #要注意，指向项目public文件夹
        root  /home/wwwroot/test.kelvinsail.com/public;

        include other.conf;
        #error_page   404   /404.html;

        # Deny access to PHP files in specific directory
        #location ~ /(wp-content|uploads|wp-includes|images)/.*\.php$ { deny all; }

        # 注释掉下面这一行，不需要引入php配置，try_files会导致抛出500异常
        #include enable-php.conf;

        # 增加laravel链接支持
        location / {
            try_files $uri $uri/ /index.php?$query_string;
        }

        #增加php支持
        location ~ \.php$ {
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass  unix:/tmp/php-cgi.sock;
            fastcgi_index index.php;

            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;

        }


        location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
        {
            expires      30d;
        }

        location ~ .*\.(js|css)?$
        {
            expires      12h;
        }

        location ~ /.well-known {
            allow all;
        }

        location ~ /\.
        {
            deny all;
        }

        access_log  /home/wwwlogs/test.kelvinsail.com.log;
    }

```

![upload successful](/images/pasted-8.png)

4、重新打开http://test.kelvinsail.com

![upload successful](/images/pasted-9.png)