//
//  QLCarCircleCommentContentCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/29.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLCarCircleCommentContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLB;

@property (nonatomic, strong) id model;
@end

NS_ASSUME_NONNULL_END
