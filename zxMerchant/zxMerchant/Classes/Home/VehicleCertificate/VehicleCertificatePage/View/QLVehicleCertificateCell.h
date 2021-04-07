//
//  QLVehicleCertificateCell.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/25.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLHeadListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLVehicleCertificateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *descLB;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
/**
 *图片数据
 */
@property (nonatomic, strong) NSArray *imgArr;
/**
 *图片控件
 */
@property (nonatomic, strong) QLHeadListView *hlView;

@end

NS_ASSUME_NONNULL_END
