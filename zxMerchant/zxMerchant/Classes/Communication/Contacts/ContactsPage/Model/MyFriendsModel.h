//
//  MyFriendsModel.h
//  zxMerchant
//
//  Created by HK on 2021/4/27.
//  Copyright © 2021 ql. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class FriendDetailModel;

@interface MyFriendsModel : NSObject
@property (nonatomic, strong) NSArray *account_list;
@property (nonatomic, strong) NSString *head_pic;
@end

@interface FriendDetailModel : NSObject
@property (nonatomic, strong) NSString *account_id;
@property (nonatomic, strong) NSString *account_number;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *attention_time;
@property (nonatomic, strong) NSString *audit_remark;
@property (nonatomic, strong) NSString *back_pic;
@property (nonatomic, strong) NSString *business;
@property (nonatomic, strong) NSString *business_area;
@property (nonatomic, strong) NSString *business_id;
@property (nonatomic, strong) NSString *business_style;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *dynamic_url;
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *head_pic;
@property (nonatomic, strong) NSString *idcard_back_pic;
@property (nonatomic, strong) NSString *idcard_front_pic;
@property (nonatomic, strong) NSString *last_city_code;
@property (nonatomic, strong) NSString *last_region;
@property (nonatomic, strong) NSString *log_id;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *name_index;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *open_id;
@property (nonatomic, strong) NSString *personal_signature;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *read_dynamic_time;
@property (nonatomic, strong) NSString *read_friend_time;
@property (nonatomic, strong) NSString *region_code;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *vip_end_date;
@property (nonatomic, strong) NSString *vip_start_date;
@property (nonatomic, strong) NSString *visit_times;
@property (nonatomic, strong) NSString *visit_date;

@end


NS_ASSUME_NONNULL_END
