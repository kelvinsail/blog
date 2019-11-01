---
title: Android RxJava使用
tags:
  - Android
categories:
  - Android
  - RxJava
toc: false
---

# 一、RxJava
- [RxJava](https://github.com/ReactiveX/RxJava)
- [RxAndroid](https://github.com/ReactiveX/RxAndroid)
- 特点
 - 响应式，面向数据及变化的编程方式
 - 观察者模式、链式结构
 - 线程调度、异步转换

# 二、使用
## 1、角色
|角色|定义|
|---|---|
|Observable（被观察者）||
|Observer（观察者）||
|Subcriber（订阅）||
|Subjects（？）||

## 2、调度器
|类型|作用|
|---|---|
|Schedulers.computation( )|用于计算任务，如事件循环或和回调处理，不要用于IO操作(IO操作请使用Schedulers.io())；默认线程数等于处理器的数量|
|Schedulers.from(executor)|使用指定的Executor作为调度器|
|Schedulers.immediate( )|在当前线程立即开始执行任务|
|Schedulers.io( )|用于IO密集型任务，如异步阻塞IO操作，这个调度器的线程池会根据需要增长；对于普通的计算任务，请使用Schedulers.computation()；Schedulers.io( )默认是一个CachedThreadScheduler，很像一个有线程缓存的新线程调度器|
|Schedulers.newThread( )|为每个任务创建一个新线程|
|Schedulers.trampoline( )|当其它排队的任务完成后，在当前线程排队执行|
|AndroidSchedulers.mainThread()|为Android而设，在UI线程中执行|
|AndroidSchedulers.from(Looper looper, boolean async)|指定一个looper对象|

## 3、操作符（Operators）
### 1）创建
- create
- just
- from
- fromArray
- fromIterable

### 2）转换
#### cast
#### zip
#### map
 - 类型变换操作，变换之后输出类型值
#### flatmap
 - 类型变化操作，变化之后输出的是Observable对象，与map不同，可用于合并请求等操作；
 - 但针对Observables发射的数据做的是合并(merge)操作，并不能保证顺序，数据可能是交叉的；
#### concat
#### concatMap
 - 变换、连接操作，解决了flatMap()的交叉问题，提供了一种能够把发射的值连续在一起的铺平函数
#### merge
#### collect
#### reduce
#### startWith
#### flatMapIterable
#### switchMap

### 3）过滤
- skip，skipFirst，skipLast
- take，takeFirst，takeLat
- first，firstOrDefault
- last，lastOrDefault
- distinct，distinctUtilChanged
- filter
- ofType
- firstElement，lastElement
- timeout
- debounce/throtleWithTimeout

### 4)延时
#### delay
#### timer
#### interval
 - 定时、轮询，`.interval(delay,TimeUnit.SECONDS)`，第一个参数delay为轮询间隔时长、第二个为单位
#### defer
#### range
 - 从起始点(start)开始发射(count次)数据，`.range(start,count)`

### 5）条件
- all
- exists
- takeUtil，takeWhile
- skipUtil，skipWhile
- single/singleOrDefault
- constains
- defaultIfEmpty，switchIfEmpty
- isEmpty
- amb/ambWith
- sequenceEqual

### 6）其他
#### repeat
 - 循环发射数据，`.repeat(times)`
#### repeatWhen
#### count
#### retry，retryUtil，retryWhen

<!--
参考文章
https://www.jianshu.com/p/5103a86299bd
https://www.jianshu.com/p/30e13d874a61
https://www.jianshu.com/p/79cb4e1c9771

https://www.jianshu.com/p/031745744bfa

https://juejin.im/post/5a7ac6065188257a79248e99
-->