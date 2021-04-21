//
//  QLNetworkingManager.m
//  QLNetworkingManagerDemo
//
//  Created by 乔磊 on 16/4/5.
//  Copyright © 2016年 qiaolei. All rights reserved.
//

#import "QLNetworkingManager.h"
#import <YYModel.h>

static NSMutableArray *tasks;//管理网络请求的队列
static NSMutableDictionary *headers; //请求头的参数设置
static NSTimeInterval requestTimeout = 20;//请求超时时间
@implementation QLNetworkingManager

+ (QLNetworkingManager *)sharedQLNetworking {
    static QLNetworkingManager *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[QLNetworkingManager alloc] init];
    });
    return handler;
}

+(QLURLSessionTask *)getWithUrl:(NSString *)url
                         params:(NSDictionary *)params
                        success:(QLResponseSuccess)success
                           fail:(QLResponseFail)fail
{
    
    return [self baseRequestType:1 url:url params:params success:success fail:fail];
    
}

+(QLURLSessionTask *)postWithUrl:(NSString *)url
                          params:(NSDictionary *)params
                         success:(QLResponseSuccess)success
                            fail:(QLResponseFail)fail
{
    return [self baseRequestType:2 url:url params:params success:success fail:fail];
}
+(QLURLSessionTask *)postWithParams:(NSDictionary *)params
                         success:(QLResponseSuccess)success
                            fail:(QLResponseFail)fail
{
    return [self baseRequestType:2 url:nil params:params success:success fail:fail];
}
+(QLURLSessionTask *)baseRequestType:(NSUInteger)type
                                 url:(NSString *)url
                              params:(NSDictionary *)params
                             success:(QLResponseSuccess)success
                                fail:(QLResponseFail)fail
{
    //固定参数
    NSMutableDictionary *mutableParam = [NSMutableDictionary dictionaryWithDictionary:params];
    if ([params.allKeys containsObject:@"user_id"]) {
        mutableParam[@"token"] = [QLUserInfoModel getLocalInfo].token;
    }
    mutableParam[@"version_id"] = VersionId;
    mutableParam[@"sign"] = [QLParamSignManager paramSign:mutableParam];
    mutableParam[@"account_id"] = [QLUserInfoModel getLocalInfo].account.account_id;
    if (url == nil) {
        url = [NSString stringWithFormat:@"http://%@/index/%@.do",HOST,mutableParam[@"operation_type"]];
    } else {
        url = [NSString stringWithFormat:@"http://%@/%@.do",url,mutableParam[@"operation_type"]];
    }
    QLLog(@"请求地址----%@\n    请求参数----%@",url,mutableParam);
    //处理中文和空格问题
    NSString *urlStr=[NSURL URLWithString:url]?url:[self strUTF8Encoding:url];
    AFHTTPSessionManager *manager = [self getAFManager];
    QLURLSessionTask *sessionTask=nil;
    if (type==1) {
        sessionTask = [manager GET:urlStr parameters:mutableParam headers:headers progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                switch ([responseObject[@"result_code"] integerValue]) {
                    case StatusSuccess:
                        //成功
                        QLLog(@"请求成功----%@",responseObject);
                        success(responseObject);
                        break;
                    default:{
                        //失败
                        QLErrorStatusManager *errorStatus = [QLErrorStatusManager  yy_modelWithJSON:responseObject];
                        NSError *error = [errorStatus toError];
                        QLLog(@"请求失败----%@",error);
                        fail(error);
                    }
                        break;
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            QLLog(@"error=%@",error);
            if (fail) {
                NSError *networkError = [NSError errorWithDomain:@"亲，网络不给力！" code:error.code userInfo:error.userInfo];
                fail(networkError);
            }
        }];
    } else{
        [manager POST:url parameters:mutableParam headers:headers progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                switch ([responseObject[@"result_code"] integerValue]) {
                    case StatusSuccess:
                        //成功
                        QLLog(@"请求成功----%@",responseObject);
                        success(responseObject);
                        break;
                    default:{
                        //失败
                        QLErrorStatusManager *errorStatus = [QLErrorStatusManager  yy_modelWithJSON:responseObject];
                        NSError *error = [errorStatus toError];
                        QLLog(@"请求失败----%@",error);
                        fail(error);
                    }

                        break;
                }
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            QLLog(@"error----%@",error);
            if (fail) {
                NSError *networkError = [NSError errorWithDomain:@"亲，网络不给力！" code:error.code userInfo:error.userInfo];
                fail(networkError);
            }
        }];
    }

    return sessionTask;
    
}

+(QLURLSessionTask *)uploadWithImage:(UIImage *)image
                                 url:(NSString *)url
                            filename:(NSString *)filename
                                name:(NSString *)name
                              params:(NSDictionary *)params
                            progress:(QLUploadProgress)progress
                             success:(QLResponseSuccess)success
                                fail:(QLResponseFail)fail
{

    QLLog(@"请求地址----%@\n    请求参数----%@",url,params);
    if (url==nil) {
        return nil;
    }
    //检查地址中是否有中文
    NSString *urlStr=[NSURL URLWithString:url]?url:[self strUTF8Encoding:url];
    AFHTTPSessionManager *manager = [self getAFManager];
    QLURLSessionTask *sessionTask = [manager POST:urlStr parameters:params headers:headers constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //压缩图片
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        NSString *imageFileName = filename;
        if (filename == nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
        }
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        QLLog(@"上传进度--%lld,总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        QLLog(@"上传图片成功=%@",responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        QLLog(@"error=%@",error);
        if (fail) {
            fail(error);
        }
    }];

    return sessionTask;
}

+ (QLURLSessionTask *)downloadWithUrl:(NSString *)url
                           saveToPath:(NSString *)saveToPath
                             progress:(QLDownloadProgress)progressBlock
                              success:(QLResponseSuccess)success
                              failure:(QLResponseFail)fail
{
    
    
    QLLog(@"请求地址----%@\n    ",url);
    if (url==nil) {
        return nil;
    }
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPSessionManager *manager = [self getAFManager];
    
    QLURLSessionTask *sessionTask = nil;
    
    sessionTask = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        QLLog(@"下载进度--%.1f",1.0 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        //回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressBlock) {
                progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (!saveToPath) {
            
            NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            QLLog(@"默认路径--%@",downloadURL);
            return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
            
        }else{
            return [NSURL fileURLWithPath:saveToPath];
            
        }
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        QLLog(@"下载文件成功");
        if (error == nil) {
            if (success) {
                success([filePath path]);//返回完整路径
            }
            
        } else {
            if (fail) {
                
                fail(error);
            }
        }
        
        
    }];
    
    //开始启动任务
    [sessionTask resume];
    
    return sessionTask;
    
}

+(AFHTTPSessionManager *)getAFManager{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];//设置请求数据为json
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//设置返回数据类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/plain",@"text/javascript",@"text/xml",nil];
    //    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer.timeoutInterval = requestTimeout;
    //SSL证书验证
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    
    return manager;
    
}
//请求头
+ (void)configHttpHeaders:(NSDictionary *)httpHeaders {
    QLLog(@"%@",httpHeaders);
    headers = httpHeaders.mutableCopy;
}
//https证书
+ (AFSecurityPolicy*)customSecurityPolicy {
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
    AFSecurityPolicy *securityPolicy;
    if (cerPath) {
        //证书的路径
        NSData *certData = [NSData dataWithContentsOfFile:cerPath];
        // AFSSLPinningModeCertificate 使用证书验证模式
        securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:certData, nil];
    } else {
        // AFSSLPinningModeCertificate 使用证书不验证模式
        securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    }
    // 如果是需要验证自建证书，需要设置为YES,默认为NO
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    securityPolicy.validatesDomainName = NO;

    return securityPolicy;
}
#pragma makr - 开始监听网络连接

+ (void)startMonitoring
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                QLLog(@"未知网络");
                [QLNetworkingManager sharedQLNetworking].networkStats=StatusUnknown;
                
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                QLLog(@"没有网络");
                [QLNetworkingManager sharedQLNetworking].networkStats=StatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                QLLog(@"手机自带网络");
                [QLNetworkingManager sharedQLNetworking].networkStats=StatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                
                [QLNetworkingManager sharedQLNetworking].networkStats=StatusReachableViaWiFi;
                QLLog(@"WIFI--%d",[QLNetworkingManager sharedQLNetworking].networkStats);
                break;
        }
    }];
    [mgr startMonitoring];
}


+(NSString *)strUTF8Encoding:(NSString *)str{
    NSCharacterSet *allowedCharacters = [NSCharacterSet URLQueryAllowedCharacterSet];
    return [str stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
}
@end

#pragma mark -QLParamSignManager.m
@implementation QLParamSignManager
+ (NSString *)paramSign:(NSDictionary *)param {
    //排序
    NSStringCompareOptions compare = NSCaseInsensitiveSearch|NSNumericSearch|NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSArray *keyArr = [param.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:compare];
    }];
    //拼接
    NSString *sign = @"";
    for (NSString *key in keyArr) {
        sign = [NSString stringWithFormat:@"%@%@%@",sign,key,param[key]];
    }
    //UTF-8编码
    sign = [QLNetworkingManager strUTF8Encoding:sign];
    return [sign md5Str];
}
@end

#pragma mark -QLErrorStatusManager.m
@implementation QLErrorStatusManager

- (NSError *)toError {
    NSError * error = [NSError errorWithDomain:QLNONull(self.err_msg) code:[self.result_code integerValue] userInfo:@{@"code" : @([self.result_code integerValue]), @"msg" : QLNONull(self.err_msg)}];
    return error;
}
@end
