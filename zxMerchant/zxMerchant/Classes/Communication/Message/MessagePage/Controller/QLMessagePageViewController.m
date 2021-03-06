//
//  QLMessagePageViewController.m
//  PopularUsedCarMerchant
//
//  Created by lei qiao on 2020/9/20.
//  Copyright © 2020 EmbellishJiao. All rights reserved.
//

#import "QLMessagePageViewController.h"
#import "QLCommunicationPageViewController.h"
#import "QLSystemMessageCell.h"
#import "QLFriendMessageCell.h"
#import "QLMsgSettingViewController.h"
#import "QLSysMsgListViewController.h"
#import "QLChatListPageViewController.h"
#import "MessageListModel.h"

@interface QLMessagePageViewController ()<UITableViewDelegate,UITableViewDataSource,QLBaseTableViewDelegate,UIPopoverPresentationControllerDelegate,PopViewControlDelegate>
@property (nonatomic, strong) MessageListModel *dataModel;
@property (nonatomic, assign) BOOL isFirstIn;
@end

@implementation QLMessagePageViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if(self.isFirstIn)
    {
        [self dataRequest];
    }
}

-(void)JPushNotifForChatMessage:(NSNotification *)notif
{
    [self dataRequest];
}

-(void)carCricleBackToReload
{
    [self requestForCircleNew];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstIn = NO;
    [MBProgressHUD showCustomLoading:@""];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JPushNotifForChatMessage:) name:@"JPushNotifForChatMessage" object:nil];
    //tableView
    [self tableViewSet];
    //长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [longPress setMinimumPressDuration:1.5];
    [self.view addGestureRecognizer:longPress];
   
    [self requestForCircleNew];
    [self dataRequest];
    
}

//车友圈新消息
-(void)requestForCircleNew
{
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:DynamicPath params:@{@"operation_type":@"to_read/count",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        
        NSString *toreadcount = [[response objectForKey:@"result_info"] objectForKey:@"to_read_count"];
        NSString *head = [[response objectForKey:@"result_info"] objectForKey:@"head_pic"];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[toreadcount,head] forKeys:@[@"badge",@"head"]];
        if(self.msgBlock)
        {
            self.msgBlock(dic);
        }
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

- (void)dataRequest {
    
    [QLNetworkingManager postWithUrl:UserPath params:@{@"operation_type":@"last_trade_deatil_list",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        self.dataModel = [MessageListModel yy_modelWithJSON:[response objectForKey:@"result_info"]];
        self.isFirstIn = YES;
    
        NSInteger unreadMsgNum = 0;
        for (MessageDetailModel *model in self.dataModel.info_list) {
            if (model.tradeInfo) {
                unreadMsgNum = unreadMsgNum + [model.tradeInfo[@"total_msg_account"] integerValue];
            } else if (model.msgSet) {
                unreadMsgNum = unreadMsgNum + [model.msgSet[@"msg_count"] integerValue];
            }
        }
        QLBaseTabBarController *tabBarVC = (QLBaseTabBarController *)self.tabBarController;
        NSInteger tabIndex = -1;
        for (UIViewController *vc in tabBarVC.viewControllers) {
            if ([vc isKindOfClass:[QLCommunicationPageViewController class]]) {
                tabIndex = [tabBarVC.viewControllers indexOfObject:vc];
            }
        }
        if (tabIndex != -1) {
            QLBaseTarBarButton *btn = tabBarVC.mainTabBar.tabbarBtnArray[tabIndex];
            btn.badgeBtn.showNum = YES;
            btn.badgeValue = [NSString stringWithFormat:@"%ld",unreadMsgNum];
        }
        //app角标设置
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:unreadMsgNum];
        [JPUSHService setBadge:unreadMsgNum];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:error.domain];
    }];
}
#pragma mark - action
//pop的cell设置
- (void)cell:(UITableViewCell *)baseCell IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    baseCell.textLabel.font = [UIFont systemFontOfSize:13];
    baseCell.textLabel.textAlignment = NSTextAlignmentCenter;
    baseCell.textLabel.textColor = [UIColor colorWithHexString:@"#797D81"];
    baseCell.textLabel.text = dataArr[indexPath.row];
}
//pop的cell点击
- (void)popClickCall:(NSInteger)index {
    if(index == 0) {
        //置顶
        
        
    } else if (index == 1) {
        //删除
        
    }
}
//pop样式
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}
//长按
- (void)longPressAction:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint longPressPoint = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:longPressPoint];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [QLPopoverShowManager showPopover:@[@"置顶聊天",@"删除该聊天"] areaView:cell direction:UIPopoverArrowDirectionUp backgroundColor:WhiteColor delegate:self];
    }
}
//去设置
- (void)setBtnClick {
    QLMsgSettingViewController *msVC = [QLMsgSettingViewController new];
    [self.navigationController pushViewController:msVC animated:YES];
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.extendDelegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLSystemMessageCell" bundle:nil] forCellReuseIdentifier:@"sysMsgCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLFriendMessageCell" bundle:nil] forCellReuseIdentifier:@"friendMsgCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataModel.info_list count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageDetailModel *model = [self.dataModel.info_list objectAtIndex:indexPath.row];
    if ([model.type isEqualToString:@"2"]) {
        //通知
        QLSystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sysMsgCell" forIndexPath:indexPath];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[model.msgSet objectForKey:@"cover_image"]]];
        cell.badgeValue = [[model.msgSet objectForKey:@"msg_count"] intValue];
        cell.titleLB.text = [model.msgSet objectForKey:@"title"];
        cell.detailLB.text = [model.msgSet objectForKey:@"msg_content"];
        cell.timeLB.text = [QLToolsManager compareCurrentTime:[model.msgSet objectForKey:@"curr_time"]];
        return cell;
    } else {
        //聊天
        QLFriendMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendMsgCell" forIndexPath:indexPath];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[[model.tradeInfo objectForKey:@"buyer_info"] objectForKey:@"head_pic"]]];
        cell.titleLB.text = [[model.tradeInfo objectForKey:@"buyer_info"] objectForKey:@"nickname"];
        cell.timeLB.text = [[model.tradeInfo objectForKey:@"last_trade_detail"] objectForKey:@"create_time"];
        cell.accLB.text = [[model.tradeInfo objectForKey:@"last_trade_detail"] objectForKey:@"content"];
        cell.badgeValue = [[model.tradeInfo objectForKey:@"total_msg_account"] intValue];
        [cell setContentPointX];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageDetailModel *model = [self.dataModel.info_list objectAtIndex:indexPath.row];
    if ([model.type isEqualToString:@"2"]) {
        //通知
        QLSysMsgListViewController *smlVC = [[QLSysMsgListViewController alloc] initWithTitle:[model.msgSet objectForKey:@"title"]];
        [self.navigationController pushViewController:smlVC animated:YES];
    } else {
        //聊天
        QLChatListPageViewController *clpVC = [[QLChatListPageViewController alloc] initWithCarID:[model.tradeInfo objectForKey:@"car_id"] messageToID:[[model.tradeInfo objectForKey:@"buyer_info"] objectForKey:@"account_id"]];
        clpVC.navigationItem.title = [[model.tradeInfo objectForKey:@"buyer_info"] objectForKey:@"nickname"];
        [self.navigationController pushViewController:clpVC animated:YES];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
//    //文本
//    UILabel *lb = [UILabel new];
//    lb.font = [UIFont systemFontOfSize:13];
//    lb.textColor = [UIColor darkGrayColor];
//    lb.text = @"开启消息通知,及时掌握最新信息";
//    [headerView addSubview:lb];
//    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(headerView).offset(18);
//        make.centerY.equalTo(headerView);
//    }];
//    //设置按钮
//    UIButton *btn = [UIButton new];
//    btn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [btn setTitleColor:GreenColor forState:UIControlStateNormal];
//    [btn setTitle:@"去设置" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(setBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [headerView addSubview:btn];
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(headerView).offset(-15);
//        make.centerY.equalTo(headerView);
//    }];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;//40;
}
@end
