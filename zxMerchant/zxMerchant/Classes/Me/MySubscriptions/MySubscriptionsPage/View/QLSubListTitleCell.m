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
    self.dataDic = dic;
    // 更新标题
    self.titleLB.text = EncodeStringFromDic(dic, @"title");
    // 更新标签
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSString *key in dic) {
        if ([key isEqualToString:@"factory_way"] || [key isEqualToString:@"emission_standard"] || [key isEqualToString:@"transmission_case"]) {
            [dataArr addObject:EncodeStringFromDic(dic, key)];
        }
        if ([key isEqualToString:@"min_price"]) {
            NSString *lowPrice = [[QLToolsManager share] unitConversion:[EncodeStringFromDic(dic, @"min_price") floatValue]];
            NSString *maxPrice = [[QLToolsManager share] unitConversion:[EncodeStringFromDic(dic, @"max_price") floatValue]];
            if ([lowPrice isEqualToString:@"0元"] && [maxPrice isEqualToString:@"1000.00万"]) {
                continue;
            }
            
            [dataArr addObject:[NSString stringWithFormat:@"%@-%@",lowPrice,maxPrice]];
        }
        
        if ([key isEqualToString:@"car_type"]) {
            NSString *type = [self carTypeChange:EncodeStringFromDic(dic, @"car_type")];
            if (type.length > 0) {
                [dataArr addObject:type];
            }
        }
        
        if ([key isEqualToString:@"min_displacement"]) {
            // 动力型号
            NSString *energyTypeLow = EncodeStringFromDic(dic, @"min_displacement");
            NSString *energyTypeHigh = EncodeStringFromDic(dic, @"max_displacement");
            NSString *energyTypeUnit = EncodeStringFromDic(dic, @"displacement_type");
            
            if ([energyTypeLow isEqualToString:@"0"] && [energyTypeHigh isEqualToString:@"9999999"]) {
                continue;
            }
            [dataArr addObject:[NSString stringWithFormat:@"%@-%@%@",energyTypeLow,energyTypeHigh,energyTypeUnit]];
        }
        if ([key isEqualToString:@"min_driving_distance"]) {
            // 里程
            NSString *min_driving_distance = [[QLToolsManager share] unitMileage:[EncodeStringFromDic(dic, @"min_driving_distance") floatValue]];
            NSString *max_driving_distance = [[QLToolsManager share] unitMileage:[EncodeStringFromDic(dic, @"max_driving_distance") floatValue]];
            
            if ([EncodeStringFromDic(dic, @"min_driving_distance") isEqualToString:@"0"] && [EncodeStringFromDic(dic, @"max_driving_distance") isEqualToString:@"9999999"]) {
                continue;
            }
           [dataArr addObject:[NSString stringWithFormat:@"%@-%@万公里",min_driving_distance,max_driving_distance]];
        }
        // 年限
        if ([key isEqualToString:@"min_vehicle_age"]) {
            NSString *min_vehicle_age = EncodeStringFromDic(dic, @"min_vehicle_age");
            NSString *max_vehicle_age = EncodeStringFromDic(dic, @"max_vehicle_age");
            if ([min_vehicle_age isEqualToString:@"0"] && [max_vehicle_age isEqualToString:@"9999999"]) {
                continue;
            }
            [dataArr addObject:[NSString stringWithFormat:@"%@-%@年",min_vehicle_age,max_vehicle_age]];
        }
    }
    
    self.iconArr = dataArr;
}

- (NSString *)carTypeChange:(NSString *)type{
    NSString *result = @"";
//    1两厢轿车2三厢轿车3跑车4suv 5MPV 6面包车 7皮卡
    if ([type isEqualToString:@"1"]) {
        return @"两厢轿车";
    } else if ([type isEqualToString:@"2"]) {
        return @"三厢轿车";
    }else if ([type isEqualToString:@"3"]) {
        return @"跑车";
    }else if ([type isEqualToString:@"4"]) {
        return @"SUV";
    }else if ([type isEqualToString:@"5"]) {
        return @"MPV";
    }else if ([type isEqualToString:@"6"]) {
        return @"面包车";
    }else if ([type isEqualToString:@"7"]) {
        return @"皮卡";
    }
    return result;
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
