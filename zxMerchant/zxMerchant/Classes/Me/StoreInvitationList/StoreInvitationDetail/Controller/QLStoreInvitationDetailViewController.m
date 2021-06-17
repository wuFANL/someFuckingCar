//
//  QLStoreInvitationDetailViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2021/1/9.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLStoreInvitationDetailViewController.h"

@interface QLStoreInvitationDetailViewController ()

@end

@implementation QLStoreInvitationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"邀请加入店铺";
    
    [self.bottomView.cancelBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    [self.bottomView.editBtn setTitle:@"同意" forState:UIControlStateNormal];
    
}
#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0?1:2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QLBelongingShopInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"belongingShopInfoCell" forIndexPath:indexPath];
        
        return cell;
    } else {
        QLBelongingShopTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"belongingShopTextCell" forIndexPath:indexPath];
//        cell.authBtn.hidden = YES;
        
        NSArray *titles = @[@"邀请时间",@"通过时间"];
        cell.titleLB.text = titles[indexPath.row];
//        cell.accLB.text = @"--";
        
        return cell;
    }
}

@end
