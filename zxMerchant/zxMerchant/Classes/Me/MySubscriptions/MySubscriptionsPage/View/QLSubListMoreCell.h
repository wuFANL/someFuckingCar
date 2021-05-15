//
//  QLSubListMoreCell.h
//  zxMerchant
//
//  Created by lei qiao on 2021/2/28.
//  Copyright © 2021 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLSubListMoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *accLB;

- (void)updateWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
