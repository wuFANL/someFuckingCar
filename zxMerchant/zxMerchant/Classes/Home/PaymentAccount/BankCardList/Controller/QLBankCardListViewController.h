//
//  QLBankCardListViewController.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/29.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLBaseTableViewController.h"
#import "QLPaymentPageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QLBankCardListViewController : QLBaseTableViewController
/**
 *银行卡列表
 */
@property (nonatomic, strong) NSMutableArray *bankArr;
/**
 *选择回调
 */
@property (nonatomic, strong) ResultBlock chooseHandler;
@end

NS_ASSUME_NONNULL_END
