//
//  QLOSSManager.h
//  PalmSurvey
//
//  Created by 乔磊 on 2017/8/9.
//  Copyright © 2017年 AfterNinety. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AliyunOSSiOS/OSSService.h>
#import "NSString+QLUtil.h"
#import "UIImage+QLUtil.h"
typedef NS_ENUM(NSInteger, UploadImageState) {
    UploadImageFailed   = 0,
    UploadImageSuccess  = 1
};
@interface QLOSSManager : NSObject
/**
 *单例
 */
+ (QLOSSManager *)shared;
/**异步上传单张图片*/
- (void)asyncUploadImage:(UIImage *)image complete:(void(^)(NSArray *names,UploadImageState state))complete;
/**同步步上传单张图片*/
- (void)syncUploadImage:(UIImage *)image complete:(void(^)(NSArray *names,UploadImageState state))complete;
/**异步上传多张图片*/
- (void)asyncUploadImages:(NSArray<UIImage *> *)images complete:(void(^)(NSArray *names, UploadImageState state))complete;
/**通过步上传多张图片*/
- (void)syncUploadImages:(NSArray<UIImage *> *)images complete:(void(^)(NSArray *names, UploadImageState state))complete;
/**文件上传*/
- (void)uploadFile:(NSString *)videoPath complete:(void(^)(NSArray *names, UploadImageState state))complete;
@end
