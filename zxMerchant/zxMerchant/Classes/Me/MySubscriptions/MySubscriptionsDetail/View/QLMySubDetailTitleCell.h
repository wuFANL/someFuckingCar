//
//  QLMySubDetailTitleCell.h
//  zxMerchant
//
//  Created by lei qiao on 2021/2/28.
//  Copyright © 2021 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLMySubDetailTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIView *bjView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bjViewHeight;
@property (nonatomic, strong) NSMutableArray *iconArr;
- (void)updateTimeWithString:(NSString *)timeStr;
@end

NS_ASSUME_NONNULL_END
