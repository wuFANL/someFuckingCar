//
//  QLRidersDynamicListModel.h
//  zxMerchant
//
//  Created by lei qiao on 2021/5/5.
//  Copyright © 2021 ql. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class QLRidersDynamicFileModel;

@interface QLRidersDynamicListModel : NSObject
@property (nonatomic, copy) NSString *account_head_pic;
@property (nonatomic, copy) NSString *account_id;
@property (nonatomic, copy) NSString *account_nickname;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *dynamic_content;
@property (nonatomic, copy) NSString *dynamic_id;
@property (nonatomic, copy) NSArray *file_array;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *vx_state;
@end

@interface QLRidersDynamicFileModel : NSObject
@property (nonatomic, copy) NSString *account_id;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *dynamic_id;
@property (nonatomic, copy) NSString *file_id;
@property (nonatomic, copy) NSString *file_remark;
@property (nonatomic, copy) NSString *file_url;
@property (nonatomic, copy) NSString *state;
@end
NS_ASSUME_NONNULL_END
