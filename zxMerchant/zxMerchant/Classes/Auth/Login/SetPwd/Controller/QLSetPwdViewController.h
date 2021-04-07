//
//  QLSetPwdViewController.h
//  PopularUsedCarMerchant
//
//  Created by lei qiao on 2020/9/2.
//  Copyright © 2020 EmbellishJiao. All rights reserved.
//

#import "QLViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLSetPwdViewController : QLViewController
/**
 *账号编码
 */
@property (nonatomic, strong) NSString *account_id;
/**
 *返回到首页
 */
@property (nonatomic, assign) BOOL backToTab;
@end

NS_ASSUME_NONNULL_END
