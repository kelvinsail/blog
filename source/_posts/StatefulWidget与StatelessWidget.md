---
title: StatefulWidget与StatelessWidget
tags:
  - Flutter
  - Dart
originContent: >-
  # 一、StatelessWidget 和 StatefulWidget

  StatelessWidget 和 StatefulWidget 都是直接继承自 Widget 类，是大部分widget的父类

  - StatelessWidget即无状态组件，可以理解为将外部传入的数据转化为界面展示的内容，只会渲染一次。例如Text

  - StatefulWidget是有状态组件，是定义交互逻辑和业务数据，可以理解为具有动态可交互的内容界面，会根据数据的变化进行多次渲染。


  # 二、生命周期

  ![WechatIMG8.png](/images/2022/03/10/5bd1638a-8282-4412-8c10-8bc15b3bad38.png)

  ## 阶段

  对于无状态组件，生命周期只有一次，也就是build；

  而有状态组件，其生命周期的各个阶段如下：

  - createState ，该函数为 StatefulWidget 中创建 State 的方法，当 StatefulWidget 被调用时会立即执行
  createState 。

  - initState ，该函数为 State 初始化调用，因此可以在此期间执行 State
  各变量的初始赋值，同时也可以在此期间与服务端交互，获取服务端数据后调用 setState 来设置 State。

  - didChangeDependencies ，当State对象的依赖发生变化时会被调用；例如：在之前build()
  中包含了一个InheritedWidget，然后在之后的build()
  中InheritedWidget发生了变化，那么此时InheritedWidget的子widget的didChangeDependencies()回调都会被调用。典型的场景是当系统语言Locale或应用主题改变时，Flutter
  framework会通知widget调用此回调。

  - build ，主要是返回需要渲染的 Widget ，由于 build 会被调用多次，因此在该函数中只能做返回 Widget
  相关逻辑，避免因为执行多次导致状态异常。在 build 之后还有个回调
  addPostFrameCallback，在当前帧绘制完成后会回调，注册之后不能被解注册并且只会回调一次；addPostFrameCallback是
  SchedulerBinding 的方法；由于 mixin WidgetsBinding on
  SchedulerBinding，所以添加这个回调有两种方式：SchedulerBinding.instance.addPostFrameCallback((_)
  => {});或者WidgetsBinding.instance.addPostFrameCallback((_) => {});


  - reassemble， 在 debug 模式下，每次热重载都会调用该函数，因此在 debug 阶段可以在此期间增加一些 debug
  代码，来检查代码问题。

  - didUpdateWidget ，在widget重新构建时，Flutter
  framework会调用Widget.canUpdate来检测Widget树中同一位置的新旧节点，然后决定是否需要更新，如果Widget.canUpdate返回true则会调用此回调。正如之前所述，Widget.canUpdate会在新旧widget的key和runtimeType同时相等时会返回true，也就是说在在新旧widget的key和runtimeType同时相等时didUpdateWidget()就会被调用。父组件发生
  build 的情况下，子组件该方法才会被调用，其次该方法调用之后一定会再调用本组件中的 build 方法。

  - deactivate ，在组件被移除节点后会被调用，如果该组件被移除节点，然后未被插入到其他节点时，则会继续调用 dispose 永久移除。

  - dispose ，永久移除组件，并释放组件资源。


  ## 分解

  - 生命周期的整个过程可以分为四个阶段
   - 初始化阶段：createState 和 initState
   - 组件创建阶段：didChangeDependencies 和 build
   - 触发组件 build：didChangeDependencies、setState 或者didUpdateWidget 都会引发的组件重新 build
   - 组件销毁阶段：deactivate 和 dispose

  ## State

  一个StatefulWidget类会对应一个State类，State表示与其对应的StatefulWidget要维护的状态，State中的保存的状态信息可以：

  在widget 构建时可以被同步读取。

  在widget生命周期中可以被改变，当State被改变时，可以手动调用其setState()方法通知Flutter
  framework状态发生改变，Flutter framework在收到消息后，会重新调用其build方法重新构建widget树，从而达到更新UI的目的。

  > State中有两个常用属性：

  > - widget，它表示与该State实例关联的widget实例，由Flutter
  framework动态设置。注意，这种关联并非永久的，因为在应用生命周期中，UI树上的某一个节点的widget实例在重新构建时可能会变化，但State实例只会在第一次插入到树中时被创建，当在重新构建时，如果widget被修改了，Flutter
  framework会动态设置State.widget为新的widget实例。

  > -
  context，StatefulWidget对应的BuildContext，作用同StatelessWidget的BuildContext，表示当前widget在widget树中的上下文，每一个widget都会对应一个context对象（因为每一个widget都是widget树上的一个节点）。
categories:
  - Flutter
  - Dart
toc: false
date: 2022-03-10 23:29:26
---

# 一、StatelessWidget 和 StatefulWidget
StatelessWidget 和 StatefulWidget 都是直接继承自 Widget 类，是大部分widget的父类
- StatelessWidget即无状态组件，可以理解为将外部传入的数据转化为界面展示的内容，只会渲染一次。例如Text
- StatefulWidget是有状态组件，是定义交互逻辑和业务数据，可以理解为具有动态可交互的内容界面，会根据数据的变化进行多次渲染。

# 二、生命周期
![WechatIMG8.png](/images/2022/03/10/5bd1638a-8282-4412-8c10-8bc15b3bad38.png)
## 阶段
对于无状态组件，生命周期只有一次，也就是build；
而有状态组件，其生命周期的各个阶段如下：
- createState ，该函数为 StatefulWidget 中创建 State 的方法，当 StatefulWidget 被调用时会立即执行 createState 。
- initState ，该函数为 State 初始化调用，因此可以在此期间执行 State 各变量的初始赋值，同时也可以在此期间与服务端交互，获取服务端数据后调用 setState 来设置 State。
- didChangeDependencies ，当State对象的依赖发生变化时会被调用；例如：在之前build() 中包含了一个InheritedWidget，然后在之后的build() 中InheritedWidget发生了变化，那么此时InheritedWidget的子widget的didChangeDependencies()回调都会被调用。典型的场景是当系统语言Locale或应用主题改变时，Flutter framework会通知widget调用此回调。
- build ，主要是返回需要渲染的 Widget ，由于 build 会被调用多次，因此在该函数中只能做返回 Widget 相关逻辑，避免因为执行多次导致状态异常。在 build 之后还有个回调 addPostFrameCallback，在当前帧绘制完成后会回调，注册之后不能被解注册并且只会回调一次；addPostFrameCallback是 SchedulerBinding 的方法；由于 mixin WidgetsBinding on SchedulerBinding，所以添加这个回调有两种方式：SchedulerBinding.instance.addPostFrameCallback((_) => {});或者WidgetsBinding.instance.addPostFrameCallback((_) => {});

- reassemble， 在 debug 模式下，每次热重载都会调用该函数，因此在 debug 阶段可以在此期间增加一些 debug 代码，来检查代码问题。
- didUpdateWidget ，在widget重新构建时，Flutter framework会调用Widget.canUpdate来检测Widget树中同一位置的新旧节点，然后决定是否需要更新，如果Widget.canUpdate返回true则会调用此回调。正如之前所述，Widget.canUpdate会在新旧widget的key和runtimeType同时相等时会返回true，也就是说在在新旧widget的key和runtimeType同时相等时didUpdateWidget()就会被调用。父组件发生 build 的情况下，子组件该方法才会被调用，其次该方法调用之后一定会再调用本组件中的 build 方法。
- deactivate ，在组件被移除节点后会被调用，如果该组件被移除节点，然后未被插入到其他节点时，则会继续调用 dispose 永久移除。
- dispose ，永久移除组件，并释放组件资源。

## 分解
- 生命周期的整个过程可以分为四个阶段
 - 初始化阶段：createState 和 initState
 - 组件创建阶段：didChangeDependencies 和 build
 - 触发组件 build：didChangeDependencies、setState 或者didUpdateWidget 都会引发的组件重新 build
 - 组件销毁阶段：deactivate 和 dispose

## State
一个StatefulWidget类会对应一个State类，State表示与其对应的StatefulWidget要维护的状态，State中的保存的状态信息可以：
在widget 构建时可以被同步读取。
在widget生命周期中可以被改变，当State被改变时，可以手动调用其setState()方法通知Flutter framework状态发生改变，Flutter framework在收到消息后，会重新调用其build方法重新构建widget树，从而达到更新UI的目的。
> State中有两个常用属性：
> - widget，它表示与该State实例关联的widget实例，由Flutter framework动态设置。注意，这种关联并非永久的，因为在应用生命周期中，UI树上的某一个节点的widget实例在重新构建时可能会变化，但State实例只会在第一次插入到树中时被创建，当在重新构建时，如果widget被修改了，Flutter framework会动态设置State.widget为新的widget实例。
> - context，StatefulWidget对应的BuildContext，作用同StatelessWidget的BuildContext，表示当前widget在widget树中的上下文，每一个widget都会对应一个context对象（因为每一个widget都是widget树上的一个节点）。