//
//  QLReleaseImagesCell.h
//  BORDRIN
//
//  Created by 乔磊 on 2018/7/16.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class QLReleaseImagesCell;
@protocol QLReleaseImagesCellDelegate <NSObject>
@optional
/**
 *图片变化
 */
- (void)imgChange:(NSMutableArray *)images;
/**
 *图片点击
 */
- (void)imgClick:(NSInteger)index;
@end
@interface QLReleaseImagesCell : UITableViewCell
/**
 *图片数组
 */
@property (nonatomic, copy) NSMutableArray <UIImage *>*setImgArr;
/**
 *最大添加图片数量
 */
@property (nonatomic, assign) NSInteger maxImgCount;
/**
 *添加图片背景
 */
@property (nonatomic, strong) UIImage *addImg;
/**
 *是否支持多选
 */
@property (nonatomic, assign) BOOL canMultipleChoice;
/**
 *代理
 */
@property (nonatomic, weak) id<QLReleaseImagesCellDelegate> delegate;
@end