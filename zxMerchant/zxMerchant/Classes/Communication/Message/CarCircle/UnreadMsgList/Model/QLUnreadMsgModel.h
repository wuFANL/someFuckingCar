//
//  QLUnreadMsgModel.h
//  zxMerchant
//
//  Created by lei qiao on 2021/5/25.
//  Copyright © 2021 ql. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class QLDynamicMsgModel;
@interface QLUnreadMsgModel : NSObject
@property (nonatomic, strong) QLAccountModel *account_info;
@property (nonatomic, copy) NSArray *dynamic_response;
@end

@interface QLDynamicMsgModel : NSObject
@property (nonatomic, copy) NSString *account_head_pic;
@property (nonatomic, copy) NSString *account_id;
@property (nonatomic, copy) NSString *account_nickname;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *dynamic_first_pic;
@property (nonatomic, copy) NSString *dynamic_id;
@property (nonatomic, copy) NSString *response_type;
@property (nonatomic, copy) NSString *to_account_id;
@property (nonatomic, copy) NSString *to_account_nickname;

@end
NS_ASSUME_NONNULL_END
