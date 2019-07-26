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
- 虽然解耦，但对xml布局文件有侵入式修改，对布局文件复用有一定的影响，编译器会对相应的标签进行处理成LayoutInflater可识别的形式，所以定义之后代码中也可以不使用；
- `@{}`布局中的表达式除了简单判断、转换之外，不应该做复杂的代码实现；
- 官方关系示例图，MVVM中的DataBinding
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

- 相关的标签元素或属性
 - variable：标签，声明对象并将其作为一个变量，可以在xml布局文件中使用；
 - import：标签，引入一个类，可以方便的使用其中定义的静态方法（java.lang.*已默认添加引用）；
 - class：属性，用于data标签中，指定布局文件自动生成的`ViewDataBinding`文件的名称；
 - alias：属性，指定一个别名，以防止多个类名冲突；
 - include：标签，包含一个外部布局，相应的ViewModel类需要进行传递才能才include的布局中使用，但不可作为layout中定义的root布局；
 - ViewStub：
 - merge：标签，不支持布局中直接包含单个merge标签；

- 在布局中的适当位置使用 单向`@{}` 或 双向`@={}`，引用绑定的变量
 - 单向`@{}`：即数据源更改时，通知视图进行刷新；
 - 双向`@={}`：即数据改变时会通知视图刷新，视图刷新变更时也会通知数据更改；
   <span style="color:red">双向绑定时注意做变量相等判断，防止造成死循环</span>
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
 - 自动生成ViewDataBinding类继承BaseObservable，BaseObservable实际上又是Observable的实现类
 - BaseObservable中实现了订阅、取消订阅、通知刷新四个函数，并<span style='color:red'>通过`synchronized(this)`以类锁的方式实现线程安全</span>；
- 在代码中通过`ViewDataBinding`提供的方法添加、删除订阅，或通知刷新（）
 - addOnPropertyChangedCallback(@NonNull OnPropertyChangedCallback callback)
 - removeOnPropertyChangedCallback(@NonNull OnPropertyChangedCallback callback)
 - notifyChange()
 - notifyPropertyChanged(int fieldId) 
 > <span style="color:red">fieldId来自BR类定义的变量，make module之后自动生成；</span>
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
- 支持的符号、操作，以及数据类型
 - 算术符号：+ - / * %
 - 字符串合并： +
 - 逻辑运算符 && ||
 - 二元运算符 & | ^
 - 一元运算符 + - ! ~
 - 移位运算符 >> >>> <<
 - 比较 == > < >= <= (符号“<”需要写成“&lt;”)
 - 类型判断：instanceof
 - Grouping ()
 - 文本字符, 字符串, 数字, null
 - 强制转换
 - 方法调用
 - 变量访问
 - 数组访问 []
 - 三元运算符 ?:

## 2、不支持的符号或操作
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
> <span style="color:red">注意：作为绑定回调事件的函数，混淆规则要进行排除，防止混淆之后DataBinding框架无法根据函数名找到回调函数<span>

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

# 七、inclue 与 ViewStub
# 八、绑定适配
## 1、属性自动选择
- 支持View控件的自定义属性与setter方法之间的自动关联；
 - 如果xml中定义的属性为example，库会自动尝试查找setExample(arg)接受兼容类型作为参数的方法；
 - 假如arg为已定义的String字符串，则会寻找setExample(String arg)，如果为int，则是寻找setExample(int arg)；
 - 如果arg为ViewModel提供类型，如`user.name`，则会先获取`user.getName()`返回对象以确定类型；
 - 不考虑属性的名称空间，搜索方法时仅使用属性名称和类型；
- View中定义了相应的setter函数，并`make module`（或根据View中已有的setter函数，定义xml属性）；
```
public class CustomTextView extends TextView {

    private static final String TAG = "CustomTextView";

    private String name;

    public CustomTextView(Context context) {
        super(context);
    }

    public CustomTextView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public CustomTextView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }


    public void setName(String name) {
        this.name = name;
    }
}
```
- 可以在布局中直接使用app命名空间来设置对应的属性（Android Studio不会自动补全属性名称）；
```
<com.example.databindingtest.design.builder.CustomTextView
  android:id="@+id/tv"
  android:layout_width="wrap_content"
  android:layout_height="wrap_content"
  app:name="@{`yifan`}" />
```
## 2、指定属性方法（BindingMethods）
- 如果遇到属性与setter函数名称无法统一的情况，还可以使用`BindingMethods`注解来指定接收事件的函数；也是作为一种布局自定义属性接收函数的功能，所以需要在自定义控件中添加注解、事件接收函数；
- 自定义控件，以`CustomImageView`为例；
- 在头部添加注解`@BindingMethods`集合，定义需要声明的属性函数指定关系`@BindingMethod`
 - 每一个声明都需要三个属性(type:使用的类，attribute：xml布局文件中定义的属性，method：自定义布局中的接收函数名）
```
@BindingMethods({
        @BindingMethod(type = android.widget.ImageView.class, attribute = "loadimage", method = "loadImage"),
})
@SuppressLint("AppCompatCustomView")
public class CustomImageView extends ImageView {

    public CustomImageView(Context context) {
        super(context);
    }

    public CustomImageView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public CustomImageView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    public void loadImage(String url) {
        Glide.with(this.getContext()).load(url).into(this);
    }
}
```
- 布局中添加自定义属性
```
        <com.example.databindingtest.CustomImageView
            android:id="@+id/iv_content"
            android:layout_width="match_parent"
            android:layout_height="match_parent"
            app:loadimage="@{viewModel.img}" />
```

## 3、自定义逻辑（BindingAdapter）
### 1）方式
- 单属性绑定
```
@BindingAdapter("android:paddingLeft")
public static void setPaddingLeft(View view, int padding) {
  view.setPadding(padding,
                  view.getPaddingTop(),
                  view.getPaddingRight(),
                  view.getPaddingBottom());
}
```
- 多属性绑定
 - java
 ```
 @BindingAdapter({"imageUrl", "error"})
 public static void loadImage(ImageView view, String url, Drawable error) {
   Picasso.get().load(url).error(error).into(view);
 }
 ```
 - xml
 ```
 <ImageView app:imageUrl="@{venue.imageUrl}" app:error="@{@drawable/venueError}" />
 ```
 - 默认情况下，需要绑定的多个属性都发生变化才会发起通知，但也可以设置`requireAll`为`false`，但此时发起回调之后，没有发生变化的属性可能会传递`null`，需要做非空判断；
 ```
 @BindingAdapter(value={"imageUrl", "placeholder"}, requireAll=false)
 ```
### 2）语法
- 通过`@BindingAdapter`关键字绑定属性，或修改原有的属性；
- 方法必须申明为`public static`，共有静态函数，方法名称没有要求；
- 方法的第一个参数类型必须是控件或其父类，第二个参数可以是自定义或原有参数类型；
- 命名空间在`@BindingAdapter`参数未具体定义的情况下可以使用任意的，但如果已经定义那就必须遵守；
- <span style="color:red">支持新旧参数对比</span>，BindingAdapter可以选择性地在函数中使用旧的变量，如果需要则应该在传递的参数中先定义旧变量参数、然后是新的参数，如下所示
```
@BindingAdapter("android:paddingLeft")
public static void setPaddingLeft(View view, int oldPadding, int newPadding) {
  if (oldPadding != newPadding) {
      view.setPadding(newPadding,
                      view.getPaddingTop(),
                      view.getPaddingRight(),
                      view.getPaddingBottom());
   }
}
```
- 事件处理绑定的函数，只能使用具有一个抽象方法的接口或抽象类作为参数
```
//方法绑定
@BindingAdapter("android:onLayoutChange")
public static void setOnLayoutChangeListener(View view, View.OnLayoutChangeListener oldValue,
       View.OnLayoutChangeListener newValue) {
  if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
    if (oldValue != null) {
      view.removeOnLayoutChangeListener(oldValue);
    }
    if (newValue != null) {
      view.addOnLayoutChangeListener(newValue);
    }
  }
}

//布局文件绑定
<View android:onLayoutChange="@{() -> handler.layoutChanged()}"/>
```
 - 如果一个监听器具有多个回调方法，那只能拆分成多个监听器，例如：`View.OnAttachStateChangeListener`拥有两个回调事件：`onViewAttachedToWindow(View)`以及`onViewDetachedFromWindow(View)`，库中提供了两个接口来区分开这个两个属性以及处理器；
```
@TargetApi(VERSION_CODES.HONEYCOMB_MR1)
public interface OnViewDetachedFromWindow {
  void onViewDetachedFromWindow(View v);
}

@TargetApi(VERSION_CODES.HONEYCOMB_MR1)
public interface OnViewAttachedToWindow {
  void onViewAttachedToWindow(View v);
}
```
> 因为改动一个监听器会影响到另外的，所以你需要定义一个适配器来为处理其中之一或同时处理两个，可以将`requireAll`设置为`false`来拆分两个属性的变化通知；
```
@BindingAdapter({"android:onViewDetachedFromWindow", "android:onViewAttachedToWindow"}, requireAll=false)
public static void setListener(View view, OnViewDetachedFromWindow detach, OnViewAttachedToWindow attach) {
    if (VERSION.SDK_INT >= VERSION_CODES.HONEYCOMB_MR1) {
        OnAttachStateChangeListener newListener;
        if (detach == null && attach == null) {
            newListener = null;
        } else {
            newListener = new OnAttachStateChangeListener() {
                @Override
                public void onViewAttachedToWindow(View v) {
                    if (attach != null) {
                        attach.onViewAttachedToWindow(v);
                    }
                }
                @Override
                public void onViewDetachedFromWindow(View v) {
                    if (detach != null) {
                        detach.onViewDetachedFromWindow(v);
                    }
                }
            };
        }

        OnAttachStateChangeListener oldListener = ListenerUtil.trackListener(view, newListener,
                R.id.onAttachStateChangeListener);
        if (oldListener != null) {
            view.removeOnAttachStateChangeListener(oldListener);
        }
        if (newListener != null) {
            view.addOnAttachStateChangeListener(newListener);
        }
    }
}
```
> 上述的代码例子比一般的稍微复杂一点，因为使用了两个监听（addOnAttachStateChangeListener()、removeOnAttachStateChangeListener() ）来替代原有的多回调函数的监听器（OnAttachStateChangeListener）。 android.databinding.adapters.ListenerUtil类可以帮助跟踪先前的监听器，以便于在BindingAdater中将他们删除。
> 
> 同时，通过用@TargetApi（VERSION_CODES.HONEYCOMB_MR1）注解标记OnViewDetachedFromWindow和OnViewAttachedToWindow，使DataBinding库只在Honeycomb MR1及其之上的系统版本中运行该监听器。

# 九、绑定转换
## 1、对象自动转换
> 当一个Object对象从表达式中传递过来时，代码库会根据属性的值来选择接收的方法，而Object对象会被转换成所选方法的参数类型，数据通过ObservableMap进行保存，例如：
```
<TextView
   android:text='@{userMap["lastName"]}'
   android:layout_width="wrap_content"
   android:layout_height="wrap_content" />
```
> 在`android:text`属性中定义返回的`userMap`对象属性值，会自动转换成`setText(CharSequence)`方法中所找到的参数类型，如果发现可能导致转换抛出异常时，应在表达式中做额外的转换；

## 2、自定义转换
```
<View
   android:background="@{isError ? @color/red : @color/white}"
   android:layout_width="wrap_content"
   android:layout_height="wrap_content"/>
```
> 在一些情况下，需要为两个指定的类型定义一个自定义转换器。例如上述代码，view对象的`android:background`属性接收的是一个`Drawable`类型对象，但`@{}`中返回的结果`color`是一个int类型，需要将int属性值转换为ColorDrawable对象：

- 定义一个静态函数，添加`@BindingConversion`注解
```
@BindingConversion
public static ColorDrawable convertColorToDrawable(int color) {
    return new ColorDrawable(color);
}
```
> 要注意的是：
> - 定义之后，函数会对xml布局文件<span style="color:red">所有</span>`@{}`中定义的符合所绑定类型的对象做处理；
> - 在同个属性中通过三元表达式判断之后返回的两个对象类型应当统一，不能使用不同的类型，例如：`android:background="@{isError ? @drawable/error : @color/white}"`

# 十、Inverse（反向绑定）
## 1、InverseMethod
> 针对布局中model定义的数据类型与视图所展示的类型不一致时，通过`@ InverseMethod`注解标记的函数来统一两者之间的转换；例如：性别属性，在数据中经常以int类型标记，0、1、2，视图中表示为默认、男、女。
```
    @InverseMethod("convertIntToString")
    public static int convertStringToInt(String value) {
        if (null == value) {
            return 0;
        }
        if (value.equals("男")) {
            return 1;
        } else if (value.equals("女")) {
            return 2;
        } else {
            return 0;
        }
    }

    public static String convertIntToString(int value) {
        switch (value) {
            case 1:
                return "男";
            case 2:
                return "女";
            default:
            case 0:
                return "默认";
        }
    }
```
- 布局中使用
```
    <data>

        <import type="com.example.databindingtest.MainViewModel" />

        <variable
            name="viewModel"
            type="com.example.databindingtest.MainViewModel" />

    </data>

···省略
        <EditText
            android:id="@+id/tv_context"
            android:layout_width="match_parent"
            android:layout_height="match_parent"
            android:text="@{MainViewModel.convertIntToString(viewModel.sex)}"/>
```
> 注意方法是静态公有的，如果也写在ViewModel中，需要作为引入的类来使用，否则编译报错

## 2、InverseBindingAdapter
- 用于标记公有静态方法，进行双向绑定；
- 方法参数的第一个类型必须为控件或其父类；
- 需要配合@BindingAdapter使用；
- 注意需要通过新旧值判断避免造成死循环；
- 注解参数
 - attribute：String类型，必填，表示当值发生变化时，要从哪个属性中检索这个变化的值，示例："android:text"
 - event：String类型，非必填；如果填写，则使用填写的内容作为event的值；如果不填，在编译时会根据attribute的属性名再加上后缀“AttrChanged”生成一个新的属性作为event的值，举个例子：attribute属性的值为”android:text”，那么默认会在”android:text”后面追加”AttrChanged”字符串，生成”android:textAttrChanged”字符串作为event的值.
 - event属性的作用：当View的值发生改变时用来通知dataBinding值已经发生改变了，一般需要使用@BindingAdapter创建对应属性来响应这种改变。



## 3、InverseBindingMethods
- 用于标记类，进行双向绑定；
- 需要与`@InverseBindingMethod`、`@ BindingAdapter `配合使用；
- 注解参数
 - type：Class類型，必填，如：SeekBar.class
 - attribute：String類型，必填，如：android:progress
 - event：String類型，非必填，屬性值的生成規則以及作用和@InverseBindingAdapter中的event一樣。
 - method：String類型，非必填，對於什麼時候填什麼時候不填，這裏舉個例子說明：比如SeekBar，它有android:progress屬性，也有getProgress方法【你沒看錯，就是getProgress，不是setProgress】，所以對於SeekBar的android:progress屬性，不需要明確指定method，因爲不指定method時，默認的生成規則就是前綴“get”加上屬性名，組合起來就是getProgress，而剛纔也說了，getProgress方法在seekBar中是存在的，所以不用指定method也可以，但是如果默認生成的方法getXxx在SeekBar中不存在，而是其他方法比如getRealXxx,那麼我們就需要通過method屬性，指明android:xxx對應的get方法是getRealXxx,這樣dataBinding在生成代碼時，就使用getRealXxx生成代碼了；從宏觀上來看，@InverseBindingMethod的method屬性的生成規則與@BindingMethod的method屬性的生成規則其實是類似的。


# 十一、提供支持的属性

> DataBinding已为以下的控件及属性，提供默认的适配器，无需自行实现

|类|属性（S）|绑定适配器|
|---|---|---|
|[AdapterView](https://developer.android.com/reference/android/widget/AdapterView)|android:selectedItemPosition<br>android:selection|[AdapterViewBindingAdapter](https://android.googlesource.com/platform/frameworks/data-binding/+/refs/heads/studio-master-dev/extensions/baseAdapters/src/main/java/androidx/databinding/adapters/AdapterViewBindingAdapter.java)|
|[CalendarView](https://developer.android.com/reference/android/widget/CalendarView)|android:date|[CalendarViewBindingAdapter](https://android.googlesource.com/platform/frameworks/data-binding/+/refs/heads/studio-master-dev/extensions/baseAdapters/src/main/java/androidx/databinding/adapters/CalendarViewBindingAdapter.java)|
|[CompoundButton](https://developer.android.com/reference/android/widget/CompoundButton)|[android:checked](https://developer.android.com/reference/android/R.attr#checked)|[CompoundButtonBindingAdapter](https://android.googlesource.com/platform/frameworks/data-binding/+/refs/heads/studio-master-dev/extensions/baseAdapters/src/main/java/androidx/databinding/adapters/CompoundButtonBindingAdapter.java)|
|[DatePicker](https://developer.android.com/reference/android/widget/DatePicker)|android:year<br>android:month<br>android:day|[DatePickerBindingAdapter](https://android.googlesource.com/platform/frameworks/data-binding/+/refs/heads/studio-master-dev/extensions/baseAdapters/src/main/java/androidx/databinding/adapters/DatePickerBindingAdapter.java)|
|[NumberPicker](https://developer.android.com/reference/android/widget/NumberPicker)|[android:value](https://developer.android.com/reference/android/R.attr#value)|[NumberPickerBindingAdapter](https://android.googlesource.com/platform/frameworks/data-binding/+/refs/heads/studio-master-dev/extensions/baseAdapters/src/main/java/androidx/databinding/adapters/NumberPickerBindingAdapter.java)|
|[RadioButton](https://developer.android.com/reference/android/widget/RadioButton)|[android:checkedButton](https://developer.android.com/reference/android/R.attr#checkedButton)|[RadioGroupBindingAdapter](https://android.googlesource.com/platform/frameworks/data-binding/+/refs/heads/studio-master-dev/extensions/baseAdapters/src/main/java/androidx/databinding/adapters/RadioGroupBindingAdapter.java)|
|[RatingBar](https://developer.android.com/reference/android/widget/RatingBar)|[android:rating](https://developer.android.com/reference/android/R.attr#rating)|[RatingBarBindingAdapter](https://android.googlesource.com/platform/frameworks/data-binding/+/refs/heads/studio-master-dev/extensions/baseAdapters/src/main/java/androidx/databinding/adapters/RatingBarBindingAdapter.java)|
|[SeekBar](https://developer.android.com/reference/android/widget/SeekBar)|[android:progress](https://developer.android.com/reference/android/R.attr#progress)|[SeekBarBindingAdapter](https://android.googlesource.com/platform/frameworks/data-binding/+/refs/heads/studio-master-dev/extensions/baseAdapters/src/main/java/androidx/databinding/adapters/SeekBarBindingAdapter.java)|
|[TabHost](https://developer.android.com/reference/android/widget/TabHost)|android:currentTab|[TabHostBindingAdapter](https://android.googlesource.com/platform/frameworks/data-binding/+/refs/heads/studio-master-dev/extensions/baseAdapters/src/main/java/androidx/databinding/adapters/TabHostBindingAdapter.java)|
|[TextView](https://developer.android.com/reference/android/widget/TextView)|[android:text](https://developer.android.com/reference/android/R.attr#text)|[TextViewBindingAdapter](https://android.googlesource.com/platform/frameworks/data-binding/+/refs/heads/studio-master-dev/extensions/baseAdapters/src/main/java/androidx/databinding/adapters/TextViewBindingAdapter.java)|
|[TimePicker](https://developer.android.com/reference/android/widget/TimePicker)|android:hour<br>android:minute|[TimePickerBindingAdapter](https://android.googlesource.com/platform/frameworks/data-binding/+/refs/heads/studio-master-dev/extensions/baseAdapters/src/main/java/androidx/databinding/adapters/TimePickerBindingAdapter.java)|


# 参考文档链接
> - [DataBinding的Android开发者说明文档](https://developer.android.com/topic/libraries/data-binding)
> - [DataBinding的注解说明文档](https://developer.android.com/reference/android/databinding/Bindable)
> - [Android DataBinding 从入门到进阶](https://juejin.im/post/5b02cf8c6fb9a07aa632146d#heading-15)
> - [DataBinding使用教程（四）：BaseObservable与双向绑定](https://juejin.im/entry/59b628c66fb9a00a514368f8)
> - [DataBinding最全使用说明](https://juejin.im/post/5a55ecb6f265da3e4d7298e9#heading-17)