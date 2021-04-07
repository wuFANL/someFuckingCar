//
//  QLHomePageHeadView.m
//  PopularUsedCarMerchant
//
//  Created by lei qiao on 2020/9/24.
//  Copyright © 2020 EmbellishJiao. All rights reserved.
//

#import "QLHomePageHeadView.h"

@interface QLHomePageHeadView()<QLBannerViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) QLBaseCollectionView *collectionView;

@end
@implementation QLHomePageHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self commentInit];
    }
    return self;
}
//长按手势
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    //获取此次点击的坐标，根据坐标获取cell对应的indexPath
    CGPoint point = [longPress locationInView:_collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    //根据长按手势的状态进行处理。
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            //当没有点击到cell的时候不进行处理
            if (!indexPath) {
                break;
            }
            //开始移动
            [_collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程中更新位置坐标
            [_collectionView updateInteractiveMovementTargetPosition:point];
            break;
        case UIGestureRecognizerStateEnded:
            //停止移动调用此方法
            [_collectionView endInteractiveMovement];
            break;
        default:
            //取消移动
            [_collectionView cancelInteractiveMovement];
            break;
    }
}
- (void)commentInit {
    [self addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(158);
    }];
    
    //长按手势
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPressGesture.minimumPressDuration = 0.1;
    [self.collectionView addGestureRecognizer:longPressGesture];
}
#pragma mark - setter
- (void)setItemArr:(NSMutableArray *)itemArr {
    if (![itemArr isEqualToArray:self.itemArr]) {
        [self.collectionView removeFromSuperview];
        self.collectionView = nil;
        
        int row = itemArr.count/5 > 1?2:1;
        int collectionViewHeight = 95*row;
        
        QLItemModel *model = [QLItemModel new];
        model.columnCount = 5;
        model.rowCount = row;
        model.sectionInset = UIEdgeInsetsMake(20, 28, 20, 28);
        model.Spacing = QLMinimumSpacingMake(15, 15);
        model.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        model.showTransverseSortByHorizontal = row == 2?YES:NO;
        self.collectionView = [[QLBaseCollectionView alloc] initWithSize:CGSizeMake(ScreenWidth-20, collectionViewHeight) ItemModel:model];
        [self.collectionView roundRectCornerRadius:3 borderWidth:1 borderColor:LightGrayColor];
        [self.collectionView registerNib:[UINib nibWithNibName:@"QLImgTextItem" bundle:nil] forCellWithReuseIdentifier:@"baseCell"];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.bottom.equalTo(self).offset(-5);
            make.height.mas_equalTo(collectionViewHeight);
        }];
        [self.collectionView reloadData];
    }
    _itemArr = itemArr;
}
#pragma mark - collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QLImgTextItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"baseCell" forIndexPath:indexPath];
    item.titleLB.font = [UIFont systemFontOfSize:12];
    QLFunModel *model = self.itemArr[indexPath.row];
    NSDictionary *dic = [[QLToolsManager share].homePageModel getFunNameAndImgName:model.value.integerValue];
    
    item.titleLB.text = dic[@"funName"];
    item.imgView.image = [UIImage imageNamed:dic[@"imgName"]];
    return item;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(funClick:)]) {
        QLFunModel *model = self.itemArr[indexPath.row];
        [self.delegate funClick:model];
    }
}
//能否移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//移动cell变化
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath {
    NSInteger fromIndex = sourceIndexPath.row;
    id objA = self.itemArr[fromIndex];
    [self.itemArr removeObjectAtIndex:fromIndex];
    NSInteger toIndex = destinationIndexPath.row;
    [self.itemArr insertObject:objA atIndex:toIndex];
    [self.collectionView reloadData];
    
}
#pragma mark - Lazy
- (QLBannerView *)bannerView {
    if(!_bannerView) {
        _bannerView = [[QLBannerView alloc] init];
        
    }
    return _bannerView;
}

@end
