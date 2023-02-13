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
## Dart 重要 的概念如下:
- 所有的东西都是对象，无论是变量、数字、函数等都是对象。所有的对象都是类的实例。 所有的对象都继承自内置的Object类。这点类似于 Java语言“一切皆为对象” 。 
- 程序中指定数据类型使得程序合理地分配内存空间，并帮助编绎器进行语法检查。但是，指定类型不是必须的。 Dart语言是弱数据类型。 
- Dart代码在运行前解析。 指定数据类型和编译时的常量，可以提高运行速度。
- Dart程序有统一的程序人口: main()。 这一点与 Java、 C/C++语言相像。
- Dart 没有public、 protected 和 private 的概念 。 私有特性通过变量或函数加上下划线来表示。
- Dart 的工具可以检查出警告信息( warning)和错误信息( errors)。 警告信息只是表
明代码可能不工作，但是不会妨碍程序运行 。 错误信息可以是编译时的错误，也 可能是运行时的错误 。 编译 时的错误将阻止程序运行，运行时的错误将会以异常 (exception)的方式呈现 。
- Dart 支持 anync/await 异步处理。

## 面向接口
- Dart是面向接口编程，而非面向实现，即关注对象的行为而非它的内部实现；
- Dart类型基于接口，而不是类，即所有的类都能够被其他类继承、实现，除了基本类型；
- 方法不能`final`修饰，所以允许重写几乎所有方法；
- `accsesor`方法，即`set/get`默认创建，自动将所有对象进行封装，确保所有外部操作都通过存取方式来操作；
- 构造函数运渠对对象进行缓存，或者从子类型创建实例，因此使用构造函数并不意味绑定了一个具体的实现，例如：`Device.fromJson()`；

## 动态类型语言
- 在语法层面上不一定要声明实例的类型，可以使用`var`，但会降低代码可阅读性；
- 类型对运行时的语义没有影响；

## 状态
> Flutter中的状态理念与React中的一致，核心思想就是组件化的思想，应用由组件搭建而成，而组件中最重要的概念就是`State`（状态），`State`是一个组件的UI数据模型，是组件渲染时的数据依据。Flutter可以认为是一个巨大的状态机，用户的操作、请求API和系统事件的触发都是推动状态机的触发点，触发点通过调用`setState`方法推动状态机响应，生命周期如下：

![image.png](/images/2023/01/18/73485bf2-46bb-4bcf-9d4a-1b3fec766912.png)

## 关键字
> 关键字( 56 个)如下: abstract, do, import, super, as, dynamic, in, switch, assert,
else, interface, sync*, enum, implements, is, this, async*, export, library, throw, await, external, mixin, true, break, extends, new, try, case, factory, null, typedef, catch, false, operator, var, class, final, part, void, const, finally, rethrow, while, continue, for, return, with, covariant, get , set , yield*， default, if, static, deferred。

## `as`、`is`、`is!`
- `as`
  - 设置别名，即`import 'dart:math' as dartMath;`  
  - 类型转换，即`(obj as List).length;`
- `is`
  - 当`obj`实现了`T`的接口时，`obj is T`是true，`obj as T`可以将`obj`类型转换成`T`类型；
  - 注意：`is`并不检查对象是否为某个类或其子类的实例；

## operator
- 符号定义，即定义`+`等符号具体操作或重写运算符；