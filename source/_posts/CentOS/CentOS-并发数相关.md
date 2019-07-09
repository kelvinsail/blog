title: CentOS-并发数相关
tags:
  - CentOS
  - 并发数
categories:
  - CentOS
author: yifan
date: 2019-01-09 11:14:00
---
---
##1、查看当前的并发数
```
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
```
返回数据一般有
> LAST_ACK 3
CLOSE_WAIT 23
ESTABLISHED 479
FIN_WAIT1 4
SYN_SENT 1
TIME_WAIT 55
CLOSING 2
<!-- more -->
各个数据及其含义如下：
> CLOSED：无连接是活动的或正在进行
LISTEN：服务器在等待进入呼叫
SYN_RECV：一个连接请求已经到达，等待确认
SYN_SENT：应用已经开始，打开一个连接
ESTABLISHED：正常数据传输状态
FIN_WAIT1：应用说它已经完成
FIN_WAIT2：另一边已同意释放
ITMED_WAIT：等待所有分组死掉
CLOSING：两边同时尝试关闭
TIME_WAIT：另一边已初始化一个释放
LAST_ACK：等待所有分组死掉

如果只是想要查看当前正常的并发数，可以执行
```
netstat -nat|grep ESTABLISHED|wc -l
```

##2、消除未被及时释放的TIME_WAIT状态的TCP连接

如发现系统存在大量TIME_WAIT状态的连接，通过调整内核参数解决，

```
vim /etc/sysctl.conf
```
编辑文件，加入以下内容：
```
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_fin_timeout = 30
```
然后执行 ```/sbin/sysctl -p``` 让参数生效。

> net.ipv4.tcp_syncookies = 1 表示开启SYN cookies。当出现SYN等待队列溢出时，启用cookies来处理，可防范少量SYN攻击，默认为0，表示关闭；
net.ipv4.tcp_tw_reuse = 1 表示开启重用。允许将TIME-WAIT sockets重新用于新的TCP连接，默认为0，表示关闭；
net.ipv4.tcp_tw_recycle = 1 表示开启TCP连接中TIME-WAIT sockets的快速回收，默认为0，表示关闭。
net.ipv4.tcp_fin_timeout 修改系統默认的 TIMEOUT 时间