//
//  UIImage+QLUtil.h
//  luluzhuan
//
//  Created by 乔磊 on 2017/10/10.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QLUtil)
/**
 *生成二维码
 */
+ (UIImage *)generateQRCodeWithString:(NSString *)string Size:(CGFloat)size;
/*
 *颜色值创建图片
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;
+ (UIImage *)createImageWithColor:(UIColor *)color Size:(CGSize)imgSize;
/*
 *图片画圆
 */
+ (UIImage *)drawImageRoundIn:(CGSize)drawSize ContentImage:(UIImage *)image;
/*
 *图片裁剪指定大小
 */
+ (UIImage*)cutImage:(UIImage*)image rect:(CGRect)imageRect;
/*
 * 绘制图片大小
 */
+ (UIImage*)drawWithImage:(UIImage*)image size:(CGSize)size;
/**
 *压缩图片
 */
+ (UIImage *)simpleImage:(UIImage *)originImg;
/**
 *图片适配手机尺寸获得
 */
+ (CGSize)handleImage:(CGSize)retSize;
/**
 *视频第一帧
 */
+ (UIImage *)videoFramerateWithPath:(NSString *)videoPath;
/*
 *CVImageBufferRef 转 图片
 */
+ (UIImage *)getImageStream:(CVImageBufferRef)imageBuffer;
/*
 *图片旋转正
 */
- (UIImage *)fixOrientation;
/*
 *图片加图片水印（实例调用）
 */
- (UIImage *)addWaterImage:(UIImage *)waterImage Rect:(CGRect)waterRect;
/*
*图片加文字水印（实例调用）
*/
- (UIImage *)addWaterText:(NSString *)text textPoint:(CGPoint)point attributed:(NSDictionary *)attributed;
/*
 *gif图片添加文字水印
 */
- (NSString *)gifAddWaterText:(NSString *)text textPoint:(CGPoint)point attributed:(NSDictionary *)attributed;
/*
 *原图
 */
- (UIImage *)originalImage;
@end
