//
//  ViewController.m
//  GCDDemo
//
//  Created by 李方建 on 2019/3/5.
//  Copyright © 2019年 李方建. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *starTime = @"2019-03-08 17:20:00";
    NSString *endTime = @"2019-03-08 17:22:00";
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSLocale * locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    formatter.locale = locale;
    NSDate *starTimeDate = [formatter dateFromString:starTime];
    NSDate *endTimeDate = [formatter dateFromString:endTime];
    double intervalTime = [endTimeDate timeIntervalSinceReferenceDate ] - [starTimeDate timeIntervalSinceReferenceDate ];
    


}
- (void)hhh{
    [ViewController _testAction:NO];
    [ViewController _testAction:NO];
    [ViewController _testAction:NO];
    [ViewController _testAction:YES];
    [ViewController _testAction:NO];
}
+ (void)_testAction:(BOOL)reset{
    static NSMutableArray *mArr;
    static int i = 0;
    if (!mArr) {
        mArr = [NSMutableArray array];
    }
    if (reset) {
        [mArr removeAllObjects];
    }
    i=++i;
    [mArr addObject:[NSString stringWithFormat:@"%d",i]];
    NSLog(@"-----%@",mArr);
}


@end
