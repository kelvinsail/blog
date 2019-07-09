title: CentOS 部署YApi
tags:
  - CentOS
  - YApi
categories:
  - CentOS
  - YApi
author: yifan
date: 2018-09-13 17:55:00
---
---
#1.安装nodejs、npm
### 1)环境要求
*   nodejs（7.6+)
*   mongodb（2.6+）
*   git

> 如果安装错误会导致运行yapi server时报错

![upload successful](/images/pasted-30.png)

<!-- more -->
##2)下载源码安装包
```
wget http://nodejs.org/dist/v9.9.0/node-v9.9.0.tar.gz
```

![upload successful](/images/pasted-31.png)
##3)解压并进入目录
```
tar xzvf node-v9.9.0.tar.gz && cd node-v9.9.0
```
##4)检查、安装必须的插件
```
sudo yum install gcc gcc-c++
```
![upload successful](/images/pasted-32.png)

##5)编译、安装
```
 ./configure
sudo make
sudo make install
reboot//重启，如果安装之后可以运行node --version则不需要
```

![upload successful](/images/pasted-33.png)

#2.安装MongoDB
##1)创建仓库
```
vi /etc/yum.repos.d/mongodb-org-4.0.repo
```
填入内容
>[mongodb-org-4.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/4.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.0.asc
##2)开始安装
```
yum install -y mongodb-org
```

![upload successful](/images/pasted-34.png)
##3)配置MongoDB
配置IP限制
```
vi /etc/mongod.conf
```
>修改配置文件的 bindIp为0.0.0.0， 默认是 127.0.0.1， 只限于本地访问
![upload successful](/images/pasted-35.png)

##4)启动MongoDB
```
service mongod start
```

![upload successful](/images/pasted-36.png)
#3.安装yapi
##1)通过Gitlhub提供的yapi-cli工具部署
Github -> https://github.com/YMFE/yapi
```
npm install -g yapi-cli --registry https://registry.npm.taobao.org
```
##2)运行YApi部署工具
```
yapi server
```

![upload successful](/images/pasted-38.png)
##3)访问部署工具站点

![upload successful](/images/pasted-37.png)
##4)填写信息之后开始部署

![upload successful](/images/pasted-39.png)


![upload successful](/images/pasted-40.png)

##5)启动、访问YApi站点
```
cd /home/wwwroot/YAPI项目根目录/
node vendors/server/app.js
```

![upload successful](/images/pasted-41.png)

![upload successful](/images/pasted-42.png)

##6)安装pm2工具管理NodeJS
```
npm install -g pm2 //安装
cd /YAPI根目录
pm2 start vendors/server/app.js //添加yapi进程到pm2管理模块中
pm2 startup //生成自启脚本，保持当前进程活跃
pm2 save //保存当前进程状态
```

##7)MongoDB数据迁移
###导出数据
```
./mongodump //直接导出所有数据
```
###将数据json文件整个文件夹拷贝到目标服务器任意目录
###导入数据
```
mongorestore -d yapi /root/dump/目标数据库对应的备份目录
```
