//// QLMsgGroupModel.h
// PopularUsedCarMerchant
//
// reated by 乔磊 on 2020/1/18.
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

@interface QLMsgGroupModel : NSObject
/**
 *消息图片
 */
@property (nonatomic, strong) NSString *cover_image;
/**
 *最新消息时间
 */
@property (nonatomic, strong) NSString *curr_time;
/**
 *最新消息
 */
@property (nonatomic, strong) NSString *current_content;
/**
 *未读消息数
 */
@property (nonatomic, strong) NSString *msg_count;
/**
 *消息分组标题
 */
@property (nonatomic, strong) NSString *title;
@end

NS_ASSUME_NONNULL_END
