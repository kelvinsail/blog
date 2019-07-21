title: Android Binder通信机制（未完成）
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

<!-- 使用难度高 -- >

- Android提供的Binder通信机制
 - 基于C/S架构；
 - mmap内存映射机制，只复制1次，效率仅次于共享内存（共享内存0次，消息队列、管道2次）；
 - 比起内核提供的，具备安全性；
 
<!-- more -- >

# AIDL
## 定义
- AIDL，即Android Interface Definition Language，Android接口定义语言；
- 它是一套定义好的Android应用层进程间的通讯方式，或者说接口模版；
- 后缀为aidl，但实际运行起来的不是aidl文件，而是由它生成的IInterface实例文件；
- C/S模式，提供、暴露接口的作为服务端，调用接口的作为客户端；
 
## 语法
- AIDL传递的数据类型
 - 八种基本数据类型：byte、char、short、int、long、float、double、boolean；
 - 包装类型：String，CharSequence；
 - Parcelable接口的实现类；
 - List类型，List承载的数据必须是AIDL支持的类型，或者是其它声明的AIDL对象；
 - Map类型，Map承载的数据必须是AIDL支持的类型，或者是其它声明的AIDL对象；
- AIDL文件类型
 - Parcelable数据定义类；
 - 服务端提供的接口定义类；
- 参数定向tag（定义AIDL中允许的数据流向）
 - in：只能由客户端提交到服务端（默认）；
 - out：只能由服务端传递到客户端；
 - inout：允许服务端、客户端之间双向传递；
- 明确导包，即使是同个路径下也需要导入完整包名；

## 使用流程
- 服务端
 - 定义数据类aidl的具体javal类，实现Parcelable接口
 - 定义数据类aidl文件，删除默认函数；
 - 数据类aidl引入具体实现类；
 - 定义Interface接口，并声明服务端要提供的接口、tag；
 - build，as自动生成对应的java实现类，其中包含的Stub内部类就是Binder代理的实现；
 - 定义并实现一个Service，内部实例化对应的服务端接口类及函数；
 - 将该实例化的服务端接口类作为onBind的返回值；
- 客户端
 - 复制服务端的aidl、java代码到客户端项目中（保证包名、路径）
 - 声明接口对应的实现类作为成员变量；
 - 实例化一个ServiceConnection，重写回调函数；
 - 在ServiceConnection对象的回调函数onServiceConnected(···,IBinder service)将service赋值给接口实现类对象；
 - 调用bindService绑定远程对象；
 - 判断接口实现类是否为空、不为空则链接成功，可以进行接口调用；