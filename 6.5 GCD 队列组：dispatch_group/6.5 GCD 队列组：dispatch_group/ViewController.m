//
//  ViewController.m
//  6.5 GCD 队列组：dispatch_group
//
//  Created by 李方建 on 2019/7/19.
//  Copyright © 2019年 LFJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
/*
 有时候我们会有这样的需求：分别异步执行2个耗时任务，然后当2个耗时任务都执行完毕后再回到主线程执行任务。这时候我们可以用到 GCD 的队列组。
 
 调用队列组的 dispatch_group_async 先把任务放到队列中，然后将队列放入队列组中。或者使用队列组的 dispatch_group_enter、dispatch_group_leave 组合 来实现
 dispatch_group_async。
 调用队列组的 dispatch_group_notify 回到指定线程执行任务。或者使用 dispatch_group_wait 回到当前线程继续向下执行（会阻塞当前线程）。
 */
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self groupNotify];
//    [self groupWait];
    [self groupEnterAndLeave];
}

/**
 6.5.1 dispatch_group_notify
 * 队列组 dispatch_group_notify
 （监听 group 中任务的完成状态，当所有的任务都执行完成后，追加任务到 group 中，并执行任务。）
 */
- (void)groupNotify{
    NSLog(@"currentThread---%@--group---begin",[NSThread currentThread]);  // 打印当前线程
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self actWithStep:1];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self actWithStep:2];
    });
    //当group中所有任务都执行完成之后，才执行dispatch_group_notify block 中的任务。
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等对列组（跟代码顺序无关）的异步任务1、任务2、任务4、任务5都执行完毕后，回到主线程执行下边任务
        [self actWithStep:333333];
        NSLog(@"group_botify_end");
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self actWithStep:4];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self actWithStep:5];
    });
    
}
/**
   6.5.2 dispatch_group_wait
 * 队列组 dispatch_group_wait
  （暂停当前线程（阻塞当前线程），等待指定的 group 中的任务执行完成后，才会往下继续执行。）
 */
- (void)groupWait{
    NSLog(@"currentThread---%@--group---begin",[NSThread currentThread]);  // 打印当前线程
    dispatch_group_t group =  dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self actWithStep:1];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self actWithStep:2];
    });
//    dispatch_group_wait(group, DISPATCH_TIME_NOW);//（DISPATCH_TIME_NOW表示等待到现在的时间。相当于没有等待）
//    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);//（DISPATCH_TIME_FOREVER表示等待到上面的任务都完成）
    dispatch_group_wait(group, DISPATCH_TIME_NOW+1);//等待1秒，然后主线程和1、2、3、4异步执行

    //等待任务1、任务2执行完之后才走下面的代码
    NSLog(@"group_wait_end");

    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self actWithStep:3];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self actWithStep:4];
    });
    NSLog(@"currentThread---%@--groupWait---end",[NSThread currentThread]);  // 打印当前线程
    
}

/**
   6.5.3 dispatch_group_enter、dispatch_group_leave
 * 队列组 dispatch_group_enter、dispatch_group_leave
 （ dispatch_group_enter 标志着一个任务追加到 group，执行一次，相当于 group 中未执行完毕任务数+1
   dispatch_group_leave 标志着一个任务离开了 group，执行一次，相当于 group 中未执行完毕任务数-1。
   当 group 中未执行完毕任务数为0的时候，才会使dispatch_group_wait解除阻塞，以及执行追加到dispatch_group_notify中的任务。
 ）
 */
- (void)groupEnterAndLeave{
    NSLog(@"currentThread---%@--group---begin",[NSThread currentThread]);  // 打印当前线程
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [self actWithStep:1];
        dispatch_group_leave(group);
    });
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [self actWithStep:2];
        dispatch_group_leave(group);
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 队列组的异步操作都执行完毕后，回到主线程.
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"group---end");
    });
    //    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
    //    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    //
    //    NSLog(@"group---end");
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [self actWithStep:3];
        dispatch_group_leave(group);

    });
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [self actWithStep:4];
        dispatch_group_leave(group);
    });
    
}

//模拟耗时操作
- (void)actWithStep:(int)step{
    for (int i = 0; i<2; i++) {
        [NSThread sleepForTimeInterval:1];
        NSLog(@"%@", [NSString stringWithFormat:@"%d（%d）---%@",step,i,[NSThread currentThread]]);
    }
}


@end
