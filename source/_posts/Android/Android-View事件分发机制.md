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
## 概念
### Activity、Window、View关系
- 一般情况下理解为“从Activity开始分发，即Activity -> Window -> view”；
- Activity、ViewGroup、View组合成了树形结构
- Avtivity或者说根布局位于最上层的根节点，而后是根布局的子布局/控件，依照在其上层布局中的位置顺序从左往右；View事件依次从上往下、从左往右的顺序进行传递，通过每一个节点的相对应函数进行拦截、分发或处理；
- Android的View管理是以Window为单位的，每个Window对应一个View树。Window机制不仅管理着View的显示，也负责View的事件分发；

### View树
> 每一棵view树都有一个根，叫做<font color='red'>ViewRootImpl(划重点)</font> ，他负责管理这整一棵view树的绘制、事件分发等。
应用界面一般会有多个view树，我们的activity布局就是一个view树、其他应用的悬浮窗也是一个view树、dialog界面也是一个view树、我们使用windowManager添加的view也是一个view树等等。最简单的view树可以只有一个view。
android中view的绘制和事件分发，都是以view树为单位。每一棵view树，则为一个window 。系统服务WindowManagerService，管理界面的显示就是以window为单位，也可以说是以view树为单位。而view树是由viewRootImpl来负责管理的，所以可以说，wms（WindowManagerService的简写）管理的是viewRootImpl。
![view树管理](/Android-View事件分发机制/20230530103529697.png)
- wms是运行在系统服务进程的，负责管理所有应用的window。应用程序与wms的通信必须通过Binder进行跨进程通信。
- 每个viewRootImpl在wms中都有一个windowState对应，wms可以通过windowState找到对应的viewRootImpl进行管理。
> 了解window机制的一个重要原因是：事件分发并不是由Activity驱动的，而是由系统服务驱动viewRootImpl来进行分发 ，甚至可以说，在框架层角度，和Activity没有任何关系。这将有助于我们对事件分发的本质理解。

## 事件的产生
> 在我们手指触摸屏幕时，即产生了触摸信息。这个触摸信息由屏幕这个硬件产生，被系统底层驱动获取，交给Android的输入系统服务：InputManagerService，也就是IMS。
IMS会对这个触摸信息进行处理，通过WMS找到要分发的window，随后发送给对应的viewRootImpl。所以发送触摸信息的并不是WMS，WMS提供的是window的相关信息。当viewRootImpl接收到触摸信息时，也正是应用程序进程事件分发的开始。
viewRootImpl接收到触摸信息之后，经过处理之后，封装成MotionEvent对象发送给他所管理的view，由view自己进行分发。
![事件的产生](/Android-View事件分发机制/20230530103738376.png)
所以真正的过程是：<font color='red'>IMS -> WMS -> viewRootImpl -> view树 -> DecorView -> windows.callback(act/dialog等) -> View/ViewGroup</font>

# 具体过程
## 分发 dispatchTouchEvent()
> Touch事件发生时，Activity的dispatchTouchEvent()函数会将事件传递给绑定的window对象中的最外层decorView，也就是rootView，并通过该view的dispatchTouchEvent()函数对事件进行分发（即从根元素依次往下传递，直到最内层子元素或其中某一元素由于某一条件停止传递）；一般来说，并不会重写控件中的`dispatcTouchEvent()`函数，因为其并不参与事件的响应或消费，仅做分发处理；

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