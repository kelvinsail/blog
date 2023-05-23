title: Android 架构演进
tags:
  - Android
  - 架构
categories:
  - Android
  - 架构
  - MVC、MVP、MVVM
toc: false
date: 2019-07-23 11:25:20
---
# MVC
## 1、角色
- View
 - android.view.View及其子类+布局文件作为view层，负责视图的创建渲染；
- Controller
 - 通常是Activity/Fragment作为Controller角色，负责视图逻辑、业务流程处理；
- Model
 - SQLite、IO或网络请求作为model层；
<!-- more -->
## 2、结构定义


## 3、说明
- 作为入门级、安卓早期APP架构、Activity的功能强大，也使得Controller层与View并没有明显的界限，Activity/Fragment常常作为控制器+部分View实现存在，所以也导致Activity/Fragment的代码过分臃肿、难以维护；
- 在MVC架构中，model、view之间没有隔离，view可以直接使用model，model也可以直接将回调传递给view，所以作为视图逻辑、业务处理的Controller层被弱化了，没有起到解耦的作用；

# MVP
## 1、角色
- View
 - View+Activity/Fragment，负责视图创建渲染、展示逻辑，视图控制器；
 - Activity/Fragment中持有一个Presenter的实例，进行业务接口调用；
 - 实现iView接口、定义具体的数据传递逻辑，方式没有多种，比如：1）Activity/Fragment实现接口；2）创建具体iView类并实现iView接口、持有Activity/Fragment的弱引用···等等；
- Presenter
 - iPresenter：定义数据处理、业务逻辑的接口，由其子类负责实现具体的功能，不会直接拥有View的实例，但通过iView接口将具体的视图数据传递到view层；
 - iView：定义视图层的数据展示接口，解耦view、presenter；
- Model
 - 定义的数据IO层，没有统一的定义、不要求一定有封装；
 - 但基于代码复用，可创建统一的基类，封装SQLite、http操作请求的实例对象创建，控制生命周期；

## 2、结构定义


## 3、说明
- 使用iView+iPresenter结构，优化了原有的MVC架构，拆分了Acitvity的数据业务处理功能，使Activity作为视图空时期的一部分，而Preserter作为一个真正独立的数据业务处理角色；
- 但这样的实现方式使代码冗余程度大大增加，往往一个功能的实现，iPreserter、iView都需要定义新的接口，复用过程也留下会有许多不需要实现的函数；

# MVVM
## 1、角色
- View
 - 与MVC一样，View+Activity/Fragment，负责视图创建渲染、展示逻辑，视图控制器；
- ViewModel
 - VM：ViewModel本身与MVC的Presenter是一样的角色，负责处理数据业务逻辑，但vm中不应持有view层的实例引用，接口中也不应该传递view对象作为参数，也不应该具体化定义该ViewModel是为哪个具体的View层提供服务；
 - DataBinding：
- Model
 - 与MVC结构中Model定义一致；

## 2、结构定义


## 3、说明
- 由Google定义及提供，作为Jetpack的一部分，提供了组件层上的支持；
- 观察者模式，应用事件订阅、数据持有权转移，使View、ViewModel彻底解绑，也无需定义view、vm之间数据传递的接口；
- ViewModel中可以接收来自View的事件、也可以发布时间或改变数据以通知数据订阅者（也就是View层）进行刷新；
- 对于布局xml文件有一定的代码入侵，虽然布局文件定义之后代码里也可以不使用；
- 但同时，view与vm之间没有直接的数据通讯方式，所以在简单应用或界面上的使用，可能会使原本简单的事情变得复杂，酌情考虑使用（MVP同样）；