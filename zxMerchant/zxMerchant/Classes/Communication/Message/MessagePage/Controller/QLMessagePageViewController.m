//
//  QLMessagePageViewController.m
//  PopularUsedCarMerchant
//
//  Created by lei qiao on 2020/9/20.
//  Copyright © 2020 EmbellishJiao. All rights reserved.
//

#import "QLMessagePageViewController.h"
#import "QLSystemMessageCell.h"
#import "QLFriendMessageCell.h"
#import "QLMsgSettingViewController.h"
#import "QLSysMsgListViewController.h"
#import "QLChatListPageViewController.h"

@interface QLMessagePageViewController ()<UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,PopViewControlDelegate>

@end

@implementation QLMessagePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //tableView
    [self tableViewSet];
    //长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [longPress setMinimumPressDuration:1.5];
    [self.view addGestureRecognizer:longPress];
   
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
    return 15;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 5) {
        QLSystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sysMsgCell" forIndexPath:indexPath];
      
        return cell;
    } else {
        QLFriendMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendMsgCell" forIndexPath:indexPath];
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < 5) {
        QLSysMsgListViewController *smlVC = [QLSysMsgListViewController new];
        [self.navigationController pushViewController:smlVC animated:YES];
    } else {
        QLChatListPageViewController *clpVC = [QLChatListPageViewController new];
        clpVC.navigationItem.title = @"对方账号名称";
        [self.navigationController pushViewController:clpVC animated:YES];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    //文本
    UILabel *lb = [UILabel new];
    lb.font = [UIFont systemFontOfSize:13];
    lb.textColor = [UIColor darkGrayColor];
    lb.text = @"开启消息通知,及时掌握最新信息";
    [headerView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(18);
        make.centerY.equalTo(headerView);
    }];
    //设置按钮
    UIButton *btn = [UIButton new];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:GreenColor forState:UIControlStateNormal];
    [btn setTitle:@"去设置" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(setBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-15);
        make.centerY.equalTo(headerView);
    }];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row < 5?65:95;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
@end
