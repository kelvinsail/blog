title: CentOS 配置Swap
tags:
  - CentOS
  - Swap
categories:
  - CentOS
author: yifan
date: 2018-12-11 10:23:00
---
## 1、查看目前内存配置情况
> 第一种方法：运行free -h

![upload successful](/images/pasted-60.png)
可以看到swap部分参数都为0，即没有配置

>第二种方法：运行 swapon -s
如果没有任何输出，则代表没有配置
<!-- more -->
## 2、创建文件
> 运行df -h，查看硬盘空间使用情况，确保有足够的空间

![upload successful](/images/pasted-61.png)
> 创建缓存文件
网上有很多方法，例如：sudo fallocate -l 2G /swapfile，
但是容易报错：fallocate: /swapfile: fallocate failed: Operation not supported
目前未找到原因，所以只好用另一种方式：
运行：dd if=/dev/zero of=/var/swap bs=1024 count=2048000
if 表示infile，of表示outfile，bs=1024代表增加的模块大小，count=2048000代表2048000个模块，也就是2G空间
执行时间较长，且根据文件大小而定，耐心等待  ...

![upload successful](/images/pasted-62.png)

## 3、启用swap
```
mkswap /var/swap
mkswap -f /var/swap
swapon /var/swap
```
再运行free -m查看swap是否已启用，
但是到这一步，只是临时swap，需要再配置fstab使swap文件永久有效

## 4、设置swap文件永久有效
> 运行vi /etc/fstab
/var/swap swap swap defaults 0 0

重启检查是否已完成配置


## 5、取消swap
### 1）查看swap文件位置
```
[root@iZwz93t5hvwgq7l1r5y8cmZ /]# swapon -s
Filename                                Type            Size    Used    Priority
/var/swap                               file    8191996 0       -2
```
### 2）取消swap、删除文件
```
swapoff /var/swap
rm -rf /var/swap
```
### 3）检查
```
[root@iZwz93t5hvwgq7l1r5y8cmZ /]# free -h
              total        used        free      shared  buff/cache   available
Mem:           7.6G        2.7G        174M        1.1M        4.7G        4.6G
Swap:            0B          0B          0B
```

## 6、更改Swap配置（依赖度）
### 1）查看依赖度
```
[root@iZwz93t5hvwgq7l1r5y8cmZ var]# cat  /proc/sys/vm/swappiness 
0
```
> swappiness值的范围为0-100，值越高代表对swap依赖程度越高，但是swap是基于文件储存的缓存交换机制，所以效率明显低于物理内存，swappiness值过高的情况下容易导致物理内存远远没有耗尽便开始使用swap；一般来说swappiness值可以设置为10-60，ssd可以设置的高一点；

### 2）修改当前swappiness值为15，重启后失效
```
sysctl vm.swappiness=15
```

### 3）更改系统配置值，重启后依旧有效
```
echo "vm.swappiness = 15"  >>  /etc/sysctl.conf
```