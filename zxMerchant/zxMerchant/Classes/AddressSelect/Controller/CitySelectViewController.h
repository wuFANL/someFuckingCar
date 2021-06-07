//
//  CitySelectViewController.h
//  zxMerchant
//
//  Created by 张精申 on 2021/6/4.
//  Copyright © 2021 ql. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^CitySelectBlock)(NSDictionary *fatherDic,NSDictionary *subDic,NSString *adcode);
@interface CitySelectViewController : QLBaseViewController
@property (nonatomic, copy) CitySelectBlock selectBlock;
@end

NS_ASSUME_NONNULL_END
