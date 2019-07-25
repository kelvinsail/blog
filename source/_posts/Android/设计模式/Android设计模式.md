---
title: Android设计模式（未完成）
tags:
  - Android
  - 设计模式
categories:
  - Android
  - 设计模式
toc: false
author: yifan
date: 2019-07-12 21:02:00
---

# 1. 创建类
## 1）单例模式
- 特点
 - 构造函数私有
 - 通过静态函数获取实例对象
 - 确保任何情况下全局只有一个实例对象
 - 反射、反序列化、克隆也不会生成多个实例
- 定义
<!-- more -->
> 在某一系统里，某一个类有且只有一个实例对象，能够自行初始化并向全局提供入口。
使用范围最广的设计模式，在这个模式里最大的特点就是唯一性，某个类有且只有一个对象，并通过唯一的静态接口向外提供入口，在全局代码中通过该类的入口调用获取该对象进行使用，使用场景有以下几点：
> - 实例化需要较多的资源，不适合多处声明初始化；
> - 需要全局统一入口,有利于协调系统整体的行为；
> 比如说在项目里引用了`Glide`作为图片加载器，首页列表item需要用到、资讯页item用到，个人页面加载头像也用到，每个需要用到的地方有的统一圆角、有的圆形、占位图也不一致，好不容易写好了，万一UI改了、占位图要换，甚至以后要更换其它图片加载器呢？一个一个地方修改太耗时间，那为何不一开始就将图片加载封装起来，变成一个全局单例的`ImageLoader`。
- [更多](/2019/07/20/Android/设计模式/Android单例模式)

## 2）工厂模式（普通/简单工厂，抽象工厂，静态工厂）
- 定义
 - 普通工厂：依照依赖倒置原则，将对象的创建过程交给子类，普通工厂则是将对象的生成过程进行封装
 - 抽象工厂


## 3）创建者模式
- 定义
> 将一个复杂对象的创建与表示分离，使得同样的构建过程可以创建不同的表示；
- 适用场景
 - 相同的方法、不同的执行顺序，可能会产生不用的事件结果；
 - 多个部件或零件，可以装配到同一个对象中时，可能产生不同的运行结果；
 - 产品类非常复杂，或产品类中的调用顺序不同产生了不同的作用；
 - 当初始化一个对象非常复杂，参数很多，每一个位置的参数都有多个可选时；

> 理解上与算术公式很像，当公式中，只存在加减乘除的一种，那无论进行多少遍操作，参数前后替换，结果依旧不变，这时候就不适用创建者模式；
>
> 但是当公式中可以同时存在加减乘除的任意组合时，前后操作、参数的变换都可能导致产生不同的结果，这时候就满足第1、2点条件，但是只有加减乘除的算术操作复杂程度仍达不到使用创建者模式的程度，创建者模式再怎样封装，都显得多余，还不如原来的公式简单易懂；
>
> 但如果再加上取整、取余、三角函数等等的操作，当一个操作中某个或多个操作包含复杂的计算，并且可以有几个不同的参数、顺序变化、产生不同结果时，那就满足使用创建者模式的所有条件了；
> 
> 最终，对外隐藏实现过程的具体计算细节，将实现与表示分离开来，通过符号表示该类计算的含义，所以当看到公式时，会知道所代表的复杂计算过程及最终得到结果的含义；

### 实现方式
- 创建一个抽象类Computer，定义参数存放类Params，参考了AlertDialog的写法
```
public abstract class Computer {

    private Pramas mParmas;

    public Computer() {
        mParmas = new Pramas();
    }

    public void setBoard(String board) {
        mParmas.board = board;
    }

    public void setCpu(String cpu) {
        mParmas.cpu = cpu;
    }

    public void setMemory(String memory) {
        mParmas.memory = memory;
    }

    @Override
    public String toString() {
        return getConfigure(Computer.class.getSimpleName());
    }

    public String getConfigure(String model) {
        return new StringBuilder("[").append(model)
                .append(" , board: ").append(mParmas.board)
                .append(" , cpu: ").append(mParmas.cpu)
                .append(" , memory: ").append(mParmas.memory)
                .append("]").toString();
    }

    /**
     * Computer类参数实际存放的类
     */
    public static class Pramas {

        public String board;
        public String cpu;
        public String memory;

        /**
         * 应用参数设置，参考了AlertDialog的写法
         *
         * @param computer
         */
        public void apply(Computer computer) {
            if (null != board) {
                computer.setBoard(board);
            }

            if (null != cpu) {
                computer.setCpu(cpu);
            }

            if (null != memory) {
                computer.setMemory(memory);
            }
        }

    }

}
```
- 创建实际产品类MacBook，隐藏构造函数，避免外部初始化实例；
 - 实现一个静态内部类Builder，即创建者；
 - 创建者的函数使用链式调用，即setter函数都返回自身Builder对象；
```
public class MacBook extends Computer {

    private static final String TAG = "MacBook";

    protected MacBook() {
        Log.i(TAG, "MacBook: ");
    }

    @Override
    public String toString() {
        return getConfigure(MacBook.class.getSimpleName());
    }

    public static class Builder {

        Computer.Pramas params = new Computer.Pramas();

        public Builder() {
        }

        public Builder setBoard(String board) {
            params.board = board;
            return this;
        }

        public Builder setCpu(String cpu) {
            params.cpu = cpu;
            return this;
        }

        public Builder setMemory(String memory) {
            params.memory = memory;
            return this;
        }

        public MacBook create() {
            MacBook macbook = new MacBook();
            params.apply(macbook);
            return macbook;
        }
    }
}
```
- 使用
```
MacBook macBook = new MacBook.Builder()
        .setBoard("Apple")
        .setCpu("INTEL i7")
        .setMemory("16G")
        .create();
```

## 4）原型模式

# 2.结构类：
## 1）适配器模式
> 将一个类的接口A转换为希望的另一个接口B，使得原本由于接口不兼容而无法一起工作的类可以一起工作；

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