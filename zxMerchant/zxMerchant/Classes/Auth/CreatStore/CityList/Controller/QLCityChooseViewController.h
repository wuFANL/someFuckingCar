//
//  QLCityChooseViewController.h
//  luluzhuan
//
//  Created by 乔磊 on 2017/10/5.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import "QLBaseTableViewController.h"
#import "QLCityListModel.h"

typedef void (^CitySelectRefresh)(BOOL refresh,NSString *cityName,QLRegionListModel *cityModel);
@interface QLCityChooseViewController : QLBaseTableViewController
/**
 *导航栏标题
 */
@property (nonatomic, strong) NSString *naviTitle;
/**
 *是否显示当前定位
 */
@property (nonatomic, assign) BOOL showCurrentLocation;
/**
 *首页刷新回调
 */
@property (nonatomic, strong) CitySelectRefresh refreshBlock;
@end
