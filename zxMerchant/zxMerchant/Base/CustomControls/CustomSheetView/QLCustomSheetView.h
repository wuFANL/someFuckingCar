//
//  QLCustomSheetView.h
//  PopularUsedCarManagement
//
//  Created by lei qiao on 2020/6/22.
//  Copyright © 2020 EmbellishJiao. All rights reserved.
//

#import "QLBaseView.h"

NS_ASSUME_NONNULL_BEGIN
@class QLCustomSheetView;
@protocol QLCustomSheetViewDelegate <NSObject>
@optional
- (void)sheetCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath model:(id)model;
@end
@interface QLCustomSheetView : QLBaseView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
- (void)show;
- (void)hidden;
/**
 *列表数据
 */
@property (nonatomic, strong) NSArray *listArr;
/**
 *选择下标
 */
@property (nonatomic, assign) NSInteger selectIndex;
/**
 *选择回调
 */
@property (nonatomic, strong) ResultBlock clickHandler;
/**
 *
 */
@property (nonatomic, weak) id<QLCustomSheetViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
