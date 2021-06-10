//
//  QLCarCellDtlCell.h
//  zxMerchant
//
//  Created by HK on 2021/6/9.
//  Copyright © 2021 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLCarCellDtlCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *headImg;
@property (nonatomic, strong) IBOutlet UILabel *nameLab;
@property (nonatomic, strong) IBOutlet UILabel *numberLab;
@property (nonatomic, strong) IBOutlet UILabel *rightTimeLab;
@property (nonatomic, strong) IBOutlet UILabel *btmTimeLab;

@end

NS_ASSUME_NONNULL_END
