//
//  QLPicturesDetailViewController.h
//  PopularUsedCarManagement
//
//  Created by 乔磊 on 2019/1/25.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class QLPicturesDetailViewController;
@protocol QLPicturesDetailViewControllerDelegate <NSObject>
@optional
/**
 *图片数据发生变化
 */
- (void)imgDataChange:(NSArray *)imgArr;
@end
@interface QLPicturesDetailViewController : QLViewController
/**
 *进入的下标
 */
@property (nonatomic, assign) NSInteger intoIndex;
/**
 *显示删除Item
 */
@property (nonatomic, assign) BOOL showDeleteItem;
/**
 *显示图片下载Item
 */
@property (nonatomic, assign) BOOL showDownloadItem;
/**
 *图片数据
 */
@property (nonatomic, strong) NSMutableArray *imgsArr;
/**
 *代理
 */
@property (nonatomic, weak) id<QLPicturesDetailViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
