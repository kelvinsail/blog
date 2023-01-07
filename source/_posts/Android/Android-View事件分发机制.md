---
title: Android View事件分发机制
tags:
  - Android
  - View事件分发机制
categories:
  - Android
toc: false
author: yifan
date: 2019-05-18 22:00:00
---

# 相关知识
## Activity
- Activity中也有`dispatchTouchEvent()`和`onTouchEvnet()`函数，但没有实际参与分发机制，纯粹的只是通过Activity绑定的window对象，将事件传递给了decorView，也就是根节点布局。
<!-- more -->
## 函数
- ViewGroup有三个函数，及其作用分别是
```
onInterceptTouchEvent() //拦截事件
dispatchTouchEvent() //分发事件
onTouchEvnet() //处理、消费事件
```
- View则只有两个函数，及其作用分别是
```
dispatchTouchEvent() //分发事件
onTouchEvnet() //处理、消费事件
```
## 结构
- Activity、ViewGroup、View组合成了树形结构
- Avtivity或者说根布局位于最上层的根节点，而后是根布局的子布局/控件，依照在其上层布局中的位置顺序从左往右；
- View事件依次从上往下、从左往右的顺序进行传递，通过每一个节点的相对应函数进行拦截、分发或处理；

# 具体过程
## 分发 dispatchTouchEvent()
> Touch事件发生时，Activity的dispatchTouchEvent()函数会将事件传递给绑定的window对象中的最外层decorView，也就是rootView，并通过该view的dispatchTouchEvent()函数对事件进行分发（即从根元素依次往下传递，知道最内层子元素或其中某一元素由于某一条件停止传递）；一般来说，并不会重写控件中的`dispatcTouchEvent()`函数，因为其并不参与事件的响应或消费，仅做分发处理；

dispatchTouchEvent的事件分发逻辑如下：
- 如果`return true`，事件会分发给当前的view并由`onTouchEvent()`函数进行消费，同时停止继续传递分发，当`onTouchEvent`返回`true`时，则代表该事件已被消费，事件结束；
- 如果`return false`，事件分发分为两种情况：
 - 当前的view获取的事件来自Activity，则事件将交由Activity的`onTouchEvent()`函数进行消费；
 - 当前的view获取的事件来源于上层ViewGroup，则事件将会返回上层控件的`onTouchEvent()`进行消费或继续分发；
- 如果返回系统默认的`super.dispatchTouchEvent()`，则会将事件分发给当前的ViewGroup的`onInterceptTouchEvent()`判断是否进行拦截；

## 拦截 onInterceptTouchEvent()

> `onInterceptTouchEvent()`是ViewGroup的独有函数，当ViewGroup的`dispatchTouchEvent()`函数中返回默认的`super.dispatchTouchEvent()`的情况下，会自动触发当前前View的`onInterceptTouchEvent()`函数判断是否进行拦截；

onInterceptTouchEvent()的事件拦截逻辑如下：
- 如果`onInterceptTouchEvent()`返回`true`，则表示拦截该事件，并交由该View的`onTouchEvent()`进行处理；
- 如果`onInterceptTouchEvent()`返回`false`，则表示放行，当前容器上的事件会继续传递到子View中，再由子View的`dispatchTouchEvent()`来进行分发处理；
- ViewGroup中的`onInterceptTouchEvent()`默认返回`super.onInterceptTouchEvent()`，即false，不拦截事件；


## 消费 onTouchEvent()
> 在`onInterceptTouchEvent()`或`dispatchTouchEvent()`返回true时，会将事件分发给当前View的`onTouchEvent()`进行处理

逻辑如下：
- 如果事件传递到当前View的`onTouchEvent()`，并返回了false或`super.onTouchEvent()`，则该事件会从当前View向上传递，且由上层容器的`onTouchEvent()`来接收事件，如果一直传递到最上层的容器的`onTouchEvent()`也返回false，则该事件会被忽略，且后续的`ACTION_MOVE`、`ACTION_UP`也不会被传递；
- 如果返回了true，则表示该事件被消费了，且不会继续传递；