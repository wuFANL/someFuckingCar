//
//  QLCarDealersCell.h
//  zxMerchant
//
//  Created by lei qiao on 2021/6/9.
//  Copyright © 2021 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLCarDealersCell : UITableViewCell
@property (weak, nonatomic) IBOutlet QLBaseButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *accALB;
@property (weak, nonatomic) IBOutlet UILabel *accBLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIButton *gzBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gzBtnWidth;

@end

NS_ASSUME_NONNULL_END
