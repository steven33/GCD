4.1 同步执行 + 并发队列

在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。

/**
* 同步执行 + 并发队列
* 特点：在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
*/
- (void)syncConcurrent {
NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
NSLog(@"syncConcurrent---begin");

dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);

dispatch_sync(queue, ^{
// 追加任务1
for (int i = 0; i < 2; ++i) {
[NSThread sleepForTimeInterval:2];              // 模拟耗时操作
NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
}
});

dispatch_sync(queue, ^{
// 追加任务2
for (int i = 0; i < 2; ++i) {
[NSThread sleepForTimeInterval:2];              // 模拟耗时操作
NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
}
});

dispatch_sync(queue, ^{
// 追加任务3
for (int i = 0; i < 2; ++i) {
[NSThread sleepForTimeInterval:2];              // 模拟耗时操作
NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
}
});

NSLog(@"syncConcurrent---end");
}


输出结果：
2018-02-23 20:34:55.095932+0800 YSC-GCD-demo[19892:4996930] currentThread---<NSThread: 0x60400006bbc0>{number = 1, name = main}
2018-02-23 20:34:55.096086+0800 YSC-GCD-demo[19892:4996930] syncConcurrent---begin
2018-02-23 20:34:57.097589+0800 YSC-GCD-demo[19892:4996930] 1---<NSThread: 0x60400006bbc0>{number = 1, name = main}
2018-02-23 20:34:59.099100+0800 YSC-GCD-demo[19892:4996930] 1---<NSThread: 0x60400006bbc0>{number = 1, name = main}
2018-02-23 20:35:01.099843+0800 YSC-GCD-demo[19892:4996930] 2---<NSThread: 0x60400006bbc0>{number = 1, name = main}
2018-02-23 20:35:03.101171+0800 YSC-GCD-demo[19892:4996930] 2---<NSThread: 0x60400006bbc0>{number = 1, name = main}
2018-02-23 20:35:05.101750+0800 YSC-GCD-demo[19892:4996930] 3---<NSThread: 0x60400006bbc0>{number = 1, name = main}
2018-02-23 20:35:07.102414+0800 YSC-GCD-demo[19892:4996930] 3---<NSThread: 0x60400006bbc0>{number = 1, name = main}
2018-02-23 20:35:07.102575+0800 YSC-GCD-demo[19892:4996930] syncConcurrent---end

从同步执行 + 并发队列中可看到：

所有任务都是在当前线程（主线程）中执行的，没有开启新的线程（同步执行不具备开启新线程的能力）。
所有任务都在打印的syncConcurrent---begin和syncConcurrent---end之间执行的（同步任务需要等待队列的任务执行结束）。
任务按顺序执行的。按顺序执行的原因：虽然并发队列可以开启多个线程，并且同时执行多个任务。但是因为本身不能创建新线程，只有当前线程这一个线程（同步任务不具备开启新线程的能力），所以也就不存在并发。而且当前线程只有等待当前队列中正在执行的任务执行完毕之后，才能继续接着执行下面的操作（同步任务需要等待队列的任务执行结束）。所以任务只能一个接一个按顺序执行，不能同时被执行。

4.2 异步执行 + 并发队列

可以开启多个线程，任务交替（同时）执行。

/**
* 异步执行 + 并发队列
* 特点：可以开启多个线程，任务交替（同时）执行。
*/
- (void)asyncConcurrent {
NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
NSLog(@"asyncConcurrent---begin");

dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);

dispatch_async(queue, ^{
// 追加任务1
for (int i = 0; i < 2; ++i) {
[NSThread sleepForTimeInterval:2];              // 模拟耗时操作
NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
}
});

dispatch_async(queue, ^{
// 追加任务2
for (int i = 0; i < 2; ++i) {
[NSThread sleepForTimeInterval:2];              // 模拟耗时操作
NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
}
});

dispatch_async(queue, ^{
// 追加任务3
for (int i = 0; i < 2; ++i) {
[NSThread sleepForTimeInterval:2];              // 模拟耗时操作
NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
}
});

NSLog(@"asyncConcurrent---end");
}


输出结果：
2018-02-23 20:36:41.769269+0800 YSC-GCD-demo[19929:5005237] currentThread---<NSThread: 0x604000062d80>{number = 1, name = main}
2018-02-23 20:36:41.769496+0800 YSC-GCD-demo[19929:5005237] asyncConcurrent---begin
2018-02-23 20:36:41.769725+0800 YSC-GCD-demo[19929:5005237] asyncConcurrent---end
2018-02-23 20:36:43.774442+0800 YSC-GCD-demo[19929:5005566] 2---<NSThread: 0x604000266f00>{number = 5, name = (null)}
2018-02-23 20:36:43.774440+0800 YSC-GCD-demo[19929:5005567] 3---<NSThread: 0x60000026f200>{number = 4, name = (null)}
2018-02-23 20:36:43.774440+0800 YSC-GCD-demo[19929:5005565] 1---<NSThread: 0x600000264800>{number = 3, name = (null)}
2018-02-23 20:36:45.779286+0800 YSC-GCD-demo[19929:5005567] 3---<NSThread: 0x60000026f200>{number = 4, name = (null)}
2018-02-23 20:36:45.779302+0800 YSC-GCD-demo[19929:5005565] 1---<NSThread: 0x600000264800>{number = 3, name = (null)}
2018-02-23 20:36:45.779286+0800 YSC-GCD-demo[19929:5005566] 2---<NSThread: 0x604000266f00>{number = 5, name = (null)}

在异步执行 + 并发队列中可以看出：

除了当前线程（主线程），系统又开启了3个线程，并且任务是交替/同时执行的。（异步执行具备开启新线程的能力。且并发队列可开启多个线程，同时执行多个任务）。
所有任务是在打印的syncConcurrent---begin和syncConcurrent---end之后才执行的。说明当前线程没有等待，而是直接开启了新线程，在新线程中执行任务（异步执行不做等待，可以继续执行任务）。

接下来再来讲讲串行队列的两种执行方式。
4.3 同步执行 + 串行队列

不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。

/**
* 同步执行 + 串行队列
* 特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
*/
- (void)syncSerial {
NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
NSLog(@"syncSerial---begin");

dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);

dispatch_sync(queue, ^{
// 追加任务1
for (int i = 0; i < 2; ++i) {
[NSThread sleepForTimeInterval:2];              // 模拟耗时操作
NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
}
});
dispatch_sync(queue, ^{
// 追加任务2
for (int i = 0; i < 2; ++i) {
[NSThread sleepForTimeInterval:2];              // 模拟耗时操作
NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
}
});
dispatch_sync(queue, ^{
// 追加任务3
for (int i = 0; i < 2; ++i) {
[NSThread sleepForTimeInterval:2];              // 模拟耗时操作
NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
}
});

NSLog(@"syncSerial---end");
}


输出结果为：
2018-02-23 20:39:37.876811+0800 YSC-GCD-demo[19975:5017162] currentThread---<NSThread: 0x604000079400>{number = 1, name = main}
2018-02-23 20:39:37.876998+0800 YSC-GCD-demo[19975:5017162] syncSerial---begin
2018-02-23 20:39:39.878316+0800 YSC-GCD-demo[19975:5017162] 1---<NSThread: 0x604000079400>{number = 1, name = main}
2018-02-23 20:39:41.879829+0800 YSC-GCD-demo[19975:5017162] 1---<NSThread: 0x604000079400>{number = 1, name = main}
2018-02-23 20:39:43.880660+0800 YSC-GCD-demo[19975:5017162] 2---<NSThread: 0x604000079400>{number = 1, name = main}
2018-02-23 20:39:45.881265+0800 YSC-GCD-demo[19975:5017162] 2---<NSThread: 0x604000079400>{number = 1, name = main}
2018-02-23 20:39:47.882257+0800 YSC-GCD-demo[19975:5017162] 3---<NSThread: 0x604000079400>{number = 1, name = main}
2018-02-23 20:39:49.883008+0800 YSC-GCD-demo[19975:5017162] 3---<NSThread: 0x604000079400>{number = 1, name = main}
2018-02-23 20:39:49.883253+0800 YSC-GCD-demo[19975:5017162] syncSerial---end

在同步执行 + 串行队列可以看到：

所有任务都是在当前线程（主线程）中执行的，并没有开启新的线程（同步执行不具备开启新线程的能力）。
所有任务都在打印的syncConcurrent---begin和syncConcurrent---end之间执行（同步任务需要等待队列的任务执行结束）。
任务是按顺序执行的（串行队列每次只有一个任务被执行，任务一个接一个按顺序执行）。

4.4 异步执行 + 串行队列

会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务

/**
* 异步执行 + 串行队列
* 特点：会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。
*/
- (void)asyncSerial {
NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
NSLog(@"asyncSerial---begin");

dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);

dispatch_async(queue, ^{
// 追加任务1
for (int i = 0; i < 2; ++i) {
[NSThread sleepForTimeInterval:2];              // 模拟耗时操作
NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
}
});
dispatch_async(queue, ^{
// 追加任务2
for (int i = 0; i < 2; ++i) {
[NSThread sleepForTimeInterval:2];              // 模拟耗时操作
NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
}
});
dispatch_async(queue, ^{
// 追加任务3
for (int i = 0; i < 2; ++i) {
[NSThread sleepForTimeInterval:2];              // 模拟耗时操作
NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
}
});

NSLog(@"asyncSerial---end");
}


输出结果为：
2018-02-23 20:41:17.029999+0800 YSC-GCD-demo[20008:5024757] currentThread---<NSThread: 0x604000070440>{number = 1, name = main}
2018-02-23 20:41:17.030212+0800 YSC-GCD-demo[20008:5024757] asyncSerial---begin
2018-02-23 20:41:17.030364+0800 YSC-GCD-demo[20008:5024757] asyncSerial---end
2018-02-23 20:41:19.035379+0800 YSC-GCD-demo[20008:5024950] 1---<NSThread: 0x60000026e100>{number = 3, name = (null)}
2018-02-23 20:41:21.037140+0800 YSC-GCD-demo[20008:5024950] 1---<NSThread: 0x60000026e100>{number = 3, name = (null)}
2018-02-23 20:41:23.042220+0800 YSC-GCD-demo[20008:5024950] 2---<NSThread: 0x60000026e100>{number = 3, name = (null)}
2018-02-23 20:41:25.042971+0800 YSC-GCD-demo[20008:5024950] 2---<NSThread: 0x60000026e100>{number = 3, name = (null)}
2018-02-23 20:41:27.047690+0800 YSC-GCD-demo[20008:5024950] 3---<NSThread: 0x60000026e100>{number = 3, name = (null)}
2018-02-23 20:41:29.052327+0800 YSC-GCD-demo[20008:5024950] 3---<NSThread: 0x60000026e100>{number = 3, name = (null)}

在异步执行 + 串行队列可以看到：

开启了一条新线程（异步执行具备开启新线程的能力，串行队列只开启一个线程）。
所有任务是在打印的syncConcurrent---begin和syncConcurrent---end之后才开始执行的（异步执行不会做任何等待，可以继续执行任务）。
任务是按顺序执行的（串行队列每次只有一个任务被执行，任务一个接一个按顺序执行）。

下边讲讲刚才我们提到过的特殊队列：主队列。

主队列：GCD自带的一种特殊的串行队列

所有放在主队列中的任务，都会放到主线程中执行
可使用dispatch_get_main_queue()获得主队列



我们再来看看主队列的两种组合方式。
4.5 同步执行 + 主队列
同步执行 + 主队列在不同线程中调用结果也是不一样，在主线程中调用会出现死锁，而在其他线程中则不会。
4.5.1 在主线程中调用同步执行 + 主队列


互相等待卡住不可行

/**
* 同步执行 + 主队列
* 特点(主线程调用)：互等卡主不执行。
* 特点(其他线程调用)：不会开启新线程，执行完一个任务，再执行下一个任务。
*/
- (void)syncMain {

NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
NSLog(@"syncMain---begin");

dispatch_queue_t queue = dispatch_get_main_queue();

dispatch_sync(queue, ^{
// 追加任务1
for (int i = 0; i < 2; ++i) {
[NSThread sleepForTimeInterval:2];              // 模拟耗时操作
NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
}
});

dispatch_sync(queue, ^{
// 追加任务2
for (int i = 0; i < 2; ++i) {
[NSThread sleepForTimeInterval:2];              // 模拟耗时操作
NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
}
});

dispatch_sync(queue, ^{
// 追加任务3
for (int i = 0; i < 2; ++i) {
[NSThread sleepForTimeInterval:2];              // 模拟耗时操作
NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
}
});

NSLog(@"syncMain---end");
}


输出结果
2018-02-23 20:42:36.842892+0800 YSC-GCD-demo[20041:5030982] currentThread---<NSThread: 0x600000078a00>{number = 1, name = main}
2018-02-23 20:42:36.843050+0800 YSC-GCD-demo[20041:5030982] syncMain---begin
(lldb)

在同步执行 + 主队列可以惊奇的发现：

在主线程中使用同步执行 + 主队列，追加到主线程的任务1、任务2、任务3都不再执行了，而且syncMain---end也没有打印，在XCode 9上还会报崩溃。这是为什么呢？

这是因为我们在主线程中执行syncMain方法，相当于把syncMain任务放到了主线程的队列中。而同步执行会等待当前队列中的任务执行完毕，才会接着执行。那么当我们把任务1追加到主队列中，任务1就在等待主线程处理完syncMain任务。而syncMain任务需要等待任务1执行完毕，才能接着执行。
那么，现在的情况就是syncMain任务和任务1都在等对方执行完毕。这样大家互相等待，所以就卡住了，所以我们的任务执行不了，而且syncMain---end也没有打印。
要是如果不在主线程中调用，而在其他线程中调用会如何呢？
4.5.2 在其他线程中调用同步执行 + 主队列


不会开启新线程，执行完一个任务，再执行下一个任务

// 使用 NSThread 的 detachNewThreadSelector 方法会创建线程，并自动启动线程执行
selector 任务
[NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];


输出结果：
2018-02-23 20:44:19.377321+0800 YSC-GCD-demo[20083:5040347] currentThread---<NSThread: 0x600000272fc0>{number = 3, name = (null)}
2018-02-23 20:44:19.377494+0800 YSC-GCD-demo[20083:5040347] syncMain---begin
2018-02-23 20:44:21.384716+0800 YSC-GCD-demo[20083:5040132] 1---<NSThread: 0x60000006c900>{number = 1, name = main}
2018-02-23 20:44:23.386091+0800 YSC-GCD-demo[20083:5040132] 1---<NSThread: 0x60000006c900>{number = 1, name = main}
2018-02-23 20:44:25.387687+0800 YSC-GCD-demo[20083:5040132] 2---<NSThread: 0x60000006c900>{number = 1, name = main}
2018-02-23 20:44:27.388648+0800 YSC-GCD-demo[20083:5040132] 2---<NSThread: 0x60000006c900>{number = 1, name = main}
2018-02-23 20:44:29.390459+0800 YSC-GCD-demo[20083:5040132] 3---<NSThread: 0x60000006c900>{number = 1, name = main}
2018-02-23 20:44:31.391965+0800 YSC-GCD-demo[20083:5040132] 3---<NSThread: 0x60000006c900>{number = 1, name = main}
2018-02-23 20:44:31.392513+0800 YSC-GCD-demo[20083:5040347] syncMain---end

在其他线程中使用同步执行 + 主队列可看到：

所有任务都是在主线程（非当前线程）中执行的，没有开启新的线程（所有放在主队列中的任务，都会放到主线程中执行）。
所有任务都在打印的syncConcurrent---begin和syncConcurrent---end之间执行（同步任务需要等待队列的任务执行结束）。
任务是按顺序执行的（主队列是串行队列，每次只有一个任务被执行，任务一个接一个按顺序执行）。

为什么现在就不会卡住了呢？
因为syncMain 任务放到了其他线程里，而任务1、任务2、任务3都在追加到主队列中，这三个任务都会在主线程中执行。syncMain 任务在其他线程中执行到追加任务1到主队列中，因为主队列现在没有正在执行的任务，所以，会直接执行主队列的任务1，等任务1执行完毕，再接着执行任务2、任务3。所以这里不会卡住线程。
4.6 异步执行 + 主队列

只在主线程中执行任务，执行完一个任务，再执行下一个任务。

/**
* 异步执行 + 主队列
* 特点：只在主线程中执行任务，执行完一个任务，再执行下一个任务
*/
- (void)asyncMain {
NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
NSLog(@"asyncMain---begin");

dispatch_queue_t queue = dispatch_get_main_queue();

dispatch_async(queue, ^{
// 追加任务1
for (int i = 0; i < 2; ++i) {
[NSThread sleepForTimeInterval:2];              // 模拟耗时操作
NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
}
});

dispatch_async(queue, ^{
// 追加任务2
for (int i = 0; i < 2; ++i) {
[NSThread sleepForTimeInterval:2];              // 模拟耗时操作
NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
}
});

dispatch_async(queue, ^{
// 追加任务3
for (int i = 0; i < 2; ++i) {
[NSThread sleepForTimeInterval:2];              // 模拟耗时操作
NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
}
});

NSLog(@"asyncMain---end");
}


输出结果：
2018-02-23 20:45:49.981505+0800 YSC-GCD-demo[20111:5046708] currentThread---<NSThread: 0x60000006d440>{number = 1, name = main}
2018-02-23 20:45:49.981935+0800 YSC-GCD-demo[20111:5046708] asyncMain---begin
2018-02-23 20:45:49.982352+0800 YSC-GCD-demo[20111:5046708] asyncMain---end
2018-02-23 20:45:51.991096+0800 YSC-GCD-demo[20111:5046708] 1---<NSThread: 0x60000006d440>{number = 1, name = main}
2018-02-23 20:45:53.991959+0800 YSC-GCD-demo[20111:5046708] 1---<NSThread: 0x60000006d440>{number = 1, name = main}
2018-02-23 20:45:55.992937+0800 YSC-GCD-demo[20111:5046708] 2---<NSThread: 0x60000006d440>{number = 1, name = main}
2018-02-23 20:45:57.993649+0800 YSC-GCD-demo[20111:5046708] 2---<NSThread: 0x60000006d440>{number = 1, name = main}
2018-02-23 20:45:59.994928+0800 YSC-GCD-demo[20111:5046708] 3---<NSThread: 0x60000006d440>{number = 1, name = main}
2018-02-23 20:46:01.995589+0800 YSC-GCD-demo[20111:5046708] 3---<NSThread: 0x60000006d440>{number = 1, name = main}

在异步执行 + 主队列可以看到：

所有任务都是在当前线程（主线程）中执行的，并没有开启新的线程（虽然异步执行具备开启线程的能力，但因为是主队列，所以所有任务都在主线程中）。
所有任务是在打印的syncConcurrent---begin和syncConcurrent---end之后才开始执行的（异步执行不会做任何等待，可以继续执行任务）。
任务是按顺序执行的（因为主队列是串行队列，每次只有一个任务被执行，任务一个接一个按顺序执行）。


