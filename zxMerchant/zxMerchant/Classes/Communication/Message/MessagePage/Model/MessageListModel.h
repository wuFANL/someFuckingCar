//
//  MessageListModel.h
//  zxMerchant
//
//  Created by HK on 2021/5/4.
//  Copyright © 2021 ql. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class MessageDetailModel;

@interface MessageListModel : NSObject
@property (nonatomic, strong) NSArray *info_list;
@end

@interface MessageDetailModel : NSObject
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *last_mation_time;
@property (nonatomic, strong) NSDictionary *msgSet;
@property (nonatomic, strong) NSDictionary *tradeInfo;
@end


NS_ASSUME_NONNULL_END
