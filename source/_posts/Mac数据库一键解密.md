---
title: Mac数据库一键解密
tags:
  - Android
  - Mac
  - 自动化
  - SQLite解密
categories:
  - Mac
  - Android
  - SQLite解密
  - 自动化
toc: false
date: 2022-02-06 18:14:31
---

# 环境
## 安装brew
```
/bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
source .zprofile
```
## 安装SQLCipher
```
brew install sqlcipher
```

## 获取SQLCipher全路径
```
$ which sqlcipher
/opt/homebrew/bin/sqlcipher
```
# 创建自动化项目
<!-- more -->
- 选择`快速操作`
 - 工作流程收到当前选择`文件或文件夹`
 - 位于选择`访达.app`
- 添加`运行Shell脚本`
 - shell选择`/bin/bash`
 - 传递输入选`作为自变量`
 - 添加命令

```
/opt/homebrew/bin/sqlcipher "$@" -cmd "
PRAGMA key = '密钥';

PRAGMA cipher_page_size = 1024;

PRAGMA kdf_iter = 64000;

PRAGMA cipher_hmac_algorithm = HMAC_SHA1;

PRAGMA cipher_kdf_algorithm = PBKDF2_HMAC_SHA1;

ATTACH DATABASE '$@.decrypted.db' AS plaintext KEY '';

SELECT sqlcipher_export('plaintext');

DETACH DATABASE plaintext;

exit;"

open -a 'DB Browser for SQLite' "$@.decrypted.db"
echo "end"
```
 - 添加结果输出

# 保存
> 如果执行无反应，可在最后添加随意一句报错代码，看弹窗输出提示
