---
title: Android Gradle引用方式
tags:
  - Android
  - Gradle
categories:
  - Gradle
  - Android
toc: false
---

- implementation，api（compile）
这种是我们最常用的方式，使用该方式依赖的库将会参与编译和打包。

> implementation：该依赖方式所依赖的库不会传递，只会在当前module中生效。
api：该依赖方式会传递所依赖的库，当其他module依赖了该module时，可以使用该module下使用api依赖的库。
> 当我们依赖一些第三方的库时，可能会遇到com.android.support冲突的问题，就是因为开发者使用的compile或api依赖的com.android.support包与我们本地所依赖的com.android.support包版本不一样，所以就会报All com.android.support libraries must use the exact same version specification (mixing versions can lead to runtime crashes这个错误。
> 解决办法可以看这篇博客：com.android.support冲突的解决办法

- provided（compileOnly）
只在编译时有效，不会参与打包
可以在自己的moudle中使用该方式依赖一些比如com.android.support，gson这些使用者常用的库，避免冲突。

- apk（runtimeOnly）
只在生成apk的时候参与打包，编译时不会参与，很少用。

- testCompile（testImplementation）
testCompile 只在单元测试代码的编译以及最终打包测试apk时有效。

- debugCompile（debugImplementation）
debugCompile 只在debug模式的编译和最终的debug apk打包时有效

- releaseCompile（releaseImplementation）
Release compile 仅仅针对Release 模式的编译和最终的Release apk打包。

————————————————
版权声明：本文为CSDN博主「XeonYu」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/yuzhiqiang_1993/java/article/details/78366985
