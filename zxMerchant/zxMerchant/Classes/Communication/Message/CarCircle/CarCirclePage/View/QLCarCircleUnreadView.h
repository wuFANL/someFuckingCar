//
//  QLCarCircleUnreadView.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/20.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLCarCircleUnreadView : UIView
@property (weak, nonatomic) IBOutlet UIControl *msgControl;
@property (weak, nonatomic) IBOutlet QLBaseButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *numMsgLB;

@end

NS_ASSUME_NONNULL_END
