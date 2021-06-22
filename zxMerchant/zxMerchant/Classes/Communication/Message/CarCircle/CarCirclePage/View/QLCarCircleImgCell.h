//
//  QLCarCircleImgCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/26.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,QLCarCircleDataType) {
    ImageType = 0,
    VideoType = 1,
};
@interface QLCarCircleImgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bjView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bjViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bjViewLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bjViewHeight;
/**
 *数据类型
 */
@property (nonatomic, assign) QLCarCircleDataType dataType;
/**
 *数据数组
 */
@property (nonatomic, strong) NSMutableArray *dataArr;
/**
 *记录collectionView高度
 */
@property (nonatomic, assign) CGFloat collectionViewHeight;
/**
 *返回collectionView高度
 */
@property (nonatomic, strong) resultBackBlock heightHandler;
@end

NS_ASSUME_NONNULL_END
