//
//  QLCarCircleCommentCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/28.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLCarCircleCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet QLBaseButton *iconBtn;
@property (weak, nonatomic) IBOutlet UIView *bjView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bjViewHeight;

@end

NS_ASSUME_NONNULL_END
