//
//  VinCodeIdenfitViewController.h
//  zxMerchant
//
//  Created by 张精申 on 2021/6/1.
//  Copyright © 2021 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^VinCodeId)(UIImage* image,NSString *vinCode,NSString *register_date);
@interface VinCodeIdenfitViewController : UIViewController
/** 选中的图片*/
@property (nonatomic, strong) UIImage *selectImg;
@property (nonatomic, copy) VinCodeId idBlock;
@end

NS_ASSUME_NONNULL_END
