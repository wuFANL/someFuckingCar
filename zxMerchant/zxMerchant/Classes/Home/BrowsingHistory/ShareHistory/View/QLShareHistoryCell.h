//
//  QLShareHistoryCell.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/30.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLHeadListView.h"
#import "QLShareHistoryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QLShareHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIButton *browseBtn;
/**
 *设置浏览人数
 */
@property (nonatomic, strong) NSString *browseNum;
/**
 *模型
 */
@property (nonatomic, strong) QLShareHistoryModel *model;
@end

NS_ASSUME_NONNULL_END
