title: CentOS 部署Jenkins
tags:
  - CentOS
  - 自动构建
  - Jenkins
categories:
  - CentOS
  - Jenkins
author: yifan
date: 2018-09-14 15:04:00
---
# 1. 安装JDK
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
# yum search openjdk
```

![upload successful](/images/pasted-67.png)

- 安装open-jdk
```
# yum install java-1.8.0-openjdk
```
- 再检查JDK版本
> [root@localhost ~]# java -version
openjdk version "1.8.0_161"
OpenJDK Runtime Environment (build 1.8.0_161-b14)
OpenJDK 64-Bit Server VM (build 25.161-b14, mixed mode)

# 2. 安装GIT，如果已安装则跳过
```
yum install git
```
# 3. 开始安装Jenkins
- 下载依赖
```
wget -O /etc/yum.repos.d/jenkins.repo http://jenkins-ci.org/redhat/jenkins.repo
```
- 导入秘钥
```
rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
```
- 开始安装
```
yum install jenkins
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
service jenkins start
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