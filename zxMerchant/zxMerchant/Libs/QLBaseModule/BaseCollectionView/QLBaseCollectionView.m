//
//  QLBaseCollectionView.m
//  luluzhuan
//
//  Created by 乔磊 on 2017/9/28.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import "QLBaseCollectionView.h"
@implementation QLItemModel

@end

@interface QLBaseCollectionView()

@end
@implementation QLBaseCollectionView
static NSString * const reuseIdentifier = @"baseCell";

#pragma mark-  初始化
- (instancetype)initWithSize:(CGSize)size ItemModel:(QLItemModel *)itemModel {
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    QLCollectionViewFlowLayout *layout = [self layoutWithFrame:frame ItemModel:itemModel];
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        //默认设置
        [self collectionViewWithFrame:frame ItemModel:itemModel];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame ItemModel:(QLItemModel *)itemModel {
    QLCollectionViewFlowLayout *layout = [self layoutWithFrame:frame ItemModel:itemModel];
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        //默认设置
        [self collectionViewWithFrame:frame ItemModel:itemModel];
    }
    return self;
}
//初始化布局
- (QLCollectionViewFlowLayout *)layoutWithFrame:(CGRect)frame ItemModel:(QLItemModel *)itemModel {
    QLCollectionViewFlowLayout *layout;
    if (itemModel) {
        layout = [[QLCollectionViewFlowLayout alloc]initItemCount:itemModel.columnCount RowCount:itemModel.rowCount SectionInset:itemModel.sectionInset MinimumSpacing:itemModel.Spacing];
        CGFloat width = (frame.size.width-(layout.columnCount-1)*layout.minimumInteritemSpacing-layout.sectionInset.left-layout.sectionInset.right)/layout.columnCount;
        CGFloat height = (frame.size.height-(layout.rowCount-1)*layout.minimumLineSpacing-layout.sectionInset.top-layout.sectionInset.bottom)/layout.rowCount;
        if (CGSizeEqualToSize(itemModel.itemSize, CGSizeZero)) {
            itemModel.itemSize = CGSizeMake(width, height);
        }
        layout.itemSize = itemModel.itemSize;
        layout.scrollDirection = itemModel.scrollDirection;
        layout.showCosineEffect = itemModel.showCosineEffect;
        layout.showRandomSize = itemModel.showRandomSize;
        layout.showTransverseSortByHorizontal = itemModel.showTransverseSortByHorizontal;
    }
    return layout;
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
#pragma mark-  数据设置
- (void)setDataArr:(NSMutableArray *)dataArr {
    if (self.itemModel.showTransverseSortByHorizontal) {
        //页面不足一页时会显示不出来，需要自行补充数据，隐藏Item
        NSInteger pageCount = self.itemModel.rowCount*self.itemModel.columnCount;
        NSInteger page = ceil(dataArr.count/(pageCount*1.0));
        NSInteger totalItem = page*pageCount;
        if (totalItem > dataArr.count) {
            for (int i = 0; i < totalItem; i++) {
                if (dataArr.count <= i) {
                    [dataArr addObject:@"占位item"];
                }
            }
        }
    }
    _dataArr = dataArr;
    [self reloadData];
    
    if (self.extendDelegate&&[self.extendDelegate respondsToSelector:@selector(collectionView:GetData:)]) {
        [self.extendDelegate collectionView:self GetData:_dataArr];
    }
}
#pragma mark-  item注册设置
- (void)setRegisterType:(ITEM_REGISTER_TYPE)registerType {
    if (_cellClassName.length > 0) {
        if (registerType == ITEM_NibRegisterType) {
            [self registerNib:[UINib nibWithNibName:_cellClassName bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
        } else {
            [self registerClass:NSClassFromString(_cellClassName) forCellWithReuseIdentifier:reuseIdentifier];
        }
    } else {
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    
}
- (void)setCellClassName:(NSString *)cellClassName {
    _cellClassName = cellClassName;
    if (self.registerType) {
        [self setRegisterType:self.registerType];
    }
}
#pragma mark-  设置CollectionView
- (void)collectionViewWithFrame:(CGRect)frame ItemModel:(QLItemModel *)itemModel {
    self.frame = frame;
    self.itemModel = itemModel;
    self.cellClassName = itemModel.itemName;
    self.registerType = itemModel.registerType;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
    self.alwaysBounceHorizontal = NO;
    self.delegate = self;
    self.dataSource = self;
}
#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.extendDelegate&&[self.extendDelegate respondsToSelector:@selector(numberOfSections:)]) {
        return [self.extendDelegate numberOfSections:collectionView];
    }
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.extendDelegate&&[self.extendDelegate respondsToSelector:@selector(collectionView: numberOfItems:)]) {
        return [self.extendDelegate collectionView:collectionView numberOfItems:section];
    }
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.hidden = NO;
    
    NSInteger totalSection = [collectionView numberOfSections];
    id obj = nil;
    if (totalSection == 1) {
        obj = self.dataArr[indexPath.row];
    } else {
        if ([self.dataArr[indexPath.section] isKindOfClass:[NSArray class]]) {
            obj = self.dataArr[indexPath.section][indexPath.row];
        } else {
            obj = self.dataArr[indexPath.row];
        }
    }
    
    if ([obj isKindOfClass:[NSString class]]&&[obj isEqualToString:@"占位item"]) {
         cell.hidden = YES;
    } else {
        if (self.extendDelegate&&[self.extendDelegate respondsToSelector:@selector(collectionView:Item:IndexPath:Data:)]) {
            [self.extendDelegate collectionView:collectionView Item:cell IndexPath:indexPath Data:[self removePlaceholderData]];
        }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    id obj = self.dataArr[indexPath.row];
    if ([obj isKindOfClass:[NSString class]]&&[obj isEqualToString:@"占位item"]) {
        return;
    }
    if (self.extendDelegate&&[self.extendDelegate respondsToSelector:@selector(collectionViewSelect:IndexPath:Data:)]) {
        [self.extendDelegate collectionViewSelect:collectionView IndexPath:indexPath Data:[self removePlaceholderData]];
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (self.extendDelegate&&[self.extendDelegate respondsToSelector:@selector(collectionView:viewKind:IndexPath:)]) {
        return [self.extendDelegate collectionView:collectionView viewKind:kind IndexPath:indexPath];
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.extendDelegate&&[self.extendDelegate respondsToSelector:@selector(collectionView:layout:viewKind:InSection:)]) {
        
        return [self.extendDelegate collectionView:collectionView layout:collectionViewLayout viewKind:UICollectionElementKindSectionHeader InSection:section];
    }
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (self.extendDelegate&&[self.extendDelegate respondsToSelector:@selector(collectionView:layout:viewKind:InSection:)]) {
        
        return [self.extendDelegate collectionView:collectionView layout:collectionViewLayout viewKind:UICollectionElementKindSectionFooter InSection:section];
    }
    return CGSizeZero;
}
- (NSMutableArray *)removePlaceholderData {
    NSMutableArray *itemArr = [NSMutableArray arrayWithArray:self.dataArr];
    [itemArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]&&[obj isEqualToString:@"占位item"]) {
            [itemArr removeObject:obj];
        }
    }];
    return itemArr;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.extendDelegate&&[self.extendDelegate respondsToSelector:@selector(scrollViewEndScrollingAnimation:)]) {
        [self.extendDelegate scrollViewEndScrollingAnimation:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.extendDelegate&&[self.extendDelegate respondsToSelector:@selector(scrollViewEndDecelerating:)]) {
        [self.extendDelegate scrollViewEndDecelerating:scrollView];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.extendDelegate&&[self.extendDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.extendDelegate scrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.extendDelegate&&[self.extendDelegate respondsToSelector:@selector(scrollViewBeginDragging:)]) {
        [self.extendDelegate scrollViewBeginDragging:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.extendDelegate&&[self.extendDelegate respondsToSelector:@selector(scrollViewEndDragging:willDecelerate:)]) {
        [self.extendDelegate scrollViewEndDragging:scrollView willDecelerate:decelerate];
    }
}

@end
