//
//  QLSubListTitleCell.h
//  zxMerchant
//
//  Created by lei qiao on 2021/2/28.
//  Copyright © 2021 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLSubListTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIView *bjView;
@property (nonatomic, strong) NSMutableArray *iconArr;
@end

NS_ASSUME_NONNULL_END
