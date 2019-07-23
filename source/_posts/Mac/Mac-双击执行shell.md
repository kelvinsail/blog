title: Mac 双击执行shell
author: yifan
tags:
  - Mac
  - Shell
  - 双击执行Shell
categories:
  - Mac
  - ''
  - Shell
  - ''
date: 2019-07-21 10:59:00
---

- 1）创建shell脚本

```
vim hello.sh
```

- 2）写入命令，并保存

```
#!/bin/bash

echo 'hello mac shell'
```
<!-- more -->
- 3）设置权限
```
chmod a+x hello.sh
```

- 4）设置打开方式
 - 右键hello.sh，选择【打开方式】-【其他】
 - 启用：选择【所有的应用程序】
 - 勾选【始终以此方式打开】
 - 选择【终端.app】
 - 点击【打开】