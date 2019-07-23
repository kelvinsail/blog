title: Android 多个module合并打包
tags:
  - Android
  - SDK
categories:
  - SDK
  - Android
toc: false
date: 2019-07-22 10:56:48
---

# 方式一：fat-aar-plugin
- 优点
 - 集成插件，方便
- 缺点
 - 不稳定，依赖编译环境
 - 兼容性（只支持gradle2，不兼容gradle3）
 - 集成后需要根据环境修改、兼容
- 原理
 - 复制打包后.class等文件，进行合并 

<!-- more -->
# 方式二：Gradle脚本（思路，试验中）

## 1、关系
- 例如：主工程，module A，module B，module C
 - module A、B，无本地依赖引用
 - module C 引用 A、B
 - 主工程引用module A、C

## 2、思路
 - 1）Gradle打包脚本
 - 2）依照依赖关系进行分批打包被依赖的子包为aar，例如：先打包module A，module B
 - 3）将module A、B的aar包加入module C 并引用依赖；
 - 4）最后打包module C为aar包，即最终的SDK

## 3、SDK使用方式
- aar包含的内容
 - 代码、资源文件、aar、so
- 主项目引用
 - 复制aar到libs
 - 添加依赖
 - 主项目build.gradle添加其他引用库，releativeX、gson等

## 4、问题
- 手动，步骤1、2、成功
- <span style="color:red">module C 打包后、主工程引用，style资源文件引用异常，资源定义缺失？？</span>
- 原因，module C 依赖了module A、B，但通过aar依赖、二次打包之后，代码、资源文件不能被自动打包进module C的aar中

# 方式二：Gradle脚本v2
## 1、关系
- 例如：主工程，module A，module B，module C，module D
 - 主工程、module A/B/C照旧
 - module D，作为临时项目

## 2、思路
- 新增一个module C，作为临时整合module
- 依赖gradle脚本，每次将module A、B、C的代码、资源、jar&so库文件整合到module D
- 打包module D，作为最终的SDK


