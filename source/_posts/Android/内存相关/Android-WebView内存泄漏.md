title: Android WebView内存泄漏
author: yifan
tags:
  - Android
  - WebView
  - WebView内存泄漏
categories:
  - Android
  - WebView
date: 2019-07-16 08:06:00
---
# WebView内存泄漏
## 原因

webview引起的内存泄漏主要是因为org.chromium.android_webview.AwContents 类中注册了component callbacks，但是未正常反注册而导致的。
org.chromium.android_webview.AwContents 类中有这两个方法 onAttachedToWindow 和 onDetachedFromWindow；系统会在attach和detach处进行注册和反注册component callback；
<!-- more -->
在onDetachedFromWindow() 方法的第一行中：
```
if (isDestroyed()) return;， 
```
如果 isDestroyed() 返回 true 的话，那么后续的逻辑就不能正常走到，所以就不会执行unregister的操作；我们的activity退出的时候，都会主动调用 WebView.destroy() 方法，这会导致 isDestroyed() 返回 true；destroy()的执行时间又在onDetachedFromWindow之前，所以就会导致不能正常进行unregister()。
然后解决方法就是：让onDetachedFromWindow先走，在主动调用destroy()之前，把webview从它的parent上面移除掉。
```
ViewParent parent = mWebView.getParent();
if (parent != null) {
    ((ViewGroup) parent).removeView(mWebView);
}

mWebView.destroy();
```
## 解决方案
完整的activity的onDestroy()方法：
```
@Override
protected void onDestroy() {
    if( mWebView!=null) {
        // 如果先调用destroy()方法，则会命中if (isDestroyed()) return;这一行代码，需要先onDetachedFromWindow()，再destory()
        ViewParent parent = mWebView.getParent();
        if (parent != null) {
            ((ViewGroup) parent).removeView(mWebView);
        }

        mWebView.stopLoading();
        // 退出时调用此方法，移除绑定的服务，否则某些特定系统会报错
        mWebView.getSettings().setJavaScriptEnabled(false);
        mWebView.clearHistory();
        mWebView.clearView();
        mWebView.removeAllViews();
        mWebView.destroy();

    }
    super.on Destroy();
}
```