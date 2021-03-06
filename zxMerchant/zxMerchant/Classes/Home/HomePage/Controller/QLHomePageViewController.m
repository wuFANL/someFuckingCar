//
//  QLHomePageViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/9/30.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLHomePageViewController.h"
#import "QLHomeNaviView.h"
#import "QLHomePageHeadView.h"
#import "QLHomeToolHeadView.h"
#import "QLHorizontalScrollCell.h"
#import "QLHomeCarItem.h"
#import "QLHomeVisitRecordCell.h"
#import "QLHomeVisitListCell.h"
#import "QLHomeCarCell.h"
#import "QLHomeSearchViewController.h"
#import "QLAddCarPageViewController.h"
#import "QLMyStoreViewController.h"
#import "QLVehicleCertificateViewController.h"
#import "QLPaymentPageViewController.h"
#import "QLMySubscriptionsPageViewController.h"
#import "QLCarSourceDetailViewController.h"
#import "QLPhotosShareViewController.h"
#import "QLStoreSharePageViewController.h"
#import "QLReleaseCarCircleViewController.h"
#import "QLMyHelpSellViewController.h"
#import "QLShareHistoryViewController.h"
#import "QLCarDealersViewController.h"

@interface QLHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,QLHomeNaviViewDelegate,QLBannerViewDelegate,QLHomePageHeadViewDelegate>
@property (nonatomic, strong) QLHomeNaviView *naviView;
@property (nonatomic, strong) QLHomePageHeadView *headView;
@property (nonatomic, strong) QLHomePageModel *homePageModel;

/** 朋友圈*/
@property (nonatomic, strong) NSArray *friendData;
@end

@implementation QLHomePageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    [self getHomeData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getFriendList];
    //tableView
    [self tableViewSet];
    //导航
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(44+(BottomOffset?44:20));
    }];
    
    [[QLLocationManager sharedLocationManager] updateCityWithCompletionHandler:^(CLPlacemark *placemark, CLLocation *location, NSError *error) {
        if (!error) {
            [QLToolsManager share].currentCityName = [placemark.locality stringByReplacingOccurrencesOfString:@"市" withString:@""];
            [QLToolsManager share].currentLocation = location;
        }
        
    }];
}
#pragma mark - network
//首页数据
- (void)getHomeData {
    
    [MBProgressHUD showCustomLoading:nil];
    WEAKSELF
    
    [QLNetworkingManager postWithUrl:HomePath params:@{@"operation_type":@"index",@"account_id":QLNONull([QLUserInfoModel getLocalInfo].account.account_id)} success:^(id response) {
        weakSelf.homePageModel = [QLHomePageModel yy_modelWithJSON:response[@"result_info"]];
        [MBProgressHUD immediatelyRemoveHUD];
        //功能数据筛选
        [weakSelf funDataDo];
        //刷新
        [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

- (void)getFriendList {
    WEAKSELF
    [QLNetworkingManager postWithUrl:BasePath params:@{@"operation_type":@"get_visit_data",@"account_id":QLNONull([QLUserInfoModel getLocalInfo].account.account_id)} success:^(id response) {
        NSDictionary* info = [response objectForKey:@"result_info"];
        if ([info isKindOfClass:[NSDictionary class]]) {
            NSArray * arr =[info objectForKey:@"pic_list"];
            if ([arr isKindOfClass:[NSArray class]]) {
                weakSelf.friendData = arr;
            }
        }
        //刷新
        [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
#pragma mark - action
//查看
- (void)allBtnClick:(UIButton *)sender {
    NSInteger row = sender.tag;
    if (row == 2) {
        //分享记录
        QLShareHistoryViewController *shVC = [QLShareHistoryViewController new];
        [self.navigationController pushViewController:shVC animated:YES];
    } else {
        //车商友
        QLCarDealersViewController *cdVC = [QLCarDealersViewController new];
        [self.navigationController pushViewController:cdVC animated:YES];
        
    }
}
//功能模块点击
- (void)funClick:(QLFunModel *)model {
    if (model.value.integerValue == SubscriptionVehicle) {
        //订阅车辆
        QLMySubscriptionsPageViewController *mspVC = [QLMySubscriptionsPageViewController new];
        [self.navigationController pushViewController:mspVC animated:YES];
    } else if (model.value.integerValue == MyStore) {
        //我的店铺
        QLMyStoreViewController *msVC = [QLMyStoreViewController new];
        [self.navigationController pushViewController:msVC animated:YES];
    } else if (model.value.integerValue == VehicleCertificate) {
        //车辆牌证
        QLVehicleCertificateViewController *vcVC = [QLVehicleCertificateViewController new];
        [self.navigationController pushViewController:vcVC animated:YES];
    } else if (model.value.integerValue == PaymentAccount) {
        //收款卡号
        QLPaymentPageViewController *ppVC = [QLPaymentPageViewController new];
        [self.navigationController pushViewController:ppVC animated:YES];
    } else if (model.value.integerValue == CreditReporting) {
        //征信查询
       
    }
}
//功能模块数据处理
- (void)funDataDo {
    //功能数据筛选
    NSMutableArray *temArr = [NSMutableArray array];
    QLFunModel *fun1Model = [[QLToolsManager share].homePageModel getFun:SubscriptionVehicle];
    QLFunModel *fun2Model = [[QLToolsManager share].homePageModel getFun:MyStore];
    QLFunModel *fun3Model = [[QLToolsManager share].homePageModel getFun:VehicleCertificate];
    QLFunModel *fun4Model = [[QLToolsManager share].homePageModel getFun:PaymentAccount];
    
    if (fun1Model) {
        [temArr addObject:fun1Model];
    }
    if (fun2Model) {
        [temArr addObject:fun2Model];
    }
    if (fun3Model) {
        [temArr addObject:fun3Model];
    }
    if (fun4Model) {
        [temArr addObject:fun4Model];
    }
    
    if (![[QLUserInfoModel getLocalInfo].account.state isEqualToString:@"1"]) {
        if ([temArr containsObject:fun1Model]) {
            [temArr removeObject:fun1Model];
        }
    }
    
    int row = temArr.count/5 > 1?2:1;
    int collectionViewHeight = 95*row;
    self.headView.size = CGSizeMake(self.view.width, 140+collectionViewHeight);
    self.headView.itemArr = temArr;
    
}
//头部按钮
- (void)accBtnClick:(UIButton *)sender {
    // 去找车源
    [self.tabBarController setSelectedIndex:1];
    
}
//轮播图设置
- (void)bannerView:(QLBannerView *)bannerView ImageData:(NSArray *)imageArr Index:(NSInteger)index ImageBtn:(UIButton *)imageBtn {
    [imageBtn setBackgroundImage:[UIImage imageNamed:imageArr[index]] forState:UIControlStateNormal];
}
//轮播图点击
- (void)bannerView:(QLBannerView *)bannerView ImageClick:(NSArray *)imageArr Index:(NSInteger)index ImageBtn:(UIButton *)imageBtn {
    
}
//发车事件
- (void)msgBtnClick {
    QLAddCarPageViewController *acpVC = [QLAddCarPageViewController new];
    [self.navigationController pushViewController:acpVC animated:YES];
}
//搜索点击
- (void)searchBarClick {
    QLHomeSearchViewController *hsVC = [QLHomeSearchViewController new];
    hsVC.searchType = SearchCar;
    [self.navigationController pushViewController:hsVC animated:YES];
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.backgroundColor = WhiteColor;
    adjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLHomeCarCell" bundle:nil] forCellReuseIdentifier:@"hCarCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLHomeVisitRecordCell" bundle:nil] forCellReuseIdentifier:@"recordCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLHomeVisitListCell" bundle:nil] forCellReuseIdentifier:@"visitListCell"];
    //tableHeaderView
    self.tableView.tableHeaderView = self.headView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 4;
            break;
        default:
            // 好车推荐
            return self.homePageModel.recommend_car_list.count;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // 头条车源
        QLHorizontalScrollCell *cell = [[QLHorizontalScrollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"horizontalScrollCell"];
        QLItemModel *itemModel = [QLItemModel new];
        itemModel.rowCount = 1;
        itemModel.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        itemModel.Spacing = QLMinimumSpacingMake(10, 10);
        itemModel.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        itemModel.itemName = @"QLHomeCarItem";
        itemModel.registerType = ITEM_NibRegisterType;
        itemModel.itemSize = CGSizeMake(158, 185);
        cell.itemModel = itemModel;
        cell.itemArr  = self.homePageModel.top_car_list;
        cell.itemSetHandler = ^(id result, NSError *error) {
            QLHomeCarItem *item = result[@"item"];
            NSArray *dataArr = result[@"dataArr"];
            NSIndexPath *indexPath = result[@"indexPath"];
            // 更新cell
            [item updateWithDic:dataArr[indexPath.row]];
        };
        cell.itemSelectHandler = ^(id result, NSError *error) {
            NSArray *dataArr = result[@"dataArr"];
            NSIndexPath *indexPath = result[@"indexPath"];
            QLCarSourceDetailViewController *vc = [[QLCarSourceDetailViewController alloc]init];
            [vc updateVcWithData:dataArr[indexPath.row]];
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        return cell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // 我的常用
            QLHorizontalScrollCell *cell = [[QLHorizontalScrollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"horizontalScrollCell"];
            QLItemModel *itemModel = [QLItemModel new];
            itemModel.rowCount = 1;
            itemModel.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
            itemModel.Spacing = QLMinimumSpacingMake(30, 30);
            itemModel.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            itemModel.itemName = @"QLImgTextItem";
            itemModel.registerType = ITEM_NibRegisterType;
            itemModel.itemSize = CGSizeMake(50, 60);
            cell.itemModel = itemModel;
        
            NSMutableArray *temArr = [NSMutableArray array];
            for (QLFunModel *model in self.homePageModel.function_list) {
                if (model.value.integerValue == 101||model.value.integerValue == 102||model.value.integerValue == 103||model.value.integerValue == 111) {
                    [temArr addObject:model];
                }
            }
            cell.itemArr  = temArr;
            cell.itemSetHandler = ^(id result, NSError *error) {
                QLImgTextItem *item = result[@"item"];
                NSArray *dataArr = result[@"dataArr"];
                NSIndexPath *indexPath = result[@"indexPath"];
                QLFunModel *model = dataArr[indexPath.row];
                item.titleLB.text = model.extend_01;
                item.imgView.image = [UIImage imageNamed:model.diction_id];
            };
            cell.itemSelectHandler = ^(id result, NSError *error) {
                NSIndexPath *indexPath = result[@"indexPath"];
                
                if (indexPath.row == 0) {
                    [self.navigationController pushViewController:[QLPhotosShareViewController new] animated:YES];
                }
                
                if (indexPath.row == 1) {
                    // 店铺分享
                    QLStoreSharePageViewController *sspVC = [QLStoreSharePageViewController new];
                    [self.navigationController pushViewController:sspVC animated:YES];
                }
                
                if (indexPath.row == 2) {
                    // 发布动态
                    QLReleaseCarCircleViewController *rccVC = [QLReleaseCarCircleViewController new];
                    [self.navigationController pushViewController:rccVC animated:YES];
                }
                
                if (indexPath.row == 3) {
                    // 帮卖订单
                    QLMyHelpSellViewController *hsVC = [QLMyHelpSellViewController new];
                    [self.navigationController pushViewController:hsVC animated:YES];
                }
            };
            
            return cell;
        } else if (indexPath.row == 1) {
            // 今日访客
            QLHomeVisitRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recordCell" forIndexPath:indexPath];
            if (self.homePageModel) {
                [cell updateWithToday:[self.homePageModel.visit_today_c stringValue] andTotal:[self.homePageModel.visit_all_b stringValue]];
            }
            return cell;
        } else {
            // 车友圈
            QLHomeVisitListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"visitListCell" forIndexPath:indexPath];
            cell.allBtn.tag = indexPath.row;
            if (indexPath.row == 2) {
                cell.titleLB.text = @"朋友圈";
                cell.headListView.headsArr = self.friendData;
            } else {
                cell.titleLB.text = @"车商友人";
                NSArray *temArr = [NSArray arrayWithArray:self.homePageModel.friend_list];
                temArr = [temArr arrayByAddingObjectsFromArray:self.homePageModel.friend_list];
                cell.headListView.headsArr = temArr;
            }
            [cell.allBtn addTarget:self action:@selector(allBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
    } else {
        // 好车推荐
        QLHomeCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hCarCell" forIndexPath:indexPath];
        [cell updateUIWithDic:self.homePageModel.recommend_car_list[indexPath.row]];
        return cell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QLHomeToolHeadView *headView = [QLHomeToolHeadView new];
    headView.accBtn.tag = section;
    headView.accBtn.hidden = YES;
    [headView.accBtn addTarget:self action:@selector(accBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (section == 0) {
        headView.accBtn.hidden = NO;
        headView.titleLB.text = @"头条车源";
        [headView.accBtn setTitle:@" 更多" forState:UIControlStateNormal];
    } else if (section == 1) {
        headView.titleLB.text = @"我的常用";
        
    } else {
        headView.titleLB.text = @"好车推荐";

    }
        
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        //self.homePageModel.recommend_car_list[indexPath.row]
        QLCarSourceDetailViewController *vc = [QLCarSourceDetailViewController new];
        [vc updateVcWithData:self.homePageModel.recommend_car_list[indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 185;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0||indexPath.row == 1) {
            return 60;
        } else {
            return 70;
        }
    } else {
        return 120;
    }
}

#pragma mark - Lazy
- (QLHomeNaviView *)naviView {
    if(!_naviView) {
        _naviView = [QLHomeNaviView new];
        [_naviView.rightBtn setImage:[UIImage imageNamed:@"addFC"] forState:UIControlStateNormal];
        _naviView.rightBtn.titleLabel.text = @"发车";
        [_naviView.rightBtn layoutButtonWithEdgeInsetsStyle:QLButtonEdgeInsetsStyleTop imageTitleSpace:5];
        _naviView.delegate = self;
    }
    return _naviView;
}
- (QLHomePageHeadView *)headView {
    if(!_headView) {
        _headView = [[QLHomePageHeadView alloc] init];
        _headView.delegate = self;
        _headView.bannerView.delegate = self;
        _headView.bannerView.imagesArr = @[@"carSourceBj"];
    }
    return _headView;
}

- (QLHomePageModel *)homePageModel {
    if (!_homePageModel) {
        _homePageModel =[[ QLHomePageModel alloc]init];
    }
    return _homePageModel;
}
@end
