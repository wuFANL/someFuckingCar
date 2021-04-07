//
//  QLFileManager.m
//  RabbitHole
//
//  Created by 乔磊 on 2019/10/1.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLFileManager.h"
#import "NSString+QLUtil.h"
#import <CoreText/CoreText.h>
#import <AVFoundation/AVFoundation.h>

#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

@interface QLFileManager()
@property (nonatomic, strong) UIFont *textFont;
@end
@implementation QLFileManager

//视频加水印
- (void)addWaterWithVideoPath:(NSString*)path waterText:(NSString *)waterText font:(UIFont *)textFont complete:(void (^)(NSString *compressStr))complete {
    self.textFont = textFont;
    [self addWaterWithVideoPath:path waterobj:waterText complete:^(NSString *compressStr) {
        complete(compressStr);
    }];
}
- (void)addWaterWithVideoPath:(NSString*)path waterImg:(UIImage *)waterImg complete:(void (^)(NSString *compressStr))complete {
    [self addWaterWithVideoPath:path waterobj:waterImg complete:^(NSString *compressStr) {
        complete(compressStr);
    }];
}
- (void)addWaterWithVideoPath:(NSString*)path waterobj:(id)obj complete:(void (^)(NSString *compressStr))complete {
    //1 创建AVAsset实例
    AVURLAsset*videoAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    //3 视频通道
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject] atTime:kCMTimeZero error:nil];
    //2 音频通道
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] firstObject] atTime:kCMTimeZero error:nil];
    //3.1 AVMutableVideoCompositionInstruction 视频轨道中的一个视频，可以缩放、旋转等
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    // 3.2 AVMutableVideoCompositionLayerInstruction 一个视频轨道，包含了这个轨道上的所有视频素材
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    [videolayerInstruction setOpacity:0.0 atTime:videoAsset.duration];
    //AVMutableVideoComposition：管理所有视频轨道，水印添加就在这上面
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    //视频旋转处理
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, 0.0);
    // Rotate transformation
    CGAffineTransform  t2 = CGAffineTransformRotate(t1, degreesToRadians(90.0));
    [videolayerInstruction setTransform:t2 atTime:kCMTimeZero];
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    CGSize naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    
    //添加水印
    if ([obj isKindOfClass:[NSString class]]) {
        [self applyVideoEffectsToComposition:mainCompositionInst size:naturalSize waterText:obj];
    } else if ([obj isKindOfClass:[UIImage class]]) {
        [self applyVideoEffectsToComposition:mainCompositionInst size:naturalSize waterImg:obj];
    }

    // 4 - 输出路径
    NSString *myPathDocs =  [QLFileManager filePath:[QLFileManager createFileName]];
    //判断文件是否存在，如果已经存在删除
    [[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:nil];
    NSURL* videoUrl = [NSURL fileURLWithPath:myPathDocs];
    
    // 5 - 视频文件输出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL = videoUrl;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if( exporter.status == AVAssetExportSessionStatusCompleted){
                QLLog(@"导出完成");
                NSURL *compressURL = exporter.outputURL;
                NSString *compressUrlStr = compressURL.absoluteString;
                if ([compressUrlStr containsString:@"file://"]) {
                    compressUrlStr = [compressUrlStr substringFromIndex:7];
                }
                complete(compressUrlStr);
            }else if( exporter.status == AVAssetExportSessionStatusFailed ){
                QLLog(@"导出failed");
                complete(nil);
            }
        });
    }];
}
//图片
- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size waterImg:(UIImage *)waterImg {
    
    CALayer*picLayer = [CALayer layer];
    picLayer.contents = (id)waterImg.CGImage;
    CGFloat videoW = size.width;
    CGFloat w = videoW*0.1;
    CGFloat h = w*(waterImg.size.height/waterImg.size.width);
    picLayer.frame = CGRectMake(size.width-w-30, size.height-30-h, w, h);
    
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:picLayer];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer setMasksToBounds:YES];
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    
    composition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
}
// 文字
- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size waterText:(NSString *)waterText {
    
    CATextLayer *subtitleText = [[CATextLayer alloc] init];
    subtitleText.wrapped = YES;//自动换行
    CGFloat w = [waterText widthWithFont:self.textFont];
    CGFloat h = 40;
    [subtitleText setFrame:CGRectMake(size.width-w-30-20, size.height-h-30, w, h)];
    UIFontDescriptor *ctfFont = self.textFont.fontDescriptor;
    NSNumber *fontSize = [ctfFont objectForKey:@"NSFontSizeAttribute"];
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.textFont.fontName, fontSize.floatValue, NULL);
    [subtitleText setFont:fontRef];
    [subtitleText setFontSize:fontSize.floatValue];
    [subtitleText setString:waterText];
    [subtitleText setForegroundColor:[[UIColor whiteColor] CGColor]];
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:subtitleText];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer setMasksToBounds:YES];
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    
    composition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
}
//生成视频文件名
+ (NSString *)getVideoFileName {
    [self createFolder];
    NSString *name = [self createFileName];
    return [NSString stringWithFormat:@"/%@.mp4",name];
}
//删除视频文件
+ (BOOL)deleteVideoFile:(NSString *)filePath
{
    if (![NSString isEmptyString:filePath]) {
        return NO;
    }
    BOOL flag = NO;
    NSError *__autoreleasing error = nil;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    flag = [manager removeItemAtPath:filePath error:&error];
    
    if (flag == NO && error) {
        QLLog(@"file delete failed!!! error --> %@",error);
    } else {
        QLLog(@"file in path:%@ deleted!",filePath);
    }
    return flag;
}
//保存图片
+ (NSDictionary *)saveImage:(UIImage *)image
{
    NSString *name = [self createFileName];
    BOOL flag = [self writeToFile:image path:[self filePath:name]];
    
    return @{@"name":name, @"success":@(flag)};
}
//通过名称获取图片
+ (UIImage *)getImageByName:(NSString *)name
{
    if (![NSString isEmptyString:name]) {
        return nil;
    }
    UIImage *image = [UIImage imageWithContentsOfFile:[self filePath:name]];
    return image;
}
//删除图片
+ (BOOL)deleteImageByName:(NSString *)name
{
    if (![NSString isEmptyString:name]) {
        return NO;
    }
    BOOL flag = NO;
    NSError *__autoreleasing error = nil;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    flag = [manager removeItemAtPath:[self filePath:name] error:&error];
    
    if (flag == NO && error) {
        QLLog(@"file delete failed!!! error --> %@",error);
    } else {
        QLLog(@"file in path:%@ deleted!",name);
    }
    return flag;
}
//获取缓存文件夹大小
+ (long long)getFileSize {
    NSString *filePath = [self filePath:nil];
    NSFileManager* manager = [NSFileManager defaultManager];
    //是否文件夹
    BOOL isFolder;
    //文件是否存在
    BOOL flag = [manager fileExistsAtPath:filePath isDirectory:&isFolder];
    long long folderSize = 0;
    if (flag) {
        if (isFolder) {
            //是文件夹
            NSEnumerator * childFileEnumerator = [[manager subpathsAtPath:filePath] objectEnumerator];
            NSString * fileName;
            while ((fileName = [childFileEnumerator nextObject]) != nil) {
                NSString * fileAbsolutePath = [filePath stringByAppendingPathComponent:fileName];
                folderSize += [[manager attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
                QLLog(@"%@",fileAbsolutePath);
            }
        }else{
            //不是文件夹
            folderSize = [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        }
    }
    
    return folderSize;
}
//删除缓存文件夹
+ (void)deleteFolder {
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL flag = [manager fileExistsAtPath:[self filePath:nil] isDirectory:nil];
    if (flag) {
        [manager removeItemAtPath:[self filePath:nil] error:nil];
    }
}
//创建缓存文件夹
+ (BOOL)createFolder {
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL flag = [manager fileExistsAtPath:[self filePath:nil] isDirectory:nil];
    if (!flag) {
        NSError *__autoreleasing error = nil;
        [manager createDirectoryAtPath:[self filePath:nil] withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            QLLog(@"error--->%@",error);
        }
    }
    
    return flag;
}
//生成沙盒路径
+ (NSString *)filePath:(NSString * _Nullable)name {
    NSString *tempPath;
    if (name) {
        tempPath = [NSString stringWithFormat:@"QLCache/%@",name];
    } else {
        tempPath = @"QLCache";
    }
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [rootPath stringByAppendingPathComponent:tempPath];
    return filePath;
}
//生成文件名
+ (NSString *)createFileName {
    return [[NSUUID UUID] UUIDString];
}
//单例
+ (QLFileManager *)share {
    static QLFileManager *fileManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileManager = [QLFileManager new];
    });
    return fileManager;
}
#pragma- Private Method
+ (BOOL)writeToFile:(UIImage *)image path:(NSString *)path
{
    BOOL flag = NO;
    [self createFolder];
    NSData *data = UIImageJPEGRepresentation(image, 0.3);
    flag = [data writeToFile:path atomically:YES];
    
    if (flag) {
        QLLog(@"file save in path:%@",path);
    } else {
        QLLog(@"file save failed!!!");
    }
    return flag;
}
@end
