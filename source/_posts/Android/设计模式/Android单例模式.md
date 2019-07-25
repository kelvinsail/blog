---
title: Android 单例模式
tags:
  - Android
  - 设计模式
  - 单例模式
categories:
  - Android
  - 设计模式
toc: false
author: yifan
date: 2019-07-20 20:54:00
---

# 单例模式

## 一、特点

- 构造函数私有
- 通过静态函数获取实例对象
- 确保任何情况下全局只有一个实例对象
- 反射、反序列化、克隆也不会生成多个实例

## 二、定义

<!-- more -->

> 在某一系统里，某一个类有且只有一个实例对象，能够自行初始化并向全局提供入口。
使用范围最广的设计模式，在这个模式里最大的特点就是唯一性，某个类有且只有一个对象，并通过唯一的静态接口向外提供入口，在全局代码中通过该类的入口调用获取该对象进行使用，使用场景有以下几点：
> - 实例化需要较多的资源，不适合多处声明初始化；
> - 需要全局统一入口,有利于协调系统整体的行为；
> 比如说在项目里引用了`Glide`作为图片加载器，首页列表item需要用到、资讯页item用到，个人页面加载头像也用到，每个需要用到的地方有的统一圆角、有的圆形、占位图也不一致，好不容易写好了，万一UI改了、占位图要换，甚至以后要更换其它图片加载器呢？一个一个地方修改太耗时间，那为何不一开始就将图片加载封装起来，变成一个全局单例的`ImageLoader`。

## 三、实现方式
以往常见的有4种：饿汉模式、懒汉模式、DCL(Double Check Lock)，以及静态内部类
### 1、饿汉模式

```
public class Singleton{

    private static final Singleton mInstance = new Singleton();

    private Singleton(){}

    public static Singleton getInstance(){
        return mInstance;
    }

}
```

### 2、懒汉模式

```
public class Singleton{

    private static  Singleton mInstance;

    private Singleton(){}

    public static Singleton getInstance(){
        if (null == mInstance){
            mInstance = new Singleton();
        }
        return mInstance;
    }

}
```

### 3、DCL双检锁模式

```
public class Singleton{

    private volatile static Singleton mInstance;

    private Singleton(){}

    public static Singleton getInstance(){
        if (null == mInstance){
            synchronized(Singleton.class){
                if ( null == Singleton){
                    mInstance = new Singleton();
                }
            }
        }
        return mInstance;
    }

}
```

> 关于上述四种实现方式的主要以后两者为主，涉及到原子性操作、JDK版本、同步、线程安全等概念，sInstance = new Singleton()并不是原子操作，在底层可以拆分为3步：
> 
> - 1、为Singleton实例对象分配堆内存空间；
> - 2、调用Singleton构造函数，初始化成员字段；
> - 3、将sInstance对象指向分配好的堆内存空间（这时开始就不再是null）；
> 
> 而由于JVM的乱序执行，所以2、3步骤不是严格顺序执行，也有可能先执行3再执行2，而3执行之后mInstance就为非空对象，但此时如果有其他线程访问就会出现异常，不过这只是低概率的事件，JDK1.5版本之后已经得到处理，双检锁模式也可以使用volatile关键字声明mInstance对象，确保单例对象类里每一次使用的对象都是从内存中取出，就可以避免DCL失效的问题，只是这样会造成一些额外的开销；


### 4、静态内部类

```
public class Singleton{

    private Singleton(){}

    public static Singleton getInstance(){
        return SingletonHolder.sInstance;
    }

    public static class SingletonHolder{
        private static final Singleton sInstance = new Singleton();
    }

}
```
> 外部类加载时不会主动先创建内部类，所以第一次加载Singleton类时，不会初始化SingletonHolder类，只有第一次调用getInstance()方法时，SingletonHolder及mInstance会被创建，所以它也是一种懒汉模式，未使用时不耗费资源。

## 四、其他实现方式

### 1、容器实现
```
public class SingletonManager {
    private static Map<String, Object> hashMap = new HashMap<String, Object>();

    public static void addInstance(String key, Object instance) {
        if (!hashMap.containsKey(key)) {
            hashMap.put(key, instance);
        }
    }

    public static Object getInstance(String key) {
        return hashMap.get(key);
    }
}
```
> 相对来说用法简单，甚至可封装成一个单例管理类，在该类的HashMap中管理多个单例对象，但是需要注意的是HashMap并非线程安全，在复杂环境下要注意线程安全；

### 2、枚举类实现

```
/**
 * 接口，申明单例中所需要实现的函数
 */
public interface SingletonImpl{

    void load(String imageUrl);
}

/**
 * 单例实现类，实现SingletonImpl接口
 */
public enum Singleton implements SingletonImpl {

    //对SingletonImpl申明的函数进行实现
    //为什么INSTANCE值需要实现SingletonImpl的函数？
    //从这里也可以看出，在枚举类中的每一个值，其实都是一个对象
    //这也导致了用枚举类会比静态常量实现，要更耗内存
    INSTANCE {
        @Override
        public void load(String imageUrl) {

        }
    };

    public static Singleton getInstance() {
        return INSTANCE;
    }
}
```

> 在java中，枚举类是任何情况下都是线程安全的，并且内部可以声明变量、实现函数，在反序列化的情况下，枚举类不会生成新的实例，但是，枚举类需要知道的是：
> 1、枚举类是一种特殊的类，它和普通的类一样，有自己的成员变量、成员方法、构造器 (只能使用 private 访问修饰符，所以无法从外部调用构造器，构造器只在构造枚举值时被调用)；
> 2、一个 Java 源文件中最多只能有一个 public 类型的枚举类，且该 Java 源文件的名字也必须和该枚举类的类名相同；
> 3、使用 enum 定义的枚举类默认继承了 java.lang.Enum 类，并实现了 java.lang.Seriablizable 和 java.lang.Comparable 两个接口;
> 4、所有的枚举值都是 public static final 的，且非抽象的枚举类不能再派生子类；
> 5、枚举类的所有实例(枚举值)必须在枚举类的第一行显式地列出，否则这个枚举类将永远不能产生实例。列出这些实例(枚举值)时，系统会自动添加 public static final 修饰，无需手动显式添加。
> 6、在Android官方文档中，不建议使用枚举类实现，因为相对于同样的静态常量+注解实现方式，枚举类的内存占用要多得多，但用于单例模式，则不存在同样的对比性；
> 7、上述的除了枚举类型实现之外其他实现方式，需要注意反序列化对单例模式的影响，但枚举类型的特性使得即使反序列化，也不会生成一个新的对象；
> 防止反射攻击的方法
> - 使用一个static标记位，再次实例化时验证值并抛出异常
> - 使用枚举类型方法 

## 五、Android中的单例模式
- 系统服务获取context.getSystemService
 - WindowsManagerService[context.getSystemService(Context.WINDOW_SERVICE)]
 - ActivityManagerService[context.getSystemService(Context.ACTIVITY_SERVICE)]
 - LayoutInflater[context.getSystemService(Context.LAYOUT_INFLATER_SERVICE)]
- Context中的LayoutInflater等服务（实例化之后以HashMap容器方式实现单例，并缓存起来）

## 六、
- 优点
 - 在内存中有且只有一个实例，所以避免对象的重复创建，节省内存开支；
 - 如果是一个创建时需要读取配置、获取较多资源的对象时，还能节省开销，避免对资源的多重访问；
 - 可以作为全局资源或设置的访问点，优化和共享资源访问；
- 缺点
 - 一般没有接口，所以不方便扩展，维护难度大；
 - 生命周期长、容易引起内存泄漏，传递上下文作为参数时需要注意，最好以Application作为context；


<!-- 
静态内部类的优点是：外部类加载时并不需要立即加载内部类，内部类不被加载则不去初始化INSTANCE，故而不占内存。即当SingleTon第一次被加载时，并不需要去加载SingleTonHoler，只有当getInstance()方法第一次被调用时，才会去初始化INSTANCE,第一次调用getInstance()方法会导致虚拟机加载SingleTonHoler类，这种方法不仅能确保线程安全，也能保证单例的唯一性，同时也延迟了单例的实例化。

那么，静态内部类又是如何实现线程安全的呢？首先，我们先了解下类的加载时机。


类加载时机：JAVA虚拟机在有且仅有的5种场景下会对类进行初始化。
1.遇到new、getstatic、setstatic或者invokestatic这4个字节码指令时，对应的java代码场景为：new一个关键字或者一个实例化对象时、读取或设置一个静态字段时(final修饰、已在编译期把结果放入常量池的除外)、调用一个类的静态方法时。
2.使用java.lang.reflect包的方法对类进行反射调用的时候，如果类没进行初始化，需要先调用其初始化方法进行初始化。
3.当初始化一个类时，如果其父类还未进行初始化，会先触发其父类的初始化。
4.当虚拟机启动时，用户需要指定一个要执行的主类(包含main()方法的类)，虚拟机会先初始化这个类。
5.当使用JDK 1.7等动态语言支持时，如果一个java.lang.invoke.MethodHandle实例最后的解析结果REF_getStatic、REF_putStatic、REF_invokeStatic的方法句柄，并且这个方法句柄所对应的类没有进行过初始化，则需要先触发其初始化。
这5种情况被称为是类的主动引用，注意，这里《虚拟机规范》中使用的限定词是"有且仅有"，那么，除此之外的所有引用类都不会对类进行初始化，称为被动引用。静态内部类就属于被动引用的行列。

我们再回头看下getInstance()方法，调用的是SingleTonHoler.INSTANCE，取的是SingleTonHoler里的INSTANCE对象，跟上面那个DCL方法不同的是，getInstance()方法并没有多次去new对象，故不管多少个线程去调用getInstance()方法，取的都是同一个INSTANCE对象，而不用去重新创建。当getInstance()方法被调用时，SingleTonHoler才在SingleTon的运行时常量池里，把符号引用替换为直接引用，这时静态对象INSTANCE也真正被创建，然后再被getInstance()方法返回出去，这点同饿汉模式。那么INSTANCE在创建过程中又是如何保证线程安全的呢？在《深入理解JAVA虚拟机》中，有这么一句话:

 虚拟机会保证一个类的<clinit>()方法在多线程环境中被正确地加锁、同步，如果多个线程同时去初始化一个类，那么只会有一个线程去执行这个类的<clinit>()方法，其他线程都需要阻塞等待，直到活动线程执行<clinit>()方法完毕。如果在一个类的<clinit>()方法中有耗时很长的操作，就可能造成多个进程阻塞(需要注意的是，其他线程虽然会被阻塞，但如果执行<clinit>()方法后，其他线程唤醒之后不会再次进入<clinit>()方法。同一个加载器下，一个类型只会初始化一次。)，在实际应用中，这种阻塞往往是很隐蔽的。

故而，可以看出INSTANCE在创建过程中是线程安全的，所以说静态内部类形式的单例可保证线程安全，也能保证单例的唯一性，同时也延迟了单例的实例化。

那么，是不是可以说静态内部类单例就是最完美的单例模式了呢？其实不然，静态内部类也有着一个致命的缺点，就是传参的问题，由于是静态内部类的形式去创建单例的，故外部无法传递参数进去，例如Context这种参数，所以，我们创建单例时，可以在静态内部类与DCL模式里自己斟酌。
-->