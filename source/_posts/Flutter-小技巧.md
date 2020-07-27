---
title: Flutter 小技巧
tags:
  - Flutter
categories:
  - Flutter
toc: false
date: 2020-03-24 08:33:39
---

# 开发
## 去除ListView没有绑定AppBar而出现的顶部Padding
```
              MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: ListView.builder(
                  itemBuilder: getItem,
                  itemCount: getData().length,
                ),
              ),
```

<!-- more -->
## 获取状态栏高度
```
   double _statusBarHeight = MediaQuery.of(context).padding.top;
```

## 获取appbar 高度
```
   double _kLeadingWidth = kToolbarHeight;
```

# 异常
## 引入flutter module报错
```
Settings file '/Volumes/GALAXY/CodeProjects/Android/Flutter/FixDev/FlutterFix/settings.gradle' line: 4
A problem occurred evaluating settings 'FlutterFix'.
> /Volumes/GALAXY/CodeProjects/Android/Flutter/FixDev/FlutterFix/flufix/.android/include_flutter.groovy (/Volumes/GALAXY/CodeProjects/Android/Flutter/FixDev/FlutterFix/flufix/.android/include_flutter.groovy)

```

- 检查`setting.gradle`配置文件的`evaluate`函数中输入的参数路径
 - 如果flutter module是项目内一个子module，不需要传入parentFile，即:
```
evaluate(new File(
  settingsDir,
  'flufix/.android/include_flutter.groovy'
))
```
 - 如果flutter module是外部独立的module，则传入parentFile，即:
 ```
evaluate(new File(
  settingsDir.parentFile,
  'flufix/.android/include_flutter.groovy'
))

 ```
> 如果引用的是别人项目的flutter module，本地没有编译过的话，可以先用AndroidStudio打开编译下，否则有可能找不到`.android/include_flutter.groovy`