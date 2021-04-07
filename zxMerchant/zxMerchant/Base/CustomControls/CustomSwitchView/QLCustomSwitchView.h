//
//  QLCustomSwitchView.h
//  luluzhuan
//
//  Created by 乔磊 on 2017/9/28.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectIndex)(NSInteger index);
@interface QLCustomSwitchView : UIView
/**
 *初始化
 */
- (instancetype)initWithFrame:(CGRect)frame FirstTitle:(NSString *)firstTitle SecondTitle:(NSString *)secondTitle BackgroundImage:(UIImage *)backgroundImage CurrentImage:(UIImage *)currentImage;
/**
 *第一个按钮
 */
@property (nonatomic, weak) UIButton *firstBtn;
/**
 *第二个按钮
 */
@property (nonatomic, weak) UIButton *secondBtn;
/**
 *点前选中下标
 */
@property (nonatomic, assign) NSInteger selectIndex;
/**
 *点中回调
 */
@property (nonatomic, strong) SelectIndex selectBlcok;
@end
