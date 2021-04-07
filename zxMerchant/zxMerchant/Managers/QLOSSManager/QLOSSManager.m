//
//  QLOSSManager.m
//  PalmSurvey
//
//  Created by 乔磊 on 2017/8/9.
//  Copyright © 2017年 AfterNinety. All rights reserved.
//

#import "QLOSSManager.h"
NSString * const AccessKeyId = @"LTAI4FdGPVkDmrEmB9DyyTrv";
NSString * const secretKeyId = @"1ACiCmDNSzkPeKHo8W5VsgRDHWogBy";
NSString * const endPoint = @"oss-cn-hangzhou.aliyuncs.com";
NSString * const multipartUploadKey = @"multipartUploadObject";
NSString * const bucketName = @"zxcars";

@interface QLOSSManager()
@property (nonatomic, strong) OSSClient *client;
@end
@implementation QLOSSManager
+ (QLOSSManager *)shared {
    static QLOSSManager *OSSManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OSSManager = [[QLOSSManager alloc] init];
    });
    return OSSManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化OSS
        [self setupEnvironment];
    }
    return self;
}
//配置
- (void)setupEnvironment {
    // 打开调试log
    [OSSLog enableLog];
    // 初始化sdk
    [self initOSSClient];
}
- (void)initOSSClient {
    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:AccessKeyId secretKeyId:secretKeyId securityToken:@""];
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.enableBackgroundTransmitService = YES;
    conf.maxRetryCount = 2;
    conf.timeoutIntervalForRequest = 30;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    self.client = [[OSSClient alloc] initWithEndpoint:[NSString stringWithFormat:@"http://%@", endPoint] credentialProvider:credential clientConfiguration:conf];
}
- (void)asyncUploadImage:(UIImage *)image complete:(void(^)(NSArray *names,UploadImageState state))complete {
    [self uploadImages:@[image] isAsync:YES complete:complete];
}

- (void)syncUploadImage:(UIImage *)image complete:(void(^)(NSArray *names,UploadImageState state))complete {
    [self uploadImages:@[image] isAsync:NO complete:complete];
}

- (void)asyncUploadImages:(NSArray<UIImage *> *)images complete:(void(^)(NSArray *names, UploadImageState state))complete {
    [self uploadImages:images isAsync:YES complete:complete];
}

- (void)syncUploadImages:(NSArray<UIImage *> *)images complete:(void(^)(NSArray *names, UploadImageState state))complete {
    [self uploadImages:images isAsync:NO complete:complete];
}

- (void)uploadImages:(NSArray<UIImage *> *)images isAsync:(BOOL)isAsync complete:(void(^)(NSArray *names, UploadImageState state))complete {
    if (images.count == 0) {
        if (complete) {
            complete(nil ,UploadImageSuccess);
        }
        return;
    }
    //上传
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = images.count;
    
    NSMutableArray *callBackNames = [NSMutableArray array];
    int i = 0;
    for (UIImage *image in images) {
        if (image) {
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                //任务执行
                OSSPutObjectRequest * put = [OSSPutObjectRequest new];
                put.bucketName = bucketName;
                NSDate *timeData = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
                NSString *timeStr = [formatter stringFromDate:timeData];
                NSString *imageName = [NSString stringWithFormat:@"image/%@.png",[[NSString stringWithFormat:@"%@%u%u%u",timeStr,arc4random()%10,arc4random()%10,arc4random()%10] md5Str]];
                put.objectKey = imageName;
                NSData *data = UIImageJPEGRepresentation([UIImage simpleImage:image], 0.3);
                put.uploadingData = data;
                
                OSSTask * putTask = [self.client putObject:put];
                [putTask waitUntilFinished]; // 阻塞直到上传完成
                if (!putTask.error) {
                    QLLog(@"upload object success!");
                    [callBackNames addObject:[NSString stringWithFormat:@"http://%@.%@/%@", bucketName,endPoint,put.objectKey]];
                    if (isAsync) {
                        if (image == images.lastObject) {
                            QLLog(@"upload object finished!");
                            if (complete) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    complete([NSArray arrayWithArray:callBackNames] ,UploadImageSuccess);
                                });
                            }
                        }
                    }
                } else {
                    QLLog(@"upload object failed, error: %@" , putTask.error);
                    if (isAsync) {
                        if (complete) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                complete(nil ,UploadImageFailed);
                            });
                        }
                    }
                }
            }];
            if (queue.operations.count != 0) {
                [operation addDependency:queue.operations.lastObject];
            }
            [queue addOperation:operation];
        }
        i++;
    }
    if (!isAsync) {
        [queue waitUntilAllOperationsAreFinished];
        if (complete) {
            complete([NSArray arrayWithArray:callBackNames], UploadImageSuccess);
        }
    }
}
//文件上传
- (void)uploadFile:(NSString *)videoPath complete:(void(^)(NSArray *names, UploadImageState state))complete {
    if (videoPath.length == 0) {
        if (complete) {
            complete(nil ,UploadImageSuccess);
        }
        return;
    }
    //上传
    if (videoPath.length != 0) {
        //获得UploadId进行上传，如果任务失败并且可以续传，利用同一个UploadId可以上传同一文件到同一个OSS上的存储对象
        OSSResumableUploadRequest * resumableUpload = [OSSResumableUploadRequest new];
        resumableUpload.bucketName = bucketName;
        
        NSDate *timeData = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
        NSString *timeStr = [formatter stringFromDate:timeData];
        NSString *vodeoName = [NSString stringWithFormat:@"video/%@.mp4",[[NSString stringWithFormat:@"%@%u%u%u",timeStr,arc4random()%10,arc4random()%10,arc4random()%10] md5Str]];
        resumableUpload.objectKey = vodeoName;
        
        resumableUpload.partSize = 1024 * 1024;
        resumableUpload.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
            QLLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        };
        NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        //设置断点记录文件
        resumableUpload.recordDirectoryPath = cachesDir;
        //设置NO,取消时，不删除断点记录文件，如果不进行设置，默认YES，是会删除断点记录文件，下次再进行上传时会重新上传。
        resumableUpload.deleteUploadIdOnCancelling = NO;
        resumableUpload.uploadingFileURL = [NSURL fileURLWithPath:videoPath];
        OSSTask * resumeTask = [self.client resumableUpload:resumableUpload];
        [resumeTask continueWithBlock:^id(OSSTask *task) {
            if (task.error) {
                QLLog(@"error: %@", task.error);
                if (complete) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        complete(nil,UploadImageFailed);
                    });
                    
                }
            } else {
                NSString *url = [NSString stringWithFormat:@"http://%@.%@/%@", bucketName,endPoint,resumableUpload.objectKey];
                QLLog(@"Upload file success %@",url);
                if (complete) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        complete(@[url] ,UploadImageSuccess);
                    });
                    
                    
                }
            }
            return nil;
        }];
    }
}
@end
