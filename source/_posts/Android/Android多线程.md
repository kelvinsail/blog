title: Android多线程
author: yifan
tags:
  - Android
  - 多线程
categories:
  - Android
  - 多线程
date: 2019-07-11 18:48:00
---
# 多线程特性
- 原子性
- 可见性
- 有序性
# 线程安全
- 执行控制
- 内存可见

# 实现方式
## 实现Runnable
- 定义`Runnable`接口的实现类，并重写该类的`run()`方法，该方法将作为线程的执行体；
- 创建该`Runnable`类的实例，并将该实例对象作为`Thread`类的`target`来创建`Thread`实例，该对象是线程真正的执行者；
- 调用线程对象的`start()`方法来执行线程；
<!-- more -->
```
    public void startThread() {
        new Thread(new TestRun()).start();
    }

    private static class TestRun implements Runnable {
        @Override
        public void run() {
            Log.e("TestRun", "run: strat");
        }
    }
```
## 继承Thread
- 定义`Thread`的子类，并重写该类的`run()`方法，该方法将作为线程的执行体，处理真正的任务；
- 创建`Thread`实例对象，调用线程对象的`start()`方法来执行线程；
```
    public void startThread() {
        new TestThread().start();
    }

    private static class TestThread extends Thread {

        @Override
        public void run() {
            super.run();
            Log.e(TestThread.class.getName(), "run: strat");
        }
    }
```

## FutureTask+Callable
- 创建`Callable`接口的实现类，并重写`call()`方法，该方法将作为线程的执行体，并且具有返回值；
- 创建`Callable`实现类的实例，并使用`FutureTask`类来包装`Callable`对象并实例化，该`FutureTask`对象封装了`Callable`对象的`call()`方法的返回值；
- 使用该`FutureTask`对象作为`Thread`的`target`来创建线程实例并启动；
- 调用`FutureTask`的`get()`方法来获取执行结果的返回值，该方法会自动阻塞直到线程执行完毕；
```
    public void startThread() {
		FutureTask task = new FutureTask<String>(new TestCall());
        new Thread(task).start();

        try {
            Log.i("TestCall", "FutureTask: " + task.get());
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
	private static class TestCall implements Callable<String> {

        @Override
        public String call() throws Exception {
            return "run: completed !";
        }
    }
```
## AsyncTask
> 实质上是`FutureTask`及线程池的封装类，并发、核心线程数、最大任务数依照各个版本而定，有所区别；
- 创建`AsyncTask`的子类，并重写其中的`doInBackground()`方法，该方法将作为线程的执行体；
- 调用`AsyncTask`实例的`excute()`方法，启动线程；

```
    public void startThread() {
        new TestAsyncTask().execute();
    }
	
    private static class TestAsyncTask extends AsyncTask<String, Integer, String> {

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            Log.i(TestAsyncTask.class.getName(), "onPreExecute: before start");
        }

        @Override
        protected String doInBackground(String... strings) {
            return "success";
        }

        @Override
        protected void onPostExecute(String result) {
            super.onPostExecute(result);
            Log.i(TestAsyncTask.class.getName(), "onPostExecute: " + result);
        }
    }
```

## IntentService
> Service的子类，封装了Loop+Handler，可作为处理异步任务使用的Service类；其中通过`startService(intent)`方式启动，同个IntentService传入多个intent，会依照传入顺序依次执行任务，执行完毕之后会自动结束Service，无需调用`stopSelf`；
- 创建`IntentService`的子类，并重写构造函数、`onHandleIntent()`函数，并在`onHandleIntent()`中实现耗时操作；
- 注册IntentService子类，`<service android:name=".TestIntentService"/>`
- 调用`startService(intent)`启动线程；

```
    public void startThread() {
        Intent intent = new Intent(this,TestIntentService.class);
        startService(intent);
    }

    public class TestIntentService extends IntentService {

        public TestIntentService() {
            super("TestIntentService");
        }
		
        public TestIntentService(String name) {
            super("TestIntentService");
        }

        @Override
        public void onStart(@Nullable Intent intent, int startId) {
            super.onStart(intent, startId);
            Log.i(TestIntentService.class.getName(), "onStart: ");
        }

        @Override
        protected void onHandleIntent(@Nullable Intent intent) {
            Log.i(TestIntentService.class.getName(), "onHandleIntent: ");
        }

        @Nullable
        @Override
        public IBinder onBind(Intent intent) {
            Log.i(TestIntentService.class.getName(), "onBind: ");
            return super.onBind(intent);
        }

        @Override
        public int onStartCommand(@Nullable Intent intent, int flags, int startId) {
            Log.i(TestIntentService.class.getName(), "onStartCommand: ");
            return super.onStartCommand(intent, flags, startId);
        }

        @Override
        public void onCreate() {
            super.onCreate();
            Log.i(TestIntentService.class.getName(), "onCreate: ");
        }

        @Override
        public void onDestroy() {
            super.onDestroy();
            Log.i(TestIntentService.class.getName(), "onDestroy: ");
        }
    }
```

- 执行后输出结果如下
```
onCreate: 
onStartCommand: 
onStart: 
onHandleIntent: 
onDestroy: 
```

# 线程池
## 基本类型
### CacheThreadPool
> 一个缓存线程池，加入新任务时，如果缓存线程池中有可复用的闲置线程，则取出进行复用，如果没有线程可以复用，则创建一个新的线程来执行任务并加入线程池里；而当线程池中有线程闲置超过60s，会被终止并移除，所长时间闲置的缓存线程池不会耗费多余资源；

### FixThreadPool
> 一个固定核心线程数的线程池，加入新的任务时，如果该任务实例不存在于线程池中，且该线程池核心线程数未达到上限，则会创建一个新的线程来执行任务；如果当前核心线程数已满，则新任务会被加入等待序列中，直到线程池中有任务执行完毕后，复用闲置线程来执行当前来执行下一个任务；当任务数小于核心线程数时，任务执行完毕之后处于闲置的线程不会被销毁，会等待被复用，并且IDLE为10s，不会超时；

### SingleThreadPool
> 一个核心线程数、最大线程数均为1的线程池，与FixThreadPool有同样的底层队列实现方式，如果当前线程在执行过程中被突然中断销毁，会自动创建一个新的线程继续执行下一个任务，保证线程池中始终有一个线程，并在当前任务执行完毕之后开始下一个任务，该线程池保证等待队列中的任务按顺序执行；

### ScheduledThreadPool
> 一个固定核心线程数大小的线程池，与FixThreadPool类似，但最大线程数为Integer.MAX_VALUE，并且是一个计划线程池，任务可以定时、周期性执行；Java与Android中有所不同，Java中的ScheduledThreadPool的IDLE为0s，一旦任务结束就会被
回收等待复用或者被销毁，但在Android中，IDLE为10ms；

## ThreadPoolExecutor

- 构造函数

```
public class ThreadPoolExecutor extends AbstractExecutorService {
    .....
    public ThreadPoolExecutor(int corePoolSize,int maximumPoolSize,long keepAliveTime,TimeUnit unit,
            BlockingQueue<Runnable> workQueue);
 
    public ThreadPoolExecutor(int corePoolSize,int maximumPoolSize,long keepAliveTime,TimeUnit unit,
            BlockingQueue<Runnable> workQueue,ThreadFactory threadFactory);
 
    public ThreadPoolExecutor(int corePoolSize,int maximumPoolSize,long keepAliveTime,TimeUnit unit,
            BlockingQueue<Runnable> workQueue,RejectedExecutionHandler handler);
 
    public ThreadPoolExecutor(int corePoolSize,int maximumPoolSize,long keepAliveTime,TimeUnit unit,
        BlockingQueue<Runnable> workQueue,ThreadFactory threadFactory,RejectedExecutionHandler handler);
    ...
}
```

- 参数定义
 - int corePoolSize：核心线程数
 - int maximumPoolSize：线程池最大任务数
 - long keepAliveTime：线程闲置存活时间
 - TimeUnit unit：时间单位
 - BlockingQueue<Runnable> workQueue：任务等待队列
 - ThreadFactory threadFactory：线程工厂类
 - RejectedExecutionHandler handle：拒绝策略

# 中断线程
## 定义
- 是否真的调用api之后线程就退出？
 - 并不是，thread、asynctask都是通过标记、结束睡眠，而非立即结束线程任务；
## 方式 
- Thread.interrupt()
 - 如果调用了该api，并且线程执行体里的耗时操作中执行了Thread.sleep，线程会
抛出异常并结束睡眠；
 - 如果调用了该api，线程中耗时操作没有执行睡眠，也没有判断是否需要中断，则会继续执行任务直到结束；
- AsyncTask.cancel()
 - 基本与interrupt类似

# 线程同步（执行控制&内存可见性）
## Synchronized
- 对象锁
> 1） 当两个或者多个并发线程同时访问一个object中的synchronized(this)同步代码块时，一个时间内只能有一个线程得到执行，其他线程必须要等到当前线程执行完这个代码块之后才能继续执行该代码块。
> 2） 然而，当一个线程访问object中的synchronized(this)同步代码块时，其他线程仍然可以调用object中的其它非synchronized(this)同步代码块。
> 3） 尤其关键的是，当一个线程访问object中的一个synchronized(this)同步代码块>时，其他线程对于object中的其它synchronized(this)同步代码块的访问，都将被阻塞。
> 4） 第3条中的说明同样适用于其它同步代码块，也就是说，当一个线程访问object中的一个synchronized(this)同步代码块时，它就获得了整个object的对象锁，因此，其他所有线程对于object的所有同步代码块的访问都将被暂时阻塞，直至当前线程执行完这个代码块。
> 5） 上述的规则对于其他对象锁也同样适用。
- 

## Volatie
- 作用于变量，仅能保证基本类型的单次读写操作的原子性，不能保证复杂操作（例如i++）的原子性；
- 实现原理为内存屏障；
- 适用于一写多读的情况；

## 区别
- volatile仅能使用在变量级别；  synchronized则可以使用在变量、方法、和类级别；
- volatile仅能实现变量的修改可见性，并不能保证原子性；synchronized则可以保证变量的修改可见性和原子性；
- volatile不会造成线程的阻塞； synchronized可能会造成线程的阻塞；
- volatile标记的变量不会被编译器优化；synchronized标记的变量可以被编译器优化；
