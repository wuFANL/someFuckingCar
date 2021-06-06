//
//  QLToolsManager.h
//  QLKit
//
//  Created by 乔磊 on 2018/3/21.
//  Copyright © 2018年 NineZero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "QLNavigationController.h"
#import "QLCustomAlertView.h"
#import "QLPushMsgModel.h"
#import "QLHomePageModel.h"


typedef void (^ResultBlock)(id result,NSError *error);
typedef void (^ImgCallBlock)(UIImagePickerController *picker,NSDictionary *info);
extern NSString* EncodeStringFromDic(NSDictionary *dic, NSString *key);
extern NSString* Operation_type;
@interface QLToolsManager : NSObject
#pragma mark - 全局属性
/**
 *当前定位的坐标
 */
@property (nonatomic, strong) CLLocation *currentLocation;
/**
 *当前城市
 */
@property (nonatomic, strong) NSString *currentCityName;
/**
 *其他用户信息
 */
@property (nonatomic, strong) QLHomePageModel *homePageModel;


#pragma mark - 预加载数据方法
/**
 *获取验证码
 */
- (void)getCodeByMobile:(NSString *)mobile handler:(ResultBlock)result;
/**
 *分享记录
 */
- (void)shareRecord:(NSDictionary *)param handler:(ResultBlock)result;
/**
 *业务员名下车商
 */
- (void)getDealers:(ResultBlock)result;
/**
 *首页数据
 */
- (void)getFunData:(ResultBlock)result;
/**
 *获取个人信息
 */
- (void)getMeInfoRequest:(ResultBlock)result;
/**
 *申请车资出入库
 */
- (void)applyAssetsStore:(NSDictionary *)param handler:(ResultBlock)result;
/**
 *取消车资出入库
 */
- (void)cancelAssetsStore:(NSDictionary *)param handler:(ResultBlock)result;
#pragma mark - 全局方法
/**
 *利息计算
 */
+ (NSMutableDictionary *)rateConversion:(NSString *)value;
/**
 *返点计算
 */
+ (NSMutableDictionary *)rebateConversion:(NSString *)value;
/**
 *自定义弹框
 */
- (QLCustomAlertView *)alert:(NSString *)title handler:(void(^)(NSError *error))handler;
/**
 *图片选择
 */
- (void)getPhotoAlbum:(UIViewController *)currentVC resultBack:(ImgCallBlock)block;
//根据类型打开图片选择器
- (void)openImagePickerByType:(NSInteger)type currentVC:(UIViewController *)vc resultBack:(ImgCallBlock)block;
/**
 *消息详情跳转
 */
- (void)msgDetailJump:(QLPushMsgModel *)param deleate:(UIViewController *)vc;
/**
 *里程换算
 */
- (NSString *)unitMileage:(float)digital;
/**
 *单位换算(万元/元)
 */
- (NSString *)unitConversion:(float)digital;
/**
 *推出web控制器
 *@param loadUrl     加载地址
 *@param title       导航栏标题
 *@param currentSelf 当前控制器
 */
- (void)loadUrlInVC:(NSString *)loadUrl title:(NSString *)title currentVC:(UIViewController *)currentSelf;
/**
 *验证码按钮倒计时方法
 *@param codeBtn 倒计时按钮
 *@param pattern 传1：按钮点击 传2：页面初始化时调用
 */
- (void)codeBtnCountdown:(UIButton *)codeBtn Pattern:(int)pattern;
/**
 *未登录提示框
 */
- (void)noLoginAlert:(UIViewController *)currentSelf;
/**
 *联系客服
 *@param url 电话号码
 */
- (void)contactCustomerService:(NSString *)url;
/**
 *获取DocumentsPath
 */
- (NSString *)setDocumentsPath;
/**
 *获取手机IP
 */
- (NSString*)getIPAddress;
/**
 *获取手机uuid -->UUID每次生成的值都不一样,需要开发者自行保存UUID
 */
- (NSString *)getUUID;
/**
 *判断是否是 iPhone X以上版本
 */
- (BOOL)beyond_iPhoneX;
/**
 *tableViewCell圆角
 */
+ (void)cellSetRound:(UITableView *)tableView Cell:(UITableViewCell *)cell IndexPath:(NSIndexPath *)indexPath SideSpace:(CGFloat)margin;
/**
 *转换时间一小时前 一天前
 */
+ (NSString *)compareCurrentTime:(NSString *)str;
/**
 *单例
 */
+(QLToolsManager *)share;
@end
