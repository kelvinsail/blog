title: Android-Activity启动模式
date: 2019-05-11 23:43:36
tags: [Android,Activity启动模式]
categories: [Android]
---
# 四种Activity启动模式
## 标准模式（Standard）
- 默认启动模式，也是标准的Task模式；
- 在没有其他因素的影响下，使用该模式的的Activity都会构建一个新的Activity实例加入栈顶；
<!-- more -->

## 栈顶模式（SingleTop）
- 基本与Standard一致，但当且仅当所请求的Activity在栈内已有一个实例位且于栈顶时，会对位于栈顶的Activity进行复用，而不会构建新的实例加入栈顶；
- 复用并不是直接刷新Activity，而是通过调用栈顶Activity的`newIntent()`函数并传入Intent，在该模式下可以重写该函数，从而对传入的Intent进行处理；
- 使用场景
 - 商品详情界面 -> 另一个商品详情界面
 
## 栈内模式（SingleTask）
- 设置了该模式的Activity在栈内最多有且有一个实例，当栈内不存在该Activity时才会创建新的实例并加入栈顶，
- 若是栈内已存在该Activity的实例，则会对该实例进行复用，并且通过移除栈内位于该实例之上的其他Activity实例来将该实例置顶；
- 使用场景
 - 主界面实现快速返回；
 - 一键退出App；

## 全局单例模式（SingleInstance）
- 第一次启动Activity时，系统会先为其创建一个新的Task任务栈，再创建Activity实例并加入栈中；
- 新创建的Task任务栈有且仅有当前唯一一个目标Activity实例，不会再加入其他实例直到被销毁；
- 之后启动目标Activity时，都会找到该任务栈并将其转到前台，使栈内的Activity实例回到用户界面；
- 使用场景
 - Notification点击后展示的界面；
 - 分享、发送给好友选择页面；
