//
//  UIImage+QLUtil.m
//  luluzhuan
//
//  Created by 乔磊 on 2017/10/10.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import "UIImage+QLUtil.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreServices/CoreServices.h>
#import <SDWebImage.h>
#import "UIFont+QLUtil.h"
#import "NSString+QLUtil.h"
#import "UIView+QLUtil.h"
#import "QLFileManager.h"

@implementation UIImage (QLUtil)
#pragma mark - 生成二维码
+ (UIImage *)generateQRCodeWithString:(NSString *)string Size:(CGFloat)size {
    //创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //过滤器恢复默认
    [filter setDefaults];
    //给过滤器添加数据<字符串长度893>
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [filter setValue:data forKey:@"inputMessage"];
    //获取二维码过滤器生成二维码
    CIImage *image = [filter outputImage];
    UIImage *img = [self createNonInterpolatedUIImageFromCIImage:image WithSize:size];
    return img;
}
//二维码清晰
+ (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image WithSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    //创建bitmap
    size_t width = CGRectGetWidth(extent)*scale;
    size_t height = CGRectGetHeight(extent)*scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    //保存图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
#pragma mark - 图片旋转正
- (UIImage *)fixOrientation {
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
    
    
    
#pragma mark - 颜色值创建图片
+ (UIImage *)createImageWithColor:(UIColor *)color {
    
    return [self createImageWithColor:color Size:CGSizeMake(1.0f, 1.0f)];
}
+ (UIImage *)createImageWithColor:(UIColor *)color Size:(CGSize)imgSize {
    CGRect rect = CGRectMake(0.0f,0.0f,imgSize.width,imgSize.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
#pragma mark- 图片画圆
+ (UIImage *)drawImageRoundIn:(CGSize)drawSize ContentImage:(UIImage *)image {
    //1.创建一张临时的空白画布
    if([[UIScreen mainScreen] scale] == 2.0){
        UIGraphicsBeginImageContextWithOptions(drawSize, NO, 2.0);
    }else{
        UIGraphicsBeginImageContext(drawSize);
    }
    CGRect imageRect =  CGRectMake(0, 0, drawSize.width, drawSize.height);
    //在上下文环境中写绘制代码
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:imageRect];
    path.lineWidth = 1;
    [[UIColor clearColor] setStroke];
    [path stroke];
    [path addClip];
    UIImage *aImage = image;
    [aImage drawInRect:imageRect];
    //用画布中的生成一个 UIImage对象
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭绘制 的上下文区间
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark- 图片裁剪指定大小
+ (UIImage*)cutImage:(UIImage*)image rect:(CGRect)imageRect {
    UIImage  *newImage = nil;
    if (image != nil) {
        CGImageRef imageRef = image.CGImage;
        CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, imageRect);
        CGSize size;
        size.width = imageRect.size.width;
        size.height = imageRect.size.height;
        UIGraphicsBeginImageContext(size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, imageRect, subImageRef);
        newImage = [UIImage imageWithCGImage:subImageRef];
        CGImageRelease(subImageRef);
        UIGraphicsEndImageContext();
    }
    return newImage;
}
#pragma mark- 绘制图片指定大小
+ (UIImage*)drawWithImage:(UIImage*)image size:(CGSize)size {
    UIImage  *newImage = nil;
    if (image != nil) {
        UIGraphicsBeginImageContextWithOptions(size, NO,[UIScreen mainScreen].scale);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newImage;
}
#pragma mark- 压缩图片
+ (UIImage *)simpleImage:(UIImage *)originImg {
    CGSize imageSize = [self handleImage:originImg.size];
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0.0);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    CGContextAddPath(contextRef, bezierPath.CGPath);
    CGContextClip(contextRef);
    [originImg drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *clipedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return clipedImage;
}
#pragma mark- 图片适配手机尺寸获得
+ (CGSize)handleImage:(CGSize)retSize {
    CGFloat width = 0;
    CGFloat height = 0;
    if (retSize.width > retSize.height) {
        width = [UIScreen mainScreen].bounds.size.width;
        height = retSize.height / retSize.width * width;
    } else {
        height = [UIScreen mainScreen].bounds.size.height;
        width = retSize.width / retSize.height * height;
    }
    return CGSizeMake(width, height);
}
#pragma mark- CVImageBufferRef 转 图片
+ (UIImage *)getImageStream:(CVImageBufferRef)imageBuffer {
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext createCGImage:ciImage fromRect:CGRectMake(0, 0, CVPixelBufferGetWidth(imageBuffer), CVPixelBufferGetHeight(imageBuffer))];
    UIImage *image = [[UIImage alloc] initWithCGImage:videoImage];
    CGImageRelease(videoImage);
    return image;
}
#pragma mark- 视频第一帧
+ (UIImage *)videoFramerateWithPath:(NSString *)videoPath
{
    if(!videoPath) return nil;
    NSURL *video_url = nil;
    if ([videoPath containsString:@"http"]||[videoPath containsString:@"https"]) {
        video_url = [NSURL URLWithString:videoPath];
    } else {
        video_url = [NSURL fileURLWithPath:videoPath];
    }
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:video_url options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

#pragma mark- 图片加水印
//图片加图片水印
- (UIImage *)addWaterImage:(UIImage *)waterImage Rect:(CGRect)waterRect {
    //1.开启上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    //2.绘制背景图片
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    //3.绘制水印图片到当前上下文
    [waterImage drawInRect:waterRect];
    //4.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //5.关闭图形上下文
    UIGraphicsEndImageContext();
    return newImage;
}
// 图片添加文字水印
- (UIImage *)addWaterText:(NSString *)text textPoint:(CGPoint)point attributed:(NSDictionary *)attributed {
    //1.开启上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    //2.绘制图片
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    //添加水印文字
    [text drawAtPoint:point withAttributes:attributed];
    //3.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}
//gif图片添加文字水印
- (NSString *)gifAddWaterText:(NSString *)text textPoint:(CGPoint)point attributed:(NSDictionary *)attributed {
    NSData *data = [self sd_imageDataAsFormat:self.sd_imageFormat compressionQuality:0.3];
    CGImageSourceRef gifSource = CGImageSourceCreateWithData((__bridge CFDataRef) data, nil);
    size_t gifCount = CGImageSourceGetCount(gifSource);
    NSMutableArray *frames = [[NSMutableArray alloc]init];
    for (size_t i = 0; i< gifCount; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        if (CGPointEqualToPoint(CGPointZero, point)) {
            CGFloat w = [text widthWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
            point = CGPointMake(image.size.width-w-30, 30);
        }
        UIImage *gifIma = [image addWaterText:text textPoint:point attributed:attributed];
        [frames addObject:gifIma];
        CGImageRelease(imageRef);
    }
    //创建gif文件
    NSString *path = [QLFileManager filePath:[NSString stringWithFormat:@"%@.gif",[QLFileManager createFileName]]];
    QLLog(@"-----%@",path);
    //配置gif属性
    CGImageDestinationRef destion;
    CFURLRef url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)path, kCFURLPOSIXPathStyle, false);
    destion = CGImageDestinationCreateWithURL(url, kUTTypeGIF, frames.count, NULL);
    NSDictionary *frameDic = [NSDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0.3],(NSString*)kCGImagePropertyGIFDelayTime, nil] forKey:(NSString*)kCGImagePropertyGIFDelayTime];
    
    NSMutableDictionary *gifParmdict = [NSMutableDictionary dictionaryWithCapacity:2];
    [gifParmdict setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCGImagePropertyGIFHasGlobalColorMap];
    [gifParmdict setObject:(NSString*)kCGImagePropertyColorModelRGB forKey:(NSString*)kCGImagePropertyColorModel];
    [gifParmdict setObject:[NSNumber numberWithInt:8] forKey:(NSString*)kCGImagePropertyDepth];
    [gifParmdict setObject:[NSNumber numberWithInt:0] forKey:(NSString*)kCGImagePropertyGIFLoopCount];
    NSDictionary *gifProperty = [NSDictionary dictionaryWithObject:gifParmdict forKey:(NSString*)kCGImagePropertyGIFDictionary];
    for (UIImage *dimage in frames) {
        CGImageDestinationAddImage(destion, dimage.CGImage, (__bridge CFDictionaryRef)frameDic);
    }
    CGImageDestinationSetProperties(destion,(__bridge CFDictionaryRef)gifProperty);
    CGImageDestinationFinalize(destion);
    CFRelease(destion);
    return path;
}
#pragma mark- 图片原图
- (UIImage *)originalImage {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
@end
