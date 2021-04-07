//
//  QLCarCircleViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/16.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCarCircleViewController.h"
#import "QLCarCircleNaviView.h"
#import "QLCarCircleHeadView.h"
#import "QLCarCircleUnreadView.h"
#import "QLCarCircleTextCell.h"
#import "QLCarCircleImgCell.h"
#import "QLCarCircleAccCell.h"
#import "QLCarCircleLikeCell.h"
#import "QLCarCircleCommentCell.h"
#import "QLReleaseCarCircleViewController.h"
#import "QLUnreadMsgListViewController.h"

@interface QLCarCircleViewController ()<UITableViewDelegate,UITableViewDataSource,QLBannerViewDelegate>
@property (nonatomic, strong) QLCarCircleNaviView *naviView;
@property (nonatomic, strong) QLCarCircleHeadView *headView;

@end

@implementation QLCarCircleViewController
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
#pragma mark - action
//发布动态
- (void)funBtnClick {
    QLReleaseCarCircleViewController *rccVC = [QLReleaseCarCircleViewController new];
    [self.navigationController pushViewController:rccVC animated:YES];
}
//未读消息点击
- (void)unreadMsgControlClick {
    QLUnreadMsgListViewController *umlVC = [QLUnreadMsgListViewController new];
    [self.navigationController pushViewController:umlVC animated:YES];
}
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
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarCircleTextCell" bundle:nil] forCellReuseIdentifier:@"textCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarCircleImgCell" bundle:nil] forCellReuseIdentifier:@"imgCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarCircleAccCell" bundle:nil] forCellReuseIdentifier:@"accCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarCircleLikeCell" bundle:nil] forCellReuseIdentifier:@"likeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarCircleCommentCell" bundle:nil] forCellReuseIdentifier:@"commentCell"];
    
    //tableHeaderView
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 250)];
    [tableHeaderView addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tableHeaderView);
    }];
    self.tableView.tableHeaderView = tableHeaderView;
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        QLCarCircleTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        cell.likeBtn.hidden = YES;
        return cell;
    } else if (indexPath.row == 1) {
        QLCarCircleImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imgCell" forIndexPath:indexPath];
        cell.dataType = indexPath.section/2==0?ImageType:VideoType;
        cell.dataArr = [@[@"1",@"2",@"3",@"4"] mutableCopy];
        return cell;
    } else if (indexPath.row == 2) {
        QLCarCircleAccCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accCell" forIndexPath:indexPath];
        
        return cell;
    } else if (indexPath.row == 3) {
        QLCarCircleLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"likeCell" forIndexPath:indexPath];
        cell.dataArr = @[@"昵称",@"昵称",@"昵称",@"昵称",@"昵称"];
        return cell;
    } else {
        QLCarCircleCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
       
        return cell;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        QLCarCircleUnreadView *unreadView = [QLCarCircleUnreadView new];
        [unreadView.msgControl addTarget:self action:@selector(unreadMsgControlClick) forControlEvents:UIControlEventTouchUpInside];
        return unreadView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0?80:15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}
#pragma mark - Lazy
- (QLCarCircleNaviView *)naviView {
    if(!_naviView) {
        _naviView = [QLCarCircleNaviView new];
        [_naviView.funBtn setImage:[UIImage imageNamed:@"CameraIcon_white"] forState:UIControlStateNormal];
        [_naviView.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_naviView.funBtn addTarget:self action:@selector(funBtnClick) forControlEvents:UIControlEventTouchUpInside];
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