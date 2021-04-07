//
//  AppDelegate.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2018/5/3.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
//腾讯bugly
#import <Bugly/Bugly.h>
//微信
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,JPUSHRegisterDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
/*
 *初始化登录
 */
- (void)initLoginVC;
/*
 *初始化首页
 */
- (void)initTabBarVC;

@end

