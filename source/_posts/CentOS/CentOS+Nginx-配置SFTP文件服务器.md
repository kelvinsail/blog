title: CentOS  Nginx 配置SFTP文件服务器
tags:
  - CentOS
  - FTP
  - 文件服务器
categories:
  - CentOS
  - 文件服务器
author: yifan
date: 2018-10-10 10:08:00
---
# 1、新建FTP账号
- 升级
```
yum update  //升级软件，非必要
```
- 创建名称为sftp的SFTP用户组
```
groupadd sftp
```
- 创建用户
```
useradd -G sftp -s /sbin/nologin  【username 】
```
> -s 禁止用户ssh登陆 
-G 加入sftp 用户组
<!-- more -->
- 创建密码
```
passwd 【username】
```
- 修改sshd配置文件
```
vim /etc/ssh/sshd_config
```
在最下方修改
```
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# Accept locale-related environment variables
AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
AcceptEnv XMODIFIERS

# override default of no subsystems
#下面这行注释掉
#Subsystem sftp /usr/libexec/openssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#       X11Forwarding no
#       AllowTcpForwarding no
#       PermitTTY no
#       ForceCommand cvs server

# 加入
Subsystem sftp internal-sftp
# 以下需要添加在文件的最下方，否则root用户无法登录
Match Group sftp
X11Forwarding no
AllowTcpForwarding no
ChrootDirectory %h
ForceCommand internal-sftp
```
> Match Group sftp 匹配sftp用户组中的用户 
ChrootDirectory %h 只能访问默认的用户目录(自己的目录)，例如 /home/test

# 2、配置FTP账号访问路径
```
chown root:sftp /home/【username 】
chgrp -R sftp /home/【username 】
chmod -R 755 /home/【username 】
#设置用户可以上传的目录,改目录下允许用户上传删除修改文件及文件夹
mkdir /home/【username 】/upload
chown -R 【username 】:sftp /home/【username 】/upload
chmod -R 755 /home/【username 】/upload
```
# 3、重启sshd服务
```
systemctl restart sshd
```

# 4、Nginx配置站点信息
- 第一种，直接通过IP&端口访问
```
server {
        listen       8081;
        server_name  localhost;
        charset utf-8;
 		
        #charset koi8-r;
 
        #access_log  logs/host.access.log  main;
 
        location / {
            root  /home/【username 】/upload;
            index  index.html index.htm;
            autoindex on;  #显示索引
            autoindex_exact_size off; #显示大小
            autoindex_localtime on; #显示时间
        }
}
```
- 第二种，通过域名访问
```
server {
        listen       80;
        server_name  xxx.域名.com;
        charset utf-8;
 		
        #charset koi8-r;
 
        #access_log  logs/host.access.log  main;
 
        location / {
            root   /home/【username 】/upload;
            index  index.html index.htm;
            autoindex on;  #显示索引
            autoindex_exact_size off; #显示大小
            autoindex_localtime on; #显示时间
        }
}
```