//
//  QLHomePageModel.h
//  PopularUsedCar
//
//  Created by 乔磊 on 2018/6/28.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QLBannerModel;
@class QLFunModel;

typedef NS_ENUM(NSUInteger, FunctionType) {
    UnknowFunction = 0,//未知功能
    ImageShare = 101,//多图分享
    StoreShare = 102,//店铺分享
    ReleaseDynamic = 103,//发布动态
    CarPuzzle = 104,//车辆拼图
    CarSource = 105,//找车源
    CarManager = 106,//车辆管理
    BoardVehicle = 107,//上架车辆
    MyStore = 108,//我的店铺
    VehicleCertificate = 109,//车辆牌证
    VisitorManagement = 110,//访客管理
    HelpBuyOrder = 111,//帮买订单
    CustomerManager = 112,//客户管理
    PaymentAccount = 113,//收款卡号
    CreditReporting = 114,//征信查询
    ZXInventory = 115,//众享金服
    SubscriptionVehicle = 116,//订阅车辆
    FindToDepart = 117,//找人发车
};

#pragma mark - 首页数据模型
@interface QLHomePageModel : NSObject
/**
 *顶部轮播图
 */
@property (nonatomic, strong) NSArray *banner_list;
/**
 *头条车源
 */
@property (nonatomic, strong) NSArray *top_car_list;
/**
 *好车推荐
 */
@property (nonatomic, strong) NSArray *recommend_car_list;
/**
 *车商友人
 */
@property (nonatomic, strong) NSArray *friend_list;
/**
 *公众号今日访客
 */
@property (nonatomic, strong) NSNumber *visit_today_c;
/**
 *公众号总访客
 */
@property (nonatomic, strong) NSNumber *visit_all_c;
/**
 *车源今日访客
 */
@property (nonatomic, strong) NSNumber *visit_today_b;
/**
 *车源总访客
 */
@property (nonatomic, strong) NSNumber *visit_all_b;
/**
 *功能包
 */
@property (nonatomic, strong) NSMutableArray *function_list;


/** 朋友圈*/
@property (nonatomic, strong) NSArray *friendCycle;

/**
 *根据ID获取功能模型
 */
- (QLFunModel *)getFun:(FunctionType)fun_value;
/**
 *根据ID获取功能模型名称和图片名称
 */
- (NSDictionary *)getFunNameAndImgName:(FunctionType)fun_value;
@end

#pragma mark - 轮播图模型
@interface QLBannerModel : NSObject
/**
 *创建时间
 */
@property (nonatomic, strong) NSString *create_time;
/**
 *id
 */
@property (nonatomic, strong) NSString *banner_id;
/**
 *下标
 */
@property (nonatomic, strong) NSString *index_no;
/**
 *摘要
 */
@property (nonatomic, strong) NSString *news_abstract;
/**
 *内容
 */
@property (nonatomic, strong) NSString *news_content;
/**
 *标题
 */
@property (nonatomic, strong) NSString *news_title;
/**
 *跳转地址
 */
@property (nonatomic, strong) NSString *news_title_image_jump_url;
/**
 *图片地址
 */
@property (nonatomic, strong) NSString *news_title_image_url;
/**
 *operation_time
 */
@property (nonatomic, strong) NSString *operation_time;
/**
 *备注
 */
@property (nonatomic, strong) NSString *remarks;
/**
 *state
 */
@property (nonatomic, strong) NSString *state;
/**
 *类型
 */
@property (nonatomic, strong) NSString *sub_type;
/**
 *type
 */
@property (nonatomic, strong) NSString *type;
@end

#pragma mark - 功能包模型
@interface QLFunModel : NSObject
/**
 *diction_id
 */
@property (nonatomic, strong) NSString *diction_id;
/**
 *extend_01
 */
@property (nonatomic, strong) NSString *extend_01;
/**
 *extend_02
 */
@property (nonatomic, strong) NSString *extend_02;
/**
 *extend_03
 */
@property (nonatomic, strong) NSString *extend_03;
/**
 *function_id
 */
@property (nonatomic, strong) NSString *function_id;
/**
 *标注
 */
@property (nonatomic, strong) NSString *remark;
/**
 *类型
 */
@property (nonatomic, strong) NSString *type;
/**
 *内容
 */
@property (nonatomic, strong) NSString *value;
@end
