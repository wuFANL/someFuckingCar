//
//  ClipViewController.h
//  MSClipDemo
//
//  Created by MelissaShu on 17/6/15.
//  Copyright © 2017年 MelissaShu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CIRCULARCLIP   = 0,   //圆形裁剪
    SQUARECLIP            //方形裁剪
    
}ClipType;
typedef void (^resultImgBlcok)(UIImage *resultImg,NSError *error);

@class QLImageCroppingViewController;


@interface QLImageCroppingViewController : UIViewController

/*
 *裁剪的形状
 */
@property (nonatomic, assign) ClipType clipType;
/**
 *图片来源
 *0:相册
 *1:相机
 */
@property (nonatomic, assign) NSInteger type;
/*
 *默认方形裁剪框
 */
-(instancetype)initWithImage:(UIImage *)image;

/*
 *自定义大小
 */
-(instancetype)initWithImage:(UIImage *)image clipSize:(CGSize)clipSize;

/*
 *圆形裁剪
 */
-(instancetype)initWithImage:(UIImage *)image radius:(CGFloat)radius;

/**
 *是否需要下一张按钮
 */
@property (nonatomic, assign) BOOL showNextBtn;
/**
 *结果返回
 */
@property (nonatomic, strong) resultImgBlcok backBlcok;
@end
