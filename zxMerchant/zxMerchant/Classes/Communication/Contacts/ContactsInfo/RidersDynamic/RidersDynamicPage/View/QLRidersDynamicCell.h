//
//  QLRidersDynamicCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/30.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,DynamicDataType) {
    NoDynamicData = 0,
    ImageDynamic = 1,
    VideoDynamic = 2,
};
@interface QLRidersDynamicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIView *imgBjView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *numLB;
/**
 *数据类型
 */
@property (nonatomic, assign) DynamicDataType dataType;
/**
 *图片数据
 */
@property (nonatomic, strong) NSArray *imgArr;
@end

NS_ASSUME_NONNULL_END
