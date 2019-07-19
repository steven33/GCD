//
//  ViewController.m
//  GCDDemo
//
//  Created by 李方建 on 2019/3/5.
//  Copyright © 2019年 李方建. All rights reserved.
//

#import "ViewController.h"
#import "GCDUseViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSArray *listArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    NSString *starTime = @"2019-03-08 17:20:00";
    NSString *endTime = @"2019-03-08 17:22:00";
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSLocale * locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    formatter.locale = locale;
    NSDate *starTimeDate = [formatter dateFromString:starTime];
    NSDate *endTimeDate = [formatter dateFromString:endTime];
    double intervalTime = [endTimeDate timeIntervalSinceReferenceDate ] - [starTimeDate timeIntervalSinceReferenceDate ];
    */
    
    [self.view addSubview:self.tableView];


}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        
    }
    cell.textLabel.text = self.listArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *classStr = self.listArr[indexPath.row];
    classStr = [classStr componentsSeparatedByString:@"&"].lastObject;
    UIViewController *vc = [NSClassFromString(classStr) new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 40;
    }
    return _tableView;
}
- (NSArray *)listArr{
    if (!_listArr) {
        _listArr = @[@"4、GCD的基本使用&GCDUseViewController",
                     @"5、GCD线程间的通信&GCDCommunicationVC"];
    }
    return _listArr;
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
