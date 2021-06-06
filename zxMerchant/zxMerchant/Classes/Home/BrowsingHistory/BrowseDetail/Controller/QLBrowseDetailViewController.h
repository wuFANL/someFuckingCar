//
//  QLBrowseDetailViewController.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/31.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLViewController.h"
#import "QLShareHistoryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QLBrowseDetailViewController : QLViewController
/**
 *日志类型
 *1001访问商户 1002访问车辆
 */
@property (nonatomic, strong) NSString *log_type;
/**
 *相关ID
 */
@property (nonatomic, strong) NSString *about_id;
/**
 *详情数据
 */
@property (nonatomic, strong) QLShareHistoryModel *infoModel;
@end

NS_ASSUME_NONNULL_END
