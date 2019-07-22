//
//  ViewController.m
//  6.4 GCD 快速迭代方法：dispatch_apply
//
//  Created by 李方建 on 2019/7/19.
//  Copyright © 2019年 LFJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
/*
 通常我们会用 for 循环遍历，但是 GCD 给我们提供了快速迭代的函数dispatch_apply。dispatch_apply按照指定的次数将指定的任务追加到指定的队列中，并等待全部队列执行结束。
 
 如果是在串行队列中使用 dispatch_apply，那么就和 for 循环一样，按顺序同步执行。可这样就体现不出快速迭代的意义了。
 我们可以利用并发队列进行异步执行。比如说遍历 0~5 这6个数字，for 循环的做法是每次取出一个元素，逐个遍历。dispatch_apply 可以 在多个线程中同时（异步）遍历多个数字。
 还有一点，无论是在串行队列，还是并发队列中，dispatch_apply 都会等待全部任务执行完毕，这点就像是同步操作，也像是队列组中的 dispatch_group_wait方法。

 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self apply];
    [self apply1];
    [self apply2];
    // Do any additional setup after loading the view, typically from a nib.
}
/**
 * 快速迭代方法 dispatch_apply
 */
- (void)apply{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);//
    
    NSLog(@"begin");
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"%zd---%@",index, [NSThread currentThread]);
    });
    NSLog(@"end");
}
//在串行队列中使用(和 for 循环一样，按顺序同步执行)
- (void)apply1{
    dispatch_queue_t queue = dispatch_queue_create("hhh", DISPATCH_QUEUE_SERIAL);//

    NSLog(@"begin1");
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"%zd---%@",index, [NSThread currentThread]);
    });
    NSLog(@"end1");
}

//dispatch_apply函数与dispatch_sync函数形同,会等待处理执行结束
- (void)apply2{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);//
    
    dispatch_async(queue, ^{
        NSLog(@"begin2");
        dispatch_apply(6, queue, ^(size_t index) {
            NSLog(@"%zd---%@",index, [NSThread currentThread]);
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回到主线程执行用户界面更新等操作");
        });
        NSLog(@"end2");
    });
    NSLog(@"main end");
}


@end
