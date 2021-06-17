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
#import "QLOSSManager.h"

@interface QLMyInfoPageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *dataDic;

/** 头像按钮*/
@property (nonatomic, strong) QLBaseButton *headerButton;

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
    [MBProgressHUD showLoading:nil];
    // 请求店铺信息
    WEAKSELF
    [QLNetworkingManager postWithUrl:BusinessPath params:@{
        Operation_type:@"my_store",
        @"account_id":[QLUserInfoModel getLocalInfo].account.account_id,
        @"business_id":[QLUserInfoModel getLocalInfo].business.business_id
    } success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        weakSelf.dataDic = [[response objectForKey:@"result_info"] objectForKey:@"business_info"];
        [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"QLMyInfoPageViewControllerRefresh" object:nil];
}



- (void)refreshTableView {
    WEAKSELF
    [QLNetworkingManager postWithUrl:BusinessPath params:@{
        Operation_type:@"my_store",
        @"account_id":[QLUserInfoModel getLocalInfo].account.account_id,
        @"business_id":[QLUserInfoModel getLocalInfo].business.business_id
    } success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        weakSelf.dataDic = [[response objectForKey:@"result_info"] objectForKey:@"business_info"];
        [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - action
//解除绑定
- (void)unbindBtnClick {
    QLUnbindStoreView *unbindView = [QLUnbindStoreView new];
    [unbindView show];
}
//头像按钮
- (void)headBtnClick {
    // 选头像
    WEAKSELF
    [[QLToolsManager share] getPhotoAlbum:self resultBack:^(UIImagePickerController *picker, NSDictionary *info) {
        UIImage *img = info[UIImagePickerControllerOriginalImage];
        [MBProgressHUD showLoading:nil];
        [[QLOSSManager shared] syncUploadImage:img complete:^(NSArray *names, UploadImageState state) {
            // 上传头像
            NSString* url = [names firstObject];
            [QLNetworkingManager postWithUrl:UserPath params:@{
                Operation_type:@"update_account",
                @"acccount_id":[QLUserInfoModel getLocalInfo].account.account_id,
                @"head_pic":url
            } success:^(id response) {
                [weakSelf.headerButton setImage:img forState:UIControlStateNormal];
                [MBProgressHUD showSuccess:@"上传成功"];
                // 更新本地数据
                QLUserInfoModel *model = [QLUserInfoModel getLocalInfo];
                model.account.head_pic = url;
                [QLUserInfoModel updateUserInfoByModel:model];
                // 通知前一个页面刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:@"USERCENTERREFRESH" object:nil];
            } fail:^(NSError *error) {
                [MBProgressHUD showError:error.domain];
            }];
        }];
    }];
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
            self.headerButton = headBtn;
            headBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [headBtn sd_setImageWithURL:[NSURL URLWithString:[QLUserInfoModel getLocalInfo].account.head_pic] forState:UIControlStateNormal];
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
            acc = [QLUserInfoModel getLocalInfo].account.nickname;
        } else if (indexPath.row == 2) {
            title = @"手机";
            acc = [QLUserInfoModel getLocalInfo].account.mobile;
        } else if (indexPath.row == 3) {
            title = @"帐号";
            acc = [QLUserInfoModel getLocalInfo].account.account_number;
        } else if (indexPath.row == 4) {
            title = @"会员到期";
            acc = [QLUserInfoModel getLocalInfo].account.vip_end_date;
        } else if (indexPath.row == 5) {
            title = @"个人信息认证";
            acc = @"认证通过";
        }
    } else {
        if (indexPath.row == 0) {
            title = @"归属店铺";
            acc = EncodeStringFromDic(self.dataDic, @"business_name");
        } else if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            title = @"所在地区";
            acc = EncodeStringFromDic(self.dataDic, @"business_area");
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            title = @"门店地址";
//            acc = [NSString stringWithFormat:@"%@%@%@",EncodeStringFromDic(self.dataDic, @"province"),EncodeStringFromDic(self.dataDic, @"city"),EncodeStringFromDic(self.dataDic, @"county")];
            acc = EncodeStringFromDic(self.dataDic, @"address");
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
        } else if (indexPath.row == 0 ) {
            
        }
    } else {
//        if (indexPath.row == 0) {
//
//        }
        //归属店铺
        QLBelongingShopPageViewController *bspVC = [QLBelongingShopPageViewController new];
        [self.navigationController pushViewController:bspVC animated:YES];
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
//    if (section == 1) {
//        UIView *footer = [UIView new];
//
//        UIButton *btn = [UIButton new];
//        btn.titleLabel.font = [UIFont systemFontOfSize:13];
//        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [btn setTitle:@"解绑店铺" forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"accRightIcon_gray"] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(unbindBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [btn layoutButtonWithEdgeInsetsStyle:QLButtonEdgeInsetsStyleRight imageTitleSpace:10];
//        [footer addSubview:btn];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.height.equalTo(footer);
//            make.width.mas_equalTo(65);
//        }];
//
//        return footer;
//    }
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
