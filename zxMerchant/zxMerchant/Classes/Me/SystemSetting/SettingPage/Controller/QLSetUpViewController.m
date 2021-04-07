//
//  QLSetUpViewController.m
//  PopularUsedCar
//
//  Created by 乔磊 on 2018/4/27.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLSetUpViewController.h"
#import "QLSysMsgCenterController.h"

@interface QLSetUpViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLBaseTableView *tableView;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation QLSetUpViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    //增加tableView
    [self.view addSubview:self.tableView];
    //布局
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark -tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [QLUserInfoModel getLocalInfo].isLogin?2:1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionTitles = self.titles[section];
    return sectionTitles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    NSString *title = self.titles[indexPath.section][indexPath.row];
    if (indexPath.section == 1) {
        if (![cell.contentView viewWithTag:999]) {
            UILabel *titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, cell.contentView.height)];
            titleLB.text = title;
            titleLB.font = [UIFont systemFontOfSize:15];
            titleLB.tag = 999;
            titleLB.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:titleLB];
        }
    } else {
        cell.textLabel.text = title;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        if (indexPath.section==0) {
            if (indexPath.row == 0) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                NSUInteger bytesCache = [[SDImageCache sharedImageCache] totalDiskSize];
                cell.detailTextLabel.text = [NSString fileSizeWithInterge:bytesCache];
            }
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [MBProgressHUD showCustomLoading:nil];
            //清除图片缓存
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [MBProgressHUD immediatelyRemoveHUD];
                [self.tableView reloadData];
            }];
        } else if (indexPath.row ==1) {
            QLSysMsgCenterController *mpVC = [QLSysMsgCenterController new];
            [self.navigationController pushViewController:mpVC animated:YES];
        }
    } else {
        //退出登录
        if ([QLUserInfoModel getLocalInfo].isLogin) {
            [[QLToolsManager share] alert:@"您确认退出登录吗?" handler:^(NSError *error) {
                if (!error) {
                    //清除本地缓存
                    [QLUserInfoModel loginOut];
                    //移除极光
                    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                        
                    } seq:VersionId.integerValue];
                    //返回登录页
                    [AppDelegateShare initLoginVC];
                }
            }];
        } else {
            [MBProgressHUD showError:@"未登录"];
        }
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
#pragma mark -懒加载
- (QLBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[QLBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView hideTableEmptyDataSeparatorLine];
        
    }
    return _tableView;
}
- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@[@"清除缓存",@"消息设置"],@[@"退出登录"]];
    }
    return _titles;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
