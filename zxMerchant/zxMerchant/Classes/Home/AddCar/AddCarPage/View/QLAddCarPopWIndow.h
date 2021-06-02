//
//  QLAddCarPopWIndow.h
//  zxMerchant
//
//  Created by 张精申 on 2021/6/2.
//  Copyright © 2021 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLAddCarPopWIndow : UIView
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextField *reSetPriceTextField;
@property (weak, nonatomic) IBOutlet UILabel *detailDesc;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@end

NS_ASSUME_NONNULL_END
