---
title: Dart的单线程模型与异步操作
tags:
  - Flutter
  - Dart
categories:
  - Flutter
  - Dart
toc: false
date: 2022-03-10 23:25:30
---

# 一、Dart单线程模型

![71646925800_.pic_副本.png](/images/2022/03/10/225f70d4-852a-48fc-b7b9-a055cf9104e4.png)

Dart 是单线程模型，有类似与线程的isolate，它是有自己的内存和单线程控制的运行实体，一个Fluuer程序由一个或多个isolate组成，代码默认都在main isolate中执行，而在main isolate中是以Looper消息循环机制来实现dart的事件机制，looper其中包含两个任务队列，一个是“微任务队列” microtask queue，另一个叫做“事件队列” event queue，且微任务的优先级高于事件。基于dart的单线程，代码是按顺序执行，其中的优先级分为：
 - 在 Main 中写代码将最先执行，执行完 Main 中的代码后，Looper就启动并开始循环；
 - 先检查并执行 Microtask Queue 中的任务， 通常使用 scheduleMicrotask 将事件添加到 MicroTask Queue 中；
 - 最后执行 EventQueue 队列中的代码，通常使用 Future 向 EventQueue加入时间，也可以使用 async 和 await 向 EventQueue 加入事件。

> 入口函数 main() 执行完后，消息循环机制便启动了。首先会按照先进先出的顺序逐个执行微任务队列中的任务，当所有微任务队列执行完后便开始执行事件队列中的任务，事件任务执行完毕后再去执行微任务，一直循环。
所有的外部事件任务都在事件队列中，如IO、计时器、点击、以及绘制事件等；
而微任务通常来源于Dart内部，并且微任务非常少。这是因为如果微任务非常多，就会造成事件队列排不上队，会阻塞任务队列的执行（比如用户点击没有反应的情况）；

# 二、异步
> Dart 是单线程实体的语言，一般的异步操作实际上还是通过单线程通过调度任务优先级来实现的，方式大概有以下几种：

## 1、Future
> 相对于 async + await，最主要的功能就是提供了链式调用，默认在事件队列中执行，也可以通过Future.microtask来使用微任务执行，提高优先级。

## 创建一个Future过程：

- 创建一个Future（可能是我们创建的，也可能是调用内部API或者第三方API获取到的一个Future，总之你需要获取到一个Future实例，Future通常会对一些异步的操作进行封装）；
- 通过.then(成功回调函数)的方式来监听Future内部执行完成时获取到的结果；
- 通过.catchError(失败或异常回调函数)的方式来监听Future内部执行失败或者出现异常时的错误信息；

## Future中通常有两个函数执行体：
- Future构造函数传入的函数体
- then的函数体（catchError等同看待）

## Future构造函数传入的函数体放在事件队列中，then的函数体要分成三种情况：
- Future没有执行完成（有任务需要执行），那么then会直接被添加到Future的函数执行体后；
- 如果Future执行完后就then，该then的函数体被放到如微任务队列，当前Future执行完后执行微任务队列；
- 如果Future世链式调用，意味着then未执行完，下一个then不会执行；

## 2、async + await组合
使用async + await关键字修饰函数，即可向事件队列中插入事件来实现异步操作，用同步的代码格式，去实现异步的调用过程，但其实也是用了Future；

## 3、Stream
相对于Future，stream可以接受多个异步结果，但是要注意的是，普通的 Stream 只可以有一个订阅者，如果想要多订阅的话，要使用 asBroadcastStream()来转换；