//
//  QLCityListModel.h
//  luluzhuan
//
//  Created by 乔磊 on 2017/10/20.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QLAreaInfoListModel;

@interface QLCityListModel : NSObject
/*
 *分组名
 */
@property (nonatomic, strong) NSString *group_name;
/**
 *区域列表
 */
@property (nonatomic, strong) NSArray *region_list;
@end


@interface QLRegionListModel : NSObject
/*
 *分组名
 */
@property (nonatomic, strong) NSString *group_name;
/*
 *id
 */
@property (nonatomic, strong) NSString *region_id;
/*
 *id
 */
@property (nonatomic, strong) NSString *prov_id;
/*
 *区域名
 */
@property (nonatomic, strong) NSString *region_name;

@end
