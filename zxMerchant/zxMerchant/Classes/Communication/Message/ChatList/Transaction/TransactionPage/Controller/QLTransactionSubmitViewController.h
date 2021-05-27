//
//  QLTransactionSubmitViewController.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/15.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,TransactionType) {
    CooperativeTransaction = 0,//合作出售
    TransactionContract = 1,//交易合同
    ShopSale = 2,//店铺出售
};
typedef void (^MakeSureBlock) (NSString *price,NSString *content);
@interface QLTransactionSubmitViewController : QLBaseTableViewController
-(id)initWithSourceDic:(NSDictionary *)dic;
@property (nonatomic, copy) MakeSureBlock msBlock;
/**
 *类型
 */
@property (nonatomic, assign) TransactionType type;
@property (nonatomic, assign) BOOL isFromCarManager; //补充 carManager进入走不同的逻辑
/**
 *显示选择购车人
 */
@property (nonatomic, assign) BOOL showBuyer;
/**
 *显示基础信息
 */
@property (nonatomic, assign) BOOL showDesc;
@end

NS_ASSUME_NONNULL_END
