---
title: Adb命令备忘录
tags:
  - Android
  - ADB
categories:
  - Android
  - ADB
toc: false
---

# 签名
## 查看签名
```
keytool -printcert -jarfile <D:\apk\signed.apk>
```

## 重新签名

```
jarsigner -verbose -keystore <签名文件绝对路径> -signedjar <保存apk绝对路径> <待签名的apk绝对路径> <alias别名>
```

> 例如：jarsigner -verbose -keystore D:\apk\sign.jks -signedjar D:\apk\signed.apk D:\apk\unsign.apk 123