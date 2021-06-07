//
//  QLBrowseDetailViewController.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/31.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLBrowseDetailViewController.h"
#import "QLBrowseDetailHeadView.h"
#import "QLBrowseDetailCell.h"
#import "QLBrowseDetailModel.h"

@interface QLBrowseDetailViewController ()<UITableViewDelegate,UITableViewDataSource,QLBaseTableViewDelegate>
@property (nonatomic, strong) QLBrowseDetailHeadView *headView;
@property (nonatomic, strong) QLBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArr;

@end

@implementation QLBrowseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"浏览详情";
    //tableView
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}
#pragma mark - network
- (void)getDetailRequest {
    [QLNetworkingManager postWithParams:@{@"operation_type":@"get_member_log",@"about_id":QLNONull(self.about_id),@"log_type":QLNONull(self.log_type),@"share_id":QLNONull(self.infoModel.share_id)} success:^(id response) {
        NSArray *logArr = [NSArray yy_modelArrayWithClass:[QLShareHistoryModel class] json:response[@"result_info"][@"log_list"]];
        if (logArr.count != 0) {
            self.infoModel = logArr.firstObject;
        }
        [self.headView.imgView sd_setImageWithURL:[NSURL URLWithString:self.infoModel.head_pic]];
        self.headView.titleLB.text = self.infoModel.title;
        self.headView.timeLB.text = [self.infoModel.update_time timeFromString:@"MM/dd HH:mm"];
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
- (void)getListRequest {
    [QLNetworkingManager postWithParams:@{@"operation_type":@"get_user_visit_list",@"about_id":self.about_id,@"share_id":QLNONull(self.infoModel.share_id),@"page_no":@(self.tableView.page),@"page_size":@(listShowCount)} success:^(id response) {
         NSArray *temArr = [NSArray yy_modelArrayWithClass:[QLBrowseDetailModel class] json:response[@"result_info"][@"log_list"]];
               if (self.tableView.page == 1) {
                   [self.listArr removeAllObjects];
               }
               [self.listArr addObjectsFromArray:temArr];
               //刷新设置
               [self.tableView.mj_header endRefreshing];
               if (temArr.count == listShowCount) {
                   [self.tableView.mj_footer endRefreshing];
               } else {
                   [self.tableView.mj_footer endRefreshingWithNoMoreData];
               }
               [self.tableView reloadData];
    } fail:^(NSError *error) {
         [MBProgressHUD showError:error.domain];
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
    }];
}
//删除
- (void)delteList:(QLBrowseDetailModel *)model {
    [MBProgressHUD showCustomLoading:nil];
    [QLNetworkingManager postWithParams:@{@"operation_type":@"del_user_visit",@"about_id":self.about_id,@"user_id":QLNONull(model.user_id)} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        [self.listArr removeObject:model];
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
#pragma mark - action
//联系
- (void)contactBtnClick:(UIButton *)sender {
    QLBrowseDetailModel *model = self.listArr[sender.tag];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = model.nick_name;
    [MBProgressHUD showSuccess:@"昵称复制成功!"];
    [self performSelector:@selector(openWX) withObject:nil afterDelay:HUDDefaultShowTime];
}
- (void)openWX {
    //先判断是否能打开该url
    NSURL * url = [NSURL URLWithString:@"weixin://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    if (canOpen) {
        //打开微信
        [[UIApplication sharedApplication] openURL:url];
    } else {
        [MBProgressHUD showError:@"您的设备未安装微信APP"];
    }
}
//分页加载
- (void)dataRequest {
    if (self.tableView.page == 1) {
        //获取信息
        [self getDetailRequest];
    }
    //列表数据
    [self getListRequest];
}
#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1+self.listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.text = [NSString stringWithFormat:@"%lu人看啦",(unsigned long)self.listArr.count];
        return cell;
    } else {
        QLBrowseDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"browseCell" forIndexPath:indexPath];
        cell.contactBtn.tag = indexPath.row-1;
        [cell.contactBtn addTarget:self action:@selector(contactBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.model = self.listArr[indexPath.row-1];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return NO;
    }
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        QLBrowseDetailModel *model = self.listArr[indexPath.row-1];
        [self delteList:model];
       
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return indexPath.row==0?35:105;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

#pragma mark - lazyLoading
- (QLBrowseDetailHeadView *)headView {
    if (!_headView) {
        _headView = [QLBrowseDetailHeadView new];
        
    }
    return _headView;
}
- (QLBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[QLBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerNib:[UINib nibWithNibName:@"QLBrowseDetailCell" bundle:nil] forCellReuseIdentifier:@"browseCell"];
        _tableView.delegate = self;
        _tableView.dataSource= self;
        _tableView.extendDelegate = self;
        _tableView.showHeadRefreshControl = YES;
        _tableView.showFootRefreshControl = YES;
        //tableHeaderView
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
        [headerView addSubview:self.headView];
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(headerView);
        }];
        _tableView.tableHeaderView = headerView;
    }
    return _tableView;
}
- (NSMutableArray *)listArr {
    if (!_listArr) {
        _listArr = [NSMutableArray array];
    }
    return _listArr;
}


@end
