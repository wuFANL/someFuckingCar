//
//  QLCityChooseViewController.m
//  luluzhuan
//
//  Created by 乔磊 on 2017/10/5.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import "QLCityChooseViewController.h"
#import "QLListSectionIndexView.h"
#import "QLCityTableViewCell.h"

@interface QLCityChooseViewController ()<UITableViewDelegate,UITableViewDataSource,QLBaseTableViewDelegate>
@property (nonatomic, strong) QLListSectionIndexView *indexView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) CLPlacemark *placemark;
@end

@implementation QLCityChooseViewController
static NSString *const reuseIdentifier = @"cityCell";
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.naviTitle;
    //城市列表数据
    [self cityListRequest];
    //tableView
    [self tableViewSet];
    //索引
    self.indexView.indexArr = @[@"A",@"B",@"C"];
    [self.view addSubview:self.indexView];
    [self.indexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(35);
        make.bottom.equalTo(self.view).offset(-65);
        make.right.equalTo(self.view).offset(-5);
        make.width.mas_equalTo(35);
    }];
    //定位
    [[QLLocationManager sharedLocationManager] updateCityWithCompletionHandler:^(CLPlacemark *placemark, CLLocation *location, NSError *error) {
        if (!error) {
            self.placemark = placemark;
            [self.tableView reloadData];
        }
    }];
}
//刷新数据按钮
- (void)centerBtnClick:(UIButton *)sender {
    //刷新城市数据
    [self cityListRequest];
}
#pragma mark - network
- (void)cityListRequest {
    [MBProgressHUD showCustomLoading:nil];
    [QLNetworkingManager postWithParams:@{@"operation_type":@"get_region_data"} success:^(id response) {
        self.dataArr = [NSArray yy_modelArrayWithClass:[QLCityListModel class] json:response[@"result_info"][@"region_list"]];
        [MBProgressHUD immediatelyRemoveHUD];
        self.tableView.showBackgroundView = NO;
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD immediatelyRemoveHUD];
        self.tableView.showBackgroundView = YES;
    }];
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    adjustsScrollViewInsets_NO(self.tableView, self);
    [self.tableView hideTableEmptyDataSeparatorLine];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.extendDelegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCityTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.showCurrentLocation?self.dataArr.count+1:self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.tag = indexPath.section;
    if (indexPath.section == 0&&self.showCurrentLocation){
        QLRegionListModel *regionModel = [QLRegionListModel new];
        regionModel.group_name = @"当前定位";
        NSString *regionName = [self.placemark.addressDictionary[@"City"] stringByReplacingOccurrencesOfString:@"市" withString:@""];
        regionModel.region_name = regionName.length==0?@"定位":regionName;
        QLCityListModel *model = [QLCityListModel new];
        model.group_name = regionModel.group_name;
        model.region_list = @[regionModel];
        cell.model = model;
    } else {
        cell.model = self.dataArr[(self.showCurrentLocation?indexPath.section-1:indexPath.section)];
        
    }
    cell.selectedBlock = ^(NSInteger section, NSInteger row) {
        if (section == 0&&row==0&&self.showCurrentLocation) {
            self.refreshBlock(YES, [self.placemark.addressDictionary[@"City"] stringByReplacingOccurrencesOfString:@"市" withString:@""],nil);
        } else {
            QLCityListModel *model = self.dataArr[(self.showCurrentLocation?section-1:section)];
            QLRegionListModel *regionModel = model.region_list[row];
            self.refreshBlock(YES, regionModel.region_name,regionModel);
        }
        [self.navigationController popViewControllerAnimated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger line = 0;
    if (indexPath.section == 0&&self.showCurrentLocation) {
        line = 1;
    } else {
        QLCityListModel *model = self.dataArr[(self.showCurrentLocation?indexPath.section-1:indexPath.section)];
        line = (model.region_list.count/3+(model.region_list.count%3==0?0:1));
    }
    CGFloat height = line*40+(line+1)*10+25;
    return height;
}
#pragma mark - Lazy
- (QLListSectionIndexView *)indexView {
    if (!_indexView) {
        _indexView = [[QLListSectionIndexView alloc]init];
        _indexView.defaultColor = GreenColor;
        _indexView.relevanceView = self.tableView;
    }
    return _indexView;
}
- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}
@end
