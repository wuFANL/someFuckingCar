//
//  QLBaseTableViewController.m
//  Integral
//
//  Created by 乔磊 on 2019/4/19.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLBaseTableViewController.h"

@interface QLBaseTableViewController ()


@end

@implementation QLBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}
#pragma mark- action
//tableView类型设置
- (void)setInitStyle:(UITableViewStyle)initStyle {
    _initStyle = initStyle;
    
    //重新初始化
    self.tableView = [[QLBaseTableView alloc]initWithFrame:CGRectZero style:initStyle == UITableViewStyleGrouped?UITableViewStyleGrouped:UITableViewStylePlain];
    [self.view insertSubview:self.tableView aboveSubview:self.backgroundView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

#pragma mark - Lazy
- (QLBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[QLBaseTableView alloc] init];
        _tableView.page = 0;
    }
    return _tableView;
}
@end
