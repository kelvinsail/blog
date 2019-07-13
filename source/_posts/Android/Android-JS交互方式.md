title: Android JS交互方式
author: yifan
tags:
  - Android
  - JS交互
  - WebView
categories:
  - Android
date: 2019-07-13 11:03:00
---
- 1.通过schema方式，使用`shouldOverrideUrlLoading`方法对url协议进行解析。这种js的调用方式与ios的一样，使用iframe来调用native代码。
- 2.通过在webview页面里直接注入原生js代码方式，使用addJavascriptInterface方法来实现。
在android里实现如下：
```
class JSInterface {
    @JavascriptInterface //注意这个代码一定要加上
    public String getUserData() {
        return "UserData";
    }
}
webView.addJavascriptInterface(new JSInterface(), "AndroidJS");
```
<!-- more -->
上面的代码就是在页面的window对象里注入了AndroidJS对象。在js里可以直接调用
```
alert(AndroidJS.getUserData()) //UserDate
```
> 要注意的是在Android API17之后，JsInterface实现类需要添加注解`@JavascriptInterface`，否则会失效；
- 3.使用prompt,console.log,alert方式，这三个方法对js里是属性原生的，在android webview这一层是可以重写这三个方法的。一般我们使用prompt，因为这个在js里使用的不多，用来和native通讯副作用比较少。
```
class YouzanWebChromeClient extends WebChromeClient {
    @Override
    public boolean onJsPrompt(WebView view, String url, String message, String defaultValue, JsPromptResult result) {
        // 这里就可以对js的prompt进行处理，通过result返回结果
    }
    @Override
    public boolean onConsoleMessage(ConsoleMessage consoleMessage) {

    }
    @Override
    public boolean onJsAlert(WebView view, String url, String message, JsResult result) {

    }
}
```
Native调用javascript方式
在android里是使用webview的loadUrl进行调用的，如：
```
// 调用js中的JSBridge.trigger方法
webView.loadUrl("javascript:JSBridge.trigger('webviewReady')");
```
