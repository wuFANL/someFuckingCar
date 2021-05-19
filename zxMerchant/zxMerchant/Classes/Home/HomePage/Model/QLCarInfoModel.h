//
//  QLCarInfoModel.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2018/10/6.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLCarInfoModel : NSObject
/**
 *归属人类型
 */
@property (nonatomic, strong) NSString *belonger_name;
/**
 *归属人
 */
@property (nonatomic, strong) NSString *belonger_type;
/**
 *事故等级
 */
@property (nonatomic, strong) NSString *accident_level;
/**
 *用户手机
 */
@property (nonatomic, strong) NSString *mobile;
/**
 *车辆描述
 */
@property (nonatomic, strong) NSString *car_desc;
/**
 *车况等级
 */
@property (nonatomic, strong) NSString *car_score;
/**
 *车辆视频
 */
@property (nonatomic, strong) NSString *car_video;
/**
 *cfgLevel
 */
@property (nonatomic, strong) NSString *cfgLevel;
/**
 *车使用性质
 */
@property (nonatomic, strong) NSString *car_usage;
/**
 *1两厢轿车 2三厢轿车 3跑车4suv 5MPV 6面包车 7皮卡
 */
@property (nonatomic, strong) NSString *car_type;
/**
 *车身颜色
 */
@property (nonatomic, strong) NSString *body_color;
/**
 *最高价（元）
 */
@property (nonatomic, strong) NSString *auction_end_price;
/**
 *起拍价
 */
@property (nonatomic, strong) NSString *auction_start_price;
/**
 *拍卖次数
 */
@property (nonatomic, strong) NSString *auction_times;
/**
 *品牌
 */
@property (nonatomic, strong) NSString *brand;
/**
 *品牌id
 */
@property (nonatomic, strong) NSString *brand_id;
/**
 *c_id
 */
@property (nonatomic, strong) NSString *c_id;
/**
 *汽车ID
 */
@property (nonatomic, strong) NSString *car_id;
/**
 *砍价ID
 */
@property (nonatomic, strong) NSString *cu_id;
/**
 *封面
 */
@property (nonatomic, strong) NSString *car_img;
/**
 *城市
 */
@property (nonatomic, strong) NSString *city_belong;
/**
 *车辆状态:
 0仓库中
 1已上架
 3成交
 */
@property (nonatomic, strong) NSString *deal_state;
/**
 *create_time
 */
@property (nonatomic, strong) NSString *create_time;
/**
 *排量
 */
@property (nonatomic, strong) NSString *displacement;
/**
 *行驶公里
 */
@property (nonatomic, strong) NSString *driving_distance;
/**
 *驾驶模式
 */
@property (nonatomic, strong) NSString *driving_mode;
/**
 *排放标准
 */
@property (nonatomic, strong) NSString *emission_standard;
/**
 *出厂方式
 */
@property (nonatomic, strong) NSString *factory_way;
/**
 *车标识 内容
 */
@property (nonatomic, strong) NSString *flag_desc;
/**
 *车标识
 */
@property (nonatomic, strong) NSString *flag_type;
/**
 *车品质
 */
@property (nonatomic, strong) NSString *flag_quality;
/**
 *价格变动
 */
@property (nonatomic, strong) NSString *price_change;
/**
 *生产厂商
 */
@property (nonatomic, strong) NSString *manufactor;
/**
 *商户ID
 */
@property (nonatomic, strong) NSString *member_id;
/**
 *指导价
 */
@property (nonatomic, strong) NSString *guide_price;
/**
 *该车能贷款的金额（元）
 */
@property (nonatomic, strong) NSString *merchant_withdraw_amount;
/**
 *车行预计卖价（元）
 */
@property (nonatomic, strong) NSString *merchant_apply_price;
/**
 *卖价首付
 */
@property (nonatomic, strong) NSString *merchant_sell_pre_price;
/**
 *车行实际卖价（元）
 */
@property (nonatomic, strong) NSString *merchant_real_price;
/**
 *0不包括过户费 1包括过户费
 */
@property (nonatomic, strong) NSString *sell_contain_transfer_fee;
/**
 *销售底价
 */
@property (nonatomic, strong) NSString *sell_min_price;
/**
 *最终售价            
 */
@property (nonatomic, strong) NSString *sell_real_price;
/**
 *采购价
 */
@property (nonatomic, strong) NSString *procure_price;
/**
 *首付
 */
@property (nonatomic, strong) NSString *sell_pre_price;
/**
 *首付比例
 */
@property (nonatomic, strong) NSString *first_payment_ratio;
/**
 *车行报价
 */
@property (nonatomic, strong) NSString *sell_price;
/**
 *砍价
 */
@property (nonatomic, strong) NSString *cut_price;
/**
 *批发价
 */
@property (nonatomic, strong) NSString *wholesale_price;
/**
 *型号
 */
@property (nonatomic, strong) NSString *model;
/**
 *型号id
 */
@property (nonatomic, strong) NSString *model_id;
/*
 *我的报价
 */
@property (nonatomic, strong) NSString *my_last_price;
/**
 *上架时间
 */
@property (nonatomic, strong) NSString *on_shelf_time;
/**
 *上牌日期
 */
@property (nonatomic, strong) NSString *production_date;
/**
 *上牌年份
 */
@property (nonatomic, strong) NSString *production_year;
/**
 *拍卖ID
 */
@property (nonatomic, strong) NSString *play_id;
/**
 *检验员ID
 */
@property (nonatomic, strong) NSString *surveyor_id;
/**
 *变速箱
 */
@property (nonatomic, strong) NSString *transmission_case;
/**
 *档位数
 */
@property (nonatomic, strong) NSString *gearNum;
/**
 *系列
 */
@property (nonatomic, strong) NSString *series;
/**
 *系列id
 */
@property (nonatomic, strong) NSString *series_id;
/**
 *服务费
 */
@property (nonatomic, strong) NSString *serve_price;
/**
 *state
 *
  0 (申请中)
  1 (拍卖中)
  2 (拍卖结束)
  3 (审核拒绝)
 */
@property (nonatomic, strong) NSString *state;
/**
 *update_time
 */
@property (nonatomic, strong) NSString *update_time;
/**
 *车架号
 */
@property (nonatomic, strong) NSString *vin_code;
/**
 *是否提现
 */
@property (nonatomic, strong) NSString *is_loan;
/**
 *是否拍卖
 */
@property (nonatomic, strong) NSString *is_play;
/**
 *车龄
 */
@property (nonatomic, strong) NSString *car_age;
/**
 *燃油类型
 */
@property (nonatomic, strong) NSString *fuel_type;
/**
 *库龄天数
 */
@property (nonatomic, strong) NSString *days;
/**
 *强制险时间
 */
@property (nonatomic, strong) NSString *insure_date;
/**
 *年检时间
 */
@property (nonatomic, strong) NSString *mot_date;
/**
 *过户次数
 */
@property (nonatomic, strong) NSString *transfer_times;
/**
 *喷油形式
 */
@property (nonatomic, strong) NSString *supplyOil;
/**
 *车尺寸
 */
@property (nonatomic, strong) NSString *vehicleSize;
/**
 *轮毂
 */
@property (nonatomic, strong) NSString *wheelbase;
/**
 *座位数
 */
@property (nonatomic, strong) NSString *seating;
/**
 *附件表
 */
@property (nonatomic, strong) NSArray *att_list;

@end

NS_ASSUME_NONNULL_END
