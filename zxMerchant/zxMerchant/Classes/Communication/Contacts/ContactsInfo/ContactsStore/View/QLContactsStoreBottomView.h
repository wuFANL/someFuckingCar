//
//  QLContactsStoreBottomView.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/13.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLContactsStoreBottomView : UIView
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allBtnWidth;
@property (weak, nonatomic) IBOutlet UIButton *funBtn;
/**
 *是否处于编辑状态
 */
@property (nonatomic, assign) BOOL isEditing;

@end

NS_ASSUME_NONNULL_END
