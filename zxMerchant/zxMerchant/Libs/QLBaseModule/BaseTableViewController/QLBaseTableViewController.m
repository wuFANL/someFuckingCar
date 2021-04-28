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
    
    //记录tableView属性
    CGRect frame = self.tableView.frame;
    id delegate = self.tableView.delegate;
    id dataSource = self.tableView.dataSource;
    UIView *headView = self.tableView.tableHeaderView;
    UIView *footView = self.tableView.tableFooterView;
    UIColor *separatorColor = self.tableView.separatorColor;
    UITableViewCellSeparatorStyle separatorStyle = self.tableView.separatorStyle;
    UIEdgeInsets separatorInset = self.tableView.separatorInset;
    //重新初始化
    self.tableView = [[QLBaseTableView alloc]initWithFrame:CGRectZero style:initStyle == UITableViewStyleGrouped?UITableViewStyleGrouped:UITableViewStylePlain];
    //重新设置tableView属性
    if (delegate) {
        self.tableView.delegate = delegate;
    }
    if (dataSource) {
        self.tableView.dataSource = dataSource;
    }
    if (headView) {
        self.tableView.tableHeaderView = headView;
    }
    if (footView) {
        self.tableView.tableFooterView = footView;
    }
    if (separatorColor) {
        self.tableView.separatorColor = separatorColor;
    }
    if (separatorStyle) {
        self.tableView.separatorStyle = separatorStyle;
    }
    
    
    self.tableView.separatorInset = separatorInset;
    [self.view insertSubview:self.tableView aboveSubview:self.backgroundView];
    if (CGRectIsEmpty(frame)) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    } else {
        self.tableView.frame = frame;
    }
    
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
