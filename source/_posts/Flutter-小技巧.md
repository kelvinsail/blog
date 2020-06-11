---
title: Flutter 小技巧
tags:
  - Flutter
categories:
  - Flutter
toc: false
date: 2020-03-24 08:33:39
---

# 去除ListView没有绑定AppBar而出现的顶部Padding
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
# 获取状态栏高度
```
   double _statusBarHeight = MediaQuery.of(context).padding.top;
```

# 获取appbar 高度
```
   double _kLeadingWidth = kToolbarHeight;
```