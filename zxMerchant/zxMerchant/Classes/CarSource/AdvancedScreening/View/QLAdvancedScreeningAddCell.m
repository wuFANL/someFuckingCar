//
//  QLAdvancedScreeningAddCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/29.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLAdvancedScreeningAddCell.h"
#import "QLConditionsItem.h"

@interface QLAdvancedScreeningAddCell()<UICollectionViewDelegate,UICollectionViewDataSource,QLIrregularLayoutDataSource>
@property (nonatomic, strong) QLBaseCollectionView *collectionView;

@end
@implementation QLAdvancedScreeningAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.bjView roundRectCornerRadius:3 borderWidth:1 borderColor:LightGrayColor];
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bjView).offset(10);
        make.top.equalTo(self.bjView).offset(10);
        make.bottom.equalTo(self.bjView).offset(-10);
        make.right.equalTo(self.addBtn.mas_left).offset(-15);
    }];
}
#pragma mark - setter
- (void)setItemArr:(NSArray *)itemArr {
    _itemArr = itemArr;
    [self.collectionView reloadData];
}
#pragma mark - action
- (void)deleteBtnClick:(UIButton *)sender {
    NSInteger index = sender.tag;
    self.deleteHandler(@(index), nil);
    
}
#pragma mark - collectionView
- (CGSize)layout:(QLCollectionViewFlowLayout *)collectionViewLayout sizeForSectionAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.width, 0);
}
- (CGSize)layout:(QLCollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.itemArr[indexPath.row];
    return CGSizeMake([title widthWithFontSize:12]+10+40, 25);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QLConditionsItem *item = (QLConditionsItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    item.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [item roundRectCornerRadius:3 borderWidth:1 borderColor:[UIColor groupTableViewBackgroundColor]];
    item.showDeleteBtn = YES;
    item.deleteBtn.tag = indexPath.row;
    [item.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    item.titleLB.text = self.itemArr[indexPath.row];
   
    return item;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - Lazy
- (QLBaseCollectionView *)collectionView {
    if (!_collectionView) {
        QLCollectionViewFlowLayout *layout = [[QLCollectionViewFlowLayout alloc]initMinimumSpacing:QLMinimumSpacingMake(10, 10)];
        layout.dataSource = self;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[QLBaseCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = ClearColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"QLConditionsItem" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}
@end
