//// QLSysMsgCenterController.m
// PopularUsedCarMerchant
//
// reated by 乔磊 on 2020/1/16.
// Copyright © 2020 EmbellishJiao. All rights reserved.
//
/**
*　　┏┓　　　┏┓+ +
*　┏┛┻━━━┛┻┓ + +
*　┃　　　　　　　┃
*　┃　　　━　　　┃ ++ + + +
* ████━████ ┃+
*　┃　　　　　　　┃ +
*　┃　　　┻　　　┃
*　┃　　　　　　　┃ + +
*　┗━┓　　　┏━┛
*　　　┃　　　┃
*　　　┃　　　┃ + + + +
*　　　┃　　　┃
*　　　┃　　　┃ +  神兽保佑
*　　　┃　　　┃    代码无bug
*　　　┃　　　┃　　+
*　　　┃　 　　┗━━━┓ + +
*　　　┃ 　　　　　　　┣┓
*　　　┃ 　　　　　　　┏┛
*　　　┗┓┓┏━┳┓┏┛ + + + +
*　　　　┃┫┫　┃┫┫
*　　　　┗┻┛　┗┻┛+ + + +
*/


    

#import "QLSysMsgCenterController.h"
#import "QLSystemMessageCell.h"
#import "QLMsgGroupModel.h"
#import "QLMsgSettingViewController.h"

@interface QLSysMsgCenterController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *listArr;
@end

@implementation QLSysMsgCenterController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    //数据
    [self getMsgGroupList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息中心";
    //tableView
    [self tableViewSet];
    
}
#pragma mark- network
- (void)getMsgGroupList {
//    [MBProgressHUD showCustomLoading:nil];
//    [QLNetworkingManager postWithParams:@{@"operation_type":@"get_group_msg_list",@"user_id":QLNONull([QLUserInfoModel getLocalInfo].merchant_staff.sub_id)} success:^(id response) {
//        [MBProgressHUD immediatelyRemoveHUD];
//        self.listArr = [NSArray yy_modelArrayWithClass:[QLMsgGroupModel class] json:response[@"result_info"][@"group_msg_list"]];
//        [self.tableView reloadData];
//    } fail:^(NSError *error) {
//        [MBProgressHUD showError:error.domain];
//    }];
}
#pragma mark- action
//去设置
- (void)setBtnClick {
    QLMsgSettingViewController *msVC = [QLMsgSettingViewController new];
    [self.navigationController pushViewController:msVC animated:YES];
}
#pragma mark- tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 75, 0, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLSystemMessageCell" bundle:nil] forCellReuseIdentifier:@"sysMsgCell"];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLSystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sysMsgCell" forIndexPath:indexPath];
    cell.model = self.listArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
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
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 42;
}
@end
