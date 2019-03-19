在iOS开发过程中，我们一般在主线程里边进行UI刷新，例如：点击、滚动、拖拽等事件。我们通常把一些耗时的操作放在其他线程，比如说图片下载、文件上传等耗时操作。而当我们有时候在其他线程完成了耗时操作时，需要回到主线程，那么就用到了线程之间的通讯。
/**
* 线程间通信
*/
- (void)communication {
// 获取全局并发队列
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); 
// 获取主队列
dispatch_queue_t mainQueue = dispatch_get_main_queue(); 

dispatch_async(queue, ^{
// 异步追加任务
for (int i = 0; i < 2; ++i) {
[NSThread sleepForTimeInterval:2];              // 模拟耗时操作
NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
}

// 回到主线程
dispatch_async(mainQueue, ^{
// 追加在主线程中执行的任务
[NSThread sleepForTimeInterval:2];              // 模拟耗时操作
NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
});
});
}


输出结果：
2018-02-23 20:47:03.462394+0800 YSC-GCD-demo[20154:5053282] 1---<NSThread: 0x600000271940>{number = 3, name = (null)}
2018-02-23 20:47:05.465912+0800 YSC-GCD-demo[20154:5053282] 1---<NSThread: 0x600000271940>{number = 3, name = (null)}
2018-02-23 20:47:07.466657+0800 YSC-GCD-demo[20154:5052953] 2---<NSThread: 0x60000007bf80>{number = 1, name = main}


可以看到在其他线程中先执行任务，执行完了之后回到主线程执行主线程的相应操作。
