//
//  QLSubListTitleCell.m
//  zxMerchant
//
//  Created by lei qiao on 2021/2/28.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLSubListTitleCell.h"
#import "QLIconItem.h"

@interface QLSubListTitleCell()<QLIrregularLayoutDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) QLBaseCollectionView *collectionView;

@property (nonatomic, strong) NSDictionary *dataDic;
@end
@implementation QLSubListTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.bjView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bjView);
    }];
    
}

- (void)updateWith:(NSDictionary *)dic {
    if (self.dataDic) {
        return;
    }
    self.dataDic = dic;
    // 更新标题
    self.titleLB.text = EncodeStringFromDic(dic, @"title");
    // 更新标签
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSString *key in dic) {
        if ([key isEqualToString:@"factory_way"] || [key isEqualToString:@"emission_standard"] || [key isEqualToString:@"transmission_case"]) {
            [dataArr addObject:EncodeStringFromDic(dic, key)];
        }
        if ([key isEqualToString:@"max_driving_distance"]) {
            NSString* driveMaxDistance = [[QLToolsManager share] unitMileage:[EncodeStringFromDic(dic, @"max_driving_distance") floatValue]];
            if ([driveMaxDistance isEqualToString:@"100"]) {
                continue;
            }
            [dataArr addObject:[NSString stringWithFormat:@"%@万公里",driveMaxDistance]];
        }
        if ([key isEqualToString:@"min_price"]) {
            NSString *lowPrice = [[QLToolsManager share] unitConversion:[EncodeStringFromDic(dic, @"min_price") floatValue]];
            NSString *maxPrice = [[QLToolsManager share] unitConversion:[EncodeStringFromDic(dic, @"max_price") floatValue]];
            [dataArr addObject:[NSString stringWithFormat:@"%@-%@",lowPrice,maxPrice]];
        }
        if ([key isEqualToString:@"min_displacement"]) {
            // 动力型号
            NSString *energyTypeLow = EncodeStringFromDic(dic, @"min_displacement");
            NSString *energyTypeHigh = EncodeStringFromDic(dic, @"max_displacement");
            NSString *energyTypeUnit = EncodeStringFromDic(dic, @"displacement_type");
            
            if ([energyTypeLow isEqualToString:@"0"] && [energyTypeHigh isEqualToString:@"10"]) {
                continue;
            }
            [dataArr addObject:[NSString stringWithFormat:@"%@-%@%@",energyTypeLow,energyTypeHigh,energyTypeUnit]];
        }
        if ([key isEqualToString:@"min_driving_distance"]) {
            // 里程
            NSString *min_driving_distance = [[QLToolsManager share] unitMileage:[EncodeStringFromDic(dic, @"min_driving_distance") floatValue]];
            NSString *max_driving_distance = [[QLToolsManager share] unitMileage:[EncodeStringFromDic(dic, @"min_driving_distance") floatValue]];
            
            if ([min_driving_distance isEqualToString:@"0"] && [max_driving_distance isEqualToString:@"0"]) {
                continue;;
            }
           [dataArr addObject:[NSString stringWithFormat:@"%@-%@万公里",min_driving_distance,max_driving_distance]];
        }
        // 年限
        if ([key isEqualToString:@"min_vehicle_age"]) {
            NSString *min_vehicle_age = EncodeStringFromDic(dic, @"min_vehicle_age");
            NSString *max_vehicle_age = EncodeStringFromDic(dic, @"max_vehicle_age");
            if ([min_vehicle_age isEqualToString:@"0"] && [max_vehicle_age isEqualToString:@"100"]) {
                continue;;
            }
            [dataArr addObject:[NSString stringWithFormat:@"%@-%@年",min_vehicle_age,max_vehicle_age]];
        }
    }
    
    self.iconArr = dataArr;
}

#pragma mark -setter
- (void)setIconArr:(NSMutableArray *)iconArr {
    _iconArr = iconArr;
    [self.collectionView reloadData];
}
#pragma mark -collectionView
- (CGSize)layout:(QLCollectionViewFlowLayout *)collectionViewLayout sizeForSectionAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeZero;
}
- (CGSize)layout:(QLCollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.iconArr[indexPath.row];
    return CGSizeMake([title widthWithFontSize:10]+8, 20);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.iconArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QLIconItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSString *title = self.iconArr[indexPath.row];
    [item.iconBtn setTitle:title forState:UIControlStateNormal];
    [item.iconBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [item.iconBtn setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [item.iconBtn roundRectCornerRadius:2 borderWidth:1 borderColor:ClearColor];
    return item;
}
#pragma mark - Lazy
- (QLBaseCollectionView *)collectionView {
    if (!_collectionView) {
        QLCollectionViewFlowLayout *layout = [[QLCollectionViewFlowLayout alloc]initMinimumSpacing:QLMinimumSpacingMake(6, 6)];
        layout.dataSource = self;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[QLBaseCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = WhiteColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"QLIconItem" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

@end
