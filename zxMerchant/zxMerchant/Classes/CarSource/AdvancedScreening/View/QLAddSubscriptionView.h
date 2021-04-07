//
//  QLAddSubscriptionView.h
//  zxMerchant
//
//  Created by lei qiao on 2021/3/1.
//  Copyright © 2021 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLAddSubscriptionView : QLBaseView
@property (weak, nonatomic) IBOutlet UIView *bjView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bjViewBottom;
@property (weak, nonatomic) IBOutlet QLBaseButton *titleBtn;
@property (weak, nonatomic) IBOutlet UILabel *accLB;
@property (weak, nonatomic) IBOutlet UIView *tfView;
@property (weak, nonatomic) IBOutlet UITextField *textTF;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (void)show;
- (void)hidden;
@end

NS_ASSUME_NONNULL_END
