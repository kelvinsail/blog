title: CentOS 安装
tags:
  - CentOS
categories:
  - CentOS
author: yifan
date: 2018-08-02 11:45:00
---
---
# 安装CentOS
## 选择语言直接进入到安装配置界面
![image.png](http://upload-images.jianshu.io/upload_images/3867295-a3ab1eadf93c1270.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)
<!-- more -->
## 设置安装位置
![image.png](http://upload-images.jianshu.io/upload_images/3867295-a1ad9d894968be36.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)

## 点击添加磁盘，选择【我要配置分区】
![image.png](http://upload-images.jianshu.io/upload_images/3867295-3d8c9c12c83636e3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)

## 点击【+】，添加挂载点
![image.png](http://upload-images.jianshu.io/upload_images/3867295-07e5f24615c6e224.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)

## 选择【swap】，容量设置为内存的两倍，保存
![image.png](http://upload-images.jianshu.io/upload_images/3867295-81e5821cd10dae2e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)

## 再添加一个挂载点【/】,容量留空，默认为剩下的所有空间，保存
![image.png](http://upload-images.jianshu.io/upload_images/3867295-093ac479ad267f66.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)

## 点击完成，确认、【授权更改】
![image.png](http://upload-images.jianshu.io/upload_images/3867295-8e3a767822856108.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)

## 保存后，点击【开始安装】
![image.png](http://upload-images.jianshu.io/upload_images/3867295-95e7b8faf6b2cebb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)

## 安装过程，设置root账户密码
![image.png](http://upload-images.jianshu.io/upload_images/3867295-90a7eaa83aa0ac59.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)
![image.png](http://upload-images.jianshu.io/upload_images/3867295-eb1f182e9ab1845b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)

## 可以不用创建账户，等待安装结束
![image.png](http://upload-images.jianshu.io/upload_images/3867295-a31d9c9702b78523.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)

## 安装完成之后，点击【重启】
![image.png](http://upload-images.jianshu.io/upload_images/3867295-c8e6983db055b411.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)

## 启动，默认第一项即为CentOS启动项
![image.png](http://upload-images.jianshu.io/upload_images/3867295-8e39310efaf953fe.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)

## 输入账号名、回车确认，输入密码，登录
![image.png](http://upload-images.jianshu.io/upload_images/3867295-c6e324d131ca449b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)

# CentOs默认没有开启网卡，需要开启网卡配置、重启网卡；
## 进入文件夹【cd /etc/sysconfig/network-scripts】;
## 【ls】列出文件列表，第一个【ifcfg-XXX】就是配置文件；
## 用【vi】命令打开，编辑，更改【ONBOOT】的值为yes；
## 保存，重启网卡【service network start】；
![image.png](http://upload-images.jianshu.io/upload_images/3867295-3e400a211d9791f4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)
![image.png](http://upload-images.jianshu.io/upload_images/3867295-3841dda933f823fd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)

# 台式机安装centos7提示“No Caching mode page found”
**提示如下错误：**
```
[sdb] No Caching mode page found
[sdb] Assuming drive cache:write through
```
**解决方法：**
![2.png](http://upload-images.jianshu.io/upload_images/3867295-bf695cdbb1240a0d?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240 "1544693987329210.png")
先移动到第二项test this media & Install Centos 7(按Tab键移动)然后进行编辑路径将
```
vmlinuz initrd=initrd.img inst.stage2=hd:LABEL=CentOS\x207\x20x86_64 quiet
```
改为
```
vmlinuz initrd=initrd.img linux dd quiet
```
然后按enter键，出现如下图的u盘信息
![3.png](http://upload-images.jianshu.io/upload_images/3867295-784a988274181e6b?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240 "1544693999671128.png")
重启系统：使用ctrl+alt+del
再次重复上面的步骤 如下：
```
vmlinuz initrd=initrd.img inst.stage2=hd:LABEL=CentOS\x207\x20x86_64 quiet
```
改为
```
vmlinuz initrd=initrd.img inst.stage2=hd:/dev/sdb4（我自己的U盘盘符） quiet
```
按enter键等待安装程序启动，进行CentOS的安装即可
