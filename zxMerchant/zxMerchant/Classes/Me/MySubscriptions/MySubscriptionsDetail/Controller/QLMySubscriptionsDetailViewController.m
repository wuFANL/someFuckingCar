//
//  QLMySubscriptionsDetailViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2021/2/28.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLMySubscriptionsDetailViewController.h"
#import "QLMySubDetailTitleCell.h"
#import "QLHomeCarCell.h"

@interface QLMySubscriptionsDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 数据源*/
@property (nonatomic, strong) NSDictionary *dataDic;
@end

@implementation QLMySubscriptionsDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航
    [self setNavi];
    //tableView
    [self tableViewSet];
}

// 更新
- (void)updateWithDic:(NSDictionary *)dic {
    self.dataDic = dic;
}

#pragma mark - navigation
- (void)editItemClick {
    
}

- (void)deleteItemClick {
    
}

//设置导航
- (void)setNavi {
    self.navigationItem.title = @"订阅详情";
    //右导航按钮
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"delete_green"] originalImage] style:UIBarButtonItemStyleDone target:self action:@selector(deleteItemClick)];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"editIcon"] originalImage] style:UIBarButtonItemStyleDone target:self action:@selector(editItemClick)];
    self.navigationItem.rightBarButtonItems = @[deleteItem,editItem];
}

#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLHomeCarCell" bundle:nil] forCellReuseIdentifier:@"hCarCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLMySubDetailTitleCell" bundle:nil] forCellReuseIdentifier:@"mySubDetailTitleCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *tempArr = [self.dataDic objectForKey:@"car_list"];
    return section==0?1:tempArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QLMySubDetailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mySubDetailTitleCell" forIndexPath:indexPath];
        // 更新标签
        NSMutableArray *dataArr = [NSMutableArray array];
        NSDictionary * dic = self.dataDic;
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
        // 获取所有标签
        cell.iconArr = dataArr;
        [cell updateTimeWithString:EncodeStringFromDic(dic, @"create_time")];
        return cell;
    } else {
        QLHomeCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hCarCell" forIndexPath:indexPath];
        cell.lineView.hidden = NO;
        NSArray *tempArr = [self.dataDic objectForKey:@"car_list"];
        if ([tempArr isKindOfClass:[NSArray class]]) {
            [cell updateUIWithDic:tempArr[indexPath.row]];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *header = [UIView new];
        
        UILabel *lb = [UILabel new];
        lb.font = [UIFont systemFontOfSize:12];
        lb.textColor = [UIColor darkGrayColor];
        NSArray *tempArr = [self.dataDic objectForKey:@"car_list"];
        lb.text = [NSString stringWithFormat:@"匹配到%lu辆车",(unsigned long)tempArr.count];//@"";
        [header addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header).offset(15);
            make.centerY.equalTo(header);
        }];
        
        return header;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==0?0.01:36;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

@end
