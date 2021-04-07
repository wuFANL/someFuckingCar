//
//  QLEditStaffInfoViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2021/2/24.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLEditStaffInfoViewController.h"
#import "QLChangeMobileViewController.h"

@interface QLEditStaffInfoViewController ()


@end

@implementation QLEditStaffInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑账号";
    
}
#pragma mark - action
- (void)aControlClick:(UIControl *)control {
    
}
- (void)bControlClick:(UIControl *)control {
    
}
#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section==0?2:3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1&&indexPath.row > 0) {
        QLSubmitImgConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"submitImgConfigCell" forIndexPath:indexPath];
        cell.titleLBHeight.constant = 0;
        cell.titleLBBottom.constant = 0;
        cell.titleLB.hidden = YES;
        cell.aControl.tag = indexPath.row;
        cell.bControl.tag = indexPath.row;
        [cell.aControl addTarget:self action:@selector(aControlClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.bControl addTarget:self action:@selector(bControlClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    } else {
        QLContentTFCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tfCell" forIndexPath:indexPath];
        cell.lineViewRight.constant = 0;
        cell.lineView.hidden = NO;
        cell.accImgView.hidden = YES;
        
        NSString *title = @"";
        NSString *placeholder = @"";
        if (indexPath.section == 0) {
            placeholder = @"请输入";
            cell.contentTF.enabled = YES;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if (indexPath.row == 0) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                placeholder = @"请选择";
                cell.contentTF.enabled = NO;
                title = @"更换手机号";
            } else if (indexPath.row == 1) {
                title = @"姓名";
            }
        } else {
            title = @"权限设置";
            placeholder = @"请选择";
            cell.contentTF.enabled = NO;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.titleLB.text = title;
        cell.contentTF.placeholder = placeholder;
        
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0&&indexPath.row == 0) {
        //更换手机号
        QLChangeMobileViewController *cmVC = [QLChangeMobileViewController new];
        [self.navigationController pushViewController:cmVC animated:YES];
    } else if (indexPath.section == 1&&indexPath.row == 0) {
        //权限管理
        QLEditPermissionViewController *epVC = [QLEditPermissionViewController new];
        [self.navigationController pushViewController:epVC animated:YES];
    }
}
@end
