//
//  QLCarPhotosCell.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/29.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLCarInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QLCarPhotosCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseBtnWidth;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
/**
 *是否显示选择按钮
 */
@property (nonatomic, assign) BOOL showChooseBtn;
/**
 *数据
 */
@property (nonatomic, strong) QLCarInfoModel *model;
@end

NS_ASSUME_NONNULL_END
