---
title: Android-Handler消息处理机制
tags:
  - Android
  - Handler
  - 消息处理机制
categories:
  - Android
  - Handler
toc: false
date: 2019-05-10 14:26:47
---

## UI线程
- 每一个应用启动时，系统都会为其分配一个进程、一个主线程，默认情况下所有的组件、操作都在该线程下运行执行；
- Android的单线程模型，UI操作不是线程安全，而且所有的UI操作都必须在主线程中执行；
- 而主线程主要负责也是与UI相关的操作，比如控件绘制、View事件分发等，因此主线程也叫UI线程；
<!-- more -->
- 4.0之后开始禁止在主线程中访问网络等耗时操作，当主线程被堵塞5秒就会出现了ANR提示；
- 为了解决线程间交互的问题，Android提供了Handler+MessageQueue+Looper消息处理机制；

## Handler、Looper、Message以及MessageQueue
### Message
消息体，通常由`Message.obain()`方法从消息池取出消息对象进行复用；
### MessageQueue
消息队列，由Looper初始化，每个线程/Looper中有且仅有一个；
### Looper
- 相当于一个轮询器，在进程中以while(true)的形式持续监听并依次分发、处理其他线程发送过来的消息；
- 首先，通过调用静态函数`prepare()`创建Looper实例，并在其构造函数中初始化一个MessageQueue，Looper与当前线程绑定，保证一个线程仅有一个Looper实例，同时一个Looper也仅有一个MessageQueue，而后通过`loop()`，不断从MessageQueue中取出新的消息，分发给`msg.target`所指定的Handler对象去处理；

### Handler
消息的发送者、接收者，负责创建Message并发送，最终加入到目标MessageQueue中，并接收Looper从MessageQueue中取出并分发给当前线程的Message；

> 注意：Hanlder仅作为Message的发送与接收者，真正处理Message的是Handler所在的线程，例如：当Activity+Handler导致Activity内存泄露时，引用链为Activity->Handler->UI线程，Activity因为被UI线程所持有而导致无法被回收；

<!--
## Handler的使用
```

```
-->