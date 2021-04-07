//
//  QLTopCarSourcePriceCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/24.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLTopCarSourcePriceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *pifaLB;
@property (weak, nonatomic) IBOutlet UILabel *lingshouLB;
@property (weak, nonatomic) IBOutlet UIButton *chatPriceBtn;

@property (nonatomic, strong) NSString *pifaPrice;
@property (nonatomic, strong) NSString *lingshouPrice;
@end

NS_ASSUME_NONNULL_END
