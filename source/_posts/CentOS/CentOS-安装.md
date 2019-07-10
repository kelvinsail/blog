title: CentOS 安装
tags:
  - CentOS
categories:
  - CentOS
author: yifan
date: 2018-08-02 11:45:00
---
# 安装CentOS
## 选择语言直接进入到安装配置界面

![upload successful](/images/pasted-81.png)

<!-- more -->
## 设置安装位置

![upload successful](/images/pasted-82.png)

## 点击添加磁盘，选择【我要配置分区】

![upload successful](/images/pasted-83.png)

## 点击【+】，添加挂载点

![upload successful](/images/pasted-84.png)

## 选择【swap】，容量设置为内存的两倍，保存

![upload successful](/images/pasted-85.png)

## 再添加一个挂载点【/】,容量留空，默认为剩下的所有空间，保存

![upload successful](/images/pasted-86.png)

## 点击完成，确认、【授权更改】

![upload successful](/images/pasted-87.png)

## 保存后，点击【开始安装】

![upload successful](/images/pasted-88.png)

## 安装过程，设置root账户密码

![upload successful](/images/pasted-89.png)

![upload successful](/images/pasted-90.png)

## 可以不用创建账户，等待安装结束

![upload successful](/images/pasted-91.png)

## 安装完成之后，点击【重启】

![upload successful](/images/pasted-92.png)

## 启动，默认第一项即为CentOS启动项

![upload successful](/images/pasted-93.png)

## 输入账号名、回车确认，输入密码，登录

![upload successful](/images/pasted-94.png)

# CentOs默认没有开启网卡，需要开启网卡配置、重启网卡；
## 进入文件夹【cd /etc/sysconfig/network-scripts】;
## 【ls】列出文件列表，第一个【ifcfg-XXX】就是配置文件；
## 用【vi】命令打开，编辑，更改【ONBOOT】的值为yes；
## 保存，重启网卡【service network start】；

![upload successful](/images/pasted-95.png)

![upload successful](/images/pasted-96.png)

# 台式机安装centos7提示“No Caching mode page found”
**提示如下错误：**
```
[sdb] No Caching mode page found
[sdb] Assuming drive cache:write through
```
**解决方法：**

![upload successful](/images/pasted-97.png)

先移动到第二项test this media & Install Centos 7(按Tab键移动)然后进行编辑路径将
```
vmlinuz initrd=initrd.img inst.stage2=hd:LABEL=CentOS\x207\x20x86_64 quiet
```
改为
```
vmlinuz initrd=initrd.img linux dd quiet
```
然后按enter键，出现如下图的u盘信息

![upload successful](/images/pasted-98.png)

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