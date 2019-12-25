---
title: Android Kotlin学习笔记（未完成）
tags:
  - Android
  - Kotlin
categories:
  - Android
  - Kotlin
toc: false
date: 2019-07-29 13:49:00
---

# 一、声明及初始化
## 1、类
### 1）创建
> 类的声明由类名、类头（指定参数类型、主构造函数、继承实现关系）、类体（花括号及其中的变量、函数）构成，类头、类体都是可选，如果没有可以省略，如果主构造函数如果没有其他注解或可见修饰符，‘ constructor’关键字也可以省略
 - 声明一个普通类
 ```
 class Test{
 }
 ```
<!-- more -->
 - 声明及继承类/接口
 ```
 //普通继承
 class MainActivity: AppCompatActivity(){
 }
 //普通实现
 class User: Serializable {
 }
 //普通继承、实现
 class User : ViewModel(), Serializable {
 }
 //继承类、实现接口，以及带主构造函数
 class User(var id: Int, var name: String) : ViewModel(),Serializable {
 }
 ```
> 差别:
 - 默认即为public公开，所以可以省略public关键字；
 - 使用`":"`代替`"extends"`、`"implemenet"`关键字；
 - 自带初始化函数`init{}`，作为类初始化过程、主构造函数的一部分，但不代表构造函数，也不能管理传入参数

### 2）构造函数
- 分为主构造函数、二级构造函数
 - 主构造函数：在类名之后携带的`(var id: Int, var name: String)`即为主构造函数及其传参，而`init{}`作为主构造函数的内部代码块，如果参数或初始花代码为空，可以省略不写；
 - 二级构造函数，在类中声明，以`constructor`关键字声明，没有具体函数名，但要在构造函数声明`:`的后面调用主构造函数；
- 以二级构造函数初始化类，方法执行顺序是主构造函数 -> init{} -> 二级构造函数；
- 主构造函数不是必须的，如果一个类没有受限于父类，可以定义两个互不关联的二级构造函数，且无需定义主构造函数；

### 3）构造传参
- 格式：在类名之后以`()`包含，单个参数格式为`val/var/缺省 参数名:类型/类型?`，`类型?`代表可以为空
- 加val/var或不加
 - 加val/var代表，参数传递到该类之后将作为类的成员属性，`init{}`方法、成员方法中都可以引用；
 - 不加，则只是代表构造函数中有这个参数，只能够在`init{}`方法中引用，成员函数无法使用该参数变量；
- 参数默认值，可以通过设定参数的默认值，使得该参数作为可选传递参数，格式：`(参数名:类型 = 默认值)`；
 - 如果是java+kotlin混合项目，kotlin类中带有默认值的构造函数，需要加上注解`@JvmOverloads`，否则Java代码无法识别默认参数；
```
class User(var id: Int, name: String, sex: Int = 0) : ViewModel(), Serializable {

    init {
        /*初始代码块*/
    }

    constructor(id: Int, age: Int, name: String) : this(id, name) {
        /*二级构造函数*/
    }

}
//简化成：
class User(var id: Int, age: Int, name: String, sex: Int = 0) : ViewModel(), Serializable {

    init {
        /*初始代码块*/
    }
    
}
```
## 2、接口

## 3、函数
### 1）声明定义
- 函数声明使用关键字`fun`，默认为`public`，可以省略该关键字；
- 参数格式为：`参数:类型`，
 - 如果参数可以为空，则应在类型后加上`?`，格式为：`参数:类型?`；
 - 参数允许具有默认值，格式为`参数:类型 = 默认值`；
 - 具有多个默认参数时，可以通过参数名指定传递参数，如：`User().setInfo(1, home = "shenzhen")`；
- 在参数定义之后，可以添加返回值申明，格式为：`fun tese(name:String):String{}`；
 - 如果返回参数为空，具体定义类型为：`Unit`，但可以忽略不写；
- 通过在声明关键字`fun`前添加关键字`override`来声明对父类的该函数进行重载；
- 通过关键字`vararg`来声明可变参数，即类似于Java中的`public void setNames(String... names)`，kotlin的写法为`fun setNames(vararg names: String?)`，不允许传递多个可变参数；
- kotlin中的函数方法体也可当做变量来赋值，例如toast扩展函数的声明实现
```
fun Context.toast(msg: CharSequence) = Toast.makeText(this, msg, Toast.LENGTH_SHORT).show()
```


### 2）方式
- 普通函数(无返回值)
```
fun test(){
}
//无返回值函数也可以写成以下方式，Unit标记无返回值
fun log(): Unit { 
    Log.e(·····)
}
```
- 函数传参
```
fun test(text:String){}
```

- 函数+可变参数
```
fun testArray(vararg arr: String) {
    for (str in arr) {
        Log.i(TAG, "testArray: $str" )
    }
}

//调用
Test().testArray("111","222","333","444","555","666")
```

- 函数返回值
```
fun sum(a: Int, b: Int): Int {   // Int 参数，返回值 Int
    return a + b
}

//表达式作为函数体，返回类型自动推断

fun sum(a: Int, b: Int) = a + b

// public 方法则必须明确写出返回类型，除非无返回值或Unit
public fun sum(a: Int, b: Int): Int = a + b   

```

- 静态方法
```
companion object {
    fun testStatic(): Boolean {
        return true
    }
}
```

- 匿名函数（Lambda）
```
fun testArray(vararg arr: String) {
    for (str in arr) {
        val forLambda: (String) -> (Int) = { text -> Log.i(TAG, "testArray: $text") }
    }
}
```
### 3）特殊类型
#### a）全局函数
> 正常的函数定义在类的内部，依赖类进行调用，而kotlin中允许在独立的kt文件中直接定义全局函数，区别与java的静态函数，定义之后可以在程序中直接使用，不需要通过类，例如：`arrayOf()`;

#### b）泛型函数
> 通过在函数名之前使用`<*>`泛型（例如`<T>`）声明未被定义的参数类型（包括传入和输出），之后必须在使用函数时传入参数类型进行定义才能使用；
```
fun <T> addHouse(address: T):T {
··· 省略 ···
}
```
#### c）内联函数
- 在开发过程中通常会将重复的代码抽离为一个函数，而函数在调用过程会经历一系列的压栈出栈操作，频繁的调用某一个函数，也会额外的性能消耗；
- 内联函数可以理解为一个代码块，通过`inline`声明之后，会在编译期间将内联函数与调用位置进行替代；
- 关键字
 - inline(标记为内联函数)
```
inline fun getName(vararg names: String): String {
    var all = "";
    for (name in names) {
        all = "$all, $name"
    }
    return all;
}
```
- noinline
> 如果将一个函数作为参数传给内联函数，在内联函数中又将该函数传参传递给另一个非内联函数作为参数时，编译时就会报错，因为作为内联函数形参的时候，函数传参也是inline的函数对象，但编译时函数传参已经转变为一个具体的值，而不再是一个对象，另一个内联函数要接收函数对象时则会报错；
> 通过`noinline`关键字标记参数为非内联函数来解决上述问题；
```
inline fun <T> getName(noinline names: () -> T) {
    mark(names)
}

fun <T> mark(names: () -> T){
    
}
```
- crossinline
> - 禁止被标记的lambda表达式进行局部返回，只能以`return@XXXinterface`进行返回；
> - 官方释义：一些内联函数可能调用传给它们的不是直接来自函数体、而是来自另一个执行上下文的 lambda 表达式参数，例如来自局部对象或嵌套函数。在这种情况下，该 lambda 表达式中也不允许非局部控制流。为了标识这种情况，该 lambda 表达式参数需要用 crossinline 修饰符标记。
- reified
> 泛型具体化，与`inline`配合使用，可以在内联函数中具体化泛型来使用；


#### d）简化函数
> 简化函数结构，变成类似于三元运算符`?:`结构；

#### e）尾递归函数

#### f）高阶函数

## 4、变量、常量
### 1）创建、声明
> 创建实例时不需要使用关键字new
- var：可变变量定义：
 - `var <标识符> : <类型> = <初始化值>`
- val：不可变变量定义，只能赋值一次的变量，类似Java中final修饰的变量
 - `val <标识符> : <类型> = <初始化值>`
 > 常量与变量都可以没有初始化值，但是在引用前必须初始化 
 > 声明时类型指定不是必须的，kotlin编译器支持自动类型判断，所以可以由编译器自己判断。
### 2）延迟初始化
- lateinit：延迟初始化
 - 只能用来修饰作为成员变量的var对象，不能是局部变量，也不能是基本类型，因为基本类型在类加载时会自动赋予初始默认值；
 - 作用是让编辑器检查是不会因为属性变量未被初始化而报错，使用前需要判断以及初始化，但并不是直到第一次使用才初始化；
 - 使用
 ```
 class RepoApplicarion : Application() {

     override fun onCreate() {
         super.onCreate()
         instance = this
     }

     companion object {
        
         private lateinit var instance: RepoApplicarion
        
         fun get() = instance

     }
 }
 ```
- by lazy：延迟初始化
 - 属性委托，作用于常量val，接收一个lambda并返回一个Lazy<T>实例的函数；
 - 仅当变量第一次被调用时委托方法才会执行，并且只执行一次，启后每次调用都是返回记录的结果值；
 - 也是一种懒汉单例模式
 ```
   val lazyTest: Int by lazy {
        var x = 1
        Log.i(TAG, "x:$x")
        var y = 2
        Log.i(TAG, "y: $y")
        x + y
    }

    fun test(text: String) {
        Log.i(TAG, "test: $lazyTest")
        Log.i(TAG, "test: $lazyTest")
    }

    //输出结果如下
    I/Test: x:1
    I/Test: y: 2
    I/Test: test: 3
    I/Test: test: 3
 ```

### 3）set/get方法
```
var <propertyName>[: <PropertyType>] [= <property_initializer>]
    [<getter>]
    [<setter>]
```
- 对于var修饰的变量，set/get方法有默认实现，可以不用写；而val修饰的变量则没有相应的set默认实现，也不允许重写
- set/get方法的自定义实现
```
    var title: String = ""
        get() {
            return field.toUpperCase(Locale.getDefault())
        }
        set(value) {
            field = value.trim()
            Log.d(TAG, "set: $value")
        }

    val content: String
        get() {
            return "this is content"
        }
```

- field变量
 - 方法中需要以field替代自身变量，不允许通过变量名引用set/get方法本身的变量，会导致递归死循环；
 - 方法中也不允许声明定义与自身变量同名的其他变量；
 - field被称为Backing Fields(后端变量)，相当于`this`，代指变量自身的引用；

- private修饰
 - 可以通过`private`将set/get方法修饰为私有，但如果变量本身为`public`，则get方法无法定为私有函数；
 ```
     var title: String = ""
        get() {
            return field.toUpperCase(Locale.getDefault())
        }
        private set(value) {
            field = value.trim()
        }
 ```

# 二、数据类型
## 1、基本类型
- 1）基本数据类型

|基本数据类型名称|Kotlin数据类型|Java数据类型|
|---|---|---|
|整形|Int|int、Integer|
|长整型|Long|long、Long|
|浮点型|Float|float、Float|
|双精度|Double|double、Double|
|布尔型|Boolean|boolean、Boolean|
|字符型|Char|char|
|字符串|String|String|

- 2）类型转换

|Kotlin|说明|
|---|---|
|toInt|转为整型数值|
|toLong|转为长整型数值|
|toFloat|转为浮点型数值|
|toDouble|转为双精度数值|
|toChar|转为字符|
|toString|转为字符串|
|toBoolean|转为布尔型|

> String可以使用相应的函数转为其他基本类型，但要注意得是如果是转换非数字（例如“hello”）、数字格式不匹配（“0.01”转int），转换时会抛出`NumberFormatException`异常；
## 2、数组
- 1）基本类型

|Kotlin基本数组类型|数组类型的名称|类型初始化方法|
|---|---|---|
|整型数组|IntArray|intArrayOf|
|长整型数组|LongArray|lonArrayOf|
|浮点数组|FloatArrary|floatArrayOf|
|双精度数组|DoubleArray|doubleArrayOf|
|布尔数组|BooleanArrat|booleanArrayOf|
|字符数组|CharArray|charArrayOf|

> 使用，例如
> ```
> var int_array:IntArrat = intArrayOf(1,2,3,4)
> ```

- 2）其他类型

> 例如：String，Kotlin中没有提供基本的StringArray，所以只能使用其他类型的数组来储存：
```
var string_array:Array<String> = arrayOf{"Hello","World"}
```

> 除了String，其他类型、包括基本类型，都可以使用该Array<T>数组来存放数据

- 3）操作
 - 获取长度(.size)
 - 获取元素`[index]`或`get(index: Int)`
 - 存放元素`set(index: Int, value: T)`
 - 遍历
 ```
  //for循环
  for (str in string_array){
    Log.i(TAG, "test: $str")
  }
  //while循环
  var index:Int = 0
  while (index <string_array.size){
  Log.i(TAG, "test: ${string_array[index]}")
    index++
  }
 ```
## 3、容器

# 三、条件判断
## 1、ifelse

## 2、循环语句
### 1）while
### 2）for
#### a）for
#### b）forEach
#### c）forEachIndexed
### 3）repeat

## 3、为空判断
### 1）可空属性
> 在Kotlin中，对为空判断控制的非常严格，一般变量常量的声明都需要使用`var`、`val`关键字并赋值，如果可能为空则需要在类型声明后面加上`?`标记(`var msg:String? = null`)，声明该属性为可空属性，使用时也需要在变量后面加上`?.`，例如：(`msg?.lenght`)，如果使用时变量为空，则直接返回`null`；
### 2）Elvis运算符
> 获取字符长度时，变量为空则返回`null`，此时的返回值肯定与逻辑的并不相符，可以使用`?:`为空值校验设置默认值，即为空时，以默认值替代`null`，例如`msg?.length ?: 1`;
### 3）强制非空转换
> 还有另外一种运算符`!!`，用于标记可空属性，表示强制将该可空属性转换为非空属性，但要注意得是，需要自行判断是否为空，如果标记的对象为空，则使用时可能会抛出空指针异常；

## 4、等式判断
### 1）结构相等
> 使用`==`替代Java原有的`equals()`函数进行值对比，判断是否相等，而非参数内存地址对比，而判断两个属性不相等，则可以使用`!=`，这种对比在kotlin中称为结果相等对比，即两个属性值、内部等都一致；
### 2）引用相等（全等判断）
> 使用`===`来判断两个属性之间，是否结构、引用内存地址等都相等，即两个属性<span style="color:red">全等</span>，而判断两个属性非全等，可使用"!=="；
 - 对于基本类型而言，结构相等、引用相等判断并无区别；
 - 对于一个类的不同实例，如果有一个属性`equals`或引用不相等，则既是结构不相等也是引用不相等；
 - 对于一个类的不同实例，如果属性都`equals`相等，则为结构相等，但引用不相等；

## 5、类判断
### 1）类实例判断
> Java中通过`instanceof`判断一个属性是否为某个类的实例化对象，但在kotlin中，将该命令简化为`is`，使用方式与Java中差不多：`if(user is User)`，如果要判断不相等，则加上`!`，如：`if(user !is User)`;
### 2）数组元素判断
> Java中判断一个数组中是否包含某个元素得时候，基本都是通过遍历循环来判断，而在kotlin中，提供了关键字`in`来判断，例如：判断Int数组arr是否包含元素`4`，为`if(4 in arr)`，除了判断基本类型也可用来判断类对象，如：`(user in arr)`，如果要进行不存在判断，则加上`!`，为`(user !in arr)`

<!--
Android
1、控件变量自动映射功能，直接通过控件id名引用控件

-->


# 参考文档
> [Kotlin内联函数的使用](https://www.jianshu.com/p/4f29c9724b33)