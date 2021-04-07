//
//  QLAgreementDetailViewController.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2018/11/1.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLAgreementDetailViewController : QLWebViewController
/**
 *导航栏标题
 */
@property (nonatomic, strong) NSString *naviTitle;
/**
 *协议编号
 */
@property (nonatomic, strong) NSString *serialNum;
@end

NS_ASSUME_NONNULL_END
