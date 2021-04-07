//
//  QLFriendMessageCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/6.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLFriendMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *badgeLB;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIView *accView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *accImgView;
@property (weak, nonatomic) IBOutlet UILabel *accLB;

@property (nonatomic, assign) NSInteger badgeValue;

@end

NS_ASSUME_NONNULL_END
