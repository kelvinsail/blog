---
title: Android备忘
tags:
  - Android
categories:
  - Android
toc: false
date: 2019-07-22 10:45:14
---

# 字符
## 1、常用转义字符
> 转义字符均以`&`开始，以`;`结尾

<!-- more -->

|字符|HTML转义|ASII转义|
|---|---|---|
| 空格|&nbsp；|&#160；|
|< 小于号|&lt；|&#60；|
|> 大于号|&gt；|&#62；|
|& 与号|&amp；|&#38；|
|" 引号|&quot；|&#34；|
|‘ 撇号|&apos；|&#39；|
|× 乘号|&times；|&#215；|
|÷ 除号|&divide；|&#247；|

# AndroidQ 适配
## 1、网络
### 提示
- 方法一：添加网络安全配置
 - 创建配置文件`res/xml/network_security_config.xml`
```
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">Your URL(ex: 127.0.0.1)</domain>
    </domain-config>
</network-security-config>
```
 - AndroidManifest.xml设定安全配置文件路径
 ```
 <?xml version="1.0" encoding="utf-8"?>
 <manifest ...>
     <uses-permission android:name="android.permission.INTERNET" />
     <application
         ...
         android:networkSecurityConfig="@xml/network_security_config"
         ...>
         ...
     </application>
 </manifest>
 ```

- 方法二、关闭网络安全限制
 - AndroidManifest.xml添加`android:usesCleartextTraffic`
 ```
 <?xml version="1.0" encoding="utf-8"?>
 <manifest ...>
     <uses-permission android:name="android.permission.INTERNET" />
     <application
         ...
         android:usesCleartextTraffic="true"
         ...>
         ...
     </application>
 </manifest>
 ```

# 配置问题
## 1、提示“License for package Android SDK Build-Tools 28.0.2 not accepted.”
- 运行命令
```
cd ~/Library/Android/sdk/tools/bin
./sdkmanager --licenses

```
- 根据提示，输入y

## Android Studio
### Android Studio 3.5 xml代码格式化错乱问题
- 打开任意xml文件
- 快键键打开代码格式化选项弹窗
  - Windows: ctrl + shift + alt + l 
  - macOS: command + shift+ option + L
- 取消勾选"Rerange code"

### win控制台中文错乱问题
- 打开`Help` -> `Edit Custom VM Options` 
- 添加`-Dfile.encoding=UTF-8`，重启AS

### 无法调试断点
- `File` -> `Setting` -> `Plugins`  -> 移除`Android NDK Support`勾选

### win平台sdkmanager提示`Failed to download any source lists!`
如果开了代理，需要设置下代理端口号
执行`sdkmanager --list --verbose --no_https --proxy=http --proxy_host=127.0.0.1 --proxy_port=端口号`
