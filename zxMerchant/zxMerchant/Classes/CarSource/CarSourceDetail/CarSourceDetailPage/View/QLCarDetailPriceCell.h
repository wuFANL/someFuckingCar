//
//  QLCarDetailPriceCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/27.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLCarDetailPriceCell : UITableViewCell
// 橘色价格1
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
// 灰色价格2
@property (weak, nonatomic) IBOutlet UILabel *accPriceLB;
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;
@property (weak, nonatomic) IBOutlet QLBaseButton *reduceBtn;
@property (weak, nonatomic) IBOutlet QLBaseButton *internalPriceBtn;

- (void)updateWithDic:(NSDictionary *)dataDic;
@end

NS_ASSUME_NONNULL_END
