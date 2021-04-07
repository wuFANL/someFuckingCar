//
//  QLCustomAlertView.h
//  PopularUsedCarManagement
//
//  Created by 乔磊 on 2018/11/12.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ResultBlock)(id _Nullable result,NSError *_Nullable error);

@interface QLCustomAlertView : QLBaseView
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet QLBaseButton *titleBtn;
@property (weak, nonatomic) IBOutlet UIView *tfView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *editTF;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
/**
 *设置标题
 */
@property (nonatomic, strong) NSString *title;
/**
 *是否显示输入框
 */
@property (nonatomic, assign) BOOL showTF;
/**
 *h结果返回
 */
@property (nonatomic, strong) ResultBlock result;

- (void)show;
- (void)hidden;
@end

NS_ASSUME_NONNULL_END
