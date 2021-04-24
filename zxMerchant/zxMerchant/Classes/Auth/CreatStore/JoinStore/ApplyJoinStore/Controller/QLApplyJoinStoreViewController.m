//
//  QLApplyJoinStoreViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/2.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLApplyJoinStoreViewController.h"
#import "QLSubmitBottomView.h"
#import "QLSubmitImgConfigCell.h"
#import "QLCreatStoreTFCell.h"
#import "QLOSSManager.h"
#import "QLJoinStoreDetailViewController.h"

@interface QLApplyJoinStoreViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLSubmitBottomView *bottomView;
@property (nonatomic, strong) NSString *headImageV;
@property (nonatomic, strong) NSString *cardFront;
@property (nonatomic, strong) NSString *cardbackG;
@property (nonatomic, strong) NSString *nameString;

@property (nonatomic, strong) QLSubmitImgConfigCell *headerCell;
@property (nonatomic, strong) QLSubmitImgConfigCell *cardFrontCell;
@property (nonatomic, strong) QLSubmitImgConfigCell *cardBackGCell;
@end

@implementation QLApplyJoinStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

//加入车行
- (void)addShopRequest {
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:BusinessPath params:@{@"operation_type":@"join_business",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"business_id":self.bussiness_id,@"name":self.nameString,@"head_pic":self.headImageV,@"idcar_font_pic":self.cardFront,@"idcar_back_pic":self.cardbackG} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        
        QLJoinStoreDetailViewController *jsdVC = [[QLJoinStoreDetailViewController alloc] initWithDataDic:@{@"operation_type":@"application_information",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"business_id":self.bussiness_id}];
        [self.navigationController pushViewController:jsdVC animated:YES];
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

#pragma mark - action
//提交
- (void)submitBtnClick {
    if([NSString isEmptyString:self.headImageV])
    {
        [MBProgressHUD showError:@"请上传头像"];
        return;
    }
    if([NSString isEmptyString:self.cardFront])
    {
        [MBProgressHUD showError:@"请上传身份证正面"];
        return;
    }
    if([NSString isEmptyString:self.cardbackG])
    {
        [MBProgressHUD showError:@"请上传身份证背面"];
        return;
    }
    if([NSString isEmptyString:self.nameString])
    {
        [MBProgressHUD showError:@"请输入姓名"];
        return;
    }
    [self addShopRequest];
}
//选择图片
- (void)aControlClick:(UIControl *)control {
    [[QLToolsManager share] getPhotoAlbum:self resultBack:^(UIImagePickerController *picker, NSDictionary *info) {
         //选择的图片
        [MBProgressHUD showCustomLoading:nil];
        UIImage *img = info[UIImagePickerControllerOriginalImage];
        switch (control.tag) {
            case 0:
            {
                [[QLOSSManager shared] asyncUploadImage:img complete:^(NSArray *names, UploadImageState state) {
                    [MBProgressHUD immediatelyRemoveHUD];
                    if (state == UploadImageSuccess) {
                        self.headImageV = [names firstObject];
                        self.headerCell.aImgView.image = img;
                    } else {
                        [MBProgressHUD showError:@"图片上传失败"];
                    }
                }];
            }
                break;
            case 1:
            {
                [[QLOSSManager shared] asyncUploadImage:img complete:^(NSArray *names, UploadImageState state) {
                    [MBProgressHUD immediatelyRemoveHUD];
                    if (state == UploadImageSuccess) {
                        self.cardFront = [names firstObject];
                        self.cardFrontCell.aImgView.image = img;
                    } else {
                        [MBProgressHUD showError:@"图片上传失败"];
                    }
                }];
            }
                break;
            case 2:
            {
                [[QLOSSManager shared] asyncUploadImage:img complete:^(NSArray *names, UploadImageState state) {
                    [MBProgressHUD immediatelyRemoveHUD];
                    if (state == UploadImageSuccess) {
                        self.cardbackG = [names firstObject];
                        self.cardBackGCell.aImgView.image = img;
                    } else {
                        [MBProgressHUD showError:@"图片上传失败"];
                    }
                }];
            }
                break;
                
            default:
                break;
        }
        
    }];
}
//输入栏内容发生变化
- (void)textFieldTextChange:(UITextField *)tf {
    self.nameString = tf.text;
    if([NSString isEmptyString:self.nameString])
    {
        self.nameString = [QLUserInfoModel getLocalInfo].account.nickname;
    }
}
#pragma mark -tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.backgroundColor = WhiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCreatStoreTFCell" bundle:nil] forCellReuseIdentifier:@"tfCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLSubmitImgConfigCell" bundle:nil] forCellReuseIdentifier:@"submitImgConfigCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        QLCreatStoreTFCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tfCell" forIndexPath:indexPath];
        cell.accImgView.hidden = YES;
        cell.tf.enabled = YES;
        cell.tf.tag = indexPath.row;
        if([NSString isEmptyString:[QLUserInfoModel getLocalInfo].account.nickname]) {
            cell.tf.placeholder = @"输入姓名";
        } else {
            cell.tf.text = [QLUserInfoModel getLocalInfo].account.nickname;
            self.nameString = [QLUserInfoModel getLocalInfo].account.nickname;
        }
        [cell.tf addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    } else {
        QLSubmitImgConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"submitImgConfigCell" forIndexPath:indexPath];
        cell.titleLBHeight.constant = 0;
        cell.titleLBBottom.constant = 0;
        cell.titleLB.hidden = YES;
        cell.aControl.tag = indexPath.row;
        cell.bControl.tag = indexPath.row;
        [cell.aControl addTarget:self action:@selector(aControlClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.bControl.hidden = NO;
        cell.bTitleLB.text = @"图例";
        if (indexPath.row == 0) {
            cell.bControl.hidden = YES;
            cell.aTitleLB.text = @"头像";
            self.headerCell = cell;
        } else if (indexPath.row == 1) {
            cell.bImgView.image = [UIImage imageNamed:@"ID_card_front"];
            cell.aTitleLB.text = @"上传身份证正面";
            self.cardFrontCell = cell;
        } else if (indexPath.row == 2) {
            cell.bImgView.image = [UIImage imageNamed:@"ID_card_back"];
            cell.aTitleLB.text = @"上传身份证反面";
            self.cardBackGCell = cell;
        }
        return cell;
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    [headerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.left.equalTo(headerView).offset(30);
    }];
    
    NSMutableAttributedString *string;
    if (section == 0) {
        string = [[NSMutableAttributedString alloc] initWithString:@"加入店铺" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 30],NSForegroundColorAttributeName: [UIColor colorWithRed:48/255.0 green:56/255.0 blue:66/255.0 alpha:1.0]}];
        
    }
    label.attributedText = string;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0?60:0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
#pragma mark - Lazy
- (QLSubmitBottomView *)bottomView {
    if(!_bottomView) {
        _bottomView = [QLSubmitBottomView new];
        [_bottomView.funBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_bottomView.funBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}
@end
