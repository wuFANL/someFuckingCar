//
//  QLUMShareManager.m
//  LoveSuguo
//
//  Created by 乔磊 on 2018/1/25.
//  Copyright © 2018年 NineZero. All rights reserved.
//

#import "QLUMShareManager.h"
#import "UIAlertController+QLUtil.h"

NSString *const UMShareAppkey = @"5c0aaf41f1f55639b0000702";

@implementation QLUMShareManager
+ (QLUMShareManager *)shareManager {
    static QLUMShareManager *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [QLUMShareManager new];
    });
    return share;
}
- (void)initShare {
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    /* 设置友盟appkey */
    [UMConfigure initWithAppkey:UMShareAppkey channel:@"App Store"];
    /*是否使用HTTPS*/
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    [self configUSharePlatforms];
    [self confitUShareSettings];
}
/*
 * 打开图片水印
 */
- (void)confitUShareSettings {
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}
/*
 *分享模块设置
 *（记得设置appKey appSecret redirectURL）
 */
- (void)configUSharePlatforms {
    /*
     *设置微信的appKey和appSecret
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx474e9c7f31de82c5" appSecret:@"d17e1bc278c523e8b8406cc4e5c754b2" redirectURL:@""];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1107804538" appSecret:@"taoHCLIiKecytfF2" redirectURL:@""];
    
}
- (void)showShareUI:(UMShareObject *)shareObject currentVC:(id)vc {
    // 自定义分享模块
//    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareToPlatformType:platformType shareObject:shareObject currentVC:vc];
    }];
}
/*
 *分享网页
 */
- (void)shareToPlatformType:(UMSocialPlatformType)platformType shareObject:(UMShareObject *)shareObject currentVC:(id)vc {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [self shareToPlatformType:platformType messageObject:messageObject currentVC:vc];
}
/*
 *分享
 */
- (void)shareToPlatformType:(UMSocialPlatformType)platformType messageObject:(UMSocialMessageObject *)messageObj currentVC:(id)vc {
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObj currentViewController:vc completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        //回调
        if (self.successHandler) {
            if (!error) {
                self.successHandler(@(YES),nil);
            } else {
                self.successHandler(@(NO),error);
            }
        }
        //弹框提示
        [self alertWithError:error];
    }];
}
/*
 *显示错误
 */
- (void)alertWithError:(NSError *)error {
    [UIAlertController showAlertController:UIAlertControllerStyleAlert Title:!error?@"分享成功":@"分享失败" DetailTitle:!error?@"":error.domain DefaultTitle:nil CancelTitle:@"取消" Delegate:nil DefaultAction:^(NSString *selectedTitle) {
        
    } CancelAction:^{
        
    }];
}
@end
