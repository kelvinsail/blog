---
title: Flutter学习笔记
tags:
  - Android
  - Flutter
categories:
  - Android
  - Flutter
toc: false
---

# Dart
## 面向接口
- Dart是面向接口编程，而非面向实现，即关注对象的行为而非它的内部实现；
- Dart类型基于接口，而不是类，即所有的类都能够被其他类继承、实现，除了基本类型；
- 方法不能`final`修饰，所以允许重写几乎所有方法；
- `accsesor`方法，即`set/get`默认创建，自动将所有对象进行封装，确保所有外部操作都通过存取方式来操作；
- 构造函数运渠对对象进行缓存，或者从子类型创建实例，因此使用构造函数并不意味绑定了一个具体的实现，例如：`Device.fromJson()`；

## 动态类型语言
- 在语法层面上不一定要声明实例的类型，可以使用`var`，但会降低代码可阅读性；
- 类型对运行时的语义没有影响；

## 关键字

## `as`、`is`、`is!`
- `as`
  - 设置别名，即`import 'dart:math' as dartMath;`  
  - 类型转换，即`(obj as List).length;`
- `is`
  - 当`obj`实现了`T`的接口时，`obj is T`是true，`obj as T`可以将`obj`类型转换成`T`类型；
  - 注意：`is`并不检查对象是否为某个类或其子类的实例；

## operator
- 符号定义，即定义`+`等符号具体操作或重写运算符；