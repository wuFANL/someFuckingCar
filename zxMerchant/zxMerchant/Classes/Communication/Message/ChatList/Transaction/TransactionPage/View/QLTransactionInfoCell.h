//
//  QLTransactionInfoCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/15.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLTransactionInfoCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *carImageV;
@property (nonatomic, strong) IBOutlet UILabel *carNameLab;
@property (nonatomic, strong) IBOutlet UILabel *carContentLab;

@end

NS_ASSUME_NONNULL_END
