//
//  QLHomeVisitRecordCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/3.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLHomeVisitRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIControl *todayControl;
@property (weak, nonatomic) IBOutlet QLBaseLabel *todayLB;
@property (weak, nonatomic) IBOutlet UIControl *totalControl;
@property (weak, nonatomic) IBOutlet QLBaseLabel *totalLB;

@end

NS_ASSUME_NONNULL_END
