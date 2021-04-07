//
//  QLChooseTimeView.h
//  TheOneCampus
//
//  Created by 乔磊 on 2017/8/23.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import "QLBaseView.h"

typedef void (^TimeBackBlock)(NSString *time);
@interface QLChooseTimeView : QLBaseView
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewBottom;
@property (weak, nonatomic) IBOutlet UIView *alertView;


/**
 *结果
 */
@property (nonatomic, strong) TimeBackBlock resultBackBlock;
/**
 *最小时间
 */
@property (nonatomic, strong) NSDate *minDate;
/**
 *当前时间
 */
@property (nonatomic, strong) NSDate *currentDate;
/**
 *最大时间
 */
@property (nonatomic, strong) NSDate *maxDate;
/**
 *显示几个时间段（年、月、日、时、分、秒）
 */
@property (nonatomic, assign) NSInteger columns;
/**
 *是否显示单位
 */
@property (nonatomic, assign) BOOL showUnit;
/**
 *显示数据选择器
 */
- (void)showTimeView;
/**
 *消失数据选择器
 */
- (void)disappearTimeView;
@end
