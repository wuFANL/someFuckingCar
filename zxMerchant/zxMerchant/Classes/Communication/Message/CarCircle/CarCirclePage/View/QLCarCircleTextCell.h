//
//  QLCarCircleTextCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/26.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLRidersDynamicListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QLCarCircleTextCell : UITableViewCell
// 头像
@property (weak, nonatomic) IBOutlet QLBaseButton *headBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headBtnTop;
// 姓名
@property (weak, nonatomic) IBOutlet UIButton *nikenameBtn;

// 时间 + 地点
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLBBottom;
// 关注车主
@property (weak, nonatomic) IBOutlet QLBaseButton *likeBtn;
// 文案
@property (weak, nonatomic) IBOutlet UILabel *textLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLBLeft;
// 点击全文
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (weak, nonatomic) IBOutlet QLBaseButton *vipBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *openBtnBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *openBtnHight;

// 会员角标
@property (nonatomic, strong) UIImageView *vip_image;

@property (nonatomic, strong) QLRidersDynamicListModel *model;
@property (nonatomic, strong) NSDictionary *dataDic;
- (void)upDateWithDic:(NSDictionary *)dic;
@property (nonatomic, assign) BOOL showAllBtn;

@end

NS_ASSUME_NONNULL_END
