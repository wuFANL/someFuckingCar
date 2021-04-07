//
//  QLMyInfoPageViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/12/21.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLMyInfoPageViewController.h"
#import "QLChangeMobileViewController.h"
#import "QLEditAccountViewController.h"
#import "QLBelongingShopPageViewController.h"
#import "QLUnbindStoreView.h"

@interface QLMyInfoPageViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation QLMyInfoPageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的信息";
    //tableView
    [self tableViewSet];
    
}
#pragma mark - action
//解除绑定
- (void)unbindBtnClick {
    QLUnbindStoreView *unbindView = [QLUnbindStoreView new];
    [unbindView show];
}
//头像按钮
- (void)headBtnClick {
    
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section==0?5:3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    
    NSString *title = @"";
    NSString *acc = @"";
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            title = @"头像";
            acc = @"";
            //头像
            QLBaseButton *headBtn = [[QLBaseButton alloc] init];
            headBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [headBtn roundRectCornerRadius:4 borderWidth:1 borderColor:WhiteColor];
            [headBtn addTarget:self action:@selector(headBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:headBtn];
            [headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView);
                make.right.equalTo(cell.contentView).offset(-15);
                make.width.height.mas_equalTo(60);
            }];
        } else if (indexPath.row == 1) {
            title = @"姓名";
            acc = @"王传";
        } else if (indexPath.row == 2) {
            title = @"手机";
            acc = @"18566292258";
        } else if (indexPath.row == 3) {
            title = @"帐号";
            acc = @"SO5655258";
        } else if (indexPath.row == 4) {
            title = @"会员到期";
            acc = @"2020-15-14";
        } else if (indexPath.row == 5) {
            title = @"个人信息认证";
            acc = @"认证通过";
        }
    } else {
        if (indexPath.row == 0) {
            title = @"归属店铺";
            acc = @"将注册账号资料传过来";
        } else if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            title = @"所在地区";
            acc = @"将注册账号资料传过来";
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            title = @"门店地址";
            acc = @"--";
        }
    }
    
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = acc;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            //更换手机号
            QLChangeMobileViewController *cmVC = [QLChangeMobileViewController new];
            [self.navigationController pushViewController:cmVC animated:YES];
            
        } else if (indexPath.row == 3) {
            //换账户
            QLEditAccountViewController *eaVC = [QLEditAccountViewController new];
            [self.navigationController pushViewController:eaVC animated:YES];
        }
    } else {
        if (indexPath.row == 0) {
            //归属店铺
            QLBelongingShopPageViewController *bspVC = [QLBelongingShopPageViewController new];
            [self.navigationController pushViewController:bspVC animated:YES];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *header = [UIView new];
        
        UILabel *lb = [UILabel new];
        lb.font = [UIFont systemFontOfSize:13];
        lb.textColor = [UIColor darkGrayColor];
        lb.text = @"店铺信息";
        [header addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header).offset(15);
            make.centerY.equalTo(header);
        }];
        
        return header;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *footer = [UIView new];
        
        UIButton *btn = [UIButton new];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitle:@"解绑店铺" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"accRightIcon_gray"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(unbindBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [btn layoutButtonWithEdgeInsetsStyle:QLButtonEdgeInsetsStyleRight imageTitleSpace:10];
        [footer addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.height.equalTo(footer);
            make.width.mas_equalTo(65);
        }];
        
        return footer;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section==0&&indexPath.row==0)?80:50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==0?0.01:30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section==0?0.01:30;
}

@end
