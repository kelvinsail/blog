title: Android 关键字
tags: []
originContent: ''
categories: []
toc: false
date: 2019-07-23 11:24:52
---
# synchronized
- 可以修饰代码块、函数；
- 通过加类锁保证线程安全；
- 如果一个类中
 - synchronized修饰了多个函数，则统一时间只有有一个函数被外部执行，其余的都需要等待；
 - synchronized修饰了多个代码块，加锁的对象都是同一个，情况同上；
 - synchronized修饰了多个代码块，加锁的对象不同，根据加锁的对象来判断执行情况及顺序；

# volatile
- 只能修饰变量，不能修饰函数和类；
- 不能保证被修饰对象的完整原子性，只能保证每次使用被修饰的变量都是主内存中取出的最新值；
- 适合一写多读情况下，保证取值的最新；

# transient
- 一旦变量被transient修饰，变量将不再是对象持久化的一部分，该变量内容在序列化后无法获得访问。
- transient关键字只能修饰变量，而不能修饰函数和类。注意，本地变量是不能被transient关键字修饰的。变量如果是用户自定义类变量，则该类需要实现Serializable接口。
- 被transient关键字修饰的变量不再能被序列化，一个静态变量不管是否被transient修饰，均不能被序列化。