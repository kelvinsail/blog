---
title: CentOS安装 JAVA&TOMCAT环境
tags:
  - CentOS
  - JAVA
  - Tomcat
categories:
  - CentOS
toc: false
author: yifan
date: 2018-08-05 10:36:00
---

# 安装JAVA 

## 1、卸载原有openJDK
## 2、下载jdk rpm安装包
http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
<!-- more -->
![upload successful](/images/pasted-43.png)
## 3、上传到服务端
## 4、更改文件权限并安装
```
chmod 777 jdk-8u181-linux-x64.rpm
rpm -ivh jdk-8u181-linux-x64.rpm
```
![upload successful](/images/pasted-44.png)

## 5、添加环境变量
用编辑器打开文件
```
vi /etc/profile
```
添加变量
```
export JAVA_HOME=/usr/java/jdk1.8.0_181-amd64
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH
```

## 6、更新源文件
```
source /etc/profile
```

## 7、检查java环境
![upload successful](/images/pasted-45.png)
# 安装haveged
## 1、检查是否需要安装haveged(<1000)
```
cat /proc/sys/kernel/random/entropy_avail
```

![upload successful](/images/pasted-46.png)

## 2、安装haveged
```
yum install epel-release -y
yum install haveged -y
```
![upload successful](/images/pasted-47.png)

## 3、设置启动
```
[root@localhost tomcat]# systemctl start haveged
[root@localhost tomcat]# systemctl enable haveged 
Created symlink from /etc/systemd/system/multi-user.target.wants/haveged.service to /usr/lib/systemd/system/haveged.service.
[root@localhost tomcat]# systemctl status haveged
● haveged.service - Entropy Daemon based on the HAVEGE algorithm
   Loaded: loaded (/usr/lib/systemd/system/haveged.service; enabled; vendor preset: disabled)
   Active: active (running) since 六 2018-08-04 10:05:53 CST; 22s ago
     Docs: man:haveged(8)
           http://www.issihosts.com/haveged/
 Main PID: 1812 (haveged)
   CGroup: /system.slice/haveged.service
           └─1812 /usr/sbin/haveged -w 1024 -v 1 --Foreground

8月 04 10:05:53 localhost.localdomain systemd[1]: Started Entropy Daemon based on the HAVEGE algorithm.
8月 04 10:05:53 localhost.localdomain systemd[1]: Starting Entropy Daemon based on the HAVEGE algorithm...
8月 04 10:05:53 localhost.localdomain haveged[1812]: haveged: ver: 1.9.1; arch: x86; vend: GenuineInte...28K
8月 04 10:05:53 localhost.localdomain haveged[1812]: haveged: cpu: (L4 VC); data: 32K (L4 V); inst: 32...538
8月 04 10:05:53 localhost.localdomain haveged[1812]: haveged: tot tests(BA8): A:1/1 B:1/1 continuous t...839
8月 04 10:05:53 localhost.localdomain haveged[1812]: haveged: fills: 0, generated: 0
Hint: Some lines were ellipsized, use -l to show in full.
```
## 4、检查是否熵是否>1000

![upload successful](/images/pasted-99.png)

# 安装TOMCAT
## 1、下载安装包
https://tomcat.apache.org/download-80.cgi
## 2、解压到安装路径
```
mkdir /opt/tomcat
sudo tar -zxvf apache-tomcat-8.0.50.tar.gz -C /opt/tomcat --strip-components=1
```
## 3、试运行tomcat
```
cd /opt/tomcat/bin
./startup.sh
```

![upload successful](/images/pasted-53.png)
关闭Tomcat
```
./shutdown.sh
```
Tomcat创建systemd unit 文件
```
sudo vi /etc/systemd/system/tomcat.service
```
写入
> [Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target 
 [Service]
Type=forking
Environment=JAVA_HOME=试运行时出现的路径
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/bin/kill -15 $MAINPID
User=tomcat
Group=tomcat
[Install]
WantedBy=multi-user.target

设置自动启动
```
sudo systemctl start tomcat.service
sudo systemctl enable tomcat.service
```

## 4、开启防火墙
```
sudo firewall-cmd --zone=public --permanent --add-port=8080/tcp
sudo firewall-cmd --reload
```
![upload successful](/images/pasted-51.png)
## 5、访问http://IP:8080页面

![upload successful](/images/pasted-50.png)

## 6、设置Tomcat管理员账号密码
```
vi /opt/tomcat/conf/tomcat-users.xml
```
添加
```
<role rolename="manager"/>
<role rolename="manager-gui"/>
<role rolename="admin"/>
<role rolename="admin-gui"/>
<role rolename="manager-script"/>
<role rolename="manager-jmx"/>
<role rolename="manager-status"/>
<user username="root" password="hello12345" roles="admin-gui,admin,manager-gui,manager,manager-script,manager-jmx,manager-status"/>
```

## 7、取消IP限制
```
vi /opt/tomcat/webapps/manager/META-INF/context.xml
```
将【<Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />】注释

![upload successful](/images/pasted-49.png)
## 8、访问管理页面

![upload successful](/images/pasted-48.png)

# Tomcat卸载
- 停止tomcat
```
service httpd stop
```
- 关闭tomcat自启动
```
sudo systemctl disable httpd
```