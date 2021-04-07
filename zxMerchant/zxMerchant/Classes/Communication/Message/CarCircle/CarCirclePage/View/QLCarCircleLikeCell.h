//
//  QLCarCircleLikeCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/27.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface QLCarCircleLikeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet QLBaseButton *iconBtn;
@property (weak, nonatomic) IBOutlet UIView *bjView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bjViewHeight;
/**
 *数据数组
 */
@property (nonatomic, strong) NSArray *dataArr;
@end

NS_ASSUME_NONNULL_END
