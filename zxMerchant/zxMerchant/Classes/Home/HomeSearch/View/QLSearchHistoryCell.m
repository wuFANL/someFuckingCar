//
//  QLSearchHistoryCell.m
//  PopularUsedCar
//
//  Created by 乔磊 on 2018/5/11.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLSearchHistoryCell.h"
#import "QLConditionsItem.h"

@interface QLSearchHistoryCell()<UICollectionViewDelegate,UICollectionViewDataSource,QLIrregularLayoutDataSource>
@property (nonatomic, strong) QLBaseCollectionView *collectionView;

@end
@implementation QLSearchHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //collectionView
    [self addCollectionView];
    
}

- (void)setItemArr:(NSArray *)itemArr {
    _itemArr = itemArr;
    [self.collectionView reloadData];
    if (itemArr.count > 0) {
        CGFloat width = 0;
        for (int i = 0; i < itemArr.count; i++) {
            NSString *title = [self getResultByIndex:i];
            width = width + ([title widthWithFontSize:12]+30);
        }
        width = width + (itemArr.count-1)*10;
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLB);
            make.right.equalTo(self.deleteBtn);
            make.top.equalTo(self.titleLB.mas_bottom).offset(5);
            make.bottom.equalTo(self.contentView).offset(-5);
            make.height.mas_equalTo(35+35*(width/(ScreenWidth-30)));
        }];
    }
}
- (void)addCollectionView {
    QLCollectionViewFlowLayout *layout = [[QLCollectionViewFlowLayout alloc]initMinimumSpacing:QLMinimumSpacingMake(10, 10)];
    layout.dataSource = self;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[QLBaseCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = ClearColor;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"QLConditionsItem" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLB);
        make.right.equalTo(self.deleteBtn);
        make.top.equalTo(self.titleLB.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.height.mas_equalTo(35);
    }];
    [self.collectionView reloadData];
}
- (CGSize)layout:(QLCollectionViewFlowLayout *)collectionViewLayout sizeForSectionAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.width, 5);
}
- (CGSize)layout:(QLCollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = [self getResultByIndex:indexPath.row];
    return CGSizeMake([title widthWithFontSize:12]+20, 30);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QLConditionsItem *item = (QLConditionsItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    item.titleLB.text = [self getResultByIndex:indexPath.row];
    [item roundRectCornerRadius:3 borderWidth:1 borderColor:LightGrayColor];
    item.showDeleteBtn = NO;
    return item;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.result([self getResultByIndex:indexPath.row]);
}
//通过下标获取数据
- (NSString *)getResultByIndex:(NSInteger)index {
    NSString *title = @"";
    if (self.itemArr.count > 0) {
        id result = self.itemArr[self.itemArr.count-1-index];
        if ([result isKindOfClass:[NSString class]]) {
           title = result;
        }
    }
    
    return title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
