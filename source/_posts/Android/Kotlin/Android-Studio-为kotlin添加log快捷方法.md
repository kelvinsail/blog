---
title: Android Studio 为kotlin添加log快捷方法
tags:
  - Android
  - Android Studio
categories:
  - Android
  - Android Studio
toc: false
date: 2019-07-29 14:30:14
---

> 如果创建普通的java语言Android项目，输入`logt`、`logi`、`loge`等会自动提示补全，但创建kotlin项目之后，快捷方法输入就不起作用了，如果使用`println()`又没有默认的tag标记，可以通过以下方法进行手动添加log快捷方法输入

- 创建文件夹
```
Windows: <your_user_home_directory>.IntelliJ IDEA<version_number>\config\templates
Linux: ~IntelliJ IDEA/config/templates
macOS(IDEA): ~/Library/Preferences/IntelliJ IDEA/templates
macOS(Android Studio):~/Library/Preferences/AndroidStudio3.4/templates
```

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