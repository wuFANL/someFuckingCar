//
//  UITableView+JGHiddenLine.m
//  Store
//
//  Created by jgs on 16/12/14.
//  Copyright © 2016年 JGS. All rights reserved.
//

#import "UITableView+QLUtil.h"

@implementation UITableView (QLUtil)
- (void)hideTableEmptyDataSeparatorLine {
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    self.tableFooterView = view;
}
@end
