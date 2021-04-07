//
//  QLMySubscriptionsDetailViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2021/2/28.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLMySubscriptionsDetailViewController.h"
#import "QLMySubDetailTitleCell.h"
#import "QLHomeCarCell.h"

@interface QLMySubscriptionsDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation QLMySubscriptionsDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航
    [self setNavi];
    //tableView
    [self tableViewSet];
}

#pragma mark - navigation
- (void)editItemClick {
    
}
- (void)deleteItemClick {
    
}
//设置导航
- (void)setNavi {
    self.navigationItem.title = @"订阅详情";
    //右导航按钮
   
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"delete_green"] originalImage] style:UIBarButtonItemStyleDone target:self action:@selector(deleteItemClick)];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"editIcon"] originalImage] style:UIBarButtonItemStyleDone target:self action:@selector(editItemClick)];
    self.navigationItem.rightBarButtonItems = @[deleteItem,editItem];
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLHomeCarCell" bundle:nil] forCellReuseIdentifier:@"hCarCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLMySubDetailTitleCell" bundle:nil] forCellReuseIdentifier:@"mySubDetailTitleCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section==0?1:3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QLMySubDetailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mySubDetailTitleCell" forIndexPath:indexPath];
        cell.iconArr = [@[@"30万-50万",@"30万-50万",@"30万-50万",@"30万-50万",@"30万-50万",@"30万-50万"] mutableCopy];
        return cell;
    } else {
        QLHomeCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hCarCell" forIndexPath:indexPath];
        cell.lineView.hidden = NO;
        return cell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *header = [UIView new];
        
        UILabel *lb = [UILabel new];
        lb.font = [UIFont systemFontOfSize:12];
        lb.textColor = [UIColor darkGrayColor];
        lb.text = @"匹配到0辆车";
        [header addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header).offset(15);
            make.centerY.equalTo(header);
        }];
        
        return header;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==0?0.01:36;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

@end
