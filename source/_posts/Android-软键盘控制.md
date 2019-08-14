---
title: Android 软键盘控制
tags:
  - Android
  - 软键盘
categories:
  - Android
  - 软键盘
toc: false
date: 2019-08-05 18:00:00
---

# 一、布局自适应
## 1、添加自适应属性
- manifast.xml文件配置
```
<activity
        android:name=".MainActivity"
        android:windowSoftInputMode="adjustResize"/>
```
- Java代码控制
<!-- more -->
```
getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
```
## 2、横屏软键盘遮挡布局
- 在布局文件的EditText中添加`imeOptions`属性
```
<EditText
    android:layout_width="wrap_content"
    android:layout_height="match_parent"
    android:imeOptions="flagNoExtractUi|flagNoFullscreen|actionSend" />
```

# 二、打开/关闭
## 1、打开输入法窗口
```
InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
imm.showSoftInput(editText, InputMethodManager.SHOW_FORCED);
```

## 2、关闭输入法窗口
```
InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
imm.hideSoftInputFromWindow(editText.getWindowToken(),
InputMethodManager.HIDE_NOT_ALWAYS);
```


## 3、如果输入法打开则关闭，如果没打开则打开
```
InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
imm.toggleSoftInput(0, InputMethodManager.HIDE_NOT_ALWAYS);
```


## 4、获取输入法打开的状态
```
InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
boolean status = imm.isActive();//true：open；false：close
```