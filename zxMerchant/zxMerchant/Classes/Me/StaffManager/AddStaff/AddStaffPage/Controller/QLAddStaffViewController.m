//
//  QLAddStaffViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2021/2/21.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLAddStaffViewController.h"


@interface QLAddStaffViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIButton *codeBtn;
/** 手机号*/
@property (nonatomic, strong) UITextField *phoneNumberField;
/** 角色*/
@property (nonatomic, strong) NSDictionary *roleDic;

@property (nonatomic, strong) UIImageView *bImageView;
@property (nonatomic, strong) UIImageView *aImageView;

/** 正面*/
@property (nonatomic, strong) NSString *frontImg;
@property (nonatomic, strong) NSString *backImg;
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
- (void)codeBtnClick:(UIButton *)button {
    // 获取验证码
    if ([NSString phoneNumAuthentication:self.phoneNumberField.text] == NO) {
        [MBProgressHUD showError:@"请输入正确手机号"];
        return;
    }
    [QLNetworkingManager postWithParams:@{@"operation_type":@"send_verification_code",@"mobile":@"18061732918"} success:^(id response) {
        NSDictionary *resDic = response;
        NSString * infoStr = [resDic objectForKey:@"result_info"];
        if ([infoStr isKindOfClass:[NSString class]] && [infoStr isEqualToString:@"success"]) {
            [MBProgressHUD showSuccess:@"发送成功"];
            [[QLToolsManager share] codeBtnCountdown:button Pattern:1];
        } else {
            [MBProgressHUD showSuccess:infoStr];
        }
    } fail:^(NSError *error) {

        [MBProgressHUD showError:@"验证码发送失败"];
    }];
    
}
- (void)aControlClick:(UIControl *)control {
    // 打开相册
    WEAKSELF
    [[QLToolsManager share] getPhotoAlbum:self resultBack:^(UIImagePickerController *picker, NSDictionary *info) {
        UIImage *img = info[UIImagePickerControllerOriginalImage];
        weakSelf.aImageView.image = img;
        weakSelf.frontImg = [UIImageJPEGRepresentation(img, 0.2f) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }];
}


- (void)aControlClick2:(UIControl *)control {
    
    WEAKSELF
    [[QLToolsManager share] getPhotoAlbum:self resultBack:^(UIImagePickerController *picker, NSDictionary *info) {
        UIImage *img = info[UIImagePickerControllerOriginalImage];
        weakSelf.bImageView.image = img;
        weakSelf.backImg = [UIImageJPEGRepresentation(img, 0.2f) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }];
    
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
    return section==0?4:3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1&&indexPath.row > 0) {
        QLSubmitImgConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"submitImgConfigCell" forIndexPath:indexPath];
        cell.titleLBHeight.constant = 0;
        cell.titleLBBottom.constant = 0;
        cell.titleLB.hidden = YES;
        cell.aControl.tag = indexPath.row;
        cell.bControl.tag = indexPath.row;
        
        if (indexPath.row == 1) {
            self.aImageView = cell.aImgView;
            [cell.aControl addTarget:self action:@selector(aControlClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (indexPath.row == 2) {
            self.bImageView = cell.aImgView;
            [cell.aControl addTarget:self action:@selector(aControlClick2:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
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
                self.phoneNumberField = cell.contentTF;
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
        WEAKSELF
        QLEditPermissionViewController *epVC = [QLEditPermissionViewController new];
        epVC.block = ^(NSDictionary * _Nonnull param) {
            // 选过了
            QLContentTFCell*cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            cell.contentTF.text = [NSString stringWithFormat:@"%@",[param objectForKey:@"role_name"]];
            weakSelf.roleDic = param;
        };
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

- (void)sendAddNew {
    NSMutableArray *textArr = [NSMutableArray array];
    // 搜集所有的数据
    for (NSUInteger i = 0; i < 4; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        QLContentTFCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSString *text = cell.contentTF.text;
        if (!text) {
            [MBProgressHUD showError:@"所有项为必填项"];
            return;
        }
        [textArr addObject:text];
    }
    
    if (![self.roleDic.allKeys containsObject:@"business_role_id"]) {
        [MBProgressHUD showError:@"请选择权限"];
        return;
    }
    
    // 身份证照片
    if (!self.frontImg || !self.backImg) {
        [MBProgressHUD showError:@"请上传照片"];
        return;
    }
    
    NSDictionary *data = @{
        @"operation_type":@"add_business_personnel",
        @"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id,
        @"business_id":[QLUserInfoModel getLocalInfo].business.business_id,
        @"nickname":textArr[0],
        @"mobile":textArr[1],
        @"code":textArr[2],
        @"password":[textArr[3] md5Str],
        @"role_data":(@{
            @"role_id":[self.roleDic objectForKey:@"business_role_id"],
            @"role_name":[self.roleDic objectForKey:@"role_name"]
                      }),
        @"idcard_front_pic":self.frontImg,
        @"idcard_back_pic":self.backImg
    };
    // 发送请求
    [QLNetworkingManager postWithUrl:BusinessPath params:data success:^(id response) {
        [MBProgressHUD showSuccess:@"已提交审核"];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
    
}

#pragma mark - Lazy
- (QLSubmitBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [QLSubmitBottomView new];
        [_bottomView.funBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_bottomView.funBtn addTarget:self action:@selector(sendAddNew) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}
- (UIButton *)codeBtn {
    if (!_codeBtn) {
        _codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 85, 15)];
        [_codeBtn setTitleColor:GreenColor forState:UIControlStateNormal];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeBtn addTarget:self action:@selector(codeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeBtn;
}
@end
