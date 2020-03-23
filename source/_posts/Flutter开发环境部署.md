---
title: Flutter开发环境部署
tags:
  - Android
  - Flutter
categories:
  - Android
  - Flutter
toc: false
date: 2020-01-10 09:04:45
---

# MacOS
## 一、下载
### 1、官网
[传送门](https://flutter.dev/docs/development/tools/sdk/releases?tab=macos#macos)
### 2、git
```
# git clone -b master https://github.com/flutter/flutter.git

Cloning into 'flutter'...
remote: Enumerating objects: 63, done.
remote: Counting objects: 100% (63/63), done.
remote: Compressing objects: 100% (42/42), done.
remote: Total 212404 (delta 20), reused 39 (delta 12), pack-reused 212341
Receiving objects: 100% (212404/212404), 84.94 MiB | 50.00 KiB/s, done.
Resolving deltas: 100% (162431/162431), done.
cd flutter
flutter --version
```

## 二、设置
### 1、环境变量
- 1、打开
```
vim ~/.bash_profile
```
- 2、添加flutter路径并保存
```
export PATH="$PATH:/Volumes/GALAXY/Android/flutter/bin"
```
- 3、添加Flutter域名，防止`get pub`被墙
 - mac
 ```
 export PUB_HOSTED_URL=https://pub.flutter-io.cn
 export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
 ```
 - windows
 Path中添加：
 ```
 PUB_HOSTED_URL : https://pub.flutter-io.cn
 FLUTTER_STORAGE_BASE_URL : https://storage.flutter-io.cn
 ```
- 4、刷新
```
source ~/.bash_profile
```

### 2、检查、补全设置
```
flutter doctor
```

![image.png](/images/2020/01/10/6ca08920-334d-11ea-a1f9-c98b8da8634c.png)
