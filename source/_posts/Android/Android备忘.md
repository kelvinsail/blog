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


# 配置问题
## 1、提示“License for package Android SDK Build-Tools 28.0.2 not accepted.”
- 运行命令
```
cd ~/Library/Android/sdk/tools/bin
./sdkmanager --licenses

```
- 根据提示，输入y

