//
//  QLShareHistoryModel.h
//  PopularUsedCarMerchant
//
//  Created by lei qiao on 2020/4/12.
//  Copyright © 2020 EmbellishJiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLShareHistoryModel : NSObject
@property (nonatomic, strong) NSString *about_id;
@property (nonatomic, strong) NSString *from_member_id;
@property (nonatomic, strong) NSString *head_pic;
@property (nonatomic, strong) NSString *log_type;
@property (nonatomic, strong) NSString *member_sub_id;
@property (nonatomic, strong) NSString *share_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *update_time;
@property (nonatomic, strong) NSString *visit_num;
@property (nonatomic, strong) NSArray *pic_list;
@end

NS_ASSUME_NONNULL_END
