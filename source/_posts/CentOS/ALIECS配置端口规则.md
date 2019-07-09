title: Aliyun ECS 配置端口规则
tags:
  - VPS
  - 端口规则
  - 安全组
categories:
  - VPS
author: yifan
date: 2018-09-14 11:17:00
---
---
##1、阿里云服务器购买之后，ssh、sftp可以访问，直接部署nginx无法访问，是因为80、8000/9000端口默认没有开放
<!-- more -->
##2、进入控制台，打开ECS实例->配置规则

![upload successful](/images/pasted-23.png)
##3、增加80、8000/9999(非必要)端口号开放规则

![upload successful](/images/pasted-24.png)
> 如果购买了ECS云服务器，安装了MySQL、开启账号远程访问之后，依旧无法远程连接数据库，也有可能是3306端口没有配置安全规则的问题...