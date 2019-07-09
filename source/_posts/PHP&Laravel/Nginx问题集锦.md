title: Nginx问题集锦
tags:
  - Nginx
categories: 
  - Nginx
author: yifan
date: 2018.02.09 12:34:00
---

---
1. nginx 重启后日志文件报错
nginx: [alert] could not open error log file: open() "/usr/local/var/log/nginx/error.log" failed (13: Permission denied)
权限不够，加上
```
sudo nginx -s reload 
```
2. nginx.pid文件丢失，执行修复命令
```
sudo nginx -c /usr/local/etc/nginx/nginx.conf
```
“/usr/local/etc/nginx/nginx.conf”配置文件路径需要根据各机器而定，并不一定相同
