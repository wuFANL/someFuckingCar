//
//  QLAdvancedScreeningAddCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/29.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLAdvancedScreeningAddCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bjView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
/**
 *数据
 */
@property (nonatomic, strong) NSArray *itemArr;
@end

NS_ASSUME_NONNULL_END
