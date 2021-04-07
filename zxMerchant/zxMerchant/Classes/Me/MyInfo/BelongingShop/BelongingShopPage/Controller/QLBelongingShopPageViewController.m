//
//  QLBelongingShopPageViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/12/29.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLBelongingShopPageViewController.h"
#import "QLEnterpriseCertificationViewController.h"

@interface QLBelongingShopPageViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation QLBelongingShopPageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"店铺详情";
    //底部
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(BottomOffset?-34:0);
        make.height.mas_equalTo(50);
    }];
    //tableView
    [self tableViewSet];
    
}
#pragma mark - action
//企业认证
- (void)authBtnClick {
    QLEnterpriseCertificationViewController *ecVC = [QLEnterpriseCertificationViewController new];
    [self.navigationController pushViewController:ecVC animated:YES];
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLBelongingShopInfoCell" bundle:nil] forCellReuseIdentifier:@"belongingShopInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLBelongingShopTextCell" bundle:nil] forCellReuseIdentifier:@"belongingShopTextCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0?1:4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QLBelongingShopInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"belongingShopInfoCell" forIndexPath:indexPath];
        
        return cell;
    } else {
        QLBelongingShopTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"belongingShopTextCell" forIndexPath:indexPath];
        
        
        NSArray *titles = @[@"店铺归属人",@"联系方式",@"店铺认证",@"企业认证"];
        
        
        cell.titleLB.text = titles[indexPath.row];
        cell.accLB.text = @"--";
        cell.authBtn.hidden = indexPath.row == ([tableView numberOfRowsInSection:indexPath.section]-1)?NO:YES;
        [cell.authBtn addTarget:self action:@selector(authBtnClick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *header = [UIView new];
        
        UILabel *lb = [UILabel new];
        lb.font = [UIFont systemFontOfSize:15];
        lb.textColor = [UIColor darkGrayColor];
        lb.text = @"基础信息";
        [header addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header).offset(16);
            make.centerY.equalTo(header);
        }];
        
        return header;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==0?0.01:40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - Lazy
- (QLBelongingShopBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [QLBelongingShopBottomView new];
    }
    return _bottomView;
}

@end
