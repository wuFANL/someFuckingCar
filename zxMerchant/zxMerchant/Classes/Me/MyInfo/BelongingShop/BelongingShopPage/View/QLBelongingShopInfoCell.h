//
//  QLBelongingShopInfoCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/12/29.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLBelongingShopInfoCell : UITableViewCell
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
// 名称
@property (weak, nonatomic) IBOutlet UILabel *storeNameLB;
// 细节
@property (weak, nonatomic) IBOutlet UILabel *addressLB;
//状态
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;

- (void)updateWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
