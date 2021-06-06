//
//  QLBrowseDetailCell.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/31.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLBrowseDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QLBrowseDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet QLBaseButton *browseBtn;
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;
/**
 *数据模型
 */
@property (nonatomic, strong) QLBrowseDetailModel *model;
@end

NS_ASSUME_NONNULL_END
