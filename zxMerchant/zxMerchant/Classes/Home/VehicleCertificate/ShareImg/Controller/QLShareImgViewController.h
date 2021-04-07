//
//  QLShareImgViewController.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/25.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLShareImgViewController : QLViewController
/*
 *图片数组
 */
@property (nonatomic, strong) NSMutableArray *imgsArr;
/**
 *类型
 *0：车辆牌证   1：多图分享
 */
@property (nonatomic, assign) NSInteger type;
/*
 *数据数组
 */
@property (nonatomic, strong) NSMutableArray *carInfoArr;
@end

NS_ASSUME_NONNULL_END
