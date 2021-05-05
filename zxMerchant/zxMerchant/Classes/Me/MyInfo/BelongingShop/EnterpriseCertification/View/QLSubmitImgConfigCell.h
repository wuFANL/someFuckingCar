//
//  QLSubmitImgConfigCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/12/30.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLSubmitImgConfigCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLBTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLBHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLBBottom;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIControl *aControl;
@property (weak, nonatomic) IBOutlet UIImageView *aImgView;
@property (weak, nonatomic) IBOutlet UILabel *aTitleLB;
@property (weak, nonatomic) IBOutlet UIControl *bControl;
@property (weak, nonatomic) IBOutlet UIImageView *bImgView;
@property (weak, nonatomic) IBOutlet UILabel *bTitleLB;


- (void)updateWithStaff:(BOOL)isStaff andIndexPath:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
