//
//  QLAddCarPopWIndow.h
//  zxMerchant
//
//  Created by 张精申 on 2021/6/2.
//  Copyright © 2021 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^AddCarSureBlock)(NSString *price,NSString *detail);
typedef void(^AddCarCancleBlock)(void);
@interface QLAddCarPopWIndow : UIView
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextField *reSetPriceTextField;

@property (weak, nonatomic) IBOutlet UITextView *detailDesc;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (nonatomic, copy) AddCarSureBlock sureBlock;
@property (nonatomic, copy) AddCarCancleBlock cancleBlock;
@end

NS_ASSUME_NONNULL_END
