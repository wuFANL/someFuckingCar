//
//  QLCarSourceManagerCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/12/3.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ThreeBtnTapBlock) (NSInteger btnTag);

@interface QLCarSourceManagerCell : UITableViewCell
@property (nonatomic, copy) ThreeBtnTapBlock tagBlock;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *accImgView;
@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet UIImageView *activityImgView;
@property (weak, nonatomic) IBOutlet UILabel *activityStatusLB;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLB;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *desLB;
@property (weak, nonatomic) IBOutlet QLBaseButton *statusBtn;
@property (weak, nonatomic) IBOutlet QLBaseButton *priceBtn;
@property (weak, nonatomic) IBOutlet UILabel *prePriceLB;
@property (weak, nonatomic) IBOutlet UIView *funView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *funViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIButton *helpBtn;

/**
 *类型
 */
@property (nonatomic, assign) BOOL showFunView;
@end

NS_ASSUME_NONNULL_END
