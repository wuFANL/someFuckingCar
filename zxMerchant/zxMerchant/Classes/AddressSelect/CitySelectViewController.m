//
//  CitySelectViewController.m
//  zxMerchant
//
//  Created by 张精申 on 2021/6/4.
//  Copyright © 2021 ql. All rights reserved.
//

#import "CitySelectViewController.h"
#import "SelectCityCollectionViewCell.h"
#import "QLCarSourceNaviView.h"
#import "SelectCityHeader.h"
#import "QLNavigationController.h"

@interface CitySelectViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
/** 城市数据源*/
@property (nonatomic, strong) NSMutableArray *cityData;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) QLCarSourceNaviView *naviView;
@end

@implementation CitySelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择城市";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 请求城市数据
    WEAKSELF
    [QLNetworkingManager postWithUrl:HomePath params:@{
        Operation_type:@"all_open_region",
        @"account_id":[QLUserInfoModel getLocalInfo].account.account_id
    } success:^(id response) {
        NSDictionary *result_info = [response objectForKey:@"result_info"];
        if ([result_info isKindOfClass:[NSDictionary class]]) {
            NSArray *dataArr = [result_info objectForKey:@"region_list"];
            if ([dataArr isKindOfClass:[NSArray class]]) {
                weakSelf.cityData = [dataArr mutableCopy];
            }
            
            [weakSelf.collectionView reloadData];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
    
    //导航栏
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(44+(BottomOffset?44:20));
    }];
    
    [self.view addSubview:self.collectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDictionary *cityDic = self.cityData[section];
    NSArray* region_list = [cityDic objectForKey:@"region_list"];
    if ([region_list isKindOfClass:[NSArray class]]) {
        return region_list.count;
    }
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectCityCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SelectCityCollectionViewCell class]) forIndexPath:indexPath];
    NSDictionary *cityDataDic = self.cityData[indexPath.section];
    NSArray *array = [cityDataDic objectForKey:@"region_list"];
    if ([array isKindOfClass:[NSArray class]]) {
        if (array.count >= indexPath.row) {
            NSDictionary * dic = [array objectAtIndex:indexPath.row];
            cell.titleLabel.text = EncodeStringFromDic(dic, @"region_name");
        }
    }
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.cityData.count;
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        SelectCityHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        header.titleLabel.text = EncodeStringFromDic(self.cityData[indexPath.section], @"region_name");
        return header;
    }
    return nil;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cityDataDic = self.cityData[indexPath.section];
    NSArray *array = [cityDataDic objectForKey:@"region_list"];
    if ([array isKindOfClass:[NSArray class]] && self.selectBlock) {
        self.selectBlock(cityDataDic, array[indexPath.row], EncodeStringFromDic(array[indexPath.row], @"adcode"));
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- lazy
- (NSMutableArray *)cityData {
    if (!_cityData) {
        _cityData = [NSMutableArray array];
    }
    return _cityData;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
       
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = [SelectCityCollectionViewCell selfSize];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 8;
        layout.headerReferenceSize = CGSizeMake(ScreenWidth, 50);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[SelectCityHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        [_collectionView registerClass:[SelectCityCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([SelectCityCollectionViewCell class])];
    }
    return _collectionView;
}
@end
