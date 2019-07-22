//
//  ViewController.m
//  6.6 GCD 信号量：dispatch_semaphore
//
//  Created by 李方建 on 2019/7/19.
//  Copyright © 2019年 LFJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
/*
 GCD 中的信号量是指 Dispatch Semaphore，是持有计数的信号。类似于过高速路收费站的栏杆。可以通过时，打开栏杆，不可以通过时，关闭栏杆。在 Dispatch Semaphore 中，使用计数来完成这个功能，计数小于 0 时等待，不可通过。计数为 0 或大于 0 时，计数减 1 且不等待，可通过。
 Dispatch Semaphore 提供了三个函数。
    dispatch_semaphore_create：创建一个 Semaphore 并初始化信号的总量
    dispatch_semaphore_signal：发送一个信号，让信号总量加 1
    dispatch_semaphore_wait：可以使总信号量减 1，信号总量小于 0 时就会一直等待（阻塞所在线程），否则就可以正常执行。
 
 注意：信号量的使用前提是：想清楚你需要处理哪个线程等待（阻塞），又要哪个线程继续执行，然后使用信号量。
 Dispatch Semaphore 在实际开发中主要用于：
1、 保持线程同步，将异步执行任务转换为同步执行任务
2、保证线程安全，为线程加锁
 */
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self semaphoreSync];


    
}
/**
  6.6.1 Dispatch Semaphore 线程同步
 * semaphore 线程同步(利用 Dispatch Semaphore 实现线程同步，将异步执行任务转换为同步执行任务。)
 */
- (void)semaphoreSync{
    NSLog(@"currentThread---%@--semaphore---begin",[NSThread currentThread]);  // 打印当前线程
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block int num = 0;
    dispatch_async(queue, ^{
        [self actWithStep:1];
        num = 100;
        dispatch_semaphore_signal(semaphore);//semaphore 加 1，此时 semaphore == 0，正在被阻塞的线程（主线程）恢复继续执行。
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//semaphore 减 1，此时 semaphore == -1，当前线程进入等待状态。
    NSLog(@"semaphore---end,num = %d",num);//100
    
    
}
//模拟耗时操作
- (void)actWithStep:(int)step{
    for (int i = 0; i<2; i++) {
        [NSThread sleepForTimeInterval:1];
        NSLog(@"%@", [NSString stringWithFormat:@"%d（%d）---%@",step,i,[NSThread currentThread]]);
    }
}
/*
 6.6.2 Dispatch Semaphore 线程安全和线程同步（为线程加锁）
 线程安全：如果你的代码所在的进程中有多个线程在同时运行，而这些线程可能会同时运行这段代码。如果每次运行结果和单线程运行的结果是一样的，而且其他的变量的值也和预期的是一样的，就是线程安全的。
 若每个线程中对全局变量、静态变量只有读操作，而无写操作，一般来说，这个全局变量是线程安全的；若有多个线程同时执行写操作（更改变量），一般都需要考虑线程同步，否则的话就可能影响线程安全。
 线程同步：可理解为线程 A 和 线程 B 一块配合，A 执行到一定程度时要依靠线程 B 的某个结果，于是停下来，示意 B 运行；B 依言执行，再将结果给 A；A 再继续操作。
 举个简单例子就是：两个人在一起聊天。两个人不能同时说话，避免听不清(操作冲突)。等一个人说完(一个线程结束操作)，另一个再说(另一个线程再开始操作)。
 下面，我们模拟火车票售卖的方式，实现 NSThread 线程安全和解决线程同步问题。
 场景：总共有50张火车票，有两个售卖火车票的窗口，一个是北京火车票售卖窗口，另一个是上海火车票售卖窗口。两个窗口同时售卖火车票，卖完为止。
 */
/**
 * 6.6.2.1 非线程安全：不使用 semaphore
 * 初始化火车票数量、卖票窗口(非线程安全)、并开始卖票
 */
//- (void)initTicketStatusNotSave{
//    //创建两个队列
//
//
//
//
//
//}

@end
