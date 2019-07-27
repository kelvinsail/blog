---
title: Mac 安装zsh
tags:
  - Mac
  - zsh
categories:
  - zsh
  - Mac
toc: false
date: 2019-07-27 09:16:08
---

# 一、安装zsh
- 1、Mac终端默认bash，但其实已经自带zsh，只需运行切换命令，再重新打开终端
```
chsh -s /bin/zsh
```
<!-- more -->

> 开启之后的zsh处于原始状态，基本没有任何配置，虽然很强大，但要一步一步配置自己的zsh耗费时间太多，所以可以安装oh-my-zsh，相当于是一个开源配置包
> 安装了zsh + oh-my-zsh + zsh-autosuggestions之后，mac自带终端已经可以胜任一般的命令行操作或远程操作

# 二、安装oh-my-zsh
- 1、clone项目
```
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh 
```
- 2、备份原有的zshrc文件
```
cp ~/.zshrc ~/.zshrc.bak
```
- 3、替换zshrc文件
```
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
```
- 4、重新打开终端或刷新源文件，即可看到变动
```
source ~/.zshrc
```
# 三、安装插件
## 1、历史提示插件（zsh-autosuggestions）
- 1）clone项目
```
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
```
- 2）配置zshrc
```
vim ~/.zshrc
```
- 3）zshrc添加插件
 - 初始默认的设置为`plugins=(git)`
 - 在git后面添加插件名，改为`plugins=(git zsh-autosuggestions)`
- 4）重新打开终端或刷新源
```
source ~/.zshrc
```