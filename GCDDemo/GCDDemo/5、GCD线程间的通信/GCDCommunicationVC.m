//
//  GCDCommunicationVC.m
//  GCDDemo
//
//  Created by 李方建 on 2019/7/18.
//  Copyright © 2019年 李方建. All rights reserved.
//

#import "GCDCommunicationVC.h"

@interface GCDCommunicationVC ()

@end

@implementation GCDCommunicationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self communication];
}
- (void)communication{
    //全局并发队列
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 异步追加任务
        for (int i = 0; i< 2; i++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程

        }
        //回掉主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            // 追加在主线程中执行的任务
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        });
        
        
        
    });
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
