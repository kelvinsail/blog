title: CentOS安装 JAVA&TOMCAT环境
tags:
  - CentOS
  - JAVA
  - Tomcat
categories:
  - CentOS
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



# 安装MySQL
安装wget
```
[root@localhost ~]# yum install wget
已加载插件：fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirrors.aliyun.com
 * epel: mirror01.idc.hinet.net
 * extras: mirrors.aliyun.com
 * updates: mirrors.aliyun.com
正在解决依赖关系
--> 正在检查事务
---> 软件包 wget.x86_64.0.1.14-15.el7_4.1 将被 安装
--> 解决依赖关系完成

依赖关系解决

=====================================================================================================
 Package             架构                  版本                            源                   大小
=====================================================================================================
正在安装:
 wget                x86_64                1.14-15.el7_4.1                 base                547 k

事务概要
=====================================================================================================
安装  1 软件包

总下载量：547 k
安装大小：2.0 M
Is this ok [y/d/N]: y
Downloading packages:
wget-1.14-15.el7_4.1.x86_64.rpm                                               | 547 kB  00:00:00
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  正在安装    : wget-1.14-15.el7_4.1.x86_64                                                      1/1
  验证中      : wget-1.14-15.el7_4.1.x86_64                                                      1/1

已安装:
  wget.x86_64 0:1.14-15.el7_4.1

完毕！
```

安装MySQL软件源
```
[root@localhost ~]# wget http://repo.mysql.com/mysql57-community-release-el7-10.noarch.rpm
--2018-08-09 23:20:07--  http://repo.mysql.com/mysql57-community-release-el7-10.noarch.rpm
正在解析主机 repo.mysql.com (repo.mysql.com)... 223.119.242.56
正在连接 repo.mysql.com (repo.mysql.com)|223.119.242.56|:80... 已连接。
已发出 HTTP 请求，正在等待回应... 200 OK
长度：25548 (25K) [application/x-redhat-package-manager]
正在保存至: “mysql57-community-release-el7-10.noarch.rpm”

100%[===========================================================>] 25,548      --.-K/s 用时 0.03s

2018-08-09 23:20:07 (992 KB/s) - 已保存 “mysql57-community-release-el7-10.noarch.rpm” [25548/25548])
```
```
[root@localhost ~]# sudo rpm -Uvh mysql57-community-release-el7-10.noarch.rpm
警告：mysql57-community-release-el7-10.noarch.rpm: 头V3 DSA/SHA1 Signature, 密钥 ID 5072e1f5: NOKEY
准备中...                          ################################# [100%]
正在升级/安装...
   1:mysql57-community-release-el7-10 ################################# [100%]
```
开始安装MySQL服务端
```

[root@localhost ~]#  yum install -y mysql-community-server
已加载插件：fastestmirror
mysql-connectors-community                                                    | 2.5 kB  00:00:00
mysql-tools-community                                                         | 2.5 kB  00:00:00
mysql57-community                                                             | 2.5 kB  00:00:00
(1/3): mysql-tools-community/x86_64/primary_db                                |  45 kB  00:00:00
(2/3): mysql-connectors-community/x86_64/primary_db                           |  25 kB  00:00:00
(3/3): mysql57-community/x86_64/primary_db                                    | 152 kB  00:00:00
Loading mirror speeds from cached hostfile
 * base: mirrors.aliyun.com
 * epel: mirror01.idc.hinet.net
 * extras: mirrors.aliyun.com
 * updates: mirrors.aliyun.com
正在解决依赖关系
--> 正在检查事务
---> 软件包 mysql-community-server.x86_64.0.5.7.23-1.el7 将被 安装
--> 正在处理依赖关系 mysql-community-common(x86-64) = 5.7.23-1.el7，它被软件包 mysql-community-server-5.7.23-1.el7.x86_64 需要
--> 正在处理依赖关系 mysql-community-client(x86-64) >= 5.7.9，它被软件包 mysql-community-server-5.7.23-1.el7.x86_64 需要
--> 正在处理依赖关系 perl(strict)，它被软件包 mysql-community-server-5.7.23-1.el7.x86_64 需要
--> 正在处理依赖关系 perl(Getopt::Long)，它被软件包 mysql-community-serve

·········省略

  验证中      : 1:mariadb-libs-5.5.56-2.el7.x86_64                                             33/33

已安装:
  mysql-community-libs.x86_64 0:5.7.23-1.el7     mysql-community-libs-compat.x86_64 0:5.7.23-1.el7
  mysql-community-server.x86_64 0:5.7.23-1.el7

作为依赖被安装:
  mysql-community-client.x86_64 0:5.7.23-1.el7      mysql-community-common.x86_64 0:5.7.23-1.el7
  perl.x86_64 4:5.16.3-292.el7                      perl-Carp.noarch 0:1.26-244.el7
  perl-Encode.x86_64 0:2.51-7.el7                   perl-Exporter.noarch 0:5.68-3.el7
  perl-File-Path.noarch 0:2.09-2.el7                perl-File-Temp.noarch 0:0.23.01-3.el7
  perl-Filter.x86_64 0:1.49-3.el7                   perl-Getopt-Long.noarch 0:2.40-3.el7
  perl-HTTP-Tiny.noarch 0:0.033-3.el7               perl-PathTools.x86_64 0:3.40-5.el7
  perl-Pod-Escapes.noarch 1:1.04-292.el7            perl-Pod-Perldoc.noarch 0:3.20-4.el7
  perl-Pod-Simple.noarch 1:3.28-4.el7               perl-Pod-Usage.noarch 0:1.63-3.el7
  perl-Scalar-List-Utils.x86_64 0:1.27-248.el7      perl-Socket.x86_64 0:2.010-4.el7
  perl-Storable.x86_64 0:2.45-3.el7                 perl-Text-ParseWords.noarch 0:3.29-4.el7
  perl-Time-HiRes.x86_64 4:1.9725-3.el7             perl-Time-Local.noarch 0:1.2300-2.el7
  perl-constant.noarch 0:1.27-2.el7                 perl-libs.x86_64 4:5.16.3-292.el7
  perl-macros.x86_64 4:5.16.3-292.el7               perl-parent.noarch 1:0.225-244.el7
  perl-podlators.noarch 0:2.5.1-3.el7               perl-threads.x86_64 0:1.87-4.el7
  perl-threads-shared.x86_64 0:1.43-6.el7

替代:
  mariadb-libs.x86_64 1:5.5.56-2.el7

完毕！

```

启动MySQL
```
service mysqld start
```
重新设置mysql root账号
```
 [root@localhost ~]# sudo grep 'temporary password' /var/log/mysqld.log
2019-01-10T10:02:21.971876Z 1 [Note] A temporary password is generated for root@localhost: fQv3YsS-RjZA
```
登录mysql root账号
```
 [root@localhost ~]# mysql -uroot -pfQv3YsS-RjZA
```
> mysql默认账号密码强度有一定要求，如果是测试环境或本地环境想设置简单密码，则需要先调整密码强度设置

调整密码长度要求
```
mysql> set global validate_password_length=0;
```
调整密码强度检查等级，0/LOW、1/MEDIUM、2/STRONG
```
mysql> set global validate_password_policy=0;
```
设置密码为123456
```
mysql> set password for 'root'@'localhost' = password('123456');
```
设置root允许远程登录
```
mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
```
刷新缓存并退出
```
mysql> flush privileges;
mysql> exit
```