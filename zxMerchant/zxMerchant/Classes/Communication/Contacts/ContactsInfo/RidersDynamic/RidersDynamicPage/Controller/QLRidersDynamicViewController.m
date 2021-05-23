//
//  QLRidersDynamicViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/30.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLRidersDynamicViewController.h"
#import "QLCarCircleNaviView.h"
#import "QLCarCircleHeadView.h"
#import "QLRidersDynamicCell.h"
#import "QLRidersDynamicTextCell.h"
#import "QLCarCircleImgCell.h"
#import "QLRidersDynamicDetailViewController.h"
#import "QLRidersDynamicListModel.h"

@interface QLRidersDynamicViewController ()<UITableViewDelegate,UITableViewDataSource,QLBaseTableViewDelegate,QLBannerViewDelegate>
@property (nonatomic, strong) QLCarCircleNaviView *naviView;
@property (nonatomic, strong) QLCarCircleHeadView *headView;

@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation QLRidersDynamicViewController

-(id)initWithFriendId:(NSString *)friendID
{
    self = [super init];
    if(self)
    {
        self.friendId = friendID;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(44+(BottomOffset?44:20));
    }];
    //tableView
    [self tableViewSet];
}
#pragma - network
- (void)getStoreInfo {
    [QLNetworkingManager postWithUrl:FirendPath params:@{@"operation_type":@"info",@"account_id":self.friendId,@"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id} success:^(id response) {
        NSDictionary *resultDic = response[@"result_info"];
        
        self.headView.bannerView.imagesArr = @[QLNONull(resultDic[@"business_store"][@"cover_image"])];
        [self.headView.headBtn sd_setImageWithURL:[NSURL URLWithString:QLNONull(resultDic[@"user_info"][@"head_pic"])] forState:UIControlStateNormal];
        self.headView.nameLB.text = QLNONull(resultDic[@"business_store"][@"name"]);
        [self.headView.storeNameBtn setTitle:QLNONull(resultDic[@"business_store"][@"business_name"]) forState:UIControlStateNormal];
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
- (void)dataRequest {
    if (self.tableView.page == 1) {
        [self getStoreInfo];
    }
    [QLNetworkingManager postWithUrl:DynamicPath params:@{@"operation_type":@"personal_page_list",@"person_id":QLNONull(self.friendId),@"page_no":@(self.tableView.page),@"page_size":@(listShowCount)} success:^(id response) {
        if (self.tableView.page == 1) {
            [self.listArray removeAllObjects];
        }
        NSArray *temArr = [NSArray yy_modelArrayWithClass:[QLRidersDynamicListModel class] json:response[@"result_info"][@"dynamic_list"]];
        [self.listArray addObjectsFromArray:temArr];
        //无数据设置
        if (self.listArray.count == 0) {
            self.tableView.hidden = YES;
            self.showNoDataView = YES;
        } else {
            self.tableView.hidden = NO;
            self.showNoDataView = NO;
        }
        //刷新设置
        [self.tableView.mj_header endRefreshing];
        if (temArr.count == listShowCount) {
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        //刷新
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:error.domain];
    }];
}

#pragma mark - action
//轮播图设置
- (void)bannerView:(QLBannerView *)bannerView ImageData:(NSArray *)imageArr Index:(NSInteger)index ImageBtn:(UIButton *)imageBtn {
    [imageBtn sd_setImageWithURL:[NSURL URLWithString:imageArr[index]] forState:UIControlStateNormal];
}
//轮播图点击
- (void)bannerView:(QLBannerView *)bannerView ImageClick:(NSArray *)imageArr Index:(NSInteger)index ImageBtn:(UIButton *)imageBtn {
    
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
    self.tableView.extendDelegate = self;
    self.tableView.showHeadRefreshControl = YES;
    self.tableView.showFootRefreshControl = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLRidersDynamicCell" bundle:nil] forCellReuseIdentifier:@"ridersDynamicCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLRidersDynamicTextCell" bundle:nil] forCellReuseIdentifier:@"ridersDynamicTextCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarCircleImgCell" bundle:nil] forCellReuseIdentifier:@"imgCell"];
    
    //tableHeaderView
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 250)];
    [tableHeaderView addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tableHeaderView);
    }];
    self.tableView.tableHeaderView = tableHeaderView;
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < self.listArray.count) {
        QLRidersDynamicListModel *model = self.listArray[section];
        return model.file_array.count == 0?1:2;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLRidersDynamicListModel *model = self.listArray[indexPath.section];
    if (indexPath.row == 0) {
        QLRidersDynamicTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ridersDynamicTextCell" forIndexPath:indexPath];
        cell.model = model;
        return cell;
    } else {
        QLCarCircleImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imgCell" forIndexPath:indexPath];
        cell.collectionViewHeight = model.fileCellHeight;
        cell.dataType = ImageType;
        cell.dataArr = [model.file_array mutableCopy];
        cell.heightHandler = ^(id result) {
            model.fileCellHeight = [result floatValue];
        };
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        QLRidersDynamicDetailViewController *rddVC = [QLRidersDynamicDetailViewController new];
        [self.navigationController pushViewController:rddVC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
#pragma mark - Lazy
- (QLCarCircleNaviView *)naviView {
    if(!_naviView) {
        _naviView = [QLCarCircleNaviView new];
        _naviView.funBtn.hidden = YES;
        [_naviView.funBtn setImage:[UIImage imageNamed:@"msg_white"] forState:UIControlStateNormal];
        [_naviView.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _naviView;
}
- (QLCarCircleHeadView *)headView {
    if(!_headView) {
        _headView = [[QLCarCircleHeadView alloc] init];
        _headView.bannerView.delegate = self;
    }
    return _headView;
}
- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
@end
