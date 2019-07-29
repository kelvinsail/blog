---
title: Android Kotlin
tags: []
categories: []
toc: false
date: 2019-07-29 13:49:32
---

# 声明及初始化
## 1、类
- 声明一个普通类
```
class Test{
}
```

- 声明及快速实现构造函数传参

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
- var: 可变变量定义：
 - `var <标识符> : <类型> = <初始化值>`
- val: 不可变变量定义，只能赋值一次的变量，类似Java中final修饰的变量
 - `val <标识符> : <类型> = <初始化值>`
- lateint
> 常量与变量都可以没有初始化值，但是在引用前必须初始化
> 声明时类型指定不是必须的，kotlin编译器支持自动类型判断，所以可以由编译器自己判断。