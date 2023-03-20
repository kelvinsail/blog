---
title: CentOS 部署Jenkins
tags:
  - CentOS
  - Jenkins
  - 自动构建
categories:
  - CentOS
  - Jenkins
toc: false
author: yifan
date: 2018-09-14 15:04:00
---

# 1. 安装JDK
> 开源 Devops 工具 Jenkins 在官方博客平台宣布，从 6 月 28 日发布的 Jenkins 2.357 和将于 9 月发布的 LTS 版本开始，Jenkins 需要 Java 11 才能使用，将放弃 Java 8，可以安装2.357以下的版本但是据说安装插件会有很多问题，建议安装Java11以便于后续升级、安装插件；
>
> 确认此前未安装过JDK，如果安装过先确认jdk不是gcj版本，否则Jenkins可能运行异常，需要卸载重装JDK；

- 查看jdk版本 
```
# java -version
```
- 卸载jdk
```
# yum remove java
```
<!-- more -->
- 搜索open-jdk
```
# yum search openjdk //或者 yum -y list java*
```

![upload successful](/images/pasted-67.png)

- 安装open-jdk
```
# yum install -y java-11-openjdk*
# rpm -qa | grep jdk 
# yum install epel-release
# yum install java-11-openjdk-devel
```
- 再检查JDK版本
# java -version
openjdk version "11.0.18" 2023-01-17 LTS
OpenJDK Runtime Environment (Red_Hat-11.0.18.0.10-1.el7_9) (build 11.0.18+10-LTS)
OpenJDK 64-Bit Server VM (Red_Hat-11.0.18.0.10-1.el7_9) (build 11.0.18+10-LTS, mixed mode, sharing)

# 2. 安装GIT，如果已安装则跳过
```
yum install git
```
# 3. 开始安装Jenkins
- 下载依赖
```
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
```
- 导入秘钥
```
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
```
- 开始安装
```
sudo yum install jenkins
```

![upload successful](/images/pasted-68.png)

- 安装完毕后，查看、修改配置
```
chkconfig --list | grep jenkins
```
![upload successful](/images/pasted-69.png)

> jenkins的war包存放在/usr/lib/jenkins目录下，配置文件路径为/etc/sysconfig/jenkins，存放了相关的配置：端口号、jenkins主目录路径等

![upload successful](/images/pasted-70.png)

- 启动jenkins，进入部署界面
> 使用阿里ECS需要先检查对应的端口是否已经加入安全组，不然无法访问
```
sudo service jenkins start
```

- 设置开机自动启动
```
sudo systemctl enable jenkins
systemctl status jenkins
```

![upload successful](/images/pasted-71.png)

- 根据提示，走完部署流程
```
cat /var/lib/jenkins/secrets/initialAdminPassword   //查看密码
```

![upload successful](/images/pasted-72.png)

点击【安装推荐的插件】


![upload successful](/images/pasted-73.png)

- 配置管理员账号密码


![upload successful](/images/pasted-74.png)

- 完成部署


![upload successful](/images/pasted-75.png)

- Jenkins + Gitlab配置
 - 安装gitlab插件
 - 进入全局设置-配置gitlab链接
 - 进入centos生成ssh_key
 ```
 cd ~/.ssh
 ssh-keygen -t rsa -C "邮箱"
 ```
 - gitlab添加ssh_key
 - jenkins新建任务、配置，添加token

- Jenkins设置备份还原、迁移
>可安装ThinBackup插件，备份后把备份文件夹复制到新服务器上，在新服务器的jenkins-ThinBackup中导入；
备份时注意：
路径文件夹如果不存在可能导致备份失败，需要手动创建，并设置755、jenkins权限所属；
具体使用可参考：
https://blog.csdn.net/tengdazhang770960436/article/details/62043154

- 安装所需插件：ThinBackup、Gitlab
> 如果部署在局域网，部署到远程服务器，则还需要安装Phing、Publish Over SSH等进行远程部署;
但是一般不建议部署在本地，相对麻烦，通过Java web方式启动服务时需要外网固定ip，局域网、动态IP无法实现；


- Gitlab登录对应账号，访问setting->account->复制Private token
- Jenkins登录配置
> 打开系统管理->系统设置->gitlab，填写name、Gitlab host URL，使用刚复制的Private token配置新的	Gitlab API token并使用，Test connection；

![upload successful](/images/pasted-76.png)