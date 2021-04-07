//
//  QLBrandModel.h
//  PopularUsedCarManagement
//
//  Created by 乔磊 on 2019/1/30.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class QLBrandInfoModel;
@class QLSeriesModel;
@class QLTypeModel;
@class QLTypeInfoModel;

@interface QLBrandModel : NSObject
@property (nonatomic, strong) NSString *brand_group;
@property (nonatomic, strong) NSArray *brand_list;
@property (nonatomic, strong) NSArray *brand_list_recom;
@end

@interface QLBrandInfoModel : NSObject
@property (nonatomic, strong) NSString *brand_group;
@property (nonatomic, strong) NSString *brand_name;
@property (nonatomic, strong) NSString *brand_num;
@property (nonatomic, strong) NSString *brand_short_name;
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *brand_id;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *juhe_num;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *type;
@end

@interface QLSeriesModel : NSObject
@property (nonatomic, strong) NSString *brand_id;
@property (nonatomic, strong) NSString *brand_sub_name;
@property (nonatomic, strong) NSString *car_count;
@property (nonatomic, strong) NSString *series_id;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *series_group_name;
@property (nonatomic, strong) NSString *series_name;
@property (nonatomic, strong) NSString *series_num;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *type;
@end

@interface QLTypeModel : NSObject
@property (nonatomic, strong) NSString *model_year;
@property (nonatomic, strong) NSArray *modelList;

@end

@interface QLTypeInfoModel : NSObject
@property (nonatomic, strong) NSString *series_id;
@property (nonatomic, strong) NSString *liter;
@property (nonatomic, strong) NSString *model_desc;
@property (nonatomic, strong) NSString *model_num;
@property (nonatomic, strong) NSString *model_price;
@property (nonatomic, strong) NSString *model_year;
@property (nonatomic, strong) NSString *model_id;
@property (nonatomic, strong) NSString *series_name;
@property (nonatomic, strong) NSString *series_num;

@end
NS_ASSUME_NONNULL_END
