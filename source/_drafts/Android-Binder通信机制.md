title: Android Binder通信机制
author: yifan
date: 2019-07-12 12:56:37
tags:
---
# Binder机制
# IPC机制
- Linux内核提供的IPC机制有以下4种：
 - Socket
 <!-- 通用的套接字协议，效率低、开销大，常用于跨网络传输； --> 
 - 管道
 - 消息队列
 - 共享内存
- Android提供的Binder通信机制
 - 基于C/S架构
 - mmap内存映射机制，只复制1次（共享内存0次，消息队列、管道2次）