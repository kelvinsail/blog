# Bitmap
## 内存
### 缓存策略
- Android2.3.3（api10）及以下，手动调用bitmap对象的recycle()回收内存；

### 计算
- 格式：ARGB_8888、ARGB_4444、RGB_565、ALPHA_8
    > 四种类型为bitmap在内存中存在的四种色彩的存储模式，他们本质区别体现在每种模式下的bitmap内部的每个像素点，在内存中的大小和组成成分的区别。A->alpha（透明度）,R->red（红色）,G->green（绿色），B->blue（蓝色）

- 每种模式下的一个像素的具体存储大小：
    - ARGB_8888：（1像素占 4 byte）
        - A->8bit->一个字节，R->8bit->一个字节，G->8bit->一个字节，B->8bit->一个字节，即8888，一个像素总共占四个字节，8+8+8+8=32bit=4byte
    - ARGB_4444：（1像素占 2 byte）
        - A->4bit->半个字节，R->4bit->半个字节，G->4bit->半个字节，B->4bit->半个字节，即4444，一个像素总共占两个字节，4+4+4+4=16bit=2byte
    - RGB_565：（1像素占 2 byte）
        - R->5bit->半个字节，G->6bit->半个字节，B->5bit->半个字节，即565，一个像素总共占两个字节，5+6+5=16bit=2byte
    - ALPHA_8：（1像素占 1 byte）
        - A->8bit->一个字节，即8，一个像素总共占一个字节，8=8bit=1byte
- 计算大小方式：
> 一张bitmap的大小 = 有多少个像素点 * 每个像素点内存中占用的大小 = 长 * 宽 * 3中讲的各种模式下对应的像素点占用的比特位
例子：计算一张长宽为1000/1000，ARGB_8888格式的一张bitmap的大小：
1000 * 1000 * 4byte = 4000kb = 4M

## 方法
- getByteCount：API 12加入，bitmap所占内存实际大小，即一行像素所占字节大小 * bitmap高度（getRowBytes() * getHeight()）
- getAllocationByteCount：API 19加入，返回一个存储Bitmpa像素信息的内存大小，一般情况下与getByteCount相等，但复用bitmap存储一个比原bitmap要小的图片后，getAllocationByteCount会比getByteCount大；
- getRowBytes：每一行的像素所占内存大小，`bitmap.getRowBytes() * bitmap.getHeight()`即bitmap总大小

## BitmapFactort.Options
### 属性
- inSampleSize：采样率，默认1表示无缩放，等于2表示宽高缩放2倍，总大小缩小4倍；
- inBitmap：被复用的bitmap；
- inJustDecodeBound： 如果设置为true，不获取图片，不分配内存，但会返回图片的高度宽度信息；
- inMutable：是否图片内容可变，如果Bitmap复用的话，需要设置为true；
- inDensity：加载bitmap时候对应的像素密度；
- inTargetDensity：bitmap位图被真实渲染出的像素密度，对应终端设备的屏幕像素密度；