//
//  QLHomeVisitListCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/3.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLHeadListView.h"
NS_ASSUME_NONNULL_BEGIN

@interface QLHomeVisitListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet QLHeadListView *headListView;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;

@end

NS_ASSUME_NONNULL_END
