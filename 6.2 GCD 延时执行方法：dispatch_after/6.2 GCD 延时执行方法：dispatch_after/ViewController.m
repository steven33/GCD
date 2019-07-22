//
//  ViewController.m
//  6.2 GCD 延时执行方法：dispatch_after
//
//  Created by 李方建 on 2019/7/19.
//  Copyright © 2019年 LFJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
/*
 我们经常会遇到这样的需求：在指定时间（例如3秒）之后执行某个任务。可以用 GCD 的dispatch_after函数来实现。
 需要注意的是：dispatch_after函数并不是在指定时间之后才开始执行处理，而是在指定时间之后将任务追加到主队列中。严格来说，这个时间并不是绝对准确的，但想要大致延迟执行任务，dispatch_after函数是很有效的。
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self after];
}
/**
 * 延时执行方法 dispatch_after
 */
- (void)after{
    NSLog(@"currentThread---%@--asyncMain---begin",[NSThread currentThread]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 3.0秒后异步追加任务代码到主队列，并开始执行
        NSLog(@"after---%@",[NSThread currentThread]);  // 打印当前线程
    });
}


@end
