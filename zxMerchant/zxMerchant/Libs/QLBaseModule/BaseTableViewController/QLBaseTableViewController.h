//
//  QLBaseTableViewController.h
//  Integral
//
//  Created by 乔磊 on 2019/4/19.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLBaseViewController.h"
#import "QLBaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLBaseTableViewController : QLBaseViewController
/**
 *tableView类型
 */
@property (nonatomic, assign) UITableViewStyle initStyle;
/*
 *tableView
 */
@property (nonatomic, strong) QLBaseTableView *tableView;
@end

NS_ASSUME_NONNULL_END
