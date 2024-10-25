---
title: Mac一键解密xlog文件
tags:
  - Mac
  - python
  - xlog
categories:
  - Mac
  - python
  - xlog
toc: false
date: 2022-05-07 08:53:08
---


# python2.7
> macOS Monterey已经移除python2.7，即便是操作系统通过升级到最新版本的macOS Monterey以后，也会移除了随系统发行的 Python 2.7，所以如果找不到python2.7，需要重新安装一次。

## 下载安装python2.7
>[https://www.python.org/ftp/python/2.7.18/python-2.7.18-macosx10.9.pkg](https://www.python.org/ftp/python/2.7.18/python-2.7.18-macosx10.9.pkg) 一路一直点下一步安装即可

<!-- more -->
## 安装pip2
- 运行命令
```
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py
python get-pip.py
```

## 安装插件`zstandard`
- 运行`pip install zstandard`

## 安装插件`pyelliptic`
> pyelliptic如果通过pip自动安装，运行脚本时会抛出异常`Couldn’t load OpenSSL lib`，需要手动下载[`pyelliptic 1.5.10`(传送门)](https://github.com/mfranciszkiewicz/pyelliptic/archive/1.5.10.tar.gz#egg=pyelliptic)手动操作：

- 1.解压后，修改源文件中的`pyelliptic-1.5.10/pyelliptic/openssl.py`中的`crypto`引用路径：
```
def find_crypto_lib():
    if sys.platform != 'win32':
       # 注释掉下面路径,写绝对路径
       # return ctypes.util.find_library('crypto')
       return '/usr/lib/libcrypto.dylib'
```
- 2.回到根目录，执行安装
```
python setup.py install
```

## 下载腾讯`mars`开源库
- [mars传送门](https://github.com/Tencent/mars)
- 下载压缩包，解压，提取复制`mars/log`这个文件夹到存放其他目录（别随便放，不能随便删除，不然运行不了python解密）
- `log`文件夹里需要直接调用到的脚本只有`log/crypt/decode_mars_nocrypt_log_file.py`

# 创建自动化脚本

## 获取python全路径
```
$ which python
/usr/bin/python
```

## 创建自动化项目
- 选择`快速操作`
 - 工作流程收到当前选择`文件或文件夹`
 - 位于选择`访达.app`
- 添加`运行Shell脚本`
 - shell选择`/bin/bash`
 - 传递输入选`作为自变量`
 - 添加命令

```
osascript -e 'tell application "Terminal" to do script "/usr/bin/python /全路径/log/crypt/decode_mars_nocrypt_log_file.py '"$@"'" activate'
```
> macOS Monterey上增加限制，无法直接在自动化里运行python脚本，所以通过osascript启动终端运行指令
 - 添加结果输出

# 保存
> 如果执行无反应，可在最后添加随意一句报错代码，看弹窗输出提示
