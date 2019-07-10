title: CentOS Jenkins部署多节点
tags:
  - CentOS
  - 自动构建
  - Jenkins
  - 多节点
categories:
  - CentOS
  - Jenkins
author: yifan
date: 2019-04-26 16:48:00
---
# 一、配置slave服务器

## 1、安装java
[教程传送门](https://www.jianshu.com/p/be9d88aa8136)

## 2、配置jenkins用户、免密登录
```
adduser jenkins //创建jenkins用户
su - jenkins //切换用户
ssh-keygen -t rsa //生成sshkey，用于配置gitlab
cd ~/.ssh //进入ssh目录
touch authorized_keys //创建authorized_keys文件
vim  authorized_keys //将master主服务器上root用户的公钥复制到授权文件中，保存
chmod 644 authorized_keys //设置权限
```

<!-- more -->
## 3、切换账号&创建用于jenkins远程部署的目录
```
exit //退出jenkins账户
mkdir /home/wwwroot/jenkins //创建用于远程构建项目的文件夹
chown jenkins:jenkins /home/wwwroot/jenkins //更改目录所属用户
```

## 4、配置gitlab sshkey
> 具体参考其他教程，此处不进行描述

# 二、配置master主机
## 1、生成sshkey
```
ssh-keygen -t rsa //生成sshkey
```
## 2、添加jenkins凭据
### 1）进入jenkins凭据页面

![upload successful](/images/pasted-10.png)
### 2）点击添加凭据

![upload successful](/images/pasted-11.png)

### 3）添加凭据

![upload successful](/images/pasted-12.png)
## 3、添加子节点
### 1）进入添加子节点页面

![upload successful](/images/pasted-13.png)
### 2）添加子节点

![upload successful](/images/pasted-14.png)

![upload successful](/images/pasted-15.png)
### 3）确认子节点启用成功

## 4、创建Jenkins多节点同时构建任务
## 1）选择【构建一个多配置项目】

![upload successful](/images/pasted-16.png)
## 2）配置任务信息

![upload successful](/images/pasted-17.png)
## 3）选择要运行构建任务的节点
`注意：这里是选择运行构建任务的节点，不是最终要部署项目的节点`

![upload successful](/images/pasted-18.png)
## 4）选择要构建部署项目的节点

![upload successful](/images/pasted-19.png)
## 5）试部署
- 基本只有这几项与普通任务有差别，其余的参考普通项目配置即可；
- 第一次构建，任务的timeout最好设置比较长，避免超时;