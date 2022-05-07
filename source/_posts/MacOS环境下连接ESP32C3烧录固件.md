---
title: MacOS环境下连接ESP32C3烧录固件
tags:
  - Mac
  - ESP32C3
categories:
  - ESP32C3
  - Mac
toc: false
date: 2022-03-23 21:00:53
---

# 准备
## 环境
- 系统
  - MacOS Big Sur 11.6 (M1)
- python
  - Python 3.8.9 (系统自带)
- pip
  - pip 22.0.4 from /Users/wuyifan/Library/Python/3.8/lib/python/site-packages/pip (python 3.8)

<!-- more -->
## 安装esptool
- 升级pip
  - 命令：`pip3 install --upgrade pip`
- 安装esptool
  - 命令：`pip3 install esptool`

> 安装成功输出
```
wuyifan@wuyifandeMac-mini ~ % pip3 install esptool       
Defaulting to user installation because normal site-packages is not writeable
Collecting esptool
  Using cached esptool-3.2-py3-none-any.whl
Collecting bitstring>=3.1.6
  Using cached bitstring-3.1.9-py3-none-any.whl (38 kB)
Collecting ecdsa>=0.16.0
  Using cached ecdsa-0.17.0-py2.py3-none-any.whl (119 kB)
Collecting cryptography>=2.1.4
  Downloading cryptography-36.0.2-cp36-abi3-macosx_10_10_universal2.whl (4.7 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4.7/4.7 MB 8.2 MB/s eta 0:00:00
Collecting pyserial>=3.0
  Using cached pyserial-3.5-py2.py3-none-any.whl (90 kB)
Collecting reedsolo<=1.5.4,>=1.5.3
  Using cached reedsolo-1.5.4-py3-none-any.whl
Collecting cffi>=1.12
  Using cached cffi-1.15.0.tar.gz (484 kB)
  Preparing metadata (setup.py) ... done
Requirement already satisfied: six>=1.9.0 in /Applications/Xcode.app/Contents/Developer/Library/Frameworks/Python3.framework/Versions/3.8/lib/python3.8/site-packages (from ecdsa>=0.16.0->esptool) (1.15.0)
Collecting pycparser
  Using cached pycparser-2.21-py2.py3-none-any.whl (118 kB)
Building wheels for collected packages: cffi
  Building wheel for cffi (setup.py) ... done
  Created wheel for cffi: filename=cffi-1.15.0-cp38-cp38-macosx_10_14_arm64.whl size=258917 sha256=a1fe2c35aefcbc23d293f564a8b5c5e65987081a4fc0ae0d4d1a73afe6342965
  Stored in directory: /Users/wuyifan/Library/Caches/pip/wheels/a4/cb/1a/277a076c4434fadc0707a37ba48587dc2ac6397d517c3b9de7
Successfully built cffi
Installing collected packages: reedsolo, pyserial, bitstring, pycparser, ecdsa, cffi, cryptography, esptool
  WARNING: The scripts pyserial-miniterm and pyserial-ports are installed in '/Users/wuyifan/Library/Python/3.8/bin' which is not on PATH.
  Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
Successfully installed bitstring-3.1.9 cffi-1.15.0 cryptography-36.0.2 ecdsa-0.17.0 esptool-3.2 pycparser-2.21 pyserial-3.5 reedsolo-1.5.44
```


# 烧录

## 获取设备usb端口
> 设备连接成功之后会在`/dev/`目录下生成对应端口号名称的文件，可通过`ls /dev/`对比设备连接前后输出来查找端口号
```
wuyifan@wuyifandeMac-mini ~ % ls /dev/
aes_0		
afsc_type5	
apfs-raw-device.2.0	
auditpipe			
auditsessions			
autofs				
autofs_control			
autofs_homedirmounter		
autofs_notrigger		
autofs_nowait				
bpf0				
bpf1				
bpf2				
bpf3				
console				
cu.Bluetooth-Incoming-Port
cu.HAVITG1-SerialPort		
cu.SamsungUFlex2310-Serial	
cu.debug-console	
cu.usbserial-220 <----- 就是这个，不同设备不同usb口端口号不一样，注意最好用usb线直接连接主机，否则电压不足有可能无法正常烧录
cu.wlan-debug		
disk0				
disk0s1				
disk0s2				
disk1	
··· 后面省略
```

## 获取`esptool.py`路径
```
wuyifan@wuyifandeMac-mini ~ % python3
Python 3.8.9 (default, Oct 26 2021, 07:25:53) 
[Clang 13.0.0 (clang-1300.0.29.30)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> import esptool
>>> esptool
<module 'esptool' from '/Users/wuyifan/Library/Python/3.8/lib/python/site-packages/esptool.py'>
>>> exit()
```

## 开始烧录
- 命令`sudo python3 esptool.py --chip <型号> --port <你的端口号> write_flash -z  0x1000 <你的固件的完整路径> `
- 注意：
  - 此处命令、文件需要用全路径，否则有可能提示`command not found`
  - `--chip `后面带芯片型号，此处应填`esp32c3` 
- 烧录成功命令输出
```
wuyifan@wuyifandeMac-mini ~ % sudo python3 /Users/wuyifan/Library/Python/3.8/lib/python/site-packages/esptool.py --chip esp32c3 --port /dev/cu.usbserial-220  write_flash -z  0x20000 /Users/wuyifan/Downloads/general_uart_diming_switch_20220318.bin
Password:
esptool.py v3.2
Serial port /dev/cu.usbserial-220
Connecting...
Chip is ESP32-C3 (revision 3)
Features: Wi-Fi
Crystal is 40MHz
MAC: 34:b4:72:4a:8b:dc
Uploading stub...
Running stub...
Stub running...
Configuring flash size...
Flash will be erased from 0x00020000 to 0x00185fff...
Compressed 1463568 bytes to 774546...
Wrote 1463568 bytes (774546 compressed) at 0x00020000 in 75.6 seconds (effective 154.9 kbit/s)...
Hash of data verified.
Leaving...
Hard resetting via RTS pin...
```