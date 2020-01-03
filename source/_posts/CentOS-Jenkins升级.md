---
title: CentOS Jenkins升级
tags:
  - CentOS
  - Jenkins
categories:
  - CentOS
  - Jenkins
toc: false
date: 2019-12-30 09:02:39
---

# 当Jenkins控制台提示有新版本升级时
![image.png](/images/2019/12/30/729a1a50-2a9f-11ea-a8af-c74ee765bacb.png)

# 开始准备升级
## 1、查看Jenkins目录
```
ps -aux | grep jenkins
```
![image.png](/images/2019/12/30/f3da2d30-2a9f-11ea-a8af-c74ee765bacb.png)

## 2、定位、进入war目录
<!-- more -->
```
cd usr/lib/jenkins
ls -all
```
![image.png](/images/2019/12/30/0c9fe1c0-2aa0-11ea-a8af-c74ee765bacb.png)

## 3、关闭Jenkins & 备份war文件
```
service jenkins stop
mv jenkins.war jenkins.war.bak
```
![image.png](/images/2019/12/30/5d15dfb0-2aa0-11ea-a8af-c74ee765bacb.png)

## 4、下载更新安装包、重新启动
```
wget http://updates.jenkins-ci.org/download/war/2.210/jenkins.war
//wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war
service jenkins start
```

> 可以直接下载最新的正式包`http://mirrors.jenkins.io/war-stable/latest/jenkins.war`，也可以从jenkins控制台的下载链接复制url，下载指定的正式包，例如`http://updates.jenkins-ci.org/download/war/2.210/jenkins.war`

![image.png](/images/2019/12/30/e3fe76e0-2aa0-11ea-a8af-c74ee765bacb.png)