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
#pragma mark -- 下面都是更新过的
/** 更新后的url*/
@property (nonatomic, strong) NSString *changeImageUrl;
/** 店铺名称*/
@property (nonatomic, strong) NSString *storeName;
/** 所在地区*/
@property (nonatomic, strong) NSString *area;
/** 详细地址*/
@property (nonatomic, strong) NSString *detailInfo;


@property (nonatomic, strong) UITextField *t1;
@property (nonatomic, strong) UITextField *t2;
@property (nonatomic, strong) UITextField *t3;
@end

@implementation QLBelongingShopPageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"店铺详情";
    self.view.backgroundColor = [UIColor whiteColor];
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
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    QLBelongingShopTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"belongingShopTextCell" forIndexPath:indexPath];
    NSArray *titles = @[@"门店信息",@"所在地区",@"详细地址",@"照片信息"];
    
    cell.titleLB.text = titles[indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            self.t1 = cell.TextField;
            cell.TextField.text = self.storeName?self.storeName:[QLUserInfoModel getLocalInfo].business.business_name;
        }
            break;
        case 1:
        {
            self.t2 = cell.TextField;
            cell.TextField.text = self.storeName?self.storeName:[QLUserInfoModel getLocalInfo].business.business_area;
        }
            break;
        case 2:
        {
            self.t3 = cell.TextField;
            cell.TextField.text = self.detailInfo?self.detailInfo:[QLUserInfoModel getLocalInfo].business.detailAddress;
        }
            break;
        default:{
            cell.TextField.text = @"";
        }
            break;
    }
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
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

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 140)];
    footerView.userInteractionEnabled = YES;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 0, 100, 100)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    if (self.changeImageUrl) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.changeImageUrl]];
    } else {
        [imageView sd_setImageWithURL:[NSURL URLWithString:[QLUserInfoModel getLocalInfo].business.business_pic]];
    }
    [footerView addSubview:imageView];
    
    footerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabe = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x, 100, ScreenWidth, 40)];
    titleLabe.text = @"店铺门头照片";
    [footerView addSubview:titleLabe];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendImage)];
    [footerView addGestureRecognizer:tap];
    return footerView;
}

- (void)sendImage {

    WEAKSELF
    [[QLToolsManager share] getPhotoAlbum:self resultBack:^(UIImagePickerController *picker, NSDictionary *info) {
        [MBProgressHUD showCustomLoading:nil];
        UIImage *img = info[UIImagePickerControllerOriginalImage];
        [[QLOSSManager shared] asyncUploadImage:img complete:^(NSArray *names, UploadImageState state) {
            [MBProgressHUD immediatelyRemoveHUD];
            if (state == UploadImageSuccess) {
                // 更新本地数据
                [QLNetworkingManager postWithUrl:BusinessPath params:@{
                    Operation_type:@"update_business",
                    @"account_id":[QLUserInfoModel getLocalInfo].account.account_id,
                    @"business_id":[QLUserInfoModel getLocalInfo].business.business_id,
                    @"business_name":[QLUserInfoModel getLocalInfo].business.business_name,
                    @"business_area":[QLUserInfoModel getLocalInfo].business.business_area,
                    @"address":[QLUserInfoModel getLocalInfo].business.detailAddress,
                    @"cover_image":[names firstObject]
                } success:^(id response) {
                    [MBProgressHUD showSuccess:@"图片修改成功"];
                    
                    QLUserInfoModel *model = [QLUserInfoModel getLocalInfo];
                    model.business.business_pic = [names firstObject];
                    [QLUserInfoModel updateUserInfoByModel:model];
                    weakSelf.changeImageUrl = [names firstObject];
                    [weakSelf.tableView reloadData];
                    [weakSelf sendNeedRefresh];
                } fail:^(NSError *error) {
                    [MBProgressHUD showError:error.domain];
                }];
                
                
                
                
            } else {
                [MBProgressHUD showError:@"图片上传失败"];
            }
        }];
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 140;;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (void)saveButton {
    
    if (!self.t1.text || !self.t2.text || !self.t3.text) {
        [MBProgressHUD showError:@"请填写完整"];
        return;
    }
    
    WEAKSELF
    [MBProgressHUD showLoading:nil];
    [QLNetworkingManager postWithUrl:BusinessPath params:@{
        Operation_type:@"update_business",
        @"account_id":[QLUserInfoModel getLocalInfo].account.account_id,
        @"business_id":[QLUserInfoModel getLocalInfo].business.business_id,
        @"business_name":self.t1.text,
        @"business_area":self.t2.text,
        @"address":self.t3.text,
        @"cover_image":[QLUserInfoModel getLocalInfo].business.business_pic
    } success:^(id response) {
        [MBProgressHUD showSuccess:@"修改成功"];
        
        QLUserInfoModel *model = [QLUserInfoModel getLocalInfo];
        model.business.business_name = weakSelf.t1.text;
        model.business.business_area = weakSelf.t2.text;
        model.business.detailAddress = weakSelf.t3.text;
        [QLUserInfoModel updateUserInfoByModel:model];
        [weakSelf.tableView reloadData];
        
        // 通知刷新
        [weakSelf sendNeedRefresh];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

- (void)sendNeedRefresh {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QLMyInfoPageViewControllerRefresh" object:nil];
}

#pragma mark - Lazy
- (QLBelongingShopBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [QLBelongingShopBottomView new];
        [_bottomView.editBtn addTarget:self action:@selector(saveButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}

@end
