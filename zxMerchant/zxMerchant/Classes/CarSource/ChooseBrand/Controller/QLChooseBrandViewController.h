//
//  QLChooseBrandViewController.h
//  PopularUsedCarManagement
//
//  Created by 乔磊 on 2019/1/17.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLViewController.h"
#import "QLBrandModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^BrandResult)(QLBrandInfoModel * _Nullable brandModel,QLSeriesModel * _Nullable seriesModel,QLTypeInfoModel * _Nullable typeModel);

@interface QLChooseBrandViewController : QLViewController
/**
 *上次选择的品牌id
 */
@property (nonatomic, strong) NSString *brand_id;
/**
 *上次选择的系列id
 */
@property (nonatomic, strong) NSString *series_id;
/**
 *上次选择的型号id
 */
@property (nonatomic, strong) NSString *model_id;
/**
 *是否只显示品牌
 */
@property (nonatomic, assign) BOOL onlyShowBrand;
/**
 *不显示型号
 */
@property (nonatomic, assign) BOOL noShowModel;
/*
 *结果返回
 */
@property (nonatomic, strong) BrandResult callback;

@end

NS_ASSUME_NONNULL_END
