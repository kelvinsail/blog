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
- 关系示例图，DataBinding实现MVVM
![DataBinding实现MVVM](/images/2019/07/24/ba0d6380-adbb-11e9-ba13-ed3d05d432af.png)

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
- 创建布局文件，并声明要引入的ViewModel类，注意：
 - 以`layout`为根元素，有且只有一个`data`标签；
 - 除`data`之外只能包含一个主布局或控件，不能直接包含`<merge>`元素；
 - `java.lang.*`路径下的类默认已经引入，再引入会导致报错；
```
<layout >
    <data>
        <!-- 引入其他类包，方便在布局中引用 -->
        <!-- 如果引入的类名冲突，可以使用alias定义别名 -->
        <import type="android.text.TextUtils" />

        <variable name="viewModel" 
              type="com.yifan.model.viewModel"/> 
    </data>

    <LinearLayout></LinearLayout>
</layout>
```

- data标签元素作用
 - variable：声明对象并将其作为一个变量，可以在xml布局文件中使用；
 - import：引入一个类，可以方便的使用其中定义的静态方法；
 - class
 - alias：指定一个别名，以防止多个类名冲突；
 - include：
- 自动布局属性


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
- 运行项目`Make Module ‘app’`，会自动生成布局文件对应的`ViewDataBinding`类；
- 主体可为Acitivty/Fragemnt，甚至是View、Holder
- 创建Activity或Fragment类；
- 声明布局文件对应的`ViewDataBinding`类对象，绑定DataBindingUtil生成的`ViewDataBinding`实例：
 - 通过`DataBindingUtil.setContentView（Activity activity,
            int layoutId）`设置布局并绑定；
 - 通过`inflate(@NonNull LayoutInflater inflater,
            int layoutId, @Nullable ViewGroup parent, boolean attachToParent)`解析布局，并加载绑定（通常用在RecyclerView的Holder中）
- 设置`ViewDataBinding`实例的`ViewModel`对象（make module后自动根据xml布局中引用的类定义的`name`生成setter方法，可以多个VM，点击事件绑定、方法引用都是一种特殊的VM）；
- 通过设置的`ViewModel`实例，更改数据、通知刷新UI；

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
 - 这些包装类并不是`ObservableField`的子类，而是同样继承`BaseObservableField`，内部实现原理一样;
 - 包装类型已定义，也实现了Parcelable序列化接口;

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

# 四、表达式
## 1、基础运算符
- 算术符号：+ - / * %
- 字符串合并： +
- 逻辑运算符 && ||
- 二元运算符 & | ^
- 一元运算符 + - ! ~
- 移位运算符 >> >>> <<
- 比较 == > < >= <= (符号“<”需要写成“&lt;”)
- 类型判断：instanceof
- Grouping ()
- Literals - character, String, numeric, null
- 强制转换
- 方法调用
- 变量访问
- 数组访问 []
- 三元运算符 ?:

## 2、不支持的操作
- this
- super
- new
- 泛型

## 3、空合并运算符
- 符号：`??`
- 使用
 - 如果`??`左侧判断不为空，则输出左侧变量；否则，则输出表达式右侧的变量
 ```
 android:text="@{user.displayName ?? user.lastName}"
 ```
 - 上述代码例子，等价于以下的表达式
 ```
 android:text="@{user.displayName != null ? user.displayName : user.lastName}"
 ```
## 4、属性引用
- 可以通过以下方式对类中定义的属性进行引用，包括变量、get方法以及`ObservableField`对象；
```
android:text="@{user.lastName}"
```

## 5、防止空指针
- databinding代码里会自动检查并防止空指针异常，例如：`@{user.name}`、`@{user.age}`
 - 如果`user`为空，`user.name`会输出默认的`null`；
 - 如果是int类型的`user.age`，则输出默认值`0`;

## 6、数组集合
- 数据集合，例如：arrays、lists、sparse lists以及maps，可以通过`[]`引用其中包含的变量
```
<data>
    <import type="android.util.SparseArray"/>
    <import type="java.util.Map"/>
    <import type="java.util.List"/>
    <variable name="list" type="List&lt;String>"/>
    <variable name="sparse" type="SparseArray&lt;String>"/>
    <variable name="map" type="Map&lt;String, String>"/>
    <variable name="index" type="int"/>
    <variable name="key" type="String"/>
</data>
…
android:text="@{list[index]}"
…
android:text="@{sparse[index]}"
…
android:text="@{map[key]}"
```
> 注意：xml中需要对“<”符号进行转义，例如：“List<String>” 需要写成 “List&lt;String>”；除此之外还可以使用`object.key`的方式替代`map`的取值方式，例如`"@{map[key]}"`可以写为`"@{map.key}"`

## 7、字符常量
> 根据代码中对单引号、双引号的使用，一般来说，外围使用双引号包裹，则内部常量定义需要使用单引号，如果外围为单引号，则内部使用双引号；
- android:text='@{map["firstName"]}'
- android:text="@{map['firstName']}"
- android:text="@{@string/user_name}"（可用于@color、@drawable或其他）

## 8、资源
- 可以在表达式中引用资源:
```
android:padding="@{large? @dimen/largePadding : @dimen/smallPadding}"
```
- 字符串格式化，以及plurals资源引用:
```
android:text="@{@string/nameFormat(firstName, lastName)}"
android:text="@{@plurals/banana(bananaCount)}"
```
- 当一个plural资源拥有多个参数时，所有参数都应该传递:
 - Have an orange
 - Have %d oranges

```
android:text="@{@plurals/orange(orangeCount, orangeCount)}"
```
- 其他一些资源需要使用特定的引用方式，如下：
|Type|Normal reference|Expression reference|
|---|---|---|
|String[]|@array|@stringArray|
|int[]|@array|@intArray|
|TypedArray|@array|@typedArray|
|Animator|@animator|@animator|
|StateListAnimator|@animator|@stateListAnimator|
|color int|@color|@color|
|ColorStateList|@color|@colorStateList|

## 9、调用其他控件
- 支持调用同个布局中已声明id的控件；
 - 如果控件id命名包含“_”，需要改为驼峰命名方式调用，例如：“tv_name”需要以“tvName”进行调用；
```
        <TextView
            android:id="@+id/tv_text"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="@{viewModel.text}"
            app:layout_constraintBottom_toBottomOf="parent"
            app:layout_constraintLeft_toLeftOf="parent"
            app:layout_constraintRight_toRightOf="parent"
            app:layout_constraintTop_toTopOf="parent" />


        <CheckBox
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            app:layout_constraintTop_toBottomOf="@id/tv_text"
            app:layout_constraintLeft_toLeftOf="parent"
            app:layout_constraintRight_toRightOf="parent"
            android:text="@{tvText.text}"
            android:onCheckedChanged="@{(cb,isChecked)->viewModel.onChecked(cb,isChecked)}"/>
```
## 10、上下文
- 默认提供了名为`context`的变量来支持上下文`context`的直接使用，该`context`对象来自于根布局元素`getContext()`
```
android:text="@{context.getApplicationContext().toString()}"
android:onCheckedChanged="@{()->viewModel.onChecked(context)}"
```


# 五、事件绑定
> 常见的事件例如`onClick()`点击事件，可以在代码中动态绑定一个`View.OnClickListener`，也通过xml布局文件中控件的事件绑定属性`android:onClick`与方法进行关联，DataBinding也支持该类事件绑定属性的使用；
> 方式有两种：
> - 方法调用
> - 绑定监听

## 1、方法引用
- 创建点击事件处理类
 - 引入的类不能是抽象类、也不能是接口；
 - 类不用继承View.OnCLickListener等接口，但函数一定要是public；
 - 注意方法需要与默认函数（例如`onClick(View view)`）一致，将传递view作为参数，否则编译报错；
 - 可以使用`handlers::onClickFriend`或者`handlers.onClickFriend`，但不能`handlers.onClickFriend()`，会导致编译报错；
 - 方法引用不支持传递自定义参数；
```
public class MyHandlers {
    public void onClickFriend(View view) { ... }
}
```
- 布局文件导入、设置
```
<?xml version="1.0" encoding="utf-8"?>
<layout xmlns:android="http://schemas.android.com/apk/res/android">
   <data>

       <variable name="handlers" type="com.example.MyHandlers"/>
       <variable name="user" type="com.example.User"/>

   </data>
   <LinearLayout
       android:orientation="vertical"
       android:layout_width="match_parent"
       android:layout_height="match_parent">

       <TextView android:layout_width="wrap_content"
           android:layout_height="wrap_content"
           android:text="@{user.firstName}"
           android:onClick="@{handlers::onClickFriend}"/>

   </LinearLayout>
</layout>
```
## 2、绑定监听
- 创建监听类
```
public class Presenter {
    public void onSaveClick(Task task){}
}
```
- 布局文件引入类、设置
- 使用`() -> presenter.onSaveClick(task)`格式代码进行回调传递，支持自定义参数；
```
<?xml version="1.0" encoding="utf-8"?>
<layout xmlns:android="http://schemas.android.com/apk/res/android">
    <data>

        <variable name="task" type="com.android.example.Task" />
        <variable name="presenter" type="com.android.example.Presenter" />

    </data>
    <LinearLayout 
        android:layout_width="match_parent"
        android:layout_height="match_parent">

        <Button 
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:onClick="@{() -> presenter.onSaveClick(task)}" />
    </LinearLayout>

</layout>
```
- 在上述的代码中，没有定义原本回调函数的view变量作为参数，databindng中监听绑定可以选择忽略原有参数，如果需要也可以对原有<span style="color:red">所有参数</span>进行声明，写成“@{(view) -> presenter.onSaveClick(view, task)}”

# 六、使用静态类方法
- import相应的类之后，就可以在布局文件中直接使用
```
    <data>
        <import type="android.text.TextUtils" />
        <variable
            name="viewModel"
            type="com.example.databindingtest.MainViewModel" />
    </data>

   <TextView
        android:id="@+id/tv"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="@{TextUtils.isEmpty(viewModel.text)?`text is null`:viewModel.text}" />
```


> 参考文档链接：
> [https://developer.android.com/topic/libraries/data-binding](https://developer.android.com/topic/libraries/data-binding)
