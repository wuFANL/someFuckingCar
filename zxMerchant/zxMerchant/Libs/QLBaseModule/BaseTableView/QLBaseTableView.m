//
//  QLBaseTableView.m
//  luluzhuan
//
//  Created by 乔磊 on 2017/10/8.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import "QLBaseTableView.h"

@interface QLBaseTableView()<QLBackgroundViewDelegate,UITableViewDataSource>
@end
@implementation QLBaseTableView
#pragma mark- 初始化
- (instancetype)init {
    self = [super init];
    if (self) {
        //默认设置
        [self tableViewDefault];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.frame = frame;
        //默认设置
        [self tableViewDefault];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        //设置
        [self tableViewDefault];
    }
    return self;
}
//默认设置
- (void)tableViewDefault {
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.separatorColor = [UIColor groupTableViewBackgroundColor];
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    self.page = 1;
    self.beyondDataNumber = 0;
    self.previewCellCount = 10;
    self.dataSource = self;
    //设置默认tableViewHead
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0.1)];
    headView.backgroundColor = [UIColor clearColor];
    self.tableHeaderView = headView;
    
}
//子控件布局
-(void)layoutSubviews {
    [super layoutSubviews];
    if (self.tableBackgroundView) {
        self.tableBackgroundView.frame = self.frame;
    }
}
#pragma mark- 是否增加刷新控制器
- (void)setShowHeadRefreshControl:(BOOL)showHeadRefreshControl {
    //增加刷新
    if (showHeadRefreshControl == YES) {
        [self addRefreshControl:1];
    } else {
        [self.mj_header removeFromSuperview];
    }
}
- (void)setShowFootRefreshControl:(BOOL)showFootRefreshControl {
    //增加加载
    if (showFootRefreshControl == YES) {
        [self addRefreshControl:2];
    } else {
        [self.mj_footer removeFromSuperview];
    }
    
}
#pragma mark- tableView刷新
- (void)setPreviewCellCount:(NSInteger)previewCellCount {
    _previewCellCount = previewCellCount;
    [self reloadData];
}
- (void)addRefreshControl:(int)type {
    if (type == 1) {
        if (self.mj_header.isRefreshing == NO) {
            //下拉控件（刷新数据）
            self.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDeals)];
        }
        [self.mj_header beginRefreshing];
    } else {
        if (self.mj_footer.isRefreshing == NO) {
            //上拉控件（加载新数据）
            self.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeals)];
        }
    }
}
//下拉触发
- (void)loadNewDeals {
    self.page = 1;
    if ([self.extendDelegate respondsToSelector:@selector(loadNew)]) {
        [self.extendDelegate loadNew];
    }
    //发送请求
    [self sendRequestToServer];
}
//上拉触发
- (void)loadMoreDeals {
    self.page++;
    if ([self.extendDelegate respondsToSelector:@selector(loadMore)]) {
        [self.extendDelegate loadMore];
    }
    [self sendRequestToServer];
}
//数据请求
- (void)sendRequestToServer {
    if ([self.extendDelegate respondsToSelector:@selector(dataRequest)]) {
        [self.extendDelegate dataRequest];
    }
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.previewDataSoure && [self.previewDataSoure respondsToSelector:@selector(numberOfSectionsInPreviewTableView:)]) {
        if ([self.previewDataSoure numberOfSectionsInPreviewTableView:tableView] == self.beyondDataNumber) {
            return _previewCellCount;
        } else {
            return  [self.previewDataSoure numberOfSectionsInPreviewTableView:tableView];
        }
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.previewDataSoure && [self.previewDataSoure respondsToSelector:@selector(previewTableView:numberOfRowsInSection:)]) {
        if ([self.previewDataSoure numberOfSectionsInPreviewTableView:tableView] == self.beyondDataNumber) {
            return 1;
        } else {
            if ([self.previewDataSoure previewTableView:tableView numberOfRowsInSection:section] == self.beyondDataNumber) {
                return _previewCellCount;
            } else {
                return  [self.previewDataSoure previewTableView:tableView numberOfRowsInSection:section];
            }
        }
        
    }
    return _previewCellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.previewDataSoure && [self.previewDataSoure respondsToSelector:@selector(previewTableView:numberOfRowsInSection:)]) {
        if ([self.previewDataSoure previewTableView:tableView numberOfRowsInSection:indexPath.section] == self.beyondDataNumber||[self.previewDataSoure numberOfSectionsInPreviewTableView:tableView] == self.beyondDataNumber) {
            UITableViewCell *cell = [self.previewDataSoure previewCell:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            for (UIView *s in cell.contentView.subviews) {
                if ([s isKindOfClass:[UILabel class]]) {
                    UILabel *lb = (UILabel *)s;
                    lb.text = lb.text.length==0?@" ":lb.text;
                }
                if (!s.backgroundColor) {
                    s.backgroundColor = _previewCellDefaultColor?_previewCellDefaultColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
                }
                
            }
            return cell;
        } else if (self.previewDataSoure && [self.previewDataSoure respondsToSelector:@selector(previewTableView:cellForRowAtIndexPath:)]) {
            UITableViewCell *cell = [self.previewDataSoure previewTableView:tableView cellForRowAtIndexPath:indexPath];
            for (UIView *s in cell.contentView.subviews) {
                UIColor *color = s.backgroundColor;
                if (CGColorEqualToColor(color.CGColor, _previewCellDefaultColor.CGColor)||CGColorEqualToColor(color.CGColor, [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1].CGColor)) {
                    s.backgroundColor = [UIColor clearColor];
                }
            }
            return cell;
        }
    
    }

    
    return [self.previewDataSoure previewTableView:tableView cellForRowAtIndexPath:indexPath];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.previewDataSoure && [self.previewDataSoure respondsToSelector:@selector(previewTableView:titleForHeaderInSection:)]) {
        return [self.previewDataSoure previewTableView:tableView titleForHeaderInSection:section];
    }
    return nil;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (self.previewDataSoure && [self.previewDataSoure respondsToSelector:@selector(previewTableView:titleForFooterInSection:)]) {
        return [self.previewDataSoure previewTableView:tableView titleForFooterInSection:section];
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.previewDataSoure && [self.previewDataSoure respondsToSelector:@selector(previewTableView:canEditRowAtIndexPath:)]) {
        return [self.previewDataSoure previewTableView:tableView canEditRowAtIndexPath:indexPath];
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.previewDataSoure && [self.previewDataSoure respondsToSelector:@selector(previewTableView:canMoveRowAtIndexPath:)]) {
        return [self.previewDataSoure previewTableView:tableView canMoveRowAtIndexPath:indexPath];
    }
    return NO;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.previewDataSoure && [self.previewDataSoure respondsToSelector:@selector(sectionIndexTitlesForPreviewTableView:)]) {
        return [self.previewDataSoure sectionIndexTitlesForPreviewTableView:tableView];
    }
    return [NSArray new];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (self.previewDataSoure && [self.previewDataSoure respondsToSelector:@selector(previewTableView:sectionForSectionIndexTitle:atIndex:)]) {
        return [self.previewDataSoure previewTableView:tableView sectionForSectionIndexTitle:title atIndex:index];
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.previewDataSoure && [self.previewDataSoure respondsToSelector:@selector(previewTableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [self.previewDataSoure previewTableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (self.previewDataSoure && [self.previewDataSoure respondsToSelector:@selector(previewTableView:moveRowAtIndexPath:toIndexPath:)]) {
        [self.previewDataSoure previewTableView:tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
}
#pragma mark- 背景设置
- (void)addBackgroundView {
    self.tableBackgroundView = [[QLBaseBackgroundView alloc]initWithFrame:self.frame];
    self.tableBackgroundView.delegate= self;
    self.tableBackgroundView.placeholder = @"加载失败，请重新加载";
    [self.tableBackgroundView sizeToFit];
    [self insertSubview:self.tableBackgroundView atIndex:0];
}
//设置背景文字
- (void)setBackgroundViewTitle:(NSString *)backgroundViewTitle {
    _backgroundViewTitle = backgroundViewTitle;
    self.tableBackgroundView.placeholder = backgroundViewTitle;
}
//是否显示
- (void)setShowBackgroundView:(BOOL)showBackgroundView {
    _showBackgroundView = showBackgroundView;
    if (showBackgroundView == YES) {
        if (!self.tableBackgroundView) {
            //增加背景
            [self addBackgroundView];
        }
        self.tableBackgroundView.hidden = NO;
    } else {
        [self.tableBackgroundView removeFromSuperview];
    }
}
//出现预览cell忽略的数量
- (void)setBeyondDataNumber:(NSInteger)beyondDataNumber {
    _beyondDataNumber = beyondDataNumber;

}
//点击事件
- (void)clickPlaceholderBtn:(UIButton *)sender {
    if ([self.extendDelegate respondsToSelector:@selector(centerBtnClick:)]) {
        [self.extendDelegate centerBtnClick:sender];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
