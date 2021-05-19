//
//  QLCarDetailModel.h
//  PopularUsedCar
//
//  Created by 乔磊 on 2018/7/2.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLCarInfoModel.h"
@class QLCarBannerModel;
@class QLExamineInfoModel;
@class QLDescribeModel;
@class QLStaffInfoModel;

@interface QLCarDetailModel : NSObject
/**
 *当前拍卖价格
 */
@property (nonatomic, strong) NSString *auction_end_price;
/**
 *底价
 */
@property (nonatomic, strong) NSString *auction_start_price;
/**
 *拍卖次数
 */
@property (nonatomic, strong) NSString *auction_times;
/**
 *车龄
 */
@property (nonatomic, strong) NSString *car_age;
/**
 *车辆信息
 */
@property (nonatomic, strong) QLCarInfoModel *car_base_info;
/**
 *车辆图片集合(车辆外观)
 */
@property (nonatomic, strong) NSArray *car_img_exterior_list;
/**
 *检测师描述列表
 */
@property (nonatomic, strong) NSArray *describe_list;
/**
 *车检基本信息
 */
@property (nonatomic, strong) NSArray *examine_info;
/**
 *车辆轮播图
 */
@property (nonatomic, strong) NSArray *car_img_banner_list;
/**
 *车辆图片集合(车辆内饰)
 */
@property (nonatomic, strong) NSArray *car_img_trim_list;
/**
 *车辆图片集合(结构发动机)
 */
@property (nonatomic, strong) NSArray *car_img_engine_list;
/**
 *车辆图片集合(更多细节)
 */
@property (nonatomic, strong) NSArray *car_img_other_list;
/**
 *价格变动
 */
@property (nonatomic, strong) NSString *price_change;
/**
 *服务费
 */
@property (nonatomic, strong) NSString *serve_price;
/**
 *我的出价
 */
@property (nonatomic, strong) NSString *my_auction_price;
/**
 *检测人信息
 */
@property (nonatomic, strong) QLStaffInfoModel *staff_info;
@end

#pragma mark -轮播图
@interface QLCarBannerModel : NSObject
/**
 *车辆ID
 */
@property (nonatomic, strong) NSString *car_id;
/**
 *create_time
 */
@property (nonatomic, strong) NSString *create_time;
/**
 *车证小类
 */
@property (nonatomic, strong) NSString *detail_name;
/**
 *车证大类
 */
@property (nonatomic, strong) NSString *detecte_total_name;
/**
 *描述
 */
@property (nonatomic, strong) NSString *remark;
/**
 *id
 */
@property (nonatomic, strong) NSString *banner_id;
/**
 *operation_time
 */
@property (nonatomic, strong) NSString *operation_time;
/**
 *type
 */
@property (nonatomic, strong) NSString *type;
/**
 *1有效 0无效
 */
@property (nonatomic, strong) NSString *state;
/**
 *图片
 */
@property (nonatomic, strong) NSString *pic_url;
/**
 *sort
 */
@property (nonatomic, strong) NSString *sort;
/**
 *is_show
 */
@property (nonatomic, strong) NSString *is_show;
@end

#pragma mark -车检基本信息
@interface QLExamineInfoModel : NSObject
/**
 *
 */
@property (nonatomic, strong) NSString *ckeck_value;
/**
 *
 */
@property (nonatomic, strong) NSString *icon;
/**
 *
 */
@property (nonatomic, strong) NSString *item_count;
/**
 *
 */
@property (nonatomic, strong) NSString *one_dir_code;
/**
 *
 */
@property (nonatomic, strong) NSString *one_dir_name;
/**
 *总数量
 */
@property (nonatomic, strong) NSString *all_num;
/**
 *图片
 */
@property (nonatomic, strong) NSString *detecte_total_img;
/**
 *名称
 */
@property (nonatomic, strong) NSString *detecte_total_name;
/**
 *错误数量
 */
@property (nonatomic, strong) NSString *error_num;
@end

#pragma mark -检测师描述
@interface QLDescribeModel : NSObject
/**
 *check_id
 */
@property (nonatomic, strong) NSString *check_id;
/**
 *结果
 */
@property (nonatomic, strong) NSString *result_value;
/**
 *
 */
@property (nonatomic, strong) NSString *one_dir_code;
/**
 *
 */
@property (nonatomic, strong) NSString *one_dir_name;
/**
 *state
 */
@property (nonatomic, strong) NSString *state;
/**
 *id
 */
@property (nonatomic, strong) NSString *item_id;
/**
 *图片地址
 */
@property (nonatomic, strong) NSString *image_url;
/**
 *
 */
@property (nonatomic, strong) NSString *staff_id;
@end

@interface QLStaffInfoModel : NSObject
@property (nonatomic, strong) NSString *bisadmin;
@property (nonatomic, strong) NSString *dadddate;
@property (nonatomic, strong) NSString *dmodifydate;
@property (nonatomic, strong) NSString *sdepartmentid;
@property (nonatomic, strong) NSString *sguid;
@property (nonatomic, strong) NSString *smobile;
@property (nonatomic, strong) NSString *soperatorno;
@property (nonatomic, strong) NSString *spassword;
@property (nonatomic, strong) NSString *srealname;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *susername;
@property (nonatomic, strong) NSString *user_type;
@end
