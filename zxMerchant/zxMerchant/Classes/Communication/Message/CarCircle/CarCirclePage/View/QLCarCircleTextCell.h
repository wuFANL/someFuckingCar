//
//  QLCarCircleTextCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/26.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLCarCircleTextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet QLBaseButton *headBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headBtnTop;
@property (weak, nonatomic) IBOutlet UIButton *nikenameBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet QLBaseButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *textLB;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *openBtnBottom;

@end

NS_ASSUME_NONNULL_END
