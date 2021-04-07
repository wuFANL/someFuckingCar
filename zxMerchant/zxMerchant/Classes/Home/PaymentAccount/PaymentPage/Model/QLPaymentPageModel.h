//
//  QLPaymentPageModel.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/8/6.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class QLMerchantAccountModel;
@class QLBankModel;
@interface QLPaymentPageModel : NSObject
/**
 *商家信息
 */
@property (nonatomic, strong) QLMerchantAccountModel *merchant_account;
/**
 *银行卡列表
 */
@property (nonatomic, strong) NSArray *bank_list;
@end

@interface QLMerchantAccountModel : NSObject
@property (nonatomic, strong) NSString *account_id;
/*
 *支付宝二维码
 */
@property (nonatomic, strong) NSString *alipay_url;
/*
 *总入账
 */
@property (nonatomic, strong) NSString *all_in;
/*
 *总出账
 */
@property (nonatomic, strong) NSString *all_out;
/*
 *账户余额
 */
@property (nonatomic, strong) NSString *balance;
@property (nonatomic, strong) NSString *create_time;
/*
 *使用中额度
 */
@property (nonatomic, strong) NSString *loan_amount;
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *pay_passowrd;
/*
 *预授信额度
 */
@property (nonatomic, strong) NSString *pre_quota;
/*
 *授信额度
 */
@property (nonatomic, strong) NSString *quota;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *update_time;
@property (nonatomic, strong) NSString *weixpay_url;
@end

@interface QLBankModel : NSObject
@property (nonatomic, strong) NSString *bank_card;
@property (nonatomic, strong) NSString *bank_id;
@property (nonatomic, strong) NSString *bank_name;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *operation_time;
@property (nonatomic, strong) NSString *real_name;
@property (nonatomic, strong) NSString *state;
@end
NS_ASSUME_NONNULL_END
