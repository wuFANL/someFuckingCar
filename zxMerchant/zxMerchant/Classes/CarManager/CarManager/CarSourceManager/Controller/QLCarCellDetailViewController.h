//
//  QLCarCellDetailViewController.h
//  zxMerchant
//
//  Created by HK on 2021/6/9.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLCarCellDetailViewController : QLBaseTableViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UIImageView *headImg;
@property (nonatomic, strong) IBOutlet UILabel *titleLab;
@property (nonatomic, strong) IBOutlet UILabel *contentLab;

-(id)initWithSourceDic:(NSDictionary *)sourceDic withBtnIndex:(NSInteger)btnIndex;
@end

NS_ASSUME_NONNULL_END
