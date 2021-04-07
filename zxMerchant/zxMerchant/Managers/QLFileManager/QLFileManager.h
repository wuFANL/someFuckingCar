//
//  QLFileManager.h
//  RabbitHole
//
//  Created by 乔磊 on 2019/10/1.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLFileManager : NSObject
//视频加水印
- (void)addWaterWithVideoPath:(NSString*)path waterText:(NSString *)waterText font:(UIFont *)textFont complete:(void (^)(NSString *compressStr))complete;
- (void)addWaterWithVideoPath:(NSString*)path waterImg:(UIImage *)waterImg complete:(void (^)(NSString *compressStr))complete;
//生成视频文件名
+ (NSString *)getVideoFileName;
//删除视频文件
+ (BOOL)deleteVideoFile:(NSString *)filePath;
//保存图片
+ (NSDictionary *)saveImage:(UIImage *)image;
//通过名称获取图片
+ (UIImage *)getImageByName:(NSString *)name;
//删除图片
+ (BOOL)deleteImageByName:(NSString *)name;
//获取缓存文件夹大小
+ (long long)getFileSize;
//删除缓存文件夹
+ (void)deleteFolder;
//创建缓存文件夹
+ (BOOL)createFolder;
//生成沙盒路径
+ (NSString *)filePath:(NSString * _Nullable)name;
//生成文件名
+ (NSString *)createFileName;
//单例
+ (QLFileManager *)share;
@end

NS_ASSUME_NONNULL_END
