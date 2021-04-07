//
//  QLAdvancedScreeningSectionView.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/29.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLAdvancedScreeningSectionView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIButton *aBtn;
@property (weak, nonatomic) IBOutlet UIButton *bBtn;

/**
 *是否显示功能按钮
 */
@property (nonatomic,assign) BOOL showFunBtn;
@end

NS_ASSUME_NONNULL_END
