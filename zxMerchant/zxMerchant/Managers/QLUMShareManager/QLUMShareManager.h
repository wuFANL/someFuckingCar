//
//  QLUMShareManager.h
//  LoveSuguo
//
//  Created by 乔磊 on 2018/1/25.
//  Copyright © 2018年 NineZero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>
#import <UMCommon/UMCommon.h>
@interface QLUMShareManager : NSObject
/**
 *分享回调
 */
@property (nonatomic, strong) ResultBlock successHandler;
/*
 *单例
 */
+ (QLUMShareManager *)shareManager;
/*
 *初始化（不要忘记Appdelegate中添加回调）
 */
- (void)initShare;
/*
 *显示分享面板 @param shareObject 分享对象
             @param vc 当前控制器
 */
- (void)showShareUI:(UMShareObject *)shareObject currentVC:(id)vc;
/*
 *分享网页
 */
- (void)shareToPlatformType:(UMSocialPlatformType)platformType shareObject:(UMShareObject *)shareObject currentVC:(id)vc;
/*
 *分享
 */
- (void)shareToPlatformType:(UMSocialPlatformType)platformType messageObject:(UMSocialMessageObject *)messageObj currentVC:(id)vc;
@end
