//
//  QLEditPermissionCell.h
//  zxMerchant
//
//  Created by lei qiao on 2021/2/23.
//  Copyright © 2021 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLEditPermissionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectBtnHeight;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *accLB;



@property (nonatomic, strong) NSDictionary *dataDic;
@end

NS_ASSUME_NONNULL_END
