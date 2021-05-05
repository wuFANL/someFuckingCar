//
//  QLAddStaffViewController.h
//  zxMerchant
//
//  Created by lei qiao on 2021/2/21.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLBaseTableViewController.h"
#import "QLSubmitBottomView.h"
#import "QLContentTFCell.h"
#import "QLSubmitImgConfigCell.h"
#import "QLEditPermissionViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface QLAddStaffViewController : QLBaseTableViewController
@property (nonatomic, strong) QLSubmitBottomView *bottomView;

/** 是否是新增员工*/
@property (nonatomic, assign) BOOL isAddStaff;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
