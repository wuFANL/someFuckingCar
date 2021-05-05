//
//  QLAddStaffViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2021/2/21.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLAddStaffViewController.h"


@interface QLAddStaffViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *codeBtn;
@end

@implementation QLAddStaffViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新建账号";
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    //tableView
    [self tableViewSet];
}
#pragma mark - action
- (void)codeBtnClick {
    // 获取验证码
    
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
    [self.tableView registerNib:[UINib nibWithNibName:@"QLContentTFCell" bundle:nil] forCellReuseIdentifier:@"tfCell"];
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
    return section==0?5:3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1&&indexPath.row > 0) {
        QLSubmitImgConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"submitImgConfigCell" forIndexPath:indexPath];
        cell.titleLBHeight.constant = 0;
        cell.titleLBBottom.constant = 0;
        cell.titleLB.hidden = YES;
        cell.aControl.tag = indexPath.row;
        cell.bControl.tag = indexPath.row;
        [cell.aControl addTarget:self action:@selector(aControlClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.bControl addTarget:self action:@selector(bControlClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell updateWithStaff:self.isAddStaff andIndexPath:indexPath.row];
        return cell;
    } else {
        QLContentTFCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tfCell" forIndexPath:indexPath];
        cell.lineViewRight.constant = 0;
        cell.lineView.hidden = NO;
        cell.accImgView.hidden = YES;
        
        NSString *title = @"";
        NSString *placeholder = @"";
        if (indexPath.section == 0) {
            placeholder = @"请输入";
            cell.contentTF.enabled = YES;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if (indexPath.row == 0) {
                title = @"姓名";
            } else if (indexPath.row == 1) {
                title = @"手机";
            } else if (indexPath.row == 2) {
                title = @"验证码";
                //获取验证码按钮
                [cell.contentView addSubview:self.codeBtn];
                [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.contentView);
                    make.right.equalTo(cell.contentView).offset(-12);
                }];
                
                [cell.contentTF mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.codeBtn.mas_left).offset(-8);
                }];
            } else if (indexPath.row == 3) {
                title = @"密码";
            } else if (indexPath.row == 4) {
                title = @"确认密码";
            }
        } else {
            title = @"权限设置";
            placeholder = @"请选择";
            cell.contentTF.enabled = NO;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.accessoryView = nil;
        }
        
        cell.titleLB.text = title;
        cell.contentTF.placeholder = placeholder;
        
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1&&indexPath.row == 0) {
        //权限管理
        QLEditPermissionViewController *epVC = [QLEditPermissionViewController new];
        [self.navigationController pushViewController:epVC animated:YES];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [UIView new];
        UILabel *lb = [UILabel new];
        lb.font = [UIFont systemFontOfSize:15];
        lb.textColor = [UIColor colorWithHexString:@"#999999"];
        lb.text = @"基本资料";
        [headerView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.left.mas_equalTo(16);
        }];
        return headerView;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1&&indexPath.row > 0?150:44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==0?40:10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
#pragma mark - Lazy
- (QLSubmitBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [QLSubmitBottomView new];
        [_bottomView.funBtn setTitle:@"保存" forState:UIControlStateNormal];
    }
    return _bottomView;
}
- (UIButton *)codeBtn {
    if (!_codeBtn) {
        _codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 85, 15)];
        [_codeBtn setTitleColor:GreenColor forState:UIControlStateNormal];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeBtn addTarget:self action:@selector(codeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeBtn;
}
@end
