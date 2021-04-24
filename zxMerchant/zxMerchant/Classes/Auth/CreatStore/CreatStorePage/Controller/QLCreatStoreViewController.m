//
//  QLCreatStoreViewController.m
//  PopularUsedCarMerchant
//
//  Created by lei qiao on 2020/9/21.
//  Copyright © 2020 EmbellishJiao. All rights reserved.
//

#import "QLCreatStoreViewController.h"
#import "QLSubmitBottomView.h"
#import "QLCreatStoreTFCell.h"
#import "QLCreatStoreTVCell.h"
#import "QLSubmitImgConfigCell.h"
#import "QLPCAListViewController.h"
#import "QLSearchStoreListViewController.h"

@interface QLCreatStoreViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLSubmitBottomView *bottomView;
@property (nonatomic, strong) NSMutableArray *imgsArr;
@property (nonatomic, strong) QLBusinessModel *storeModel;

//地址字典
@property (nonatomic, strong) NSDictionary *locationDic;

@property (nonatomic, strong) QLCreatStoreTFCell *nameCell;
@property (nonatomic, strong) QLCreatStoreTFCell *storeNameCell;
@property (nonatomic, strong) QLCreatStoreTFCell *storeLocationCell;
@property (nonatomic, strong) QLCreatStoreTVCell *storeAddressCell;

@property (nonatomic, strong) QLSubmitImgConfigCell *storeCoverCell;
@property (nonatomic, strong) NSString *coverImageStr;
@property (nonatomic, strong) QLSubmitImgConfigCell *cardFrontCell;
@property (nonatomic, strong) NSString *cardFImageStr;
@property (nonatomic, strong) QLSubmitImgConfigCell *cardBackCell;
@property (nonatomic, strong) NSString *cardBImageStr;

@end

@implementation QLCreatStoreViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0, 0, 15,26);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"grayBack"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];;
    //创建UIBarButtonSystemItemFixedSpace
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width = -15;
    //将两个BarButtonItem都返回给NavigationItem
    self.navigationItem.leftBarButtonItems = @[spaceItem,leftBarBtn];
    
    UIButton *joinBtn = [UIButton new];
    joinBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [joinBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [joinBtn setTitle:@" 加入店铺" forState:UIControlStateNormal];
    [joinBtn setImage:[UIImage imageNamed:@"addressAdd"] forState:UIControlStateNormal];
    [joinBtn addTarget:self action:@selector(joinStoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:joinBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
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
#pragma mark - network
- (void)creatStoreRequest {
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:BusinessPath params:@{
        @"operation_type":@"create_business",
        @"account_id":self.account_id,
        @"name":self.nameCell.tf.text,
        @"business_name":self.storeNameCell.tf.text,
        @"business_area":[self.locationDic objectForKey:@"shi"],
        @"address":self.storeAddressCell.tv.text.length > 0?self.storeAddressCell.tv.text:@"",
        @"cover_image":self.coverImageStr,
        @"idcar_back_pic":self.cardBImageStr,
        @"idcar_font_pic":self.cardFImageStr,
        @"province":[self.locationDic objectForKey:@"sheng"],
        @"city":[self.locationDic objectForKey:@"shi"],
        @"county":[self.locationDic objectForKey:@"qu"],
        @"region_code":[self.locationDic objectForKey:@"quma"]
    } success:^(id response) {
        [MBProgressHUD showSuccess:@"创建成功"];
        //进入首页
        [[QLToolsManager share] getFunData:^(id result, NSError *error) {
            [AppDelegateShare initTabBarVC];
        }];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
#pragma mark - action
//创建店铺
- (void)creatStoreBtnClick {
    if([NSString isEmptyString:self.nameCell.tf.text])
    {
        [MBProgressHUD showError:@"请输入姓名"];
        return;
    }
    if([NSString isEmptyString:self.storeNameCell.tf.text])
    {
        [MBProgressHUD showError:@"请输入门店名称"];
        return;
    }
    if([NSString isEmptyString:self.storeLocationCell.tf.text])
    {
        [MBProgressHUD showError:@"请选择区域"];
        return;
    }
    if([NSString isEmptyString:self.coverImageStr])
    {
        [MBProgressHUD showError:@"请上传店铺头像"];
        return;
    }
    if([NSString isEmptyString:self.cardFImageStr])
    {
        [MBProgressHUD showError:@"请上传身份证正面"];
        return;
    }
    if([NSString isEmptyString:self.cardBImageStr])
    {
        [MBProgressHUD showError:@"请上传身份证背面"];
        return;
    }
    [self creatStoreRequest];
}
//加入店铺
- (void)joinStoreBtnClick {
    QLSearchStoreListViewController *sjlVC = [QLSearchStoreListViewController new];
    [self.navigationController pushViewController:sjlVC animated:YES];
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
                        self.coverImageStr = [names firstObject];
                        self.storeCoverCell.aImgView.image = img;
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
                        self.cardFImageStr = [names firstObject];
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
                        self.cardBImageStr = [names firstObject];
                        self.cardBackCell.aImgView.image = img;
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
    if (tf.tag == 0) {
        self.storeModel.name = tf.text;
    } else if (tf.tag == 1) {
        self.storeModel.business_name = tf.text;
    }
    
}
//返回按钮
- (void)leftBarBtnClicked {
    if (self.backToTab) {
        [AppDelegateShare initTabBarVC];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCreatStoreTVCell" bundle:nil] forCellReuseIdentifier:@"tvCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLSubmitImgConfigCell" bundle:nil] forCellReuseIdentifier:@"submitImgConfigCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0?4:3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row != 3) {
            QLCreatStoreTFCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tfCell" forIndexPath:indexPath];
            cell.accImgView.hidden = YES;
            cell.tf.enabled = YES;
            cell.tf.tag = indexPath.row;
            if (indexPath.row == 0) {
                cell.tf.placeholder = @"输入姓名";
                self.nameCell = cell;
            } else if (indexPath.row == 1) {
                cell.tf.placeholder = @"门店名称";
                self.storeNameCell = cell;
            } else {
                cell.tf.placeholder = @"所在区域";
                cell.accImgView.hidden = NO;
                cell.tf.enabled = NO;
                self.storeLocationCell = cell;
            }
            [cell.tf addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
            return cell;
        } else {
            QLCreatStoreTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tvCell" forIndexPath:indexPath];
            cell.tv.placeholder = @"输入地址,无实体店无需输入(非必填)";
            cell.tv.constraintLB.hidden = YES;
            self.storeAddressCell = cell;
            return cell;
        }
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
            cell.aTitleLB.text = @"店铺头像";
            self.storeCoverCell = cell;
        } else if (indexPath.row == 1) {
            cell.bImgView.image = [UIImage imageNamed:@"ID_card_front"];
            cell.aTitleLB.text = @"上传身份证正面";
            self.cardFrontCell = cell;
        } else if (indexPath.row == 2) {
            cell.bImgView.image = [UIImage imageNamed:@"ID_card_back"];
            cell.aTitleLB.text = @"上传身份证反面";
            self.cardBackCell = cell;
        }
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0&&indexPath.row == 2) {
        //选择所在区域
        QLPCAListViewController *ccVC = [QLPCAListViewController new];
        [ccVC setSelectedBlock:^(NSDictionary * sourceDic) {
            self.locationDic = [sourceDic copy];
            self.storeLocationCell.tf.text = [self.locationDic objectForKey:@"shi"];
        }];
        [self.navigationController pushViewController:ccVC animated:YES];
        
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
        string = [[NSMutableAttributedString alloc] initWithString:@"生成店铺" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 30],NSForegroundColorAttributeName: [UIColor colorWithRed:48/255.0 green:56/255.0 blue:66/255.0 alpha:1.0]}];
        
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
        [_bottomView.funBtn setTitle:@"生成店铺" forState:UIControlStateNormal];
        [_bottomView.funBtn addTarget:self action:@selector(creatStoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}
- (QLBusinessModel *)storeModel {
    if (!_storeModel) {
        _storeModel = [QLBusinessModel new];
    }
    return _storeModel;
}
@end
