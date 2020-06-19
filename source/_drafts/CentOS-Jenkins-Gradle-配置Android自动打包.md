---
title: CentOS+Jenkins+Gradle 配置Android自动打包
tags: []
categories: []
toc: false
---

# 检查JDK
> 如果jdk是通过yum安装的OpenJDK，则需要卸载之后重新安装，否则编译时会报错
```

* What went wrong:
Execution failed for task ':base:compileDebugJavaWithJavac'.
> Could not find tools.jar. Please check that /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.232.b09-0.el7_7.x86_64/jre contains a valid JDK installation.

* Try:
Run with --stacktrace option to get the stack trace. Run with --info or --debug option to get more log output. Run with --scan to get full insights.

* Get more help at https://help.gradle.org

Deprecated Gradle features were used in this build, making it incompatible with Gradle 6.0.
Use '--warning-mode all' to show the individual deprecation warnings.
See https://docs.gradle.org/5.6.4/userguide/command_line_interface.html#sec:command_line_warnings
```
- 关闭Jenkins
```
# service jenkins stop
Stopping jenkins (via systemctl):                          [  OK  ]
```
- 查看yum已安装的jdk
```
<!-- more -->
# rpm -qa | grep openjdk
java-1.8.0-openjdk-headless-1.8.0.232.b09-0.el7_7.x86_64
java-1.8.0-openjdk-1.8.0.232.b09-0.el7_7.x86_64
```
- 卸载
```
# yum -y remove java-1.8.0-openjdk-headless-1.8.0.232.b09-0.el7_7.x86_64
已加载插件：fastestmirror
正在解决依赖关系
--> 正在检查事务
---> 软件包 java-1.8.0-openjdk-headless.x86_64.1.1.8.0.232.b09-0.el7_7 将被 删除
--> 正在处理依赖关系 java-1.8.0-openjdk-headless(x86-64) = 1:1.8.0.232.b09-0.el7_7，它被软件包 1:java-1.8.0-openjdk-1.8.0.232.b09-0.el7_7.x86_64 需要
--> 正在处理依赖关系 libjava.so()(64bit)，它被软件包 1:java-1.8.0-openjdk-1.8.0.232.b09-0.el7_7.x86_64 需要
--> 正在处理依赖关系 libjava.so(SUNWprivate_1.1)(64bit)，它被软件包 1:java-1.8.0-openjdk-1.8.0.232.b09-0.el7_7.x86_64 需要
--> 正在处理依赖关系 libjvm.so()(64bit)，它被软件包 1:java-1.8.0-openjdk-1.8.0.232.b09-0.el7_7.x86_64 需要
--> 正在处理依赖关系 libjvm.so(SUNWprivate_1.1)(64bit)，它被软件包 1:java-1.8.0-openjdk-1.8.0.232.b09-0.el7_7.x86_64 需要
--> 正在检查事务
---> 软件包 java-1.8.0-openjdk.x86_64.1.1.8.0.232.b09-0.el7_7 将被 删除
--> 解决依赖关系完成

依赖关系解决

================================================================================
 Package                      架构    版本                      源         大小
================================================================================
正在删除:
 java-1.8.0-openjdk-headless  x86_64  1:1.8.0.232.b09-0.el7_7   @updates  107 M
为依赖而移除:
 java-1.8.0-openjdk           x86_64  1:1.8.0.232.b09-0.el7_7   @updates  646 k

事务概要
================================================================================
移除  1 软件包 (+1 依赖软件包)

安装大小：107 M
Downloading packages:
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  正在删除    : 1:java-1.8.0-openjdk-1.8.0.232.b09-0.el7_7.x86_64           1/2 
  正在删除    : 1:java-1.8.0-openjdk-headless-1.8.0.232.b09-0.el7_7.x86_6   2/2 
  验证中      : 1:java-1.8.0-openjdk-headless-1.8.0.232.b09-0.el7_7.x86_6   1/2 
  验证中      : 1:java-1.8.0-openjdk-1.8.0.232.b09-0.el7_7.x86_64           2/2 

删除:
  java-1.8.0-openjdk-headless.x86_64 1:1.8.0.232.b09-0.el7_7                    

作为依赖被删除:
  java-1.8.0-openjdk.x86_64 1:1.8.0.232.b09-0.el7_7                             

完毕！

# yum -y remove java-1.8.0-openjdk-1.8.0.232.b09-0.el7_7.x86_64
已加载插件：fastestmirror
参数 java-1.8.0-openjdk-1.8.0.232.b09-0.el7_7.x86_64 没有匹配
不删除任何软件包
```
- 下载jdk最新的`jdk-8u251-linux-x64.rpm`安装包，上传到服务器 [地址](https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html)
- 执行命令开始安装
```
# chmod 777 jdk-8u251-linux-x64.rpm 
# rpm -ivh jdk-8u251-linux-x64.rpm 
警告：jdk-8u251-linux-x64.rpm: 头V3 RSA/SHA256 Signature, 密钥 ID ec551f03: NOKEY
准备中...                          ################################# [100%]
正在升级/安装...
   1:jdk1.8-2000:1.8.0_251-fcs        ################################# [100%]
Unpacking JAR files...
	tools.jar...
	plugin.jar...
	javaws.jar...
	deploy.jar...
	rt.jar...
	jsse.jar...
	charsets.jar...
	localedata.jar...
```
- 设置环境变量，`vim /etc/profile`，加入java路径
```
export JAVA_HOME=/usr/java/jdk1.8.0_251-amd64/
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH
```
- 刷新变量`source /etc/profile`
- 检查jdk版本
```
# java -version
java version "1.8.0_251"
Java(TM) SE Runtime Environment (build 1.8.0_251-b08)
Java HotSpot(TM) 64-Bit Server VM (build 25.251-b08, mixed mode)
```
# 安装Android SDK Tools
# 安装Gradle
# Jenkins配置

# 异常处理
## 提示SDK协议未接受
```
> Configure project :app
File /var/lib/jenkins/.android/repositories.cfg could not be loaded.
Checking the license for package Android SDK Build-Tools 28.0.3 in /usr/local/android-sdk-linux/licenses
Warning: License for package Android SDK Build-Tools 28.0.3 not accepted.

FAILURE: Build failed with an exception.

* What went wrong:
A problem occurred configuring project ':app'.
> Failed to notify project evaluation listener.
   > Failed to install the following Android SDK packages as some licences have not been accepted.
        build-tools;28.0.3 Android SDK Build-Tools 28.0.3
     To build this project, accept the SDK license agreements and install the missing components using the Android Studio SDK Manager.
     Alternatively, to transfer the license agreements from one workstation to another, see http://d.android.com/r/studio-ui/export-licenses.html
     
     Using Android SDK: /usr/local/android-sdk-linux
   > Must apply 'com.android.application' first!
```

- 下载SDKManager工具
- 运行命令
```
./sdkmanager –licenses –sdk_root=【SDK路径】
```