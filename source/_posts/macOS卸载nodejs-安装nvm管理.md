---
title: macOS卸载nodejs 安装nvm管理
tags: []
categories: []
toc: false
date: 2023-03-21 10:09:44
---

# 卸载旧版本
## 查看nodejs版本
```
$ which node
/usr/local/bin/node
```

## 卸载nodejs
```
sudo rm -rf /usr/local/{bin/{node,npm},lib/node_modules/npm,lib/node,share/man/*/node.*}
```
<!-- more -->
# 安装nvm
## 通过brew安装
```
brew update 
brew install nvm
```

## 添加环境变量
```
vim ~/.bash_profile 
```
> 添加
> ```
> export NVM_DIR=~/.nvm
> source $(brew --prefix nvm)/nvm.sh
> ```

## 重新加载
```
source ~/.bash_profile
```

# 重新安装nodejs
## 查看远端版本列表
```
nvm ls-version
nvm install v12.22.12
```