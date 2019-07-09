title: Android 动画
author: yifan
date: 2019-05-25 22:04:36
tags:
---
# 逐帧动画（Frame Animation）
## 帧动画的特性
- 通过图片生成的动画，类似于GIF动图；
- DrawableAnimation也是指该动画

## 帧动画的优缺点
- 缺点：
 - 动效单一，展示效果依赖于图片资源；
 - 动画需要很多的图片，占用空间大，容易OOM；
- 优点
 - 方便实现；
 
## 代码实现
### xml资源文件
### java代码
---

# 补间动画（Tween Animation）
## 补间动画的特性
- 支持四种类型
 - 平移（Translate）
 - 旋转（Rotate）
 - 缩放（Scale）
 - 不透明度（Alpha）
- 只是展示动画效果，但View的实际位置、状态并未改变。即便View移动到其他地方，点击事件仍在原处才有响应；
- 组合使用步骤较为复杂；
- ViewAnimation也是指该动画；

## 补间动画的优缺点
- 缺点：
 - 当动画执行完毕之后，View的位置、状态并未真正改变，仍保持原样；
- 优点：
 - 一般情况下，相对于逐帧动画，补间动画更为连贯自然；

## 代码实现
### xml资源文件
### java代码

---
# 属性动画（Property Animation）

## 属性动画的特性
- 支持所有View中可改变的属性（即sdk所提供get和set方法的部分属性）
- 更改的是View本身的实际属性，动画执行完毕之后其效果会被保留下载，不会影响其在动画执行之后的使用；
- 不支持API11，需要第三方库兼容（基本可以忽略）

## 属性动画的优缺点
- 缺点：
 - 不兼容API11（可忽略，Android3.0以下的设备基本不需要适配）
- 优点：
 - 容易定制，效果强；

## 代码实现
### xml资源文件
### java代码
---
# 其他动画

## Lottie开源动画库
### 什么是Lottie
- 官网：http://airbnb.io/lottie/#/
- airbnb发布的开源动画库，可通过将AE动画转变为json文件，并在多个平台上直接呈现效果；
- 跨平台，支持：
 - Android（API16+）
 - iOS（ iOS 8+ and MacOS 10.10+）
 - Web
 - Windows
 - React Native

### 代码实现
#### 主要的类
> `LottieAnimationView` 继承了`ImageView`,用于加载展示Lottie动画的默认控件；

> `LottieDrawable`实现了 `LottieAnimationView` 的api的`Drawable`类，可用于配合其他控件展示动画；

> `LottieComposition`用于加载Lottie动画的工具类；
### 支持的加载源
- `src/main/res/raw`中的json动画文件
- `src/main/assets`中的json动画文件
- `src/main/assets`中的zip资源文件
- json或zip文件的`url链接`
- json字符串，可以来自任何源，包括自己的网络堆栈
- json或zip文件的`InputStream`

### 引入类
在项目的`build.gradle`文件中配置:
```
dependencies {
    ...
    implementation "com.airbnb.android:lottie:$lottieVersion"
    ...
}
```

### 直接使用LottieAnimationView
#### XML中使用
- 最简单的使用方式，就是在xml布局文件中直接使用`LottieAnimationView`并通过其属性配置动画。推荐使用`lottie_rawRes`属性及`R`文件来引用静态资源，而不是直接使用文件名，这样方便跟踪动画的加载过程并进行分析。
```
<com.airbnb.lottie.LottieAnimationView
        android:id="@+id/animation_view"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"

        app:lottie_rawRes="@raw/hello_world"
        // or
        app:lottie_fileName="hello_world.json"

        // Loop indefinitely
        app:lottie_loop="true"
        // Start playing as soon as the animation is loaded
        app:lottie_autoPlay="true" />
```
- 支持的xml属性

|属性|功能|
|------|------|
|lottie_fileName|设置播放动画的 json 文件名称|
|lottie_rawRes|设置播放动画的 json 文件资源|
|lottie_autoPlay|设置动画是否自动播放(默认为false)|
|lottie_loop|设置动画是否循环(默认为false)|
|lottie_repeatMode|设置动画的重复模式(默认为restart)|
|lottie_repeatCount|设置动画的重复次数(默认为-1)|
|lottie_cacheStrategy|设置动画的缓存策略(默认为weak)|
|lottie_colorFilter|设置动画的着色颜色(优先级最低)|
|lottie_scale|设置动画的比例(默认为1f)|
|lottie_progress|设置动画的播放进度|
|lottie_imageAssetsFolder|设置动画依赖的图片资源文件地址|

#### java中使用
<!-- // or 
animationView.setAnimation(R.raw.hello_world.json); -->

```
LottieAnimationView animationView = ...

animationView.setAnimation(R.raw.hello_world);
// or from json string
JsonReader jsonReader = new JsonReader(new StringReader(json.toString()));
animationView.setAnimation(jsonReader);

animationView.playAnimation();
```
- java提供的api

|方法|功能|
|------|-------|
|setAnimation(String)|设置播放动画的 json 文件名称
|setAnimation(String, CacheStrategy)|设置播放动画的 json 文件资源和缓存策略
|setAnimation(int)|设置播放动画的 json 文件名称
|setAnimation(int, CacheStrategy)|设置播放动画的 json 文件资源和缓存策略
|loop(boolean)|设置动画是否循环(默认为false)
|setRepeatMode(int)|设置动画的重复模式(默认为restart)
|setRepeatCount(int)|设置动画的重复次数(默认为-1)
|lottie_cacheStrategy|设置动画的缓存策略(默认为weak)
|lottie_colorFilter|设置动画的着色颜色(优先级最低)
|setScale(float)|设置动画的比例(默认为1f)
|setProgress(float)|设置动画的播放进度
|setImageAssetsFolder(String)|设置动画依赖的图片资源文件地址
|playAnimation()|从头开始播放动画
|pauseAnimation()|暂停播放动画
|resumeAnimation()|继续从当前位置播放动画
|cancelAnimation()|取消播放动画
#### 动画缓存
- 所有加载的Lottie动画都默认以`LRU`的方式缓存起来，但默认为`res/raw/`或`assets/`的动画创建`key`，而通过其他API加载的动画，则需要设定一个键值；
- 如果需要激活并展示多次同一个动画时（比如RecycleView列表页），则该动画只会被解析一次，后续的加载请求复用现有的任务（Lottie> = 2.6.0）；
- 设置缓存api
 - 
<!--
All Lottie animations are cached with a LRU cache by default. Default cache keys will be created for animations loaded from res/raw/ or assets/. Other APIs require setting a cache key. If you fire multiple animation requests for the same animation in parallel such as a wishlist heart in a RecyclerView, subsequent requests will join the existing task so it only gets parsed once (Lottie >= 2.6.0).
如果您并行激发同一动画的多个动画请求（例如RecyclerView中的心愿单心脏），则后续请求将加入现有任务，因此它只会被解析一次（Lottie> = 2.6.0）。
你的应用程序中可能会有一些经常使用的动画，比如加载动画等等。为了避免每次加载文件和发序列化的开销，你可以在你的动画上设置一个缓存策略。上面所有的 setAnimation APIs都可以采用可选的第二个参数 CacheStrategy。在默认情况下，Lottie 将保存对动画的弱引用，这对于大多数情况来说应该足够了。但是，如果确定某个动画肯定会经常使用，那么请将其缓存策略更改为 CacheStrategy.Strong；或者如果确定某个动画很大而且不会经常使用，把缓存策略改成 CacheStrategy.None。
CacheStrategy 可以是None、Weak 和 Strong 三种形式来让 LottieAnimationView 对加载和解析动画的使用强或弱引用的方式。弱或强表示缓存中组合的 GC 引用强度。
-->