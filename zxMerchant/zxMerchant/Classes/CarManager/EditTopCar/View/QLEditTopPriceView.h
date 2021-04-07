//
//  QLEditTopPriceView.h
//  zxMerchant
//
//  Created by lei qiao on 2020/12/7.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLEditTopPriceView : QLBaseView
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *tradePriceLB;
@property (weak, nonatomic) IBOutlet UIView *tfView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet QLBaseTextView *txtView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (void)show;
- (void)hidden;
@end

NS_ASSUME_NONNULL_END
