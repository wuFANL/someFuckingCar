//// QLMsgSettingModel.h
// PopularUsedCarMerchant
//
// reated by 乔磊 on 2020/1/22.
// Copyright © 2020 EmbellishJiao. All rights reserved.
//
/**
*　　┏┓　　　┏┓+ +
*　┏┛┻━━━┛┻┓ + +
*　┃　　　　　　　┃
*　┃　　　━　　　┃ ++ + + +
* ████━████ ┃+
*　┃　　　　　　　┃ +
*　┃　　　┻　　　┃
*　┃　　　　　　　┃ + +
*　┗━┓　　　┏━┛
*　　　┃　　　┃
*　　　┃　　　┃ + + + +
*　　　┃　　　┃
*　　　┃　　　┃ +  神兽保佑
*　　　┃　　　┃    代码无bug
*　　　┃　　　┃　　+
*　　　┃　 　　┗━━━┓ + +
*　　　┃ 　　　　　　　┣┓
*　　　┃ 　　　　　　　┏┛
*　　　┗┓┓┏━┳┓┏┛ + + + +
*　　　　┃┫┫　┃┫┫
*　　　　┗┻┛　┗┻┛+ + + +
*/


    

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLMsgSettingModel : NSObject
/**
 *
 */
@property (nonatomic, strong) NSString *flag;
/**
 *消息内容
 */
@property (nonatomic, strong) NSString *msg_content;
/**
 *消息图片
 */
@property (nonatomic, strong) NSString *msg_image;
/**
 *消息类型
 */
@property (nonatomic, strong) NSString *msg_type;
/**
 *s_id
 */
@property (nonatomic, strong) NSString *s_id;
/**
 *user_id
 */
@property (nonatomic, strong) NSString *user_id;
@end

NS_ASSUME_NONNULL_END
