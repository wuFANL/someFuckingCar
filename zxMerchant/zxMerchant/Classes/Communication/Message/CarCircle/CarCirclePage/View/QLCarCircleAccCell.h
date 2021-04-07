//
//  QLCarCircleAccCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/27.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLCarCircleAccCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *accLB;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreOpenBtn;
@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreCloseBtn;

@end

NS_ASSUME_NONNULL_END
