//
//  QLUserInfoModel.h
//  JSTY
//
//  Created by 乔磊 on 2018/5/21.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QLUserModel;
@class QLBusinessModel;
@class QLPersonnelModel;
@class QLRoleModel;
@class QLAccountModel;
@interface QLUserInfoModel : NSObject
/**
 *token
 */
@property (nonatomic, strong) NSString *token;
/**
 *店铺信息
 */
@property (nonatomic, strong) QLBusinessModel *business;
/**
 *职员信息
 */
@property (nonatomic, strong) QLPersonnelModel *personnel;
/**
 *用户信息
 */
@property (nonatomic, strong) QLUserModel *account;
/**
 *用户账户信息
 */
@property (nonatomic, strong) QLAccountModel *member_account;



/**
 *账号
 */
- (BOOL)isTest;
/**
 *是否登录
 */
- (BOOL)isLogin;
/*
 *保存本地信息
 */
+ (void)saveUserInfo:(NSDictionary *)result_info;
/*
 *获取本地用户信息字典
 */
+ (NSDictionary *)getLocalDic;
/*
 *获取本地用户信息模型
 */
+ (QLUserInfoModel *)getLocalInfo;
/*
 *修改本地用户信息参数
 */
+ (void)updateUserInfoByModel:(QLUserInfoModel *)userInfo;
/*
 *退出登录
 */
+ (void)loginOut;
@end

@interface QLUserModel : NSObject
/**
 *account_id
 */
@property (nonatomic, strong) NSString *account_id;
/**
 *account_number
 */
@property (nonatomic, strong) NSString *account_number;
/**
 *地址
 */
@property (nonatomic, strong) NSString *address;
/**
 *attention_time
 */
@property (nonatomic, strong) NSString *attention_time;
/**
 *audit_remark
 */
@property (nonatomic, strong) NSString *audit_remark;
/**
 *back_pic
 */
@property (nonatomic, strong) NSString *back_pic;
/**
 *店铺
 */
@property (nonatomic, strong) NSString *business;
/**
 *店铺区域
 */
@property (nonatomic, strong) NSString *business_area;
/**
 *店铺编码
 */
@property (nonatomic, strong) NSString *business_id;
/**
 *城市
 */
@property (nonatomic, strong) NSString *city;
/**
 *动态url
 */
@property (nonatomic, strong) NSString *dynamic_url;
/**
 *flag
 */
@property (nonatomic, strong) NSString *flag;
/**
 *营业执照图片
 */
@property (nonatomic, strong) NSString *head_pic;
/**
 *log_id
 */
@property (nonatomic, strong) NSNumber *log_id;
/**
 *手机号
 */
@property (nonatomic, strong) NSString *mobile;
/**
 *昵称
 */
@property (nonatomic, strong) NSString *nickname;
/**
 *个人签名
 */
@property (nonatomic, strong) NSString *personal_signature;
/**
 *pwd_flag
 */
@property (nonatomic, strong) NSString *pwd_flag;
/**
 *region_code
 */
@property (nonatomic, strong) NSString *region_code;
/**
 *remak
 */
@property (nonatomic, strong) NSString *remak;
/**
 *state
 */
@property (nonatomic, strong) NSString *state;
/**
 *会员到期时间
 */
@property (nonatomic, strong) NSString *vip_end_date;
/**
 *会员开始时间
 */
@property (nonatomic, strong) NSString *vip_start_date;
/**
 *浏览次数
 */
@property (nonatomic, strong) NSString *visit_times;

@end


@interface QLBusinessModel : NSObject
/**
 *账号编码
 */
@property (nonatomic, strong) NSString *account_id;
/**
 *店铺所在省
 */
@property (nonatomic, strong) NSString *province;
/**
 *店铺所在市
 */
@property (nonatomic, strong) NSString *city;
/**
 *店铺区域
 */
@property (nonatomic, strong) NSString *business_area;
/**
 *店铺所在位置
 */
@property (nonatomic, strong) NSString *address;
/**
 *店铺详细位置
 */
@property (nonatomic, strong) NSString *detailAddress;
/**
 *店铺编码
 */
@property (nonatomic, strong) NSString *business_id;
/**
 *店铺名称
 */
@property (nonatomic, strong) NSString *business_name;
/**
 *店铺图片
 */
@property (nonatomic, strong) NSString *business_pic;
/**
 *身份证反面
 */
@property (nonatomic, strong) NSString *idcar_back_pic;
/**
 *身份证正面
 */
@property (nonatomic, strong) NSString *idcar_font_pic;
/**
 *店铺车数量
 */
@property (nonatomic, strong) NSNumber *car_count;
/**
 *封面
 */
@property (nonatomic, strong) NSString *cover_image;
/**
 *创建时间
 */
@property (nonatomic, strong) NSString *create_time;
/**
 *
 */
@property (nonatomic, strong) NSString *flag;
/**
 *纬度
 */
@property (nonatomic, strong) NSString *lat;
/**
 *经度
 */
@property (nonatomic, strong) NSString *lng;
/**
 *店主名
 */
@property (nonatomic, strong) NSString *name;
/**
 *操作时间
 */
@property (nonatomic, strong) NSString *operation_time;
/**
 *店铺邮编
 */
@property (nonatomic, strong) NSString *region_code;
/**
 *状态
 */
@property (nonatomic, strong) NSString *state;

@end

#pragma mark - 职员信息
@interface QLPersonnelModel : NSObject
/**
 *店铺编码
 */
@property (nonatomic, strong) NSString *business_id;
/**
 *店铺职员编码
 */
@property (nonatomic, strong) NSString *business_personnel_id;
/**
 *
 */
@property (nonatomic, strong) NSNumber *flag;
/**
 *职员编码
 */
@property (nonatomic, strong) NSString *personnel_id;
/**
 *昵称
 */
@property (nonatomic, strong) NSString *personnel_nickname;
/**
 *角色数据列表
 */
@property (nonatomic, strong) NSArray *role_date;
/**
 *角色
 */
@property (nonatomic, strong) QLRoleModel *role;
/**
 *
 */
@property (nonatomic, strong) NSString *state;
@end


@interface QLRoleModel : NSObject
/**
 *角色编码
 */
@property (nonatomic, strong) NSString *business_role_id;
/**
 *角色名称
 */
@property (nonatomic, strong) NSString *role_name;
@end


@interface QLAccountModel : NSObject
/**
 *
 */
@property (nonatomic, strong) NSString *account_id;
/**
 *
 */
@property (nonatomic, strong) NSString *alipay_url;
/**
 *
 */
@property (nonatomic, strong) NSString *all_in;
/**
 *
 */
@property (nonatomic, strong) NSString *all_out;
/**
 *
 */
@property (nonatomic, strong) NSString *balance;
/**
 *
 */
@property (nonatomic, strong) NSString *create_time;
/**
 *
 */
@property (nonatomic, strong) NSString *member_account_id;
/**
 *
 */
@property (nonatomic, strong) NSString *loan_amount;
/**
 *
 */
@property (nonatomic, strong) NSString *pay_passowrd;
/**
 *
 */
@property (nonatomic, strong) NSString *pre_quota;
/**
 *
 */
@property (nonatomic, strong) NSString *quota;
/**
 *
 */
@property (nonatomic, strong) NSString *state;
/**
 *
 */
@property (nonatomic, strong) NSString *weixpay_url;
@end
