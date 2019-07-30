---
title: Android Kotlin学习笔记
tags:
  - Android
  - Kotlin
categories:
  - Android
  - Kotlin
toc: false
date: 2019-07-29 13:49:32
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
## 2、函数
> 函数定义使用关键字 fun，参数格式为：参数 : 类型

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

- 函数传多参数
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
- 函数+长度可变参数
```

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

## 3、变量、常量
- 创建、声明
 - 创建实例时不需要使用关键字new
- var：可变变量定义：
 - `var <标识符> : <类型> = <初始化值>`
- val：不可变变量定义，只能赋值一次的变量，类似Java中final修饰的变量
 - `val <标识符> : <类型> = <初始化值>`
 > 常量与变量都可以没有初始化值，但是在引用前必须初始化 
 > 声明时类型指定不是必须的，kotlin编译器支持自动类型判断，所以可以由编译器自己判断。
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