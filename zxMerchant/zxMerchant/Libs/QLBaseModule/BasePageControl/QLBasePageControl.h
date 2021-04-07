//
//  QLBasePageControl.h
//  TheOneCampus
//
//  Created by 乔磊 on 2017/8/10.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import "QLBaseView.h"

@class QLBasePageControl;
@protocol QLPageClickDelegate <NSObject>
@optional
- (void)pageClickIndex:(NSInteger)index;
@end
@interface QLBasePageControl : QLBaseView
/**点的个数*/
@property (nonatomic, assign) NSInteger pageNum;
/**点的大小*/
@property (nonatomic, assign) CGSize pageSize;
/**间隔*/
@property (nonatomic, assign) CGFloat space;
/**选择图片*/
@property (nonatomic, strong) UIImage *currentImage;
/**未选中图片*/
@property (nonatomic, strong) UIImage *defaultImage;
/**当前页*/
@property (nonatomic, assign) NSInteger currentPage;
/**当前页变大*/
@property (nonatomic, assign) NSInteger currentChange;
/**
 *是否可点击
 */
@property (nonatomic, assign) BOOL canClick;
/**
 *点击代理
 */
@property (nonatomic, weak) id<QLPageClickDelegate> delegate;
@end
