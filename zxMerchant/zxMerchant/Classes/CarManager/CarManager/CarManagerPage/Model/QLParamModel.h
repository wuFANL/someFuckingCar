//
//  QLParamModel.h
//  zxMerchant
//
//  Created by HK on 2021/5/19.
//  Copyright © 2021 ql. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLParamModel : NSObject
@property (nonatomic, copy) NSString *local_state; //我的车源=1 合作车源=2  传空是全部
@property (nonatomic, copy) NSString *sort_by;     //智能排序1 价格最低2 价格最高3 库龄最短4 里程最少5
@property (nonatomic, copy) NSString *brand_id;    //品牌ID
@property (nonatomic, copy) NSString *price_min;   //价格最低 0
@property (nonatomic, copy) NSString *price_max;   //价格最高 9999999
@property (nonatomic, copy) NSString *deal_state;  //0仓库中 1上架在售 3成交
@property (nonatomic, copy) NSString *content;     //搜索内容
@property (nonatomic, copy) NSString *page_no;
@property (nonatomic, copy) NSString *page_size;
@end

@interface QLConditionModel : NSObject
@property (nonatomic, copy) NSString *conditionName; //showName
@property (nonatomic, copy) NSString *sortIndex;     //0123
@end



NS_ASSUME_NONNULL_END
