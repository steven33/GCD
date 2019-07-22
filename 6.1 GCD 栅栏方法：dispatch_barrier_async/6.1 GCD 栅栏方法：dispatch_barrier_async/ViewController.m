//
//  ViewController.m
//  6.1 GCD 栅栏方法：dispatch_barrier_async
//
//  Created by 李方建 on 2019/7/19.
//  Copyright © 2019年 LFJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
/**
 我们有时需要异步执行两组操作，而且第一组操作执行完之后，才能开始执行第二组操作。这样我们就需要一个相当于栅栏一样的一个方法将两组异步执行的操作组给分割起来，当然这里的操作组里可以包含一个或多个任务。这就需要用到dispatch_barrier_async方法在两个操作组间形成栅栏。
 dispatch_barrier_async函数会等待前边追加到并发队列中的任务全部执行完毕之后，再将指定的任务追加到该异步队列中。然后在dispatch_barrier_async函数追加的任务执行完毕之后，异步队列才恢复为一般动作，接着追加任务到该异步队列并开始执行。具体如下图所示：

 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self barrier];
    
    
}
/**
 * 栅栏方法 dispatch_barrier_async
 */
//先异步执行任务1、2、3（无序）、然后执行栅栏任务000000，然后异步执行任务4、5，然后执行栅栏任务0000001，最后执行异步执行任务6、7
- (void)barrier{
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [self actWithStep:1];
    });
    dispatch_async(queue, ^{
        [self actWithStep:2];
    });
    dispatch_async(queue, ^{
        [self actWithStep:3];
    });
    dispatch_barrier_async(queue, ^{
        [self actWithStep:000000];
    });
    dispatch_async(queue, ^{
        [self actWithStep:4];
    });
    dispatch_async(queue, ^{
        [self actWithStep:5];
    });
    dispatch_barrier_async(queue, ^{
        [self actWithStep:0000001];
    });
    dispatch_async(queue, ^{
        [self actWithStep:6];
    });
    dispatch_async(queue, ^{
        [self actWithStep:7];
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
