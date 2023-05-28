# Bitmap
## 内存
### 缓存策略
- Android2.3.3（api10）及以下，手动调用bitmap对象的recycle()回收内存；

## 方法
- getAllocationByteCount：api19加入，返回一个存储Bitmpa像素信息的内存大小，一般情况下与getByteCount相等，但复用bitmap存储一个比原bitmap要小的图片后，getAllocationByteCount会比getByteCount大
- getByteCount：bitmap所占内存实际大小，即一行像素所占字节大小 * bitmap高度（getRowBytes() * getHeight()）
- getRowBytes

## BitmapFactort.Options
### 属性
- inSampleSize：采样率，默认1表示无缩放，等于2表示宽高缩放2倍，总大小缩小4倍；
- inBitmap：被复用的bitmap；
- inJustDecodeBound： 如果设置为true，不获取图片，不分配内存，但会返回图片的高度宽度信息；
- inMutable：是否图片内容可变，如果Bitmap复用的话，需要设置为true；
- inDensity：加载bitmap时候对应的像素密度；
- inTargetDensity：bitmap位图被真实渲染出的像素密度，对应终端设备的屏幕像素密度；