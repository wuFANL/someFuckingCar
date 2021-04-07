//// QLMsgSettingViewController.m
// PopularUsedCarMerchant
//
// reated by 乔磊 on 2020/1/19.
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


    

#import "QLMsgSettingViewController.h"
#import "QLMsgSettingModel.h"

@interface QLMsgSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *listArr;
@end

@implementation QLMsgSettingViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息设置";
    //tableView
    [self tableViewSet];
    //数据
    [self getMsgSettingList];
}
#pragma mark- network
//设置列表
- (void)getMsgSettingList {
    [MBProgressHUD showCustomLoading:nil];
    [QLNetworkingManager postWithParams:@{@"operation_type":@"get_msg_set_list",@"user_id":QLNONull([QLUserInfoModel getLocalInfo].account.account_id)} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        self.listArr = [NSArray yy_modelArrayWithClass:[QLMsgSettingModel class] json:response[@"result_info"][@"msg_set_list"]];
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
//设置
- (void)msgSetting:(NSInteger)index {
     QLMsgSettingModel *model = self.listArr[index];
    BOOL flag = model.flag.boolValue;
    [MBProgressHUD showCustomLoading:nil];
    [QLNetworkingManager postWithParams:@{@"operation_type":@"update_msg_set_flag",@"s_id":model.s_id,@"flag":@(!flag)} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        model.flag = [NSString stringWithFormat:@"%d",!flag];
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
#pragma mark- action
//总开关
- (void)totalSwitchChange:(UISwitch *)control {
    for (QLMsgSettingModel *model in self.listArr) {
        if (model.flag.boolValue != control.on) {
            NSInteger index = [self.listArr indexOfObject:model];
            [self msgSetting:index];
        }
    }
    
}
//单个开关变化
- (void)switchControlChange:(UISwitch *)control {
    NSInteger tag = control.tag;
    [self msgSetting:tag];
}
#pragma mark- tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    QLMsgSettingModel *model = self.listArr[indexPath.row];
    cell.textLabel.text = model.msg_content;
    //开关
    UISwitch *switchControl = [UISwitch new];
    switchControl.tag = indexPath.row;
    switchControl.on = model.flag.boolValue;
    [switchControl addTarget:self action:@selector(switchControlChange:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = switchControl;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    //文本
    UILabel *leftLB = [UILabel new];
    leftLB.font = [UIFont systemFontOfSize:15];
    leftLB.textColor = [UIColor darkTextColor];
    leftLB.text = @"消息总开关";
    [headerView addSubview:leftLB];
    [leftLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(18);
        make.centerY.equalTo(headerView);
    }];
    //开关
    UISwitch *switchControl = [UISwitch new];
    BOOL totalFlag = NO;
    for (QLMsgSettingModel *model in self.listArr) {
        if (model.flag.boolValue) {
            totalFlag = YES;
        }
    }
    switchControl.on = totalFlag;
    [switchControl addTarget:self action:@selector(totalSwitchChange:) forControlEvents:UIControlEventValueChanged];
    [headerView addSubview:switchControl];
    [switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLB.mas_right).offset(15);
        make.centerY.equalTo(headerView);
    }];
    //设置按钮
    UILabel *rightLB = [UILabel new];
    rightLB.font = [UIFont systemFontOfSize:15];
    rightLB.textColor = [UIColor darkGrayColor];
    rightLB.text = @"开关消息免打扰";
    [headerView addSubview:rightLB];
    [rightLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-15);
        make.centerY.equalTo(headerView);
    }];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

#pragma mark - Lazy



@end
