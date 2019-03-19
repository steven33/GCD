GCD的使用步骤
1、创建一个队列（串行队列或并发队列）
2、将任务追加到任务的等待队列中，然后系统会根据任务类型执行任务（同步执行或异步执行）

3.1 队列的创建方法/获取方法
可以使用dispatch_queue_create来创建队列，需要传入两个参数，第一个参数表示队列的唯一标识符，用于 DEBUG，可为空，Dispatch Queue 的名称推荐使用应用程序 ID 这种逆序全程域名；第二个参数用来识别是串行队列还是并发队列。DISPATCH_QUEUE_SERIAL 表示串行队列，DISPATCH_QUEUE_CONCURRENT 表示并发队列。

// 串行队列的创建方法
dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
// 并发队列的创建方法
dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);


对于串行队列，GCD 提供了的一种特殊的串行队列：主队列（Main Dispatch Queue）。

所有放在主队列中的任务，都会放到主线程中执行。
可使用dispatch_get_main_queue()获得主队列。



// 主队列的获取方法
dispatch_queue_t queue = dispatch_get_main_queue();


对于并发队列，GCD 默认提供了全局并发队列（Global Dispatch Queue）。

可以使用dispatch_get_global_queue来获取。需要传入两个参数。第一个参数表示队列优先级，一般用DISPATCH_QUEUE_PRIORITY_DEFAULT。第二个参数暂时没用，用0即可。



// 全局并发队列的获取方法
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

3.2 任务的创建方法
GCD 提供了同步执行任务的创建方法dispatch_sync和异步执行任务创建方法dispatch_async。
// 同步执行任务创建方法
dispatch_sync(queue, ^{
// 这里放同步执行任务代码
});
// 异步执行任务创建方法
dispatch_async(queue, ^{
// 这里放异步执行任务代码
});

虽然使用 GCD 只需两步，但是既然我们有两种队列（串行队列/并发队列），两种任务执行方式（同步执行/异步执行），那么我们就有了四种不同的组合方式。这四种不同的组合方式是：


同步执行 + 并发队列
异步执行 + 并发队列
同步执行 + 串行队列
异步执行 + 串行队列


实际上，刚才还说了两种特殊队列：全局并发队列、主队列。全局并发队列可以作为普通并发队列来使用。但是主队列因为有点特殊，所以我们就又多了两种组合方式。这样就有六种不同的组合方式了。


同步执行 + 主队列
异步执行 + 主队列


那么这几种不同组合方式各有什么区别呢，这里为了方便，先上结果，再来讲解。你可以直接查看表格结果，然后跳过 4. GCD的基本使用 。



区别
并发队列
串行队列
主队列

同步(sync)
没有开启新线程，串行执行任务
没有开启新线程，串行执行任务
主线程调用：死锁卡住不执行其他线程调用：没有开启新线程，串行执行任务


异步(async)
有开启新线程，并发执行任务
有开启新线程(1条)，串行执行任务
没有开启新线程，串行执行任务

