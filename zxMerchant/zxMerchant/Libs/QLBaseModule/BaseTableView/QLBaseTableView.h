//
//  QLTableView.h
//  luluzhuan
//
//  Created by 乔磊 on 2017/10/8.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>
#import "QLBaseBackgroundView.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"
@class QLBaseTableView;
#pragma mark- 数据代理
@protocol QLBaseTableViewDelegate <NSObject>
@optional
/**
 *背景提示文本点击
 */
- (void)centerBtnClick:(UIButton *_Nullable)sender;
/**
 *刷新时方法
 */
- (void)loadNew;
- (void)loadMore;
/**
 *数据请求方法
 */
- (void)dataRequest;
@end
#pragma mark- 带预览cell代理
@protocol QLPreviewTableViewDataSource <NSObject>
@required
- (NSInteger)previewTableView:(UITableView *_Nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *_Nonnull)previewTableView:(UITableView *_Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath *_Nullable)indexPath;
/**
 *返回一个预览的UITableViewCell实例
 */
- (UITableViewCell *_Nonnull)previewCell:(NSIndexPath *_Nonnull)indexPath;
@optional

- (NSInteger)numberOfSectionsInPreviewTableView:(UITableView *_Nonnull)tableView;
- (nullable NSString *)previewTableView:(UITableView *_Nonnull)tableView titleForHeaderInSection:(NSInteger)section;
- (nullable NSString *)previewTableView:(UITableView *_Nonnull)tableView titleForFooterInSection:(NSInteger)section;
- (BOOL)previewTableView:(UITableView *_Nonnull)tableView canEditRowAtIndexPath:(NSIndexPath *_Nonnull)indexPath;
- (BOOL)previewTableView:(UITableView *_Nonnull)tableView canMoveRowAtIndexPath:(NSIndexPath *_Nonnull)indexPath;
- (nullable NSArray<NSString *> *)sectionIndexTitlesForPreviewTableView:(UITableView *_Nonnull)tableView;
- (NSInteger)previewTableView:(UITableView *_Nonnull)tableView sectionForSectionIndexTitle:(NSString *_Nonnull)title atIndex:(NSInteger)index;
- (void)previewTableView:(UITableView *_Nonnull)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *_Nonnull)indexPath;
- (void)previewTableView:(UITableView *_Nonnull)tableView moveRowAtIndexPath:(NSIndexPath *_Nonnull)sourceIndexPath toIndexPath:(NSIndexPath *_Nonnull)destinationIndexPath;
@end

@interface QLBaseTableView : UITableView
/**
 *backgroundView
 */
@property (nonatomic, strong) QLBaseBackgroundView * _Nullable tableBackgroundView;
/**
 *是否显示无结果背景
 */
@property (nonatomic, assign) BOOL showBackgroundView;
/**
 *背景标题
 */
@property (nonatomic, strong) NSString * _Nullable backgroundViewTitle;
/**
 *是否添加头部刷新
 */
@property (nonatomic, assign) BOOL showHeadRefreshControl;
/**
 *是否添加底部部刷新
 */
@property (nonatomic, assign) BOOL showFootRefreshControl;
/**
 *页数
 */
@property (nonatomic, assign) NSInteger page;
/*
 *比数据多出的个数
 */
@property (nonatomic, assign) NSInteger beyondDataNumber;
/**
 *需要显示预览cell数量 默认显示10个
 */
@property (nonatomic, assign) NSInteger previewCellCount;
/*
 *需要显示占位控件颜色 默认[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1]
 */
@property (nonatomic, strong) UIColor * _Nullable previewCellDefaultColor;
/**
 *使用预览效果时，必须实现此代理，代替tableView的dataSoure
 */
@property (nonatomic,weak) id<QLPreviewTableViewDataSource>_Nullable previewDataSoure;
/**
 *代理
 */
@property (nonatomic, weak) id<QLBaseTableViewDelegate>_Nullable extendDelegate;
@end
