title: Android序列化
author: yifan
tags:
  - Android
  - 序列化
categories:
  - Android
date: 2019-07-12 18:50:00
---
# 一、Android 序列化


# 二、实现
## 1、Serializable
- 创建数据类，并实现Serializable接口；
- 定义serialVersionUID静态变量；
- 声明数据变量；
- 添加变量的getter和setter方法；
<!-- more -->
## 2、Parcelable
- 创建数据类，并实现Parcelable接口；
- 声明数据变量；
- 重写writeToParcel、describeContents方法
- 创建静态内部对象CREATOR，实现Parcelable.Creator接口，并实例化；

# 三、区别
- Serializable实现简单，仅需实现接口、定义serialVersionUID（序列化时为了保持版本的兼容性，即在版本升级时反序列化仍保持对象的唯一性）；而Parcelable需要实现特殊的接口、静态内部类及重写函数；
- Serializable操作实质上是IO读写，将对象转化为字节流储存在外部设备里，需要时通过反射生成对象，因此会产生大量的临时变量，从而引起内存的频繁GC，相比之下，Parcelable底层基于内存的对象copy，所以性能更好，效率是Serializable的10倍以上，所以在Android中传参更推荐使用Parcelable；
- Parcelable的整个过程都是在内存中进行，所以不能用于将数据存储在磁盘上（比如持久化、永久保留对象，或保存对象的字节流到本地文件中），Parcelable为了更好地实现在IPC传递对象，并不是一个通用的序列化机制，当改变Parcelable中数据的底层实现都可能导致之前的数据不可读取（Parcelable是以2进制的方式写入，严重依赖写入顺序），同时Parcelable为了效率，完全没有考虑到版本之间的兼容性，所以涉及数据持久化还是需要使用Serializable；