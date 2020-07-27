---
title: Android Flutter混合开发实现
tags:
  - Android
  - Flutter
categories:
  - Android
  - Flutter
toc: false
---

# 混合开发
> 目前来说作为纯Flutter开发的app较少，基本都是将flutter作为共用的组件来开发、在Android\iOS原生项目中引入进行使用，而且个人感觉Android Studio对Native引用Flutter项目的支持比较好（AS 3.6）

# Android Native中引入Flutter
## 创建项目
- 按照一般流程创建即可，此处用的是androidx项目
<!-- more -->
## 创建flutter_module
```
//加入--androidx是为了创建androidx的flutter项目，不需要则去掉
flutter create --androidx -t module flutter_module
```
> 一般在Native项目的同级目录下创建flutter module，方便其他平台项目引用，命名不要使用单一的`flutter`，在引入flutter module之后，Android Studio会在Native项目下会自动生成一个`Flutter`module

## 引入flutter_module
- `setting.gradle`中添加module依赖
```
setBinding(new Binding([gradle: this]))
evaluate(new File(
	//如果module创建在了Native根目录下，此处的parentFile需要去掉
        settingsDir.parentFile,
        //创建的flutter module名称，如果是他人提供的已实现的module，需要先用AS编译下或运行下`flutter pub get`
        'flutter_module/.android/include_flutter.groovy'
))
```
- `app/build.gradle`引用`flutter`
```
android {
    //....省略
    defaultConfig {
	//...

	//minSdkVersion需要保证大于16
        minSdkVersion 21
    }

    compileOptions {
	//使用java1.8来编译
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

}

dependencies {
    //....省略

    //注意此处引用的是`flutter`，即Native项目自动生成的module
    //而不是import的`flutter module`
    implementation project(':flutter')
}
```

## 使用
### Fragment
```
val transaction = supportFragmentManager.beginTransaction()
transaction.replace(
    android.R.id.content,
    //flutter 1.12之后，Flutter类弃用
    //Flutter.initialRoute("initialRoute").build()
    FlutterFragment.withNewEngine().initialRoute("initialRoute").build()
)
transaction.commit()
```
### Activity
> 需要先把`io.flutter.embedding.android.FlutterActivity`添加至`AndroidManifest`清单中
```
val intent = io.flutter.embedding.android.FlutterActivity.withNewEngine()
    .initialRoute("initialRoute").build(this)
startActivity(intent)
```
### View
> 1.12之后似乎不再建议使用FlutterView来嵌入Native中
```

import android.os.Bundle
import android.util.Log
import android.widget.FrameLayout
import androidx.appcompat.app.AppCompatActivity
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.renderer.FlutterUiDisplayListener

class MainActivity : FlutterActivity() {

    lateinit var flutterEngine: FlutterEngine

    companion object {
        const val TAG = "MainActivity"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        FlutterMain.startInitialization(applicationContext)
        super.onCreate(savedInstanceState)

        val layout = FrameLayout(this)
        setContentView(layout)
        flutterEngine = FlutterEngine(this)
        flutterEngine.navigationChannel.setInitialRoute("initialRoute")
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )

        val flutterView = FlutterView(this)
        val lp = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        )
        flutterView.addOnFirstFrameRenderedListener(object : FlutterUiDisplayListener {
            override fun onFlutterUiNoLongerDisplayed() {
                Log.d(TAG, "onFlutterUiNoLongerDisplayed: ")
            }

            override fun onFlutterUiDisplayed() {
                Log.d(TAG, "onFlutterUiDisplayed: ")
            }
        })
        layout.addView(flutterView, lp)
        flutterView.attachToFlutterEngine(flutterEngine)
    }

    override fun onResume() {
        super.onResume()
        flutterEngine.lifecycleChannel.appIsResumed()
    }

    override fun onPause() {
        super.onPause()
        flutterEngine.lifecycleChannel.appIsPaused()
    }
    
}
```