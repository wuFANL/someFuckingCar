//
//  QLUnreadMsgListCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/2.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLUnreadMsgListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIImageView *likeImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likeImgViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *contentLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIControl *accControl;
@property (weak, nonatomic) IBOutlet UIImageView *accImgView;
@property (weak, nonatomic) IBOutlet UIImageView *videoiconImgView;

@end

NS_ASSUME_NONNULL_END
