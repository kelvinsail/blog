---
title: Android Studio 热键、快捷方法
tags:
  - Android
  - Android Studio
categories:
  - Android
  - Android Studio
toc: false
date: 2019-09-10 16:10:59
---

# 快捷方法
## 语法
```
<templateSet group="yifan">
  <template name="psi" value="public static final int $name$ = $value$;" description="" toReformat="false" toShortenFQNames="true">
    <variable name="name" expression="" defaultValue="" alwaysStopAt="true" />
    <variable name="value" expression="" defaultValue="" alwaysStopAt="true" />
    <context>
      <option name="JAVA_CODE" value="true" />
    </context>
  </template>
</templateSet>
```
## 元素节点
- 模板集合
 - 元素`templateSet`：作为根元素节点，定义一个模板集合
 - 属性`group`：定义集合名称
- 模板内容
 - 元素`template`：定义一个模板
 - 属性`name`：定义模板名称
 - 属性`value`：定义模板内容，可以通过双`$`引用变量，例如：`$name$`
 - 属性`description`：模板描述
- 定义变量
 - 元素`variable`：定义一个自定义变量
 - 属性`name`：变量名，作为内容引用时的名称
 - 属性`expression`：表达式->具体参考[连接](https://www.jetbrains.com/help/idea/2016.1/live-template-variables.html)
 - 属性`defaultValue`：默认值
 - 属性`alwaysStopAt`：光标停留？
- 常用表达式
 - user()：当前计算机的用户名
 - date()：当前时间
 - methodName()：当前方法名
 - methodParameters()：当前方法的输入参数
 - methodReturnType()：当前方法的返回值类型
 - className()：当前类的类名
 - classNameComplete()：当前类的完整类名
- 定义语言
 - 语法：`<context><option name="【类型】" value="true"></context>`
 - Java类型：`JAVA_CODE`
 - Kotlin类型： `KOTLIN_STATEMENT`


## 编辑
### Android Studio
- 位置：设置窗口->Editor->Live Templates
![upload successful](/images/pasted-100.png)
### 加入自定义模板
- 模板文件夹位置
 - Windows: <your_user_home_directory>.IntelliJ 
 - IDEA<version_number>\config\templates
 - Linux: ~IntelliJ IDEA/config/templates
 - macOS(IDEA): ~/Library/Preferences/IntelliJ IDEA/templates
 - macOS(Android Studio):~/Library/Preferences/AndroidStudio【版本号】/templates

# Kotlin
## 为kotlin添加log快捷方法

> 如果创建普通的java语言Android项目，输入`logt`、`logi`、`loge`等会自动提示补全，但创建kotlin项目之后，快捷方法输入就不起作用了，如果使用`println()`又没有默认的tag标记，可以通过以下方法进行手动添加log快捷方法输入

- 创建文件夹（如果已有则跳过）

<!-- more -->
- 在创建的文件中添加配置文件（androidLogKotlin.xml）
```
<templateSet group="AndroidLogKotlin">
  <template name="logm" value="android.util.Log.d(TAG, $FORMAT$)" description="Log method name and its arguments" toReformat="true" toShortenFQNames="true">
    <variable name="FORMAT" expression="groovyScript(&quot;def params = _2.collect {it + ' = [$' + it + ']'}.join(', '); return '\&quot;' + _1 + '() called' + (params.empty  ? '' : ' with: ' + params) + '\&quot;'&quot;, kotlinFunctionName(), functionParameters())" defaultValue="" alwaysStopAt="false" />
    <context>
      <option name="KOTLIN_STATEMENT" value="true" />
    </context>
  </template>
  <template name="logd" value="android.util.Log.d(TAG, &quot;$METHOD_NAME$: $content$&quot;)" description="Log.d(String)" toReformat="true" toShortenFQNames="true">
    <variable name="METHOD_NAME" expression="kotlinFunctionName()" defaultValue="" alwaysStopAt="false" />
    <variable name="content" expression="" defaultValue="" alwaysStopAt="true" />
    <context>
      <option name="KOTLIN_STATEMENT" value="true" />
    </context>
  </template>
  <template name="loge" value="android.util.Log.e(TAG, &quot;$METHOD_NAME$: $content$&quot;, $exception$)" description="Log.e(Exception, String)" toReformat="true" toShortenFQNames="true">
    <variable name="METHOD_NAME" expression="kotlinFunctionName()" defaultValue="" alwaysStopAt="false" />
    <variable name="content" expression="" defaultValue="" alwaysStopAt="true" />
    <variable name="exception" expression="" defaultValue="e" alwaysStopAt="true" />
    <context>
      <option name="KOTLIN_STATEMENT" value="true" />
    </context>
  </template>
  <template name="logi" value="android.util.Log.i(TAG, &quot;$METHOD_NAME$: $content$&quot;)" description="Log.i(String)" toReformat="true" toShortenFQNames="true">
    <variable name="METHOD_NAME" expression="kotlinFunctionName()" defaultValue="" alwaysStopAt="false" />
    <variable name="content" expression="" defaultValue="" alwaysStopAt="true" />
    <context>
      <option name="KOTLIN_STATEMENT" value="true" />
    </context>
  </template>
  <template name="logw" value="android.util.Log.w(TAG, &quot;$METHOD_NAME$: $content$&quot;)" description="Log.w(Exception, String)" toReformat="true" toShortenFQNames="true">
    <variable name="METHOD_NAME" expression="kotlinFunctionName()" defaultValue="" alwaysStopAt="false" />
    <variable name="content" expression="" defaultValue="" alwaysStopAt="true" />
    <context>
      <option name="KOTLIN_STATEMENT" value="true" />
    </context>
  </template>
  <template name="logwtf" value="android.util.Log.wtf(TAG, &quot;$METHOD_NAME$: $content$&quot;)" description="Log.wtf(Exception, String)" toReformat="true" toShortenFQNames="true">
    <variable name="METHOD_NAME" expression="kotlinFunctionName()" defaultValue="" alwaysStopAt="false" />
    <variable name="content" expression="" defaultValue="" alwaysStopAt="true" />
    <context>
      <option name="KOTLIN_STATEMENT" value="true" />
    </context>
  </template>
  <template name="logt" value="private const val TAG = &quot;$NAME$&quot;;" description="A static logtag with your current classname" toReformat="true" toShortenFQNames="true">
    <variable name="NAME" expression="fileNameWithoutExtension()" defaultValue="" alwaysStopAt="false" />
    <context>
      <option name="KOTLIN" value="true" />
    </context>
  </template>
</templateSet>
```
- 重启Android Studio
 - 输入`logt`、`logi`、`loge`等会自动提示补全
 ![image.png](/images/2019/07/29/2ccf3d00-b1ca-11e9-85ed-3314eb4e10ac.png)


[参考链接](https://gist.github.com/goodev/b691dd936d558878deb516ebe906e026)