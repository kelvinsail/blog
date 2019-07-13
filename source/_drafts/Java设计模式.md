title: Java设计模式
author: yifan
date: 2019-07-12 21:02:28
tags:
---
设计模式.md


# 1. 创建类
## 1）单例模式
### 定义
> 在某一系统里，某一个类有且只有一个实例对象，能够自行初始化并向全局提供入口。
使用范围最广的设计模式，在这个模式里最大的特点就是唯一性，某个类有且只有一个对象，并通过唯一的静态接口向外提供入口，在全局代码中通过该类的入口调用获取该对象进行使用，使用场景有以下几点：
> - 实例化需要较多的资源，不适合多处声明初始化；
> - 需要全局统一入口,有利于协调系统整体的行为；

> 比如说在项目里引用了`Glide`作为图片加载器，首页列表item需要用到、资讯页item用到，个人页面加载头像也用到，每个需要用到的地方有的统一圆角、有的圆形、占位图也不一致，好不容易写好了，万一UI改了、占位图要换，甚至以后要更换其它图片加载器呢？一个一个地方修改太耗时间，那为何不一开始就将图片加载封装起来，变成一个全局单例的`ImageLoader`。

### 实现方式
以往常见的有4种：饿汉模式、懒汉模式、DCL(Double Check Lock)，以及静态内部类
- 饿汉模式

```
public class Singleton{

    private static final Singleton mInstance = new Singleton();

    private Singleton(){}

    public static Singleton getInstance(){
        return mInstance;
    }

}
```

- 懒汉模式

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

- DCL

```
public class Singleton{

    private static  Singleton mInstance;

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

- 静态内部类

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

> 关于上述四种实现方式的主要以后两者为主，涉及到原子性操作、JDK版本、同步、线程安全等概念，sInstance = new Singleton()并不是原子操作，在底层可以拆分为3步：
> 
> - 1、为Singleton实例对象分配内存空间；
> - 2、调用Singleton构造函数，初始化成员字段；
> - 3、将sInstance对象指向分配好的内存空间（这时开始就不再是null）；
> 
> 既然是非原子性，那说明再高并发、多线程的情况下，单例模式的初始化依旧有概率会出现问题，比如线程A、B同时调用单例对象，线程A、B是不是也会同时执行底层3步原子操作？最后A、B线程得到的单例对象是同一个吗？不过这只是低概率的事件，JDK1.5版本之后已经得到处理，也可以使用volatile关键字，确保单例对象类里每一次使用的对象都是从内存中取出，DCL是为了应对这种情况设计的，只是这样会造成额外的开销；


> 所以上述四种方式，以最后一种静态内部类实现最为安全、快捷：

### 其他实现方式

- 容器实现
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

- 枚举类实现

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

## 2）工厂模式（普通工厂，抽象工厂，静态工厂）


## 3）创建者模式
### 定义
> 将一个复杂对象的创建与表示分离，使得同样的构建过程可以创建不同的表示；
### 适用场景
> 
> 1、相同的方法、不同的执行顺序，会产生不用的事件结果；
> 2、多个部件或零件，可以装配到同一个对象中时，可以产生不同的运行结果；
> 3、产品类非常复杂，或产品类中的调用顺序不同产生了不同的作用；
> 4、当初始化一个对象非常复杂，参数很多，每一个位置的参数都有多个可选时；
>
> 理解上与算术公式很像，当公式中，只存在加减乘除的一种，那无论进行多少遍操作，参数前后替换，结果依旧不变，这时候就不适用创建者模式；
>
> 但是当公式中可以同时存在加减乘除的任意组合时，前后操作、参数的变换都可能导致产生不同的结果，这时候就满足第1、2点条件，但是只有加减乘除的算术操作复杂程度仍达不到使用创建者模式的程度，创建者模式再怎样封装，都显得多余，还不如原来的公式简单易懂；
>
> 但如果再加上取整、取余、三角函数等等的操作，当一个操作中某个或多个操作包含复杂的计算，并且可以有几个不同的参数、顺序变化、产生不同结果时，那就满足使用创建者模式的所有条件了；
> 
> 最终，对外隐藏实现过程的具体计算细节，将实现与表示分离开来，通过符号表示该类计算的含义，所以当看到公式时，会知道所代表的复杂计算过程及最终得到结果的含义；

### 实现方式
```
public abstract class Computer{

  public Computer(){}

  public void setBoard(String board){

  }

}
```

## 4）原型模式

# 2.结构类：
## 1）适配器模式
## 2）装饰模式
## 3）代理模式
## 4）外观模式
## 5）组合模式
## 6）桥接模式
## 7）享元模式

# 3.行为类：
## 1）策略模式：
定义一个抽象接口，子类继承并将算法逻辑封装其中，客户端根据需要切换不同的策略得到想要额度结果；

## 2）模版模式：
类似于ListView的BaseAdapter、RecyclerView的Adapter，封装好大部分的视图加载复用逻辑，客户端无需关心这些方法的实现逻辑，继承adapter类的同时复写其中关于具体item布局的相关函数来实现具体的界面即可；

## 3）观察者模式：
一对一、一对多的消息订阅通知模式，当被观察者发生改变时，通知已订阅的观察者发生变化；

## 4）迭代器模式：
类集合、数组中的迭代器，迭代遍历数据；

## 5）责任链模式：
类似于工作流，由多个对象，每个对象都持有下一个对象的引用而形成一条链（或者树、环，形式不规定），请求在这一条链上不断往下传递，但是不清楚哪个对象会处理该请求，而且同时一个请求只能由一个对象传给另一个对象，不能同时传递给多个对象；

## 6）命令模式：
上层发布一个命令，但不关心该命令有谁来执行，但命令中已持有应该执行该命令的对象的引用，一对一、一对多某种关系的解耦？，与观察者模式不同，观察者模式根本属性为订阅通知，而命令模式在于命令解耦；

## 7）备忘录模式：
对象的备份？备份类、对象中的属性、还原，类似于canvas中的save()、restore（）；

## 8）状态模式：
根据不同的状态来执行不同的操作、划分行为等；

## 9）访问者模式：
适用于数据结构相对稳定但又容易发生变化的系统，封装某些作用于某种数据结构中各元素的操作，可以在不改变数据结构的前提下定义、扩展作用于这些元素的操作；

## 10）中介者模式：
二者互为不同的对象但是又有关联，通过一个中介类类解耦避免互相持有引用；（房子、中介、租户之间的关系）

## 11）解释器模式：
封装行为操作，上层不关心该请求的具体过程，但是需要返回所需正确的结果，类似于BigDecimal计算；
