title: Android 内存优化相关（未完成）
author: yifan
tags:
  - Android
  - 内存优化
categories:
  - Android
date: 2019-07-13 18:12:00
---
# 引用方式
## 强引用（StrongReference）
- 使用
```
Object ojb = new Object();
```
- 特点
 - 直接访问对象，但某些情况可能引起内存泄漏；
 - 当对象被强引用所关联时，JVM不会回收该对象，即使内存不足的情况下，JVM会直接抛出OutOfMemory错误1而不会回收该类对象；
<!-- more -->

## 软引用（SoftReference）
- 使用
```
Object obj =new Object();
SoftReference reference = new SoftReference<Object>(obj);
```
- 特点
 - 用来关联有作用但不是必要的对象，只有在内存不足的时候JVM才会回收该对象;
 - 适合用于数据缓存，可以保证数据的引用也能保证在内存不足情况下进行释放；

## 弱引用（WeakReference）
- 使用
```
Object obj =new Object();
WeakReference reference = new WeakReference<Object>(obj);
```
- 特点
 -  用来关联非必要对象，当JVM进行垃圾回收时，无论内存是否充足，都会回收被弱引用关联的对象;
 - 适合用于优化匿名内部类、防止内存泄漏，例如：Handler

## 虚引用（PhantomReference）
- 使用
```
Object obj =new Object();
ReferenceQueue<Object> referenceQueue = new ReferenceQueue<>();
PhantomReference reference = new PhantomReference<Object>(obj,referenceQueue);
```
- 特点
> 如果一个对象与虚引用关联，则跟没有引用与之关联一样，在任何时候都可能被垃圾回收器回收;但虚引用与软引用和弱引用的一个区别在于：虚引用必须和引用队列 （ReferenceQueue）联合使用。当垃圾回收器准备回收一个对象时，如果发现它还有虚引用，就会在回收对象的内存之前，把这个虚引用加入到与之关联的引用队列中。

# 堆与栈

# 垃圾回收
## 定义垃圾
- 引用计数（无法解决循环引用问题）
- 可达性

## 回收方法
- 标记-清除法：减少停顿时间，但会造成内存碎片；
- 标记-整理法：可以解决内存碎片，但会增加停顿时间；
- 复制法：从一个地方拷贝到另一个地方，适合有大量回收的场景，比如：新生代回收；

## 分代回收
把内存区域分成不同代，根据不同代来使用不同的回收策略
- 新生代
 - 存放新创建的对象，采用复制回收法；
 - Minor GC发生在新生代；
- 年老代
 - 垃圾回收频率较低，采用标记整理方法
 - Major GC发生在年老代；
- 永久代
 - 存放Java本身的一些数据，当类不在使用时也会被回收