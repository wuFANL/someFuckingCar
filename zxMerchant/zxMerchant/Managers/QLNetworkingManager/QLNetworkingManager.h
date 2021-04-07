//
//  LXNetworking.h
//  LXNetworkingDemo
//
//  Created by 乔磊 on 16/4/5.
//  Copyright © 2016年 qiaolei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
@class QLErrorStatusManager;
@class QLParamSignManager;
typedef enum {
    
    StatusUnknown           = -1, //未知网络
    StatusNotReachable      = 0,    //没有网络
    StatusReachableViaWWAN  = 1,    //手机自带网络
    StatusReachableViaWiFi  = 2     //wifi
    
}NetworkStatus;

typedef void( ^ QLResponseSuccess)(id response);
typedef void( ^ QLResponseFail)(NSError *error);
typedef void( ^ QLUploadProgress)(int64_t bytesProgress,
                                  int64_t totalBytesProgress);

typedef void( ^ QLDownloadProgress)(int64_t bytesProgress,
                                   int64_t totalBytesProgress);

/**
 *  方便管理请求任务。执行取消，暂停，继续等任务.
 *  - (void)cancel，取消任务
 *  - (void)suspend，暂停任务
 *  - (void)resume，继续任务
 */
typedef NSURLSessionTask QLURLSessionTask;




@interface QLNetworkingManager : NSObject

/**
 *  单例
 *
 */
+ (QLNetworkingManager *)sharedQLNetworking;

/**
 *  获取网络
 */
@property (nonatomic,assign) NetworkStatus networkStats;
/*
 *  请求头设置
 */
+ (void)configHttpHeaders:(NSDictionary *)httpHeaders;
/**
 *  开启网络监测
 */
+ (void)startMonitoring;
/*
 *AFHTTPSessionManager对象
 */
+ (AFHTTPSessionManager *)getAFManager;
/**
 *  get请求方法,block回调
 *
 *  @param url     请求连接，根路径
 *  @param params  参数
 *  @param success 请求成功返回数据
 *  @param fail    请求失败
 
 */
+(QLURLSessionTask *)getWithUrl:(NSString *)url
           params:(NSDictionary *)params
          success:(QLResponseSuccess)success
             fail:(QLResponseFail)fail;

/**
 *  post请求方法,block回调
 *
 *  @param url     请求连接，根路径
 *  @param params  参数
 *  @param success 请求成功返回数据
 *  @param fail    请求失败
 */
+(QLURLSessionTask *)postWithUrl:(NSString *)url
           params:(NSDictionary *)params
          success:(QLResponseSuccess)success
              fail:(QLResponseFail)fail;
/**
 *  默认URL的post请求方法,block回调
 *
 *  @param params  参数
 *  @param success 请求成功返回数据
 *  @param fail    请求失败
 */
+(QLURLSessionTask *)postWithParams:(NSDictionary *)params
                            success:(QLResponseSuccess)success
                               fail:(QLResponseFail)fail;
/**
 *  上传图片方法
 *
 *  @param image      上传的图片
 *  @param url        请求连接，根路径
 *  @param filename   图片的名称(如果不传则以当时间命名)
 *  @param name       上传图片时填写的图片对应的参数
 *  @param params     参数
 *  @param progress   上传进度
 *  @param success    请求成功返回数据
 *  @param fail       请求失败

 */
+ (QLURLSessionTask *)uploadWithImage:(UIImage *)image
                    url:(NSString *)url
               filename:(NSString *)filename
                   name:(NSString *)name
                 params:(NSDictionary *)params
               progress:(QLUploadProgress)progress
                success:(QLResponseSuccess)success
                   fail:(QLResponseFail)fail;

/**
 *  下载文件方法
 *
 *  @param url           下载地址
 *  @param saveToPath    文件保存的路径,如果不传则保存到Documents目录下，以文件本来的名字命名
 *  @param progressBlock 下载进度回调
 *  @param success       下载完成
 *  @param fail          失败
 *  @return 返回请求任务对象，便于操作
 */
+ (QLURLSessionTask *)downloadWithUrl:(NSString *)url
                           saveToPath:(NSString *)saveToPath
                             progress:(QLDownloadProgress )progressBlock
                              success:(QLResponseSuccess )success
                              failure:(QLResponseFail )fail;

@end


#pragma mark -QLParamSignManager.h
@interface QLParamSignManager : NSObject
/*
 *sign加签
 */
+ (NSString *)paramSign:(NSDictionary *)param;
@end

#pragma mark -QLErrorStatusManager.h
typedef NS_ENUM(NSInteger, QLRESULT_CODE) {
    StatusSuccess = 0,//成功
    StatusOtherError = -1,//一般错误
    StatusLoginOutError = -2000,//用户未登录
    StatusUserInfoError = -2001,//用户信息不正确
    StatusOperationTypeInexistence = -3001,//operation_type不存在
    StatusOperationTypeNoSet = -3002,//operation_type未设置
    StatusTokenLack = -3003,//缺少Token或用户编码
    StatusAccessConfigError = -3004,//用户权限配置错误
    StatusBalanceLack = -4001,//余额不足
    StatusNetworkError = 404 //网络错误或返回数据错误
};
@interface QLErrorStatusManager : NSObject
/**
 *响应吗(00:成功 其他失败)
 */
@property (nonatomic, copy) NSString *result_code;
/**
 *响应消息
 */
@property (nonatomic, copy) NSString *err_msg;
/**
 *result_info
 */
@property (nonatomic, copy) NSString *result_info;
/**
 *返回NSError
 */
- (NSError *)toError;
@end
