//
//  QLHomeCarCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/9/30.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, AccType) {
    AccTypeNone = 0,
    AccTypeNew = 1,
    AccTypeReduction = 2,
};
@interface QLHomeCarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *activityBjView;
@property (weak, nonatomic) IBOutlet UIImageView *activityImgView;
@property (weak, nonatomic) IBOutlet UILabel *activityStatusLB;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLB;
@property (weak, nonatomic) IBOutlet UIImageView *accImgView;
@property (weak, nonatomic) IBOutlet UIImageView *stockImgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *descLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *retailPriceLB;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

/**
 *是否显示图标
 */
@property (nonatomic, assign) AccType accType;
- (void)updateUIWithDic:(NSDictionary *)dataDic;
@end

NS_ASSUME_NONNULL_END
