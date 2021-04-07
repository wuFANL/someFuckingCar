//
//  QLAddBankCardViewController.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/5/16.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLBaseTableViewController.h"
#import "QLPaymentPageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QLAddBankCardViewController : QLBaseTableViewController
/**
 *是否需要验证账户
 */
@property (nonatomic, assign) BOOL verifyAccount;
/**
 *银行卡信息
 */
@property (nonatomic, strong) QLBankModel *bankModel;
@end

NS_ASSUME_NONNULL_END
