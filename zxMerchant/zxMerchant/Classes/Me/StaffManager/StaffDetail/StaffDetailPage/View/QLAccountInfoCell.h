//
//  QLAccountInfoCell.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/17.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLAccountInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectBtnWidth;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeftSpace;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *detailLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textSpaceLayout;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;

/**
 *是否显示选择按钮
 */
@property (nonatomic, assign) BOOL showSelectBtn;
@end

NS_ASSUME_NONNULL_END
