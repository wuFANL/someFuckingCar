//
//  AppDelegate.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2018/5/3.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "AppDelegate.h"
#import "QLNavigationController.h"
#import "QLTabBarController.h"
#import "QLWelcomeViewController.h"
#import "QLPreloadPageViewController.h"
#import "QLLoginViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //初始化window
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    BOOL hasUse = [UserDefaults boolForKey:LocalHasUseKey];
    if (!hasUse) {
        //去欢迎页
        [UserDefaults setBool:YES forKey:LocalHasUseKey];
        QLWelcomeViewController *wVC = [QLWelcomeViewController new];
        self.window.rootViewController = wVC;
        [self.window makeKeyAndVisible];
    } else {
        if ([QLUserInfoModel getLocalInfo].isLogin) {
            //数据预加载
            [self initPreloadVC];
        } else {
            //初始化登录
            [self initLoginVC];
        }
    }
    
    //打开log
    [QLKitLogManager setLogEnable:YES];
    //初始友盟
    [[QLUMShareManager shareManager] initShare];
    //初始化极光
    [self initJPUSH:launchOptions];
    //微信注册
    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString *log) {//在register之前打开log, 后续可以根据log排查问题
        QLLog(@"WeChatSDK: %@", log);
    }];
    [WXApi registerApp:@"wx474e9c7f31de82c5" universalLink:@"https://Merchant"];
    //初始化腾讯bugly
    [Bugly startWithAppId:@"86b7960613"];
    
    
    return YES;
}
#pragma mark-初始化首页
- (void)initTabBarVC {
    QLTabBarController *tabBar = [[QLTabBarController alloc]init];
    QLNavigationController *tabBarNavi = [[QLNavigationController alloc]initWithRootViewController:tabBar];
    self.window.rootViewController = tabBarNavi;
    [self.window makeKeyAndVisible];
    
}
#pragma mark -初始化登录
- (void)initLoginVC {
    QLLoginViewController *loginVC = [[QLLoginViewController alloc]init];
    QLNavigationController *navi = [[QLNavigationController alloc]initWithRootViewController:loginVC];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
}
#pragma mark-初始化预加载页
- (void)initPreloadVC {
    QLPreloadPageViewController *ppVC = [QLPreloadPageViewController new];
    self.window.rootViewController = ppVC;
    [self.window makeKeyAndVisible];
}
#pragma mark -初始化极光
- (void)initJPUSH:(NSDictionary *)launchOptions {
    //初始化 APNs
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|UNAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        
    }
    //初始化 JPush 代码
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:@"2c8ea5af3f409621880b139c" channel:@"App Store" apsForProduction:NO];
    //远程推送的消息
    if (launchOptions) {
        NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
        [self receivePush:userInfo];
    }
    
}
//获取到推送
- (void)receivePush:(NSDictionary *)userInfo {
    //有推送 刷新一下聊天列表
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JPushNotifForChatMessage" object:nil];
    
    if (userInfo != nil&&[userInfo[@"dealType"] integerValue] != 0) {
        QLPushMsgModel *model = [QLPushMsgModel new];
        model.jump_type = userInfo[@"dealType"];
        model.params = userInfo[@"dealCode"];
        if (model) {
            QLNavigationController *navi = (QLNavigationController *)self.window.rootViewController;
            [[QLToolsManager share] msgDetailJump:model deleate:navi.topViewController];
        }
    }
}
#pragma mark -微信回调
- (void)onReq:(BaseReq *)req {
//-微信回调
    QLLog(@"%@",req);
}
- (void)onResp:(BaseResp *)resp {
    QLLog(@"%@",resp);
}
#pragma mark -系统回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
        // 通知刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WeChatPayBack" object:nil];
        
        return  [WXApi handleOpenURL:url delegate:self];
    }
    return result;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    QLLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#pragma mark- JPUSHRegisterDelegate
//监测通知授权状态返回的结果
- (void)jpushNotificationAuthorization:(JPAuthorizationStatus)status withInfo:(NSDictionary *)info {
    
}
// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)){
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
        
    }else{
        //从通知设置界面进入应用
        
    }
}

// iOS 10 Support 收到通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    [self receivePush:userInfo];
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    }
    // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
    completionHandler(UNNotificationPresentationOptionAlert);
    //收到推送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:PushMsgKey object:nil userInfo:userInfo];
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    //获取推送响应
    [self receivePush:userInfo];
    // Required
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    //获取推送响应
    [self receivePush:userInfo];
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}




@end
