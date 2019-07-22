//
//  AppDelegate.m
//  6.6 GCD 信号量：dispatch_semaphore
//
//  Created by 李方建 on 2019/7/19.
//  Copyright © 2019年 LFJ. All rights reserved.
//

#import "AppDelegate.h"
//#import "ViewController.h"

@interface AppDelegate ()
{
    dispatch_semaphore_t semaphore;
}
@property (nonatomic,assign)int ticketSurplusCount;

@end

@implementation AppDelegate

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
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [self semaphoreSync];
//    [self initTicketStatusNotSave];
    [self initTicketStatusSave];
    return YES;
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
- (void)initTicketStatusNotSave{
    self.ticketSurplusCount = 50;
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("queue2", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue1, ^{
        [self saleTicketNotSafe];
        
    });
    dispatch_async(queue2, ^{
        [self saleTicketNotSafe];
    });
    
}
/**
 * 售卖火车票(非线程安全)
 */
- (void)saleTicketNotSafe{
    while (1) {
        if (self.ticketSurplusCount > 0) {
            self.ticketSurplusCount --;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%d 窗口：%@", self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];

        }else{
            break;
        }
    }
    
}
/**
   6.6.2.2 线程安全（使用 semaphore 加锁）
 * 线程安全：使用 semaphore 加锁
 * 初始化火车票数量、卖票窗口(线程安全)、并开始卖票
 */
- (void)initTicketStatusSave{
    self.ticketSurplusCount = 50;
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("queue2", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue3 = dispatch_queue_create("queue3", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue4 = dispatch_queue_create("queue3", DISPATCH_QUEUE_CONCURRENT);

    
    semaphore = dispatch_semaphore_create(1);
    dispatch_async(queue1, ^{
        [self saleTicketSafe:1];
        
    });
    dispatch_async(queue2, ^{
        [self saleTicketSafe:2];
    });
    dispatch_async(queue3, ^{
        [self saleTicketSafe:3];
    });
    dispatch_async(queue4, ^{
        [self saleTicketSafe:4];
    });
    
}
/**
 * 售卖火车票(线程安全)
 */
- (void)saleTicketSafe:(int)index{
    while (1) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//-1 (第一个减之后为0，可以通过。第二个减之后为-1，阻塞线程2)

        if (self.ticketSurplusCount > 0) {
            self.ticketSurplusCount --;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%d 窗口：%@---%d", self.ticketSurplusCount, [NSThread currentThread],index]);
            [NSThread sleepForTimeInterval:0.2];
            dispatch_semaphore_signal(semaphore);//+1 ==0或者>0 解锁


        }else{
            dispatch_semaphore_signal(semaphore);
            break;
        }
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
