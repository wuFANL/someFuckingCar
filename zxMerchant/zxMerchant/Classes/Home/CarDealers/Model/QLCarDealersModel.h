//
//  QLCarDealersModel.h
//  zxMerchant
//
//  Created by lei qiao on 2021/6/9.
//  Copyright © 2021 ql. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyFriendsModel.h"
#import "QLCarInfoModel.h"
NS_ASSUME_NONNULL_BEGIN
@class QLTradeDetailModel;
@interface QLCarDealersModel : NSObject
@property (nonatomic, strong) FriendDetailModel*buyer_info;
@property (nonatomic, strong) NSString *car_id;
@property (nonatomic, strong) QLCarInfoModel *car_info;
@property (nonatomic, strong) QLTradeDetailModel *last_trade_detail;
@property (nonatomic, strong) NSString *t_id;
@property (nonatomic, strong) NSString *total_msg_account;
@end

@interface QLTradeDetailModel : NSObject
@property (nonatomic, strong) NSString *car_id;
@property (nonatomic, strong) NSString *contact_mobile;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *file_url;
@property (nonatomic, strong) NSString *from_account_id;
@property (nonatomic, strong) NSString *from_name;
@property (nonatomic, strong) NSString *m_type;
@property (nonatomic, strong) NSString *msg_id;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *t_id;
@property (nonatomic, strong) NSString *to_account_id;
@property (nonatomic, strong) NSString *update_time;
@property (nonatomic, strong) NSString *user_id;
@end
NS_ASSUME_NONNULL_END
