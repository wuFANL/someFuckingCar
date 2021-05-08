//
//  QLRidersDynamicTextCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/3.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLRidersDynamicTextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *contentLB;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allBtnHeight;
@property (nonatomic, assign) BOOL showAllBtn;
@property (nonatomic, strong) id model;

@end

NS_ASSUME_NONNULL_END
