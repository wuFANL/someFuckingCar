//
//  QLStaffDetailViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2021/2/23.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLStaffDetailViewController.h"
#import "QLBelongingShopBottomView.h"
#import "QLBelongingShopInfoCell.h"
#import "QLEditPermissionCell.h"
#import "QLAccountInfoCell.h"
#import "QLSubmitImgConfigCell.h"
#import "QLEditStaffInfoViewController.h"

@interface QLStaffDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLBelongingShopBottomView *bottomView;

@end

@implementation QLStaffDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"员工详情";
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    //tableView
    [self tableViewSet];
    
}
#pragma mark - action
- (void)editBtnClick {
    if (self.status == InviteSuccess) {
        //重新编辑
        QLEditStaffInfoViewController *esiVC = [QLEditStaffInfoViewController new];
        [self.navigationController pushViewController:esiVC animated:YES];
    }
}
- (void)cancelBtnClick {
    [[QLToolsManager share] alert:@"您确定要删除吗?" handler:^(NSError *error) {
        if (!error) {
           
        }
    }];
}
- (void)aControlClick:(UIControl *)control {
    
}
- (void)bControlClick:(UIControl *)control {
    
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLBelongingShopInfoCell" bundle:nil] forCellReuseIdentifier:@"belongingShopInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLEditPermissionCell" bundle:nil] forCellReuseIdentifier:@"permissionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLAccountInfoCell" bundle:nil] forCellReuseIdentifier:@"infoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLSubmitImgConfigCell" bundle:nil] forCellReuseIdentifier:@"submitImgConfigCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        if (self.status == WaitStoreAgreen) {
            return 3;
        } else if (self.status == InviteSuccess) {
            return 5;
        } else {
            return 2;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QLBelongingShopInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"belongingShopInfoCell" forIndexPath:indexPath];
        
        return cell;
    } else {
        if (self.status != InviteSuccess) {
            if (indexPath.row == 0||indexPath.row == 1) {
                QLAccountInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
                cell.callBtn.hidden = YES;
                cell.titleLB.text = @"时间";
                cell.detailLB.text = @"2020年10月10日";
                return cell;
            } else {
                QLSubmitImgConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"submitImgConfigCell" forIndexPath:indexPath];
                cell.titleLBHeight.constant = 0;
                cell.titleLBBottom.constant = 0;
                cell.titleLB.hidden = YES;
                cell.aControl.tag = indexPath.row;
                cell.bControl.tag = indexPath.row;
                [cell.aControl addTarget:self action:@selector(aControlClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.bControl addTarget:self action:@selector(bControlClick:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
        } else {
            QLEditPermissionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"permissionCell" forIndexPath:indexPath];
            cell.selectBtnHeight.constant = 0;
            
            return cell;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *header = [UIView new];
        
        UILabel *lb = [UILabel new];
        lb.font = [UIFont systemFontOfSize:15];
        lb.textColor = [UIColor darkGrayColor];
        lb.text = self.status == InviteSuccess?@"权限":@"基础信息";
        [header addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header).offset(16);
            make.centerY.equalTo(header);
        }];
        
        return header;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0?120 : self.status == InviteSuccess?70:(indexPath.row==2?120:44);
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
    
        if (self.status == WaitStaffAgreen) {
            _bottomView.editBtn.hidden = YES;
            [_bottomView.cancelBtn setTitle:@"取消邀请" forState:UIControlStateNormal];
            [_bottomView.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(_bottomView);
            }];
            [_bottomView.cancelBtn  layoutButtonWithEdgeInsetsStyle:QLButtonEdgeInsetsStyleTop imageTitleSpace:5];
        } else if (self.status == WaitStoreAgreen) {
            [_bottomView.cancelBtn setTitle:@"拒绝" forState:UIControlStateNormal];
            [_bottomView.editBtn setTitle:@"同意" forState:UIControlStateNormal];
        } else if (self.status == InviteSuccess) {
            [_bottomView.cancelBtn setTitle:@"删除" forState:UIControlStateNormal];
            [_bottomView.editBtn setTitle:@"重新编辑" forState:UIControlStateNormal];
        } else {
            _bottomView.cancelBtn.hidden = YES;
            _bottomView.editBtn.hidden = YES;
        }
        [_bottomView.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}

@end
