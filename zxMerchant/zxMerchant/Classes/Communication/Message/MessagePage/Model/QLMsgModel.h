//
//  QLMsgModel.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2018/10/5.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLMsgModel : NSObject
/**
 *内容
 */
@property (nonatomic, strong) NSString *content;
/**
 *create_time
 */
@property (nonatomic, strong) NSString *create_time;
/**
 *发送人id
 */
@property (nonatomic, strong) NSString *from_user_id;
/**
 *发送者类型
 */
@property (nonatomic, strong) NSString *from_user_type;
/**
 *id
 */
@property (nonatomic, strong) NSString *msg_id;
/**
 *跳转类型
 */
@property (nonatomic, strong) NSString *jump_type;
/**
 *operation_time
 */
@property (nonatomic, strong) NSString *operation_time;
/**
 *跳转参数
 */
@property (nonatomic, strong) NSString *params;
/**
 *推送类型
 */
@property (nonatomic, strong) NSString *push_type;
/**
 *state 是否已读
 */
@property (nonatomic, strong) NSString *state;
/**
 *标题
 */
@property (nonatomic, strong) NSString *title;
/**
 *接受人ID
 */
@property (nonatomic, strong) NSString *to_user_id;
/**
 *接受人类型
 */
@property (nonatomic, strong) NSString *to_user_type;
@end

NS_ASSUME_NONNULL_END
