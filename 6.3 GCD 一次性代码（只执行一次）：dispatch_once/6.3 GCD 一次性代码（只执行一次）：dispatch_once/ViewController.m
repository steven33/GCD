//
//  ViewController.m
//  6.3 GCD 一次性代码（只执行一次）：dispatch_once
//
//  Created by 李方建 on 2019/7/19.
//  Copyright © 2019年 LFJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
/*
 我们在创建单例、或者有整个程序运行过程中只执行一次的代码时，我们就用到了 GCD 的 dispatch_once 函数。使用
 dispatch_once 函数能保证某段代码在程序运行过程中只被执行1次，并且即使在多线程的环境下，dispatch_once也可以保证线程安全。
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self once];
    [self once];
    [self once];
}
/**
 * 一次性代码（只执行一次）dispatch_once
 */
- (void)once {
    dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        NSLog(@"只执行一次代码");
    });
}


@end
