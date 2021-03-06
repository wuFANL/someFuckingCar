//
//  QLPaymentPageHeadView.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/27.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLPaymentPageModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^payMentHeaderBlock)(BOOL isWxPay);
@interface QLPaymentPageHeadView : UIView
@property (weak, nonatomic) IBOutlet UIButton *aBtn;
@property (weak, nonatomic) IBOutlet UIButton *bBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (nonatomic, strong) QLPaymentPageModel *model;
- (void)updateModel:(QLPaymentPageModel *)model andIsWxPay:(BOOL)isweChat;

@property (nonatomic, copy) payMentHeaderBlock payTypeBlock;
@end

NS_ASSUME_NONNULL_END
