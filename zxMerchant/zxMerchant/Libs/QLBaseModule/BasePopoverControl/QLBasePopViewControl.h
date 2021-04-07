//
//  QLCustomPopViewController.h
//  luluzhuan
//
//  Created by 乔磊 on 2017/10/18.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CELL_REGISTER_TYPE) {
    CellNibRegisterType = 0,//nib注册
    CellClassRegisterType = 1,//class注册
};
@class QLBasePopViewControl;
@protocol PopViewControlDelegate <NSObject>
@optional
/*
 *cell设置
 */
- (void)cell:(UITableViewCell *)baseCell IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr;
/*
 *点击回调
 */
- (void)popClickCall:(NSInteger)index;

@end
@interface QLBasePopViewControl : UIViewController<UITableViewDelegate,UITableViewDataSource>
/**
 *数据数组
 */
@property (nonatomic, strong) NSArray *dataArray;
/**
 *背景颜色
 */
@property (nonatomic, strong) UIColor *backgroundColor;
/**
 *设置大小，只有在cellName不为0时有用
 */
@property (nonatomic, assign) CGSize viewSize;
/**
 *cellName：为Cell类名
 */
@property (nonatomic, strong) NSString *cellName;
/**
 *注册cell类型(0：Nib 1:Class)
 */
@property (nonatomic, assign) CELL_REGISTER_TYPE registerType;
/**
 *delegate
 */
@property (nonatomic, weak) id<PopViewControlDelegate> delegate;
@end
