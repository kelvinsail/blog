---
title: Android DataBinding
tags:
  - Android
categories:
  - Android
toc: false
date: 2019-07-22 09:50:55
---

# DataBinding
- 观察者模式，底层基于Observable，通过synchronized实现线程安全；
- 可用于MVVM架构，实现ViewModel，抽离数据与UI；
- 不仅仅是MVVM，它可用于任何希望数据与UI抽离解耦的地方，比如：
 - RecyelerView的Holder；
 - Glide加载图片；
<!-- more -->
# 实现
## ViewModel类
- 开启app/build.gradle中的DataBinding设置
```
apply plugin: 'com.android.application'

android {

    dataBinding {
        enabled = true
    }

    .... [REST AS BEFORE...]
```
- 创建一个ViewModel类
- 继承android.databinding.BaseObservable
- 声明、初始化变量，重写函数
- 在get/is方法加上注解`@Bindable`，并在set方法中的适当位置添加notify
## 布局文件
- 创建布局文件，引入ViewModel类
```
   <data>

	<!-- 引入其他类包，方便在布局中引用 -->
        <import type="android.text.TextUtils" />

       <variable name="viewModel" type="com.yifan.model.viewModel"/> 

   </data>
```
- 在布局中的适当位置使用 @{} 或 @={}，引用绑定的变量
```
    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
       android:text="@{viewModel.name}">

    <!-- 布局中调用引入类的静态方法 --> 
    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:text="@{TextUtils.isEmpty(viewModel.name)?"null":viewModel.name}">
```
## 主体类
- 主体可为Acitivty/Fragemnt，甚至是View、Holder
- 创建主体类，初始化并绑定`ViewDataBinding`实例
 - 创建Activity或Fragment类，通过`DataBindingUtil.setContentView（Activity activity,
            int layoutId）`设置布局并绑定；
 - 通过`inflate(@NonNull LayoutInflater inflater,
            int layoutId, @Nullable ViewGroup parent, boolean attachToParent)`解析布局，并加载绑定（通常用在RecyclerView的Holder中）
- 通过`ViewDataBinding`实例，更改数据、通知刷新UI

## ObservableField（订阅、通知）
- ViewDataBinding
 - ViewDataBinding继承BaseObservable，BaseObservable实际上又是Observable的实现类
 - BaseObservable中实现了订阅、取消订阅、通知刷新四个函数，并<span style='color:red'>通过`synchronized(this)`以类锁的方式实现线程安全</span>；
- 在代码中通过`ViewDataBinding`提供的方法添加、删除订阅，或通知刷新（）
 - addOnPropertyChangedCallback(@NonNull OnPropertyChangedCallback callback)
 - removeOnPropertyChangedCallback(@NonNull OnPropertyChangedCallback callback)
 - notifyChange()
 - notifyPropertyChanged(int fieldId) 
- `callback`实际上被储存在`BaseObservable`的`PropertyChangeRegistry`对象中，以ArrayList储存;
 - `PropertyChangeRegistry`对象通过`transient`关键字，防止序列化/反序列化；
 - `PropertyChangeRegistry`继承`CallbackRegistry`，<span style="color:red">各个函数通过`synchronized`加锁，所以线程安全</span>