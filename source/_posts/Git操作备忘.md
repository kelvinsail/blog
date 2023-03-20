---
title: Git操作备忘
tags:
  - Git
categories:
  - Git
toc: false
date: 2020-07-16 08:55:47
---

# 初始化
## Git 全局设置
```
git config –global user.name “吴一帆”
git config –global user.email “kelvinsail@163.com“
```
<!-- more -->
## 创建一个新存储库
```
git clone http://gitlab.kelvinsail.com/test/test.git
cd petdocuments
touch README.md
git add README.md
git commit -m “add README”
git push -u origin master
```

## 推送现有文件夹

```
cd existing_folder
git init
git remote add origin http://gitlab.kelvinsail.com/test/test.git
git add .
git commit -m “Initial commit”
git push -u origin master
```

## 推送现有的 Git 存储库
```
cd existing_repo
git remote rename origin old-origin
git remote add origin http://gitlab.kelvinsail.com/test/test.git
git push -u origin –all
git push -u origin –tags
```

# 远端
## 更新远端

```
git remote update
```
> 在远端创建新的分支之后，可以再本地更新远端的跟踪，但注意此命令只会新增，不会删除本地已失效的远端跟踪

## 删除失效的远端跟踪
```
# git remote prune       
用法：git remote prune [<选项>] <名称>

    -n, --dry-run         演习
```

- 预览失效的要删除的远端跟踪（假设远端目录为`origin`） 

```
# git remote prune origin --dry-run
修剪 origin
URL：git@e.coding.net:test/test.git
 * [将删除] origin/feature/v10.7
 * [将删除] origin/feature/v10.7.1
 * [将删除] origin/feature/v10.7.2
```

- 直接清理失效的所有远端跟踪

```
# git remote prune origin          
修剪 origin
URL：git@e.coding.net:test/test.git
 * [已删除] origin/feature/v10.7
 * [已删除] origin/feature/v10.7.1
 * [已删除] origin/feature/v10.7.2
```


## 获取信息

- 获取当前git账号名称、email

```
git config user.name && git config user.email
```

- 获取当前项目所在分支名

```
git symbolic-ref --short -q HEAD
```

- 获取当项目前所在分支最新的提交id
```
git rev-parse HEAD
```

- 用`-C`指定项目路径目录输出信息
```
git -C /home/blog symbolic-ref --short -q HEAD
git -C /home/blog rev-parse HEAD
```
