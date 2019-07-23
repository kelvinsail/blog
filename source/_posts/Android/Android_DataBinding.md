---
title: Android DataBinding
tags:
  - Android
  - DataBinding
categories:
  - Android
  - MVVM
toc: false
date: 2019-07-21 03:50:55
---

# 一、DataBinding
- 观察者模式，底层基于Observable，通过synchronized实现线程安全；
- 可用于MVVM架构，实现ViewModel，抽离数据与UI；
- 不仅仅是MVVM，它可用于任何希望数据与UI抽离解耦的地方，比如：
 - RecyelerView的Holder；
 - 优化Glide加载图片；
- 虽然解耦，但对xml布局文件有侵入式修改，编译器会对相应的标签进行处理成LayoutInflater可识别的形式，所以定义之后代码中也可以不使用；

<!-- more -->
# 二、实现
## 1、项目build.gradle配置
- 开启app/build.gradle中的DataBinding设置
```
apply plugin: 'com.android.application'

android {

    dataBinding {
        enabled = true
    }

    .... [REST AS BEFORE...]
```
## 2、ViewModel类
- 创建一个ViewModel类
- 继承android.databinding.BaseObservable
- 声明、初始化变量，重写函数
- 添加`@Bindable`注解 
 - 如果变量为私有，则需要在get/is方法加上注解`@Bindable`
 - 如果变量为共有public，则可以直接在变量上注解`@Bindable`
- 在set方法中的适当位置调用notify相关函数
## 3、布局文件
- 创建布局文件，引入ViewModel类
```
<data>

    <!-- 引入其他类包，方便在布局中引用 -->
    <!-- 如果引入的类名冲突，可以使用alias定义别名 -->
    <import type="android.text.TextUtils" />

    <variable name="viewModel" 
              type="com.yifan.model.viewModel"/> 

</data>
```
- 在布局中的适当位置使用 单向`@{}` 或 双向`@={}`，引用绑定的变量
 - 单向`@{}`：即数据源更改时，通知视图进行刷新；
 - 双向`@={}`：即数据改变时会通知视图刷新，视图刷新变更时也会通知数据更改；
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
## 4、主体类
- 主体可为Acitivty/Fragemnt，甚至是View、Holder
- 创建主体类，初始化并绑定`ViewDataBinding`实例
 - 创建Activity或Fragment类，通过`DataBindingUtil.setContentView（Activity activity,
            int layoutId）`设置布局并绑定；
 - 通过`inflate(@NonNull LayoutInflater inflater,
            int layoutId, @Nullable ViewGroup parent, boolean attachToParent)`解析布局，并加载绑定（通常用在RecyclerView的Holder中）
- 通过`ViewDataBinding`实例，更改数据、通知刷新UI

# 三、驱动方式
## 1、BaseObservable
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

## 2、ObservableField
- `ObservableField`继承了`BaseObservableField`，而实际上`BaseObservableField`又是`BaseObservable`的子类，所以同样的也具备线程安全的特性；
- 通过泛型来指定包装类型，所以无法实现Parcelable序列化接口，内部只实现了Serializable接口
- get、set方法，在set方法中会自动调用`notifyChange()`
- 提供了基本类型的包装类
 - 有ObservableBoolean、ObservableByte、ObservableChar、ObservableShort、ObservableInt、ObservableLong、ObservableFloat、ObservableDouble和ObservableParcelable等；
 - 这些包装类并不是`ObservableField`的子类，而是同样继承`BaseObservableField`，内部实现原理一样
 - 包装类型已定义，也实现了Parcelable序列化接口

## 3、ObservableCollection
- Databinding提供的集合类，一共有两种：ObservableList、ObservableMap，分别继承了List和Map两个接口；
- 具体实现类有：ObservableArrayList、ObservableArrayMap
- ObservableArrayList
 - 实现ObservableList接口，继承ArrayList类;
 - 本身的函数addOnListChangedCallback、removeOnMapChangedCallback等没有通过synchronized加锁；
 - 底层Callback储存结构通过`MapChangeRegistry`实现，与`BaseObservable`的`PropertyChangeRegistry`一样继承了`CallbackRegistry`，是线程安全类；
- ObservableArrayMap
 - 实现了ObservableArrayMap接口，但继承的是ArrayMap类；
 - 其他的实现与`ObservableArrayList`类似；
