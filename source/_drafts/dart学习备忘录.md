---
title: dart学习备忘录
tags:
  - Flutter
  - Dart
categories:
  - Flutter
  - Dart
toc: false
---

# 语法

## 关键字

- var：dart时代码类型安全的语言，但也支持类型推断，多以可以使用`var`对变量进行声明；
  
  ```
  var name = "yifan";
  var year = 2021;
  var speed  = 3.5;
  var skills = ['Android','Futter','kotlin','dart','java'];
  var info ={
        'tags' :  ['dart'],
        'url' : 'baidu.com'
  }
  ```
- final：用于修饰变量，在定义时将其初始化，在初始化之后变量不可改变，但编译时无法得知变量的值；
- const：用于修饰常量，在编辑时即可获取值

## 流程控制语句

assert 语句

## 函数

> 建议为函数每个参数以及返回值指定类型。

- 简写
- 捕获异常

## 注释

```
// 这是一个普通的单行注释。
/// 这是一个文档注释。
/// 文档注释用于为库、类以及类的成员添加注释。
/// 像 IDE 和 dartdoc 这样的工具可以专门处理文档注释。
/* 也可以像这样使用单斜杠和星号的注释方式 */
```

## 导入

- import
  
  ```
  // 导入核心库
  import 'dart:math';
  // 从外部 Package 中导入库
  import 'package:test/test.dart';
  // 导入项目文件
   import 'path/to/my_other_file.dart';
  ```
- 前缀
- show
- hide
- 通过deferred实现懒加载
  
  ## 类

```
class Human {
  
  String name;
  int age;
  
  // 构造函数，可直接为成员变量赋值
  Human(this.name, this.age){
  // 初始化
  }
  
  // 命名构造函数，直接转发到默认构造函数
  Human.born(String name): this(name, 0)
  
  //用get将该属性定义为只读、非final，无法直接赋值
  String get info => "$name: $age";

}
```

