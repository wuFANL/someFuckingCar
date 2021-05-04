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
#import <MJRefresh.h>
@interface QLRidersDynamicViewController ()<UITableViewDelegate,UITableViewDataSource,QLBannerViewDelegate>
@property (nonatomic, strong) QLCarCircleNaviView *naviView;
@property (nonatomic, strong) QLCarCircleHeadView *headView;

@property (nonatomic, strong) NSString *friendId;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, assign) NSInteger pageIndex;
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
    self.listArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.pageIndex = 1;
    [self requestForFriendCirle];
    //导航栏
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(44+(BottomOffset?44:20));
    }];
    //tableView
    [self tableViewSet];
}

-(void)refreshHeaderDidPull
{
    
}

-(void)refreshFooterDidPull
{
    
}

-(void)requestForFriendCirle
{
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:DynamicPath params:@{@"operation_type":@"personal_page_list",@"person_id":self.friendId,@"page_no":[NSString stringWithFormat:@"%ldd",(long)self.pageIndex],@"page_size":@"20"} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        if(self.pageIndex == 1) {
            [self.listArray removeAllObjects];
            [self.listArray addObjectsFromArray:[[response objectForKey:@"result_info"] objectForKey:@"dynamic_list"]];
        } else {
            [self.listArray addObjectsFromArray:[[response objectForKey:@"result_info"] objectForKey:@"dynamic_list"]];
        }

        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

#pragma mark - action
//轮播图设置
- (void)bannerView:(QLBannerView *)bannerView ImageData:(NSArray *)imageArr Index:(NSInteger)index ImageBtn:(UIButton *)imageBtn {
    
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
    
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeaderDidPull)];
    
    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooterDidPull)];
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0?1:2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QLRidersDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ridersDynamicCell" forIndexPath:indexPath];
        cell.dataType = NoDynamicData;

        return cell;
    } else {
        if (indexPath.row == 0) {
            QLRidersDynamicTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ridersDynamicTextCell" forIndexPath:indexPath];
            
            return cell;
        } else {
            QLCarCircleImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imgCell" forIndexPath:indexPath];
            cell.dataType = indexPath.section/2==0?ImageType:VideoType;
            cell.dataArr = [@[@"1",@"2",@"3",@"4"] mutableCopy];
            return cell;
        }
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

@end
