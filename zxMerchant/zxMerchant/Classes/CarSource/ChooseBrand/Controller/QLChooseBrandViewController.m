//
//  QLChooseBrandViewController.m
//  PopularUsedCarManagement
//
//  Created by 乔磊 on 2019/1/17.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLChooseBrandViewController.h"
#import "QLListSectionIndexView.h"
#import "QLBrandCell.h"

@interface QLChooseBrandViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLListSectionIndexView *indexView;
@property (nonatomic, strong) QLBaseTableView *aTableView;
@property (nonatomic, strong) QLBaseTableView *bTableView;
@property (nonatomic, strong) QLBaseTableView *cTableView;
@property (nonatomic, strong) UIControl *bHeadView;
@property (nonatomic, strong) UIControl *cHeadView;
@property (nonatomic, strong) NSIndexPath *aIndex;
@property (nonatomic, strong) NSIndexPath *bIndex;
@property (nonatomic, strong) NSIndexPath *cIndex;
@property (nonatomic, strong) NSMutableArray *aArr;
@property (nonatomic, strong) NSMutableArray *bArr;
@property (nonatomic, strong) NSMutableArray *cArr;
@end
static const CGFloat bTableLeft = 88.f;
@implementation QLChooseBrandViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"品牌导航";
    
    //品牌tableView
    [self.view addSubview:self.aTableView];
    [self.aTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //品牌导航
    [self.view addSubview:self.indexView];
    [self.indexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(35);
        make.bottom.equalTo(self.view).offset(-65);
        make.right.equalTo(self.view).offset(-5);
        make.width.mas_equalTo(35);
    }];
    //系列tableView
    [self.view addSubview:self.bTableView];
    [self.bTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.view);
        make.left.equalTo(self.view).offset(self.view.width);
    }];
    //车型tableView
    [self.view addSubview:self.cTableView];
    [self.cTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.view);
        make.left.equalTo(self.view).offset(self.view.width);
    }];
    //列表头部
    [self addHeadControl:self.bHeadView];
    [self.view insertSubview:self.bHeadView belowSubview:self.cTableView];
    [self.bHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.bTableView);
        make.height.mas_equalTo(44);
    }];
    [self addHeadControl:self.cHeadView];
    [self.view addSubview:self.cHeadView];
    [self.cHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.cTableView);
        make.height.mas_equalTo(44);
    }];
    //获取品牌数据
    [self getCarBrand];
    
}
#pragma mark -network
//获取品牌
- (void)getCarBrand {
    [MBProgressHUD showCustomLoading:nil];
    WEAKSELF
    [QLNetworkingManager postWithUrl:BasePath params:@{@"operation_type":@"get_brand_data",@"business_id":[QLUserInfoModel getLocalInfo].account.business_id} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        self.aArr = [[NSArray yy_modelArrayWithClass:[QLBrandModel class] json:response[@"result_info"][@"brand_list"]] mutableCopy];
        //索引数据
        NSMutableArray *indexArr = [NSMutableArray array];
        for (QLBrandModel *brandModel in self.aArr) {
            [indexArr addObject:brandModel.brand_group];
        }
        self.indexView.indexArr = indexArr;
        //刷新列表
        [self.aTableView reloadData];
        if (self.brand_id.length != 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //刷新完成
                for (QLBrandModel *brand in weakSelf.aArr) {
                    for (QLBrandInfoModel *infoModel in brand.brand_list) {
                        if ([weakSelf.brand_id isEqualToString:infoModel.brand_id]) {
                            
                            NSInteger section = [weakSelf.aArr indexOfObject:brand];
                            NSInteger row = [brand.brand_list indexOfObject:infoModel];
                            weakSelf.aIndex = [NSIndexPath indexPathForRow:row inSection:section];
                            [weakSelf.aTableView selectRowAtIndexPath:weakSelf.aIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
                            if (weakSelf.series_id && weakSelf.series_id!=nil) {
                                [weakSelf openSeriesTableView];
                            }
                            
                            return;
                        }
                    }
                }
                
                
            });
        }
        
        
        
        
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
    
    
    
    
    
    //    [QLNetworkingManager postWithParams:@{@"operation_type":@"get_brand_data",@"merchant_id":QLNONull([QLUserInfoModel getLocalInfo].account.account_id)} success:^(id response) {
    //        [MBProgressHUD immediatelyRemoveHUD];
    //        self.aArr = [[NSArray yy_modelArrayWithClass:[QLBrandModel class] json:response[@"result_info"][@"brand_list"]] mutableCopy];
    //        //索引数据
    //        NSMutableArray *indexArr = [NSMutableArray array];
    //        for (QLBrandModel *brandModel in self.aArr) {
    //            [indexArr addObject:brandModel.brand_group];
    //        }
    //        self.indexView.indexArr = indexArr;
    //        //刷新列表
    //        [self.aTableView reloadData];
    //        if (self.brand_id.length != 0) {
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                //刷新完成
    //                for (QLBrandModel *brand in self.aArr) {
    //                    for (QLBrandInfoModel *infoModel in brand.brand_list) {
    //                        if ([self.brand_id isEqualToString:infoModel.brand_id]) {
    //                            NSInteger section = [self.aArr indexOfObject:brand];
    //                            NSInteger row = [brand.brand_list indexOfObject:infoModel];
    //                            self.aIndex = [NSIndexPath indexPathForRow:row inSection:section];
    //                            [self.aTableView scrollToRowAtIndexPath:self.aIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    //                            [self tableView:self.aTableView didSelectRowAtIndexPath:self.aIndex];
    //                        }
    //                    }
    //                }
    //
    //
    //            });
    //        }
    //    } fail:^(NSError *error) {
    //        [MBProgressHUD showError:error.domain];
    //    }];
    
}
- (void )openSeriesTableView{
    [self getCarSeries];
    //打开列表
    [self.bTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(bTableLeft);
    }];
}


//获取系列
- (void)getCarSeries {
    
    [MBProgressHUD showCustomLoading:nil];
    QLBrandModel *brandModel = self.aArr[self.aIndex.section];
    QLBrandInfoModel *infoModel = brandModel.brand_list[self.aIndex.row];
    [QLNetworkingManager postWithParams:@{@"operation_type":@"get_series_data",@"brand_id":infoModel.brand_id} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        self.bArr = [[NSArray yy_modelArrayWithClass:[QLSeriesModel class] json:response[@"result_info"][@"series_list"]] mutableCopy];
        QLSeriesModel *seriesModel = [[QLSeriesModel alloc]init];
        seriesModel.series_id = @"0";
        seriesModel.series_name = @"不限车系";
        [self.bArr insertObject:seriesModel atIndex:0];
        [self.bTableView reloadData];
        if (self.series_id.length != 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //刷新完成
                for (QLSeriesModel *series in self.bArr) {
                    if ([self.series_id isEqualToString:series.series_id]) {
                        NSInteger row = [self.bArr indexOfObject:series];
                        self.bIndex = [NSIndexPath indexPathForRow:row+1 inSection:0];
                        [self.bTableView selectRowAtIndexPath:self.bIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
                        
                    }else if([self.series_id isKindOfClass:[NSString class]] && [self.series_id isEqualToString:@"0"]){
                        
                        [self.bTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
                    }
                }
                
            });
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
    
}
//获取型号
- (void)getCarModel {
    [MBProgressHUD showCustomLoading:nil];
    QLSeriesModel *seriesModel = self.bArr[self.bIndex.row-1];
    [QLNetworkingManager postWithParams:@{@"operation_type":@"get_model_list",@"series_id":seriesModel.series_id} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        self.cArr = [[NSArray yy_modelArrayWithClass:[QLTypeModel class] json:response[@"result_info"][@"model_list"]] mutableCopy];
        [self.cTableView reloadData];
        if (self.model_id.length != 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //刷新完成
                for (QLTypeModel *type in self.cArr) {
                    for (QLTypeInfoModel *infoModel in type.modelList) {
                        if ([self.model_id isEqualToString:infoModel.model_id]) {
                            NSInteger section = [self.cArr indexOfObject:type];
                            NSInteger row = [type.modelList indexOfObject:infoModel];
                            self.cIndex = [NSIndexPath indexPathForRow:row inSection:section+1];
                            [self tableView:self.cTableView didSelectRowAtIndexPath:self.cIndex];
                            [self.cTableView scrollToRowAtIndexPath:self.cIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                        }
                    }
                }
                
                
            });
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
    
}
#pragma mark -action
//增加头部控件
- (void)addHeadControl:(UIControl *)control {
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"reportAcc_selected"]];
    imgView.contentMode = UIViewContentModeCenter;
    [control addSubview:imgView];
    UILabel *textLB = [UILabel new];
    textLB.font = [UIFont systemFontOfSize:15];
    textLB.text = @"收起";
    [control addSubview:textLB];
    //布局
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(control);
        make.width.equalTo(imgView.mas_height);
    }];
    [textLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(control);
        make.left.equalTo(imgView.mas_right);
    }];
    
    [control addTarget:self action:@selector(headViewClick:) forControlEvents:UIControlEventTouchUpInside];
}
//头部点击
- (void)headViewClick:(UIControl *)control {
    if (control == self.bHeadView) {
        [self tableView:self.bTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    } else {
        [self tableView:self.cTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
}
#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.aTableView) {
        return self.aArr.count;
    } else if (tableView == self.bTableView) {
        return 1;
    } else {
        return 1+self.cArr.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.aTableView) {
        QLBrandModel *brandModel = self.aArr[section];
        return brandModel.brand_list.count;
    } else if (tableView == self.bTableView) {
        //        多了收起 和 不限车系
        return 1 + self.bArr.count;
    } else {
        if (section == 0) {
            return 1;
        } else {
            QLTypeModel *typeModel = self.cArr[section-1];
            return typeModel.modelList.count;
        }
        
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLBrandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.imageView.image = nil;
    cell.textLabel.textColor = BlackColor;
    cell.backgroundColor = WhiteColor;
    cell.textLabel.numberOfLines = 2;
    //数据
    if (tableView == self.aTableView) {
        QLBrandModel *brandModel = self.aArr[indexPath.section];
        QLBrandInfoModel *infoModel = brandModel.brand_list[indexPath.row];
        cell.textLabel.text = infoModel.brand_name;
        if ([self.brand_id isEqualToString:infoModel.brand_id]) {
            self.aIndex = indexPath;
        }
        //图片
        cell.image_url = infoModel.image_url;
        //选中颜色
        if (indexPath == self.aIndex) {
            cell.textLabel.textColor = WhiteColor;
            cell.backgroundColor = GreenColor;
        }
    } else if (tableView == self.bTableView) {
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"收起";
            cell.imageView.image = [UIImage imageNamed:@"reportAcc_selected"];
            
        }else{
            
            if((indexPath.row-1)< self.bArr.count ){
                
                QLSeriesModel *seriesModel = self.bArr[indexPath.row-1];
                cell.textLabel.text = seriesModel.series_name;
                if ([self.series_id isEqualToString:seriesModel.series_id]) {
                    self.bIndex = indexPath;
                }
                //图片
                if (seriesModel.image_url.length != 0) {
                    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:seriesModel.image_url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        if (!error) {
                            cell.imageView.image = [UIImage drawWithImage:image size:CGSizeMake(35, 35)];
                        }
                    }];
                }
                //选中颜色
                if (indexPath == self.bIndex) {
                    cell.textLabel.textColor = WhiteColor;
                    cell.backgroundColor = GreenColor;
                }
            }
        }
    } else {
        if (indexPath.section == 0) {
            cell.textLabel.text = @"收起";
            cell.imageView.image = [UIImage imageNamed:@"reportAcc_selected"];
        } else {
            QLTypeModel *typeModel = self.cArr[indexPath.section-1];
            QLTypeInfoModel *infoModel = typeModel.modelList[indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",infoModel.model_desc, [[QLToolsManager share] unitConversion:infoModel.model_price.doubleValue]];
            if ([self.model_id isEqualToString:infoModel.model_id]) {
                self.cIndex = indexPath;
            }
            //选中颜色
            if (indexPath == self.cIndex) {
                cell.textLabel.textColor = WhiteColor;
                cell.backgroundColor = GreenColor;
            }
        }
        
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat space = bTableLeft;
    if (tableView == self.aTableView) {
        if (self.aIndex != indexPath) {
            self.brand_id = @"";
            self.series_id = @"";
            self.model_id = @"";
            self.aIndex = indexPath;
            self.bIndex = nil;
            self.cIndex = nil;
            [self.bArr removeAllObjects];
            [self.cArr removeAllObjects];
        }
        if (self.onlyShowBrand) {
            //返回结果
            QLBrandModel *brandModel = self.aArr[self.aIndex.section];
            QLBrandInfoModel *brandInfoModel = brandModel.brand_list[self.aIndex.row];
            self.callback(brandInfoModel, nil, nil);
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            
            [self openSeriesTableView];
            
        }
        
    } else if (tableView == self.bTableView) {
        if (indexPath.row == 0) {
            [self.bTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).offset(self.view.width);
            }];
            [self.cTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).offset(self.view.width);
            }];
            
        }
        else {
            if (self.bIndex != indexPath) {
                self.series_id = @"";
                self.model_id = @"";
                self.bIndex = indexPath;
                self.cIndex = nil;
                [self.cArr removeAllObjects];
            }
            
            if (self.noShowModel) {
                //返回结果
                QLBrandModel *brandModel = self.aArr[self.aIndex.section];
                QLBrandInfoModel *brandInfoModel = brandModel.brand_list[self.aIndex.row];
                
                if (indexPath.row == 1){
                    //系列
                    QLSeriesModel *seriesModel = [[QLSeriesModel alloc]init];
                    seriesModel.series_id = @"0";
                    seriesModel.series_name = @"不限车系";
                    self.callback(brandInfoModel, seriesModel, nil);
                }else{
                    //系列
                    QLSeriesModel *seriesModel = [[QLSeriesModel alloc]init];
                    if ((self.bIndex.row-1) < self.bArr.count) {
                        seriesModel = self.bArr[self.bIndex.row-1];
                    }
                    self.callback(brandInfoModel, seriesModel, nil);
                    
                }
                [self.navigationController popViewControllerAnimated:YES];
                
            } else {
                //获取型号数据
                [self getCarModel];
                [self.cTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view).offset(space*2);
                }];
            }
            
        }
        
    } else {
        
        if (indexPath.section == 0) {
            [self.cTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).offset(self.view.width);
            }];
        } else {
            if (self.cIndex != indexPath) {
                self.model_id = @"";
                self.cIndex = indexPath;
                
            }
            if (self.model_id.length == 0) {
                //品牌
                QLBrandModel *brandModel = self.aArr[self.aIndex.section];
                QLBrandInfoModel *brandInfoModel = brandModel.brand_list[self.aIndex.row];
                //系列
                QLSeriesModel *seriesModel = self.bArr[self.bIndex.row-1];
                //型号
                QLTypeModel *typeModel = self.cArr[self.cIndex.section-1];
                QLTypeInfoModel *typeInfoModel = typeModel.modelList[self.cIndex.row];
                //返回结果
                self.callback(brandInfoModel, seriesModel, typeInfoModel);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
    [self.aTableView reloadData];
    [self.bTableView reloadData];
    [self.cTableView reloadData];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.aTableView) {
        QLBrandModel *brandModel = self.aArr[section];
        return brandModel.brand_group;
    } else if (tableView == self.cTableView) {
        if (section != 0) {
            QLTypeModel *typeModel = self.cArr[section-1];
            return [NSString stringWithFormat:@"%@年",typeModel.model_year];
        }
        
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.aTableView) {
        return 44;
    } else if (tableView == self.bTableView) {
        return 0.01;
    } else {
        return section==0?0.01:30;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offY = scrollView.contentOffset.y;
    if (scrollView == self.bTableView) {
        [UIView animateWithDuration:0.1 animations:^{
            if (offY>=44) {
                self.bHeadView.hidden = NO;
            } else {
                self.bHeadView.hidden = YES;
            }
        }];
    } else {
        [UIView animateWithDuration:0.1 animations:^{
            if (offY>=44) {
                self.cHeadView.hidden = NO;
            } else {
                self.cHeadView.hidden = YES;
            }
        }];
        
    }
}
#pragma mark - Lazy
- (QLListSectionIndexView *)indexView {
    if (!_indexView) {
        _indexView = [[QLListSectionIndexView alloc]init];
        _indexView.defaultColor = GreenColor;
        _indexView.relevanceView = self.aTableView;
    }
    return _indexView;
}
- (QLBaseTableView *)aTableView {
    if (!_aTableView) {
        _aTableView = [[QLBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _aTableView.delegate = self;
        _aTableView.dataSource = self;
        [_aTableView registerClass:[QLBrandCell class] forCellReuseIdentifier:@"cell"];
    }
    return _aTableView;
}
- (QLBaseTableView *)bTableView {
    if (!_bTableView) {
        _bTableView = [[QLBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _bTableView.delegate = self;
        _bTableView.dataSource = self;
        [_bTableView registerClass:[QLBrandCell class] forCellReuseIdentifier:@"cell"];
    }
    return _bTableView;
}
- (QLBaseTableView *)cTableView {
    if (!_cTableView) {
        _cTableView = [[QLBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _cTableView.delegate = self;
        _cTableView.dataSource = self;
        [_cTableView registerClass:[QLBrandCell class] forCellReuseIdentifier:@"cell"];
    }
    return _cTableView;
}
- (UIControl *)bHeadView {
    if (!_bHeadView) {
        _bHeadView = [UIControl new];
        _bHeadView.backgroundColor = WhiteColor;
        _bHeadView.hidden = YES;
    }
    return _bHeadView;
}
- (UIControl *)cHeadView {
    if (!_cHeadView) {
        _cHeadView = [UIControl new];
        _cHeadView.backgroundColor = WhiteColor;
        _cHeadView.hidden = YES;
    }
    return _cHeadView;
}

- (void)dealloc
{
    QLLog(@"品牌页面dealloc");
}

@end
