title: CentOS 安装pm2-web
tags:
  - CentOS
  - pm2-web
categories:
  - CentOS
author: yifan
date: 2018-09-17 17:57:00
---
---
##1、安装
```
npm install -g pm2-web
```

- 一直报错，无法安装，提示权限不足

![upload successful](/images/pasted-20.png)

<!-- more -->
- 关闭所有进程，命令添加【--unsafe-perm】
```
npm install --unsafe-perm -g pm2-web
```
- 安装成功

##2、运行
```
pm2 start all //启动被关闭的进程，非必要
pm2-web
```

![upload successful](/images/pasted-22.png)

##3、访问
> 可以看到监听的是9000端口，直接通过IP+端口访问页面，http://IP:9000
![upload successful](/images/pasted-21.png) 
