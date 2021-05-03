//
//  QLVehicleConfigCell.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/11.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLVehicleConfigCell.h"
#import "QLCollectionValueTextCell.h"

@interface QLVehicleConfigCell()<QLBaseCollectionViewDelegate>
@property (nonatomic, strong) QLBaseCollectionView *collectionView;
/** 车辆信息具体值*/
@property (nonatomic, strong) NSMutableArray *stringArray;

@property (nonatomic, strong) NSDictionary *dataDic;
@end
@implementation QLVehicleConfigCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:@"configCell"]) {
        //车配置信息
        [self addInfoView];

    }
    return self;
}

#pragma mark -- 刷新数据

- (void)updateWithDic:(NSDictionary *)dic{
    
    // 刷新过就不刷新了
    if (self.dataDic) {
        return;
    }
    
    // 刷新数据
    if (dic && [dic objectForKey:@"car_info"]) {
        self.dataDic = dic;
        NSDictionary *infoDic = [dic objectForKey:@"car_info"];
        NSDictionary *paraDic = [dic objectForKey:@"car_param"];
        // 里程数
        NSString* distance  = EncodeStringFromDic(infoDic, @"driving_distance");
        // 首次上牌 production_year
        NSString* production_year = EncodeStringFromDic(infoDic, @"production_year");
        // 档位
        NSString* transmission_case = EncodeStringFromDic(paraDic, @"transmission_case");
        // 排量
        NSString* displacement = EncodeStringFromDic(paraDic, @"displacement");
        // 排量单位
        NSString* displacement_unit = EncodeStringFromDic(paraDic,@"displacement_unit");
        // 环保标准
        NSString* emission_standard = EncodeStringFromDic(paraDic, @"emission_standard");
        // 过户次数
        NSString* transfer_times = EncodeStringFromDic(infoDic, @"transfer_times");
        // 车辆归属地
        NSString* city_belong = EncodeStringFromDic(infoDic, @"city_belong");
        // 年检到期
        NSString* mot_date = EncodeStringFromDic(infoDic, @"mot_date");
        // 强制险到期
        NSString* insure_date = EncodeStringFromDic(infoDic, @"insure_date");
        
        self.stringArray = [@[[NSString stringWithFormat:@"%@万公里",distance],production_year,[NSString stringWithFormat:@"%@/%@%@",transmission_case,displacement,displacement_unit],emission_standard,transfer_times,city_belong,mot_date,insure_date] mutableCopy];
        
        [self.collectionView reloadData];
    }
}


- (void)addInfoView {
    NSArray *titles = @[@"表显里程",@"首次上牌",@"档位 / 排量",@"环保标准",@"过户次数",@"车辆归属地",@"年检到期",@"强制险到期"];
    QLItemModel *model = [QLItemModel new];
    model.columnCount = 3;
    model.rowCount = ceil(titles.count/3.0);
    model.sectionInset = UIEdgeInsetsMake(5, 15, 5, 15);
    model.Spacing = QLMinimumSpacingMake(10, 10);
    model.registerType = CellNibRegisterType;
    model.itemName = @"QLCollectionValueTextCell";
    QLBaseCollectionView *collectionView = [[QLBaseCollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, model.rowCount*70) ItemModel:model];
    collectionView.dataArr = [NSMutableArray arrayWithArray:titles];
    collectionView.scrollEnabled = NO;
    collectionView.extendDelegate = self;
    [self.contentView addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(model.rowCount*70);
    }];
    self.collectionView = collectionView;
}

#pragma mark -collectionView
- (void)collectionView:(UICollectionView *)collectionView Item:(UICollectionViewCell *)baseCell IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    if ([baseCell isKindOfClass:[QLCollectionValueTextCell class]]) {
        QLCollectionValueTextCell *item = (QLCollectionValueTextCell *)baseCell;
        item.titleLB.font = [UIFont boldSystemFontOfSize:14];
        item.detailLB.text = dataArr[indexPath.row];
        
        if (indexPath.row < self.stringArray.count) {
            NSString *title = [NSString stringWithFormat:@"%@",self.stringArray[indexPath.row]];
            item.titleLB.text = title;
        }
        
    }
}
- (void)collectionViewSelect:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    
}

#pragma mark -- lazy
- (NSMutableArray *)stringArray {
    if (!_stringArray) {
        _stringArray = [NSMutableArray array];
    }
    return _stringArray;
}

@end
