//
//  QLCarSourceDetailViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/26.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCarSourceDetailViewController.h"
#import "QLCarCircleNaviView.h"
#import "QLCarDetailHeadView.h"
#import "QLCarDetailSectionView.h"
#import "QLCarDetailTextCell.h"
#import "QLCarDetailPriceCell.h"
#import "QLVehicleConfigCell.h"
#import "QLVehicleDescCell.h"
#import "QLVehicleReportCell.h"
#import "QLTableImgCell.h"
#import "QLCarImgShowCell.h"
#import "QLFunBottomView.h"
#import "QLContactsStoreViewController.h"
#import "QLCarDescViewController.h"
#import <CLPlayerView.h>
#import "QLChatListPageViewController.h"

@interface QLCarSourceDetailViewController ()<UITableViewDelegate,UITableViewDataSource,QLCarDetailHeadViewDelegate>
@property (nonatomic, strong) QLCarCircleNaviView *naviView;
@property (nonatomic, strong) QLCarDetailHeadView *headView;
@property (nonatomic, strong) QLFunBottomView *bottomView;
/** 车辆信息*/
@property (nonatomic, strong) NSDictionary *carData;

/** 外部入参*/
@property (nonatomic, strong) NSDictionary *outData;
@end

@implementation QLCarSourceDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"USERCENTERREFRESH" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(44+(BottomOffset?44:20));
    }];
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

#pragma mark -- 数据更新方法
- (void)updateVcWithData:(NSDictionary *)dic {
    self.outData = dic;
    // 请求车辆信息
    NSDictionary *paraDic = @{
        @"operation_type":@"car/info",
        @"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id?[QLUserInfoModel getLocalInfo].account.account_id:@"",
        @"account_id":[dic objectForKey:@"account_id"]?[dic objectForKey:@"account_id"]:[dic objectForKey:@"belonger"],
        @"car_id":[dic objectForKey:@"car_id"]?[dic objectForKey:@"car_id"]:[dic objectForKey:@"id"]
    };
    
    WEAKSELF
    [QLNetworkingManager postWithUrl: BusinessPath params:paraDic success:^(id response) {
        [weakSelf parseDataWithResponse:response];
        // 刷新背景图
        [weakSelf parseAndRefreshHeaderImage:response];
        // 刷新主数据
        [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

- (void)parseDataWithResponse:(NSDictionary *)response {
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSDictionary *reslutInfo = [response objectForKey:@"result_info"];
        if ([reslutInfo isKindOfClass:[NSDictionary class]]) {
            self.carData = reslutInfo;
        }
    }
}

// 解析并刷新汽车背景图
- (void)parseAndRefreshHeaderImage:(NSDictionary *)response {
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSDictionary *reslutInfo = [response objectForKey:@"result_info"];
        if ([reslutInfo isKindOfClass:[NSDictionary class]]) {
            NSString *headerUrl = [NSString stringWithFormat:@"%@",[[reslutInfo objectForKey:@"car_info"] objectForKey:@"car_img"]];
            self.headView.bannerArr = @[headerUrl];
            //self.headView.headBtn.backgroundColor =[UIColor redColor];
        }
    }
}

#pragma mark - action
//谈价格
- (void)priceBtnClick {
    
    NSString *car_id = [self.outData objectForKey:@"car_id"]?[self.outData objectForKey:@"car_id"]:[self.outData objectForKey:@"id"];
    NSString *account_id = [self.outData objectForKey:@"account_id"]?[self.outData objectForKey:@"account_id"]:[self.outData objectForKey:@"belonger"];
    QLChatListPageViewController *vc = [[QLChatListPageViewController alloc] initWithCarID:car_id messageToID:account_id];
    [self.navigationController pushViewController:vc animated:YES];
}
//加入车库
- (void)joinBtnClick {
    
    NSDictionary *para = @{
        @"operation_type":@"select_car",
        @"business_id":EncodeStringFromDic([self.carData objectForKey:@"car_info"], @"business_id"),
        @"car_ids":EncodeStringFromDic([self.carData objectForKey:@"car_param"], @"id"),
        @"account_id":[QLUserInfoModel getLocalInfo].account.account_id,
        @"state":@"1"
    };
    
    [MBProgressHUD showLoading:@"正在加入"];
    [QLNetworkingManager postWithUrl:BusinessPath params:para success:^(id response) {
        NSString*resultStr = EncodeStringFromDic([response objectForKey:@"result_info"], @"result");
        if ([resultStr isEqualToString:@"success"]) {
            [MBProgressHUD showSuccess:@"已加入"];
        } else {
            [MBProgressHUD showError:resultStr];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
//更多图片
- (void)moreImgBtnClick {
    
}
//检测报告
- (void)checkReport {
    
}
// 播放视频
- (void)uploadControlClick {
    if (self.carData && [self.carData objectForKey:@"car_param"]) {
        
        NSString *vieoUrl = EncodeStringFromDic([self.carData objectForKey:@"car_param"], @"car_video");
        if (vieoUrl.length > 0) {
            // 有视频
            __block UIView* blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            blackView.backgroundColor = [UIColor blackColor];
            [self.view addSubview:blackView];
            
            __block CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, ScreenHeight)];
            [self.view addSubview:playerView];
            
            playerView.url = [NSURL URLWithString:vieoUrl];
            
            [self.view bringSubviewToFront:playerView];
            //播放
            [playerView playVideo];
            //返回按钮点击事件回调
            [playerView backButton:^(UIButton *button) {
                [playerView destroyPlayer];
                playerView = nil;
                [blackView removeFromSuperview];
                blackView = nil;
            }];
            //播放完成回调
            [playerView endPlay:^{
                //销毁播放器
                [playerView destroyPlayer];
                playerView = nil;
                [blackView removeFromSuperview];
                blackView = nil;
            }];
        }
    }
}
//分区头更多按钮点击
- (void)headerAccBtnClick:(UIButton *)sender {
    
}
//分区尾更多按钮点击
- (void)footerAccBtnClick:(UIButton *)sender {
    
    NSString *ship_id = EncodeStringFromDic([self.carData objectForKey:@"friend_ship"], @"ship_id");
    
    NSDictionary *para = @{
        @"ship_id":ship_id,
        @"business_id":EncodeStringFromDic([self.carData objectForKey:@"car_info"], @"business_id"),
        @"accID":EncodeStringFromDic([[self.carData objectForKey:@"car_info"] objectForKey:@"business_car"], @"account_id")
    };
    QLContactsStoreViewController* vc = [[QLContactsStoreViewController alloc]initWithDic:para];
    [self.navigationController pushViewController:vc animated:YES];
}
//轮播图点击
- (void)bannerView:(QLBannerView *)bannerView ImageData:(NSArray *)imageArr Index:(NSInteger)index {
    
}
//分享
- (void)funBtnClick {
    
}
//返回
- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    adjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.backgroundColor = WhiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarDetailTextCell" bundle:nil] forCellReuseIdentifier:@"titleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarDetailPriceCell" bundle:nil] forCellReuseIdentifier:@"priceCell"];
    [self.tableView registerClass:[QLVehicleConfigCell class] forCellReuseIdentifier:@"configCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLVehicleDescCell" bundle:nil] forCellReuseIdentifier:@"descCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLVehicleReportCell" bundle:nil] forCellReuseIdentifier:@"reportCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLTableImgCell" bundle:nil] forCellReuseIdentifier:@"imgCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarImgShowCell" bundle:nil] forCellReuseIdentifier:@"carImgCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    //tableHeaderView
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 250)];
    [tableHeaderView addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tableHeaderView);
    }];
    self.tableView.tableHeaderView = tableHeaderView;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
        case 2:
            return 2;
        default:
        {
            // 汽车的图片
            NSArray *carAttr = [self.carData objectForKey:@"car_attr"];
            if ([carAttr isKindOfClass:[NSArray class]]) {
                return carAttr.count;
            }
            return 0;
        }
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 车辆名称
            QLCarDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
            if (self.carData) {
                cell.titleLB.text = [NSString stringWithFormat:@"%@",[[self.carData objectForKey:@"car_info"] objectForKey:@"model"]];
            }
            return cell;
        } else {
            // 车辆价格
            QLCarDetailPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"priceCell" forIndexPath:indexPath];
            [cell updateWithDic:self.carData];
            return cell;
        }
    } else if (indexPath.section == 1) {
        // 车辆信息
        QLVehicleConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"configCell" forIndexPath:indexPath];
        if (self.carData) {
            [cell updateWithDic:self.carData];
        }
        return cell;
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            // 车辆描述
            QLVehicleDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descCell" forIndexPath:indexPath];
            [cell.uploadControl addTarget:self action:@selector(uploadControlClick) forControlEvents:UIControlEventTouchUpInside];
            [cell updateWithDic:self.carData];
            return cell;
        } else {
            QLVehicleReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reportCell" forIndexPath:indexPath];
            return cell;
        }
    } else {
        //        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        //            QLCarImgShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carImgCell" forIndexPath:indexPath];
        //            [cell.checkReportBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        //            [cell.checkReportBtn addTarget:self action:@selector(moreImgBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //            return cell;
        //        } else {
        //
        //        }
        
        QLTableImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imgCell" forIndexPath:indexPath];
        NSString *imgUrl = @"";
        NSArray *carAttr = [self.carData objectForKey:@"car_attr"];
        if ([carAttr isKindOfClass:[NSArray class]] && indexPath.row < carAttr.count) {
            imgUrl = EncodeStringFromDic(carAttr[indexPath.row], @"pic_url");
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!error) {
                    cell.imgHeight.constant = (self.view.width-30)*(image.size.height/image.size.width);
                }
            }];
        }
        
        return cell;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        QLCarDetailSectionView *sectionView = [QLCarDetailSectionView new];
        sectionView.titleLB.text = section==1?@"车辆信息":section==2?@"车辆描述":@"车辆图片";
        sectionView.moreBtn.tag = section;
        sectionView.moreBtn.hidden = section==1?NO:YES;
        [sectionView.moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [sectionView.moreBtn addTarget:self action:@selector(headerAccBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return sectionView;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        QLCarDetailSectionView *sectionView = [QLCarDetailSectionView new];
        sectionView.titleLB.text = @"";
        sectionView.collectBtn.hidden = YES;
        sectionView.moreBtn.tag = section;
        sectionView.moreBtn.hidden = NO;
        [sectionView.moreBtn setTitle:@"TA的车源" forState:UIControlStateNormal];
        [sectionView.moreBtn addTarget:self action:@selector(footerAccBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return sectionView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section != 0?45:0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 2?45:0.01;
}
#pragma mark - Lazy
- (QLCarCircleNaviView *)naviView {
    if(!_naviView) {
        _naviView = [QLCarCircleNaviView new];
        [_naviView.funBtn setImage:[UIImage imageNamed:@"share_white"] forState:UIControlStateNormal];
        [_naviView.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_naviView.funBtn addTarget:self action:@selector(funBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _naviView;
}
- (QLCarDetailHeadView *)headView {
    if(!_headView) {
        _headView = [[QLCarDetailHeadView alloc] init];
        _headView.headBtn.hidden = YES;
        _headView.nameLB.hidden = YES;
        _headView.delegate = self;
    }
    return _headView;
}
- (QLFunBottomView *)bottomView {
    if(!_bottomView) {
        _bottomView = [QLFunBottomView new];
        [_bottomView.aBtn setTitle:@"加入我的车库" forState:UIControlStateNormal];
        [_bottomView.bBtn setTitle:@"谈谈价格" forState:UIControlStateNormal];
        [_bottomView.aBtn addTarget:self action:@selector(joinBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.bBtn addTarget:self action:@selector(priceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}
@end
