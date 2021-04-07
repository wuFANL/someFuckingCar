//
//  QLBelongingShopInfoCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/12/29.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLBelongingShopInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLB;
@property (weak, nonatomic) IBOutlet UILabel *addressLB;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;

@end

NS_ASSUME_NONNULL_END
