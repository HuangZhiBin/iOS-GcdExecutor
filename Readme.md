# GCD例子
> 以Swift4实现GCD的各种例子
### 1.&nbsp;串行队列(Serial Dispatch Queue)和并行队列(Concurrent Dispatch Queue)
- **串行队列**(Serial Dispatch Queue)同时只能执行一个追加的任务(Block)
- **并行队列**(Concurrent Dispatch Queue)同时执行多个追加的任务(Block)
- 可自行创建串行队列和并行队列

#### DispatchQueueViewController
#### 串行队列
创建串行队列，执行追加的任务
```swift
        let serialQueue = DispatchQueue(label: "com.dianbo.serialQueue");//队列名称的前缀推荐使用应用程序ID,不指定第二个DispatchQueue()参数,创建的queue将默认为serialQueue
        
        serialQueue.async {
            self.log("串行队列中同步执行的第1个任务", Thread.current);
            sleep(4)
        }
        
        serialQueue.async {
            self.log("串行队列中同步执行的第2个任务", Thread.current);
            sleep(2)
        }
        
        serialQueue.async {
            self.log("串行队列中同步执行的第3个任务", Thread.current);
        }
```
- 1.&nbsp;串行队列同时只能执行一个追加处理，先追加的任务会先执行
- 2.&nbsp;执行结果
```swift
串行队列中同步执行的第1个任务: 当前线程的hash为105553118839552
串行队列中同步执行的第2个任务: 当前线程的hash为105553118839552
串行队列中同步执行的第3个任务: 当前线程的hash为105553118839552
```
- 3.&nbsp;可以看到执行顺序一定是1->2->3，并且为同一个线程
#### 并行队列
代码：创建并行队列，执行追加的任务
```swift
        let concurrentQueue = DispatchQueue(label: "com.dianbo.concurrentQueue", attributes: .concurrent)
        
        concurrentQueue.async {
            self.log("并行队列中同步执行的第1个任务", Thread.current);
            sleep(4);
        }
        
        concurrentQueue.async {
            self.log("并行队列中同步执行的第2个任务", Thread.current);
            sleep(2)
        }
        
        concurrentQueue.async {
            self.log("并行队列中同步执行的第3个任务", Thread.current);
        }
```
- 1.&nbsp;并行队列同时执行多个追加的任务
- 2.&nbsp;执行结果
```swift
并行队列中同步执行的第2个任务: 当前线程的hash为106102874632768
并行队列中同步执行的第1个任务: 当前线程的hash为105553118840576
并行队列中同步执行的第3个任务: 当前线程的hash为105553116786816
```
- 3.&nbsp;可以看到执行顺序不定(多次几次),可能是1->2->3，也可能是2->1->3。虽然追加的任务顺序是1->2->3，但在并行队列中，追加的所有任务执行顺序不定。并且不同任务在执行时，所在的线程不为同一个
> `追加`和`执行`是两个不同的概念，在并行队列中，先追加的任务不代表先执行

### 2.&nbsp;main队列(Main Dispatch Queue)和global队列(Global Dispatch Queue)
- **main队列**和**global队列**是系统标准提供的队列，即全局队列
- **main队列**(Main Dispatch Queue)是在主线程RunLoop中执行的队列，属于串行队列
- **global队列**(Global Dispatch Queue)是所有应用程序都能使用的并行队列，在swift中有6个执行优先级
    - 1.userInteractive&nbsp;(优先级最高)
    - 2.userInitiated(优先级第2高)
    - 3.default(优先级第3高)
    - 4.utility(优先级第4高)
    - 5.background(优先级最低)
    - 6.unspecified&nbsp;(未指定优先级)
代码： global队列指定优先级，分析任务的执行顺序
```swift
        DispatchQueue.global(qos: .background).async {
            self.log("background任务", Thread.current);
            sleep(4);
        }
        
        DispatchQueue.global(qos: .utility).async {
            self.log("utility任务", Thread.current);
            sleep(2)
        }
        
        DispatchQueue.global(qos: .default).async {
            self.log("default任务", Thread.current);
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.log("userInitiated任务", Thread.current);
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.log("userInteractive任务", Thread.current);
        }
        
        DispatchQueue.global(qos: .unspecified).async {
            self.log("unspecified任务", Thread.current);
        }
```

- 1.&nbsp;执行结果
```swift
userInteractive任务: 当前线程的hash为106102874588992
default任务: 当前线程的hash为106102874590080
userInitiated任务: 当前线程的hash为106102874590080
unspecified任务: 当前线程的hash为106102874582784
utility任务: 当前线程的hash为105553118758848
background任务: 当前线程的hash为106102874588096
```
- 2.&nbsp;global队列虽能指定任务执行的优先级，但不能保证实时性，因此执行顺序也只能是大致的判断，因此上面的代码执行的结果不一定是userInteractive->userInitiated->default->utility->background
> 自行创建串行队列和并行队列的优先级与default优先级的global队列相同


| Item      | Value |
| --------- | -----:|
| 作者  | **黄智彬** |
| 原创  | **YES** |
| 微信  | **ikrboy** |
| 邮箱  |   **ikrboy@163.com** |