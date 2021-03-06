//
//  QLAddCarPageViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2021/4/23.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLAddCarPageViewController.h"
#import "QLAddCarBottomView.h"
#import "QLReleaseImagesCell.h"
#import "QLSubmitTextCell.h"
#import "QLChooseBrandViewController.h"
#import <BRStringPickerView.h>
#import <BRDatePickerView.h>
#import "VinCodeIdenfitViewController.h"
#import "QLAddCarPopWIndow.h"
#import "QLMyCarDetailViewController.h"
#import "QLFullScreenImgView.h"
#import "QLPicturesDetailViewController.h"
#import "QLAddCarPageModel.h"
@interface QLAddCarPageViewController ()<UITableViewDelegate,UITableViewDataSource,QLReleaseImagesCellDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) QLAddCarBottomView *bottomView;
// 车辆图片
@property (nonatomic, strong) NSMutableArray *imgsArr;
// 车辆牌证
@property (nonatomic, strong) NSMutableArray *imgsArr1;

/** 选中的*/
@property (nonatomic, strong) QLBrandInfoModel *brandModel;
@property (nonatomic, strong) QLSeriesModel *seriesModel;
@property (nonatomic, strong) QLTypeInfoModel *typeInfoModel;

@property (nonatomic, strong) UIPickerView *pickerView;
/** 品牌文字*/
@property (nonatomic, strong) UITextView *brandTextView;
/** 首次上牌时间*/
@property (nonatomic, strong) UITextView *first;

/** 变速箱*/
@property (nonatomic, strong) NSArray *speedBox;
@property (nonatomic, strong) NSArray *colorBox;
@property (nonatomic, strong) NSArray *typeBox;
@property (nonatomic, strong) NSArray *enviBox;



#pragma mark -- 输入结果
//VIN
@property (nonatomic, strong) NSString *value1;
// 品牌/车系
@property (nonatomic, strong) NSString *value2;
// 首次上牌时间
@property (nonatomic, strong) NSString *value3;
// 里程
@property (nonatomic, strong) NSString *value4;
// 在线标价
@property (nonatomic, strong) NSString *value5;
@property (nonatomic, strong) NSString *value6;
@property (nonatomic, strong) NSString *value7;
@property (nonatomic, strong) NSString *value8;
@property (nonatomic, strong) NSString *value9;

// 选中的自定义pick
@property (nonatomic, strong) NSArray<BRResultModel *> * _Nullable resultModelArr;
@property (nonatomic, strong) NSString *value10;

// 排量
@property (nonatomic, strong) NSString *value11;
// 年检到期
@property (nonatomic, strong) NSString *value12;
// 强制险到期
@property (nonatomic, strong) NSString *value13;
//销售归属人
@property (nonatomic, strong ) NSString  *value14;
//销售归属人数据模型
@property (nonatomic, strong ) QLAddCarPageModel  *carPageModel;
// 归属人
@property (nonatomic, strong) NSDictionary *belongDic;

@property (nonatomic, strong) NSDictionary *sourceDic;
@property (nonatomic, assign) BOOL isEditModule;

// 车辆图片url
@property (nonatomic, strong) NSMutableArray *imgsUrlArr;
// 车辆牌证url
@property (nonatomic, strong) NSMutableArray *imgsUrlArr1;
@end

@implementation QLAddCarPageViewController

-(id)initWithEditMoudle:(NSDictionary *)dic carImageAr:(NSArray *)carAr personPicAr:(NSArray *)personAr {
    self = [super init];
    if (self) {
        self.isEditModule = YES;
        self.sourceDic = [dic copy];
        self.imgsUrlArr = [[NSMutableArray alloc] initWithCapacity:0];
        [self.imgsUrlArr addObjectsFromArray:carAr];
        self.imgsUrlArr1 = [[NSMutableArray alloc] initWithCapacity:0];
        [self.imgsUrlArr1 addObjectsFromArray:personAr];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.isEditModule)
    {
        self.navigationItem.title = @"编辑车辆";
        [self setUpOldData];
    }
    else
    {
        self.navigationItem.title = @"新增车辆";
        // 获取本地缓存数据
        [self setUpLocalData];
    }
    //底部
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-34);
        make.height.mas_equalTo(50);
    }];
    //tableView
    [self tableViewSet];
    [self prepareData];
    [self requestBelongData];
}

- (void)prepareData {
    self.speedBox = @[@"自动",@"手动"];
    self.colorBox = @[@"银灰色",@"深灰色",@"黑色",@"白色",@"红色",@"蓝色",@"咖啡色",@"香槟色",@"黄色",@"紫色",@"绿色",@"橙色",@"粉红色",@"彩色"];
    self.typeBox = @[@"两厢",@"三厢",@"跑车",@"SUV",@"MPV",@"面包车",@"皮卡"];
    self.enviBox = @[@"国六",@"国五",@"国四",@"国三"];
}


/// 匹配接口数据  销售归属人占存
- (void )requestBelongData{
    
    NSDictionary * para = @{
        @"operation_type":@"personnel_list",
        @"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id
    };
    WEAKSELF
    [self.carPageModel queryData:para complet:^(BOOL result) {
        if (result) {
            [weakSelf matchBelongData];
        }
    }];
}
- (void )matchBelongData{
    
    // 选中了销售归属人
    NSIndexPath *indePath = [NSIndexPath indexPathForRow:13 inSection:1];
    if ([self.value14 isKindOfClass:[NSString class]] && ![self.value14 isEqualToString:@""]) {
        
    NSInteger index = [self.carPageModel.nameArr indexOfObject:self.value14];
        if (index<self.carPageModel.belongArr.count) {
            self.belongDic = self.carPageModel.belongArr[index];
            QLSubmitTextCell *cell = [self.tableView cellForRowAtIndexPath:indePath];
            cell.textView.text = self.value14;
            self.belongDic = self.carPageModel.belongArr[index];
        }
    }
}

- (void)setUpLocalData {
    NSDictionary *localData = [[NSUserDefaults standardUserDefaults] objectForKey:@"QLAddCarTempData"];
    self.value1 = EncodeStringFromDic(localData, @"value1");
    self.value2 = EncodeStringFromDic(localData, @"value2");
    self.value3 = EncodeStringFromDic(localData, @"value3");
    self.value4 = EncodeStringFromDic(localData, @"value4");
    self.value5 = EncodeStringFromDic(localData, @"value5");
    self.value6 = EncodeStringFromDic(localData, @"value6");
    self.value7 = EncodeStringFromDic(localData, @"value7");
    self.value8 = EncodeStringFromDic(localData, @"value8");
    self.value9 = EncodeStringFromDic(localData, @"value9");
    self.value10 = EncodeStringFromDic(localData, @"value10");
    self.value11 = EncodeStringFromDic(localData, @"value11");
    self.value12 = EncodeStringFromDic(localData, @"value12");
    self.value13 = EncodeStringFromDic(localData, @"value13");
    self.value14 = EncodeStringFromDic(localData, @"value14");
    NSArray* temp1 = [localData objectForKey:@"imagArr1"];
    NSArray* temp2 = [localData objectForKey:@"imagArr2"];
   
    if ([temp1 isKindOfClass:[NSArray class]]) {
        for (NSData *imageData in temp1) {
            [self.imgsArr addObject:[UIImage imageWithData:imageData]];
        }
    }
    
    if ([temp2 isKindOfClass:[NSArray class]]) {
        for (NSData *imageData in temp2) {
            [self.imgsArr1 addObject:[UIImage imageWithData:imageData]];
        }
    }
}

-(void)setUpOldData
{
    self.value1 = [[self.sourceDic objectForKey:@"car_info"] objectForKey:@"vin_code"];
    
    self.brandModel = [[QLBrandInfoModel alloc] init];
    self.brandModel.brand_id = [[self.sourceDic objectForKey:@"car_info"] objectForKey:@"brand_id"];
    self.brandModel.brand_name =[[self.sourceDic objectForKey:@"car_info"] objectForKey:@"brand"];
    self.seriesModel = [[QLSeriesModel alloc] init];
    self.seriesModel.series_id = [[self.sourceDic objectForKey:@"car_info"] objectForKey:@"series_id"];
    self.seriesModel.series_name = [[self.sourceDic objectForKey:@"car_info"] objectForKey:@"series"];
    
    self.value3 = [[self.sourceDic objectForKey:@"car_info"] objectForKey:@"production_year"];
    self.value4 = [[[self.sourceDic objectForKey:@"car_info"] objectForKey:@"driving_distance"] stringValue];
    self.value5 = [[[self.sourceDic objectForKey:@"car_info"] objectForKey:@"sell_price"] stringValue];
    self.value6 = [[[self.sourceDic objectForKey:@"car_info"] objectForKey:@"sell_min_price"] stringValue];
    self.value7 = [[[self.sourceDic objectForKey:@"car_info"] objectForKey:@"wholesale_price"] stringValue];
    self.value8 = [[[self.sourceDic objectForKey:@"car_info"] objectForKey:@"procure_price"] stringValue];
    self.value9 = [[[self.sourceDic objectForKey:@"car_info"] objectForKey:@"transfer_times"] stringValue];
    self.value10 = [NSString stringWithFormat:@"%@/%@/%@/%@",
                   [[self.sourceDic objectForKey:@"car_param"] objectForKey:@"transmission_case"],
                   [[self.sourceDic objectForKey:@"car_param"] objectForKey:@"body_color"],
                   [self getCarMsg:[[self.sourceDic objectForKey:@"car_param"] objectForKey:@"car_type"]],
                   [[self.sourceDic objectForKey:@"car_param"] objectForKey:@"emission_standard"]];
    self.value11 = [NSString stringWithFormat:@"%@%@",[[self.sourceDic objectForKey:@"car_param"] objectForKey:@"displacement"],[[self.sourceDic objectForKey:@"car_param"] objectForKey:@"displacement_unit"]];
    self.value12 = [[self.sourceDic objectForKey:@"car_info"] objectForKey:@"mot_date"];
    self.value13 = [[self.sourceDic objectForKey:@"car_info"] objectForKey:@"insure_date"];
    self.belongDic = @{@"personnel_nickname":[[self.sourceDic objectForKey:@"car_info"] objectForKey:@"seller_name"]};
    
    if ([self.imgsUrlArr count] > 0) {
        __block NSMutableArray *tem1 = [[NSMutableArray alloc] initWithCapacity:0];
        __block NSInteger num = 0;
        for (NSDictionary *imageUrlDic in self.imgsUrlArr) {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[imageUrlDic objectForKey:@"pic_url"]] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                [tem1 addObject:image];
                num = num + 1;
                if(num == [self.imgsUrlArr count])
                {
                    [self.imgsArr addObjectsFromArray:tem1];
                    [UIView performWithoutAnimation:^{
                            NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:0];
                            [self.tableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
                    }];
                }

            }];
        }
    }
    
    if ([self.imgsUrlArr1 count] > 0) {
        __block NSMutableArray *tem1 = [[NSMutableArray alloc] initWithCapacity:0];
        __block NSInteger num = 0;
        for (NSDictionary *imageUrlDic in self.imgsUrlArr1) {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[imageUrlDic objectForKey:@"pic_url"]] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                [tem1 addObject:image];
                num = num + 1;
                if(num == [self.imgsUrlArr1 count])
                {
                    [self.imgsArr1 addObjectsFromArray:tem1];
                    [UIView performWithoutAnimation:^{
                            NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:2];
                            [self.tableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
                    }];
                }

            }];
        }
    }
}

-(NSString *)getCarMsg:(NSString *)carIndex
{
    switch ([carIndex intValue]) {
        case 1:
        {
            return @"两厢";
        }
            break;
        case 2:
        {
            return @"三厢";
        }
            break;
        case 3:
        {
            return @"跑车";
        }
            break;
        case 4:
        {
            return @"suv";
        }
            break;
        case 5:
        {
            return @"MPV";
        }
            break;
        case 6:
        {
            return @"面包车";
        }
            break;
        case 7:
        {
            return @"皮卡";
        }
            break;
            
        default:
            return @"";
            break;
    }
}

#pragma mark - action
//图片变化
- (void)imgChange:(NSMutableArray *)images isCarPic:(BOOL)iscar{
    [self.tableView beginUpdates];
    
    if (iscar) {
        self.imgsArr = images;
    } else {
        self.imgsArr1 = images;
    }
    
    [self.tableView endUpdates];
}
//图片点击
- (void)imgClick:(NSInteger)index {
    QLPicturesDetailViewController *pdVC = [QLPicturesDetailViewController new];
    pdVC.showDeleteItem = YES;
    pdVC.imgsArr = self.imgsArr;
    pdVC.intoIndex = index;
    [self.navigationController pushViewController:pdVC animated:YES];
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.backgroundColor = WhiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[QLReleaseImagesCell class] forCellReuseIdentifier:@"imgCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLSubmitTextCell" bundle:nil] forCellReuseIdentifier:@"textCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 1?14:1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        QLSubmitTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        cell.lineView.hidden = NO;
        cell.titleLB.textColor = [UIColor darkTextColor];
        cell.textView.placeholderLB.textColor = [UIColor lightGrayColor];
        cell.textView.userInteractionEnabled = YES;
        cell.actionBtn.hidden = YES;
        cell.unitLB.hidden = YES;
        cell.textView.tag = 999 + indexPath.row;
        cell.textView.delegate = self;
        cell.textView.keyboardType = UIKeyboardTypeDefault;
        cell.titleWidth.constant = 100;
        switch (indexPath.row) {
            case 0:{
                if (self.value1.length > 0) {
                    cell.titleLB.text = [NSString stringWithFormat:@"VIN码(%lu/17)",(unsigned long)self.value1.length];
                    cell.textView.placeholder = @"";
                    cell.textView.text = self.value1;
                } else {
                    cell.titleLB.text = @"VIN码(0/17)";
                    cell.textView.placeholder = @"输入或右边的扫一扫";
                    cell.textView.text = @"";
                }
                
                cell.actionBtn.hidden = NO;
                [cell.actionBtn setImage:[UIImage imageNamed:@"carScan"] forState:UIControlStateNormal];
                [cell.actionBtn addTarget:self action:@selector(scanImg)
                         forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case 1:{
                cell.titleLB.text = @"品牌/车系";
                if (self.brandModel) {
                    NSString *carName = [NSString stringWithFormat:@"%@%@",self.brandModel.brand_name,self.seriesModel.series_name];
                    cell.textView.text = carName;
                } else {
                    cell.textView.placeholder = @"点击调取品牌车系车型";
                    cell.textView.text = @"";
                }
                cell.textView.userInteractionEnabled = NO;
                self.brandTextView = cell.textView;
            }
                break;
            case 2:{
                cell.titleLB.text = @"首次上牌";
                if (self.value3.length > 0) {
                    cell.textView.placeholder = @"";
                    cell.textView.text = self.value3;
                } else {
                    cell.textView.placeholderLB.textColor = OrangeColor;
                    cell.textView.placeholder = @"必选";
                    cell.textView.text = @"";
                }
                
                cell.textView.userInteractionEnabled = NO;
                self.first = cell.textView;
            }
                break;
            case 3:{
                
                if (self.value4.length > 0) {
                    cell.textView.placeholder = @"";
                    cell.textView.text = self.value4;
                } else {
                    cell.textView.placeholder = @"0.01~100之间的数字";
                    cell.textView.text = @"";
                }
                cell.titleLB.text = @"表显里程";
                cell.unitLB.text = @"万公里";
                cell.unitLB.hidden = NO;
                cell.textView.keyboardType = UIKeyboardTypeDecimalPad;
            }
                break;
            case 4:{
                
                if (self.value5.length > 0) {
                    cell.textView.placeholder = @"";
                    cell.textView.text = self.value5;
                } else {
                    cell.textView.placeholderLB.textColor = OrangeColor;
                    cell.textView.placeholder = @"必填";
                    cell.textView.text = @"";
                }
                cell.titleLB.text = @"在线标价";
               
                cell.unitLB.text = @"万元";
                cell.unitLB.hidden = NO;
                cell.textView.keyboardType = UIKeyboardTypeDecimalPad;
            }
                break;
            case 5:{
                if (self.value6.length > 0) {
                    cell.textView.placeholder = @"";
                    cell.textView.text = self.value6;
                } else {
                    cell.textView.placeholder = @"非必填";
                    cell.textView.text = @"";
                }
                
                cell.titleLB.text = @"销售低价";
                cell.unitLB.text = @"万元";
                cell.unitLB.hidden = NO;
                cell.textView.keyboardType = UIKeyboardTypeDecimalPad;
            }
                break;
            case 6:{
                if (self.value7.length > 0) {
                    cell.textView.placeholder = @"";
                    cell.textView.text = self.value7;
                } else {
                    cell.textView.placeholderLB.textColor = OrangeColor;
                    cell.textView.placeholder = @"必填";
                    cell.textView.text = @"";
                }
                cell.titleLB.text = @"批发价";
                
                cell.unitLB.text = @"万元";
                cell.unitLB.hidden = NO;
                cell.textView.keyboardType = UIKeyboardTypeDecimalPad;
            }
                break;
            case 7:{
                if (self.value8.length > 0) {
                    cell.textView.placeholder = @"";
                    cell.textView.text = self.value8;
                } else {
                    cell.textView.placeholderLB.textColor = OrangeColor;
                    cell.textView.placeholder = @"必填";
                    cell.textView.text = @"";
                }
                cell.titleLB.text = @"采购价";
                cell.unitLB.text = @"万元";
                cell.unitLB.hidden = NO;
                cell.textView.keyboardType = UIKeyboardTypeDecimalPad;
            }
                break;
            case 8:{
                
                if (self.value9.length > 0) {
                    cell.textView.placeholder = @"";
                    cell.textView.text = self.value9;
                } else {
                    cell.textView.text = @"";
                    cell.textView.placeholder = @"非必填";
                }
                
                cell.titleLB.text = @"过户次数";
                cell.unitLB.text = @"次";
                cell.unitLB.hidden = NO;
                cell.textView.keyboardType = UIKeyboardTypeNumberPad;
            }
                break;
            case 9:{
                
                if (self.value10.length > 0) {
                    cell.titleLB.text = self.value10;
                } else {
                    cell.titleLB.text = @"变速箱/车身颜色/车辆类型/环保标准";
                }
                
                cell.textView.userInteractionEnabled = NO;
                cell.textView.text = @"";
                cell.textView.placeholder = @"";
                cell.titleWidth.constant = 250;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 10:{
                if (self.value11.length > 0) {
                    cell.textView.placeholder = @"";
                    cell.textView.text = self.value11;
                } else {
                    cell.textView.placeholder = @"非必选";
                    cell.textView.text = @"";
                }
                cell.textView.userInteractionEnabled = NO;
                cell.titleLB.text = @"排量";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 11:{
                
                
                if (self.value12.length > 0) {
                    cell.textView.text = self.value12;
                    cell.textView.placeholder = @"";
                } else {
                    cell.textView.placeholder = @"非必选";
                    cell.textView.text = @"";
                }
                
                cell.titleLB.text = @"年检到期";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textView.userInteractionEnabled = NO;
            }
                break;
            case 12:{
                
                if (self.value13.length > 0) {
                    cell.textView.text = self.value13;
                    cell.textView.placeholder = @"";
                } else {
                    cell.textView.placeholder = @"非必选";
                    cell.textView.text = @"";
                }
                cell.titleLB.text = @"强制险到期";
                cell.textView.userInteractionEnabled = NO;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            default:
                
                if (self.belongDic) {
                    cell.textView.text = EncodeStringFromDic(self.belongDic, @"personnel_nickname");
                    cell.textView.placeholder = @"";
                } else {
                    cell.textView.placeholderLB.textColor = OrangeColor;
                    cell.textView.placeholder = @"必选";
                    cell.textView.text = @"";
                }
                
                cell.titleLB.text = @"销售归属人";
               
                cell.textView.userInteractionEnabled = NO;
                break;
        }
        
        return cell;
    } else if (indexPath.section == 0) {
        // 车辆图片
        QLReleaseImagesCell *cell = [[QLReleaseImagesCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"imgCell"];
        QLItemModel *model = [QLItemModel new];
        model.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        model.Spacing = QLMinimumSpacingMake(5, 5);
        model.registerType = CellNibRegisterType;
        model.itemName = @"QLImageItem";
        CGFloat itemWidth = (ScreenWidth-16*2-5*3)/4;
        model.itemSize = CGSizeMake(itemWidth, itemWidth);
        cell.listStyleModel = model;
        cell.canMultipleChoice = YES;
        cell.maxImgCount = 30;
        cell.isCarPic = YES;
        cell.setImgArr = self.imgsArr;
        cell.delegate = self;
        
        return cell;
    } else {
        // 车辆牌证
        QLReleaseImagesCell *cell = [[QLReleaseImagesCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"imgCell"];
        QLItemModel *model = [QLItemModel new];
        model.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        model.Spacing = QLMinimumSpacingMake(5, 5);
        model.registerType = CellNibRegisterType;
        model.itemName = @"QLImageItem";
        CGFloat itemWidth = (ScreenWidth-16*2-5*3)/4;
        model.itemSize = CGSizeMake(itemWidth, itemWidth);
        cell.listStyleModel = model;
        cell.canMultipleChoice = YES;
        cell.maxImgCount = 30;
        cell.isCarPic = NO;
        cell.setImgArr = self.imgsArr1;
        cell.delegate = self;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 1) {
        // 去品牌页
        WEAKSELF
        QLChooseBrandViewController *vc = [QLChooseBrandViewController new];
        vc.callback = ^(QLBrandInfoModel * _Nullable brandModel, QLSeriesModel * _Nullable seriesModel, QLTypeInfoModel * _Nullable typeModel) {
            NSString *carName = [NSString stringWithFormat:@"%@%@",brandModel.brand_name,seriesModel.series_name];
            // vc记录
            weakSelf.brandModel = brandModel;
            weakSelf.seriesModel = seriesModel;
            weakSelf.typeInfoModel = typeModel;
            // 更新文字
            weakSelf.brandTextView.text = carName;
            weakSelf.value2 = carName;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
   else if (indexPath.section == 1 && indexPath.row == 2) {
        // 首次上牌
       WEAKSELF
       [BRDatePickerView showDatePickerWithMode:BRDatePickerModeDate title:@"" selectValue:nil resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
           QLSubmitTextCell *cell = [tableView cellForRowAtIndexPath:indexPath];
           cell.textView.text = selectValue;
           weakSelf.value3 = selectValue;
       }];
    }
   else if (indexPath.section == 1 && indexPath.row == 9) {
       // 变速箱啥的
       WEAKSELF
       [BRStringPickerView showMultiPickerWithTitle:@"" dataSourceArr:@[self.speedBox,self.colorBox,self.typeBox,self.enviBox] selectIndexs:@[@(0),@(0),@(0),@(0)] resultBlock:^(NSArray<BRResultModel *> * _Nullable resultModelArr) {
           //
           QLSubmitTextCell *cell = [tableView cellForRowAtIndexPath:indexPath];
           NSString *resultString = @"";
           for (BRResultModel *model in resultModelArr) {
               resultString = [resultString stringByAppendingString:[NSString stringWithFormat:@"%@/",model.value]];
           }
           if ([resultString hasSuffix:@"/"]) {
               resultString = [resultString substringToIndex:resultString.length - 1];
           }
           cell.titleLB.text = resultString;
           weakSelf.resultModelArr = resultModelArr;
           weakSelf.value10 = resultString;
       }];
   }
   else if (indexPath.section == 1 && indexPath.row == 12) {
       WEAKSELF
       // 强制险到期
       [BRDatePickerView showDatePickerWithMode:BRDatePickerModeDate title:@"" selectValue:nil resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
           QLSubmitTextCell *cell = [tableView cellForRowAtIndexPath:indexPath];
           cell.textView.text = selectValue;
           weakSelf.value13 = selectValue;
       }];
   }
   else if (indexPath.section == 1 && indexPath.row == 11) {
       // 年检到期
       WEAKSELF
       [BRDatePickerView showDatePickerWithMode:BRDatePickerModeDate title:@"" selectValue:nil resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
           QLSubmitTextCell *cell = [tableView cellForRowAtIndexPath:indexPath];
           cell.textView.text = selectValue;
           weakSelf.value12 = selectValue;
       }];
   }
   else if (indexPath.section == 1 && indexPath.row == 13) {
       // 销售归属人
       NSDictionary * para = @{
           @"operation_type":@"personnel_list",
           @"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id
       };
       WEAKSELF
       [self.carPageModel queryData:para complet:^(BOOL result) {
           if (result) {
               [BRStringPickerView showPickerWithTitle:@"选择销售归属人" dataSourceArr:weakSelf.carPageModel.nameArr selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
                  // 选中了销售归属人
                   QLSubmitTextCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                   cell.textView.text = resultModel.value;
                   weakSelf.value14 = resultModel.value;
                   weakSelf.belongDic = weakSelf.carPageModel.belongArr[resultModel.index];
               }];
           }
       }];
   } else if (indexPath.section == 1 && indexPath.row == 10) {
       WEAKSELF
       NSArray *list1 = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
       NSArray *list2 = @[@".0",@".1",@".2",@".3",@".4",@".5",@".6",@".7",@".8",@".9"];
       NSArray *list3 = @[@"L",@"T"];
       
       NSInteger index1 = [list1 indexOfObject:self.carPageModel.displacement1];
       NSInteger index2 = [list2 indexOfObject:self.carPageModel.displacement2];
       NSInteger index3 = [list3 indexOfObject:self.carPageModel.displacement3];
       
       [BRStringPickerView showMultiPickerWithTitle:@"" dataSourceArr:@[list1,list2,list3] selectIndexs:@[@(index1),@(index2),@(index3),@(0)] resultBlock:^(NSArray<BRResultModel *> * _Nullable resultModelArr) {
           
           QLSubmitTextCell *cell = [tableView cellForRowAtIndexPath:indexPath];
           NSString *resultString = @"";
           int index = 0;
           for (BRResultModel *model in resultModelArr) {
               resultString = [resultString stringByAppendingString:model.value];
               
               switch (index) {
                   case 0:
                   {
                       self.carPageModel.displacement1 = model.value;
                   }
                       break;
                   case 1:
                   {
                       self.carPageModel.displacement2 = model.value;
                   }
                       break;
                   case 2:
                   {
                       self.carPageModel.displacement3 = model.value;
                   }
                       break;
                       
                   default:
                       break;
               }
               
               index++;
           }
           
           cell.textView.text = resultString;
           weakSelf.value11 = resultString;
       }];
   }
    
}
// 首次上牌时间
- (void)datePickerValueChanged:(UIDatePicker *)sender {
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    NSDate *date = datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *string = [dateFormatter stringFromDate:date];
    if (sender.tag == (999 + 1)) {
        self.first.text = string;
    }
    [sender removeFromSuperview];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = section==1 ? ClearColor : WhiteColor;
    
    UILabel *lb = [UILabel new];
    if (section == 1) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"第一张默认为封面图,封面图要外观左前45度" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13],NSForegroundColorAttributeName: [UIColor colorWithRed:34/255.0 green:172/255.0 blue:56/255.0 alpha:1.0]}];
        
        lb.attributedText = string;
    } else {
        NSString *title = @"";
        NSString *nameStr = @"";
        NSString *accStr = @"";
        if (section == 0) {
            nameStr = @"车辆图片";
            accStr = @"(长按图片拖动排序)";
        } else if (section == 2) {
            nameStr = @"车辆牌证";
            accStr = @"(行驶证、登记证、车辆铭牌等至少一张)";
        }
        title = [NSString stringWithFormat:@"%@%@",nameStr,accStr];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
        
        [string addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 15]} range:[title rangeOfString:nameStr]];
        
        [string addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]} range:[title rangeOfString:accStr]];
        
        lb.attributedText = string;
    }
    
    [headerView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.left.equalTo(headerView).offset(16);
    }];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark --pick
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return self.speedBox.count;
            break;
        case 1:
            return self.colorBox.count;
            break;
        case 2:
            return self.typeBox.count;
            break;
        default:
            return self.enviBox.count;
            break;
    }
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            return [[NSAttributedString alloc]initWithString:self.speedBox[row]];
        }
            break;
        case 1:
        {
            return [[NSAttributedString alloc]initWithString:self.colorBox[row]];
        }
            break;
        case 2:
        {
            return [[NSAttributedString alloc]initWithString:self.typeBox[row]];
        }
            
            break;
        default:
        {
            return [[NSAttributedString alloc]initWithString:self.enviBox[row]];
        }
            break;
    }
}


- (void)textViewDidChange:(UITextView *)textView {
    
    switch (textView.tag - 999) {
        case 0:
        {
            if (textView.text.length > 17) {
                return;
            }
            QLSubmitTextCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            cell.titleLB.text = [NSString stringWithFormat:@"VIN码（%lu/17)",textView.text.length];
            self.value1 = textView.text;
        }
            break;
            
        case 3:
        {
            self.value4 = textView.text;
        }
            break;
        case 4:
        {
            self.value5 = textView.text;
        }
            break;
        case 5:
        {
            self.value6 = textView.text;
        }
            break;
        case 6:
        {
            self.value7 = textView.text;
        }
            break;
        case 7:
        {
            self.value8 = textView.text;
        }
            break;
        case 8:
        {
            self.value9 = textView.text;
        }
            break;
        case 10:
        {
            self.value11 = textView.text;
        }
            break;
            
        default:
            break;
    }
    
    if ([textView isKindOfClass:[QLBaseTextView class]]) {
        QLBaseTextView* view = (QLBaseTextView *)textView;
        view.placeholder = @"";
    }

}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    switch (textView.tag - 999) {
        case 0:
        {
            //如果是删除减少字数，都返回允许修改
            if ([text isEqualToString:@""]) {
                return YES;
            }
            if (range.location>= 17)
            {
                return NO;
            }
            else
            {
                QLBaseTextView* textView1 = (QLBaseTextView*)textView;
                textView1.placeholder = @"";
                return YES;
            }
        }
            break;
            
        default:
            break;
    }
    
    
    return YES;
}

#pragma mark - Lazy
- (QLAddCarBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [QLAddCarBottomView new];
        [_bottomView.submitBtn addTarget:self action:@selector(submitNewCar) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.cancelBtn addTarget:self action:@selector(saveData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}

// 本地缓存
- (void)saveData {
    
    
    [MBProgressHUD showLoading:@""];
    NSMutableArray *temp1 = [NSMutableArray array];
    if (self.imgsArr.count >0) {
        for (UIImage *image in self.imgsArr) {
            [temp1 addObject:UIImageJPEGRepresentation(image, 0.7)];
        }
    }
    
    NSMutableArray *temp2 = [NSMutableArray array];
    if (self.imgsArr1.count >0) {
        for (UIImage *image in self.imgsArr1) {
            [temp2 addObject:UIImageJPEGRepresentation(image, 0.7)];
        }
    }

    
    NSDictionary *dataDic = @{
        @"value1":self.value1?self.value1:@"",
        @"value2":self.value2?self.value2:@"",
        @"value3":self.value3?self.value3:@"",
        @"value4":self.value4?self.value4:@"",
        @"value5":self.value5?self.value5:@"",
        @"value6":self.value6?self.value6:@"",
        @"value7":self.value7?self.value7:@"",
        @"value8":self.value8?self.value8:@"",
        @"value9":self.value9?self.value9:@"",
        @"value10":self.value10?self.value10:@"",
        @"value11":self.value11?self.value11:@"",
        @"value12":self.value12?self.value12:@"",
        @"value13":self.value13?self.value13:@"",
        @"value14":self.value14?self.value14:@"",
        @"imagArr1":temp1,
        @"imagArr2":temp2
    };
    
    [[NSUserDefaults standardUserDefaults] setValue:dataDic forKey:@"QLAddCarTempData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [MBProgressHUD showSuccess:@"已缓存"];
    
}

- (void)submitNewCar{
    if (!self.value1 || self.value1.length < 17) {
        [MBProgressHUD showError:@"Vin码需要17位"];
        return;
    }
    
    if (!self.value5 || !self.value7 || !self.value8) {
        [MBProgressHUD showError:@"必填项未填"];
        return;
    }
    
    if (self.imgsArr.count < 1) {
        [MBProgressHUD showError:@"上传车辆图片"];
        return;
    }
    if (self.imgsArr1.count < 1) {
        [MBProgressHUD showError:@"上传证件"];
        return;
    }
    
    if (!self.brandModel) {
        [MBProgressHUD showError:@"请选品牌"];
        return;
    }
    
    if (!self.value10) {
        [MBProgressHUD showError:@"选择变速箱/车身颜色/车辆类型/环保标准"];
        return;
    }
    
    
    WEAKSELF
    
    [MBProgressHUD showCustomLoading:@"正在发车"];
    [[QLOSSManager shared] syncUploadImages:self.imgsArr complete:^(NSArray *names, UploadImageState state) {
        NSArray *carArr = names;
        [[QLOSSManager shared] syncUploadImages:self.imgsArr1 complete:^(NSArray *names, UploadImageState state) {
            NSArray *paperArr = names;
            // 图片都传完了
            // LSVDJ2BM6KN036465
            NSDictionary* para = @{
                Operation_type:@"add",
                @"account_id":[QLUserInfoModel getLocalInfo].account.account_id,
                @"car_imgs_1":[carArr isKindOfClass:[NSArray class]]?[carArr componentsJoinedByString:@","]:@[],
                @"car_imgs_2":[paperArr isKindOfClass:[NSArray class]]?[paperArr componentsJoinedByString:@","]:@[],
                @"vin_code":weakSelf.value1?weakSelf.value1:@"",
                @"brand_id":weakSelf.brandModel.brand_id,
                @"series_id":weakSelf.seriesModel.series_id,
                @"model_id":weakSelf.typeInfoModel?weakSelf.typeInfoModel.model_id:@"",
                @"brand":weakSelf.brandModel.brand_name,
                @"series":weakSelf.seriesModel.series_name,
                @"model":weakSelf.typeInfoModel?weakSelf.typeInfoModel.series_name:@"",
                @"production_date":weakSelf.value3?weakSelf.value3:@"",
                @"driving_distance":weakSelf.value4?weakSelf.value4:@"",
                @"sell_price":weakSelf.value5?@([weakSelf.value5 floatValue]*10000):@"",
                @"sell_min_price":weakSelf.value6?@([weakSelf.value6 floatValue]*10000):@"",
                @"wholesale_price":weakSelf.value7?@([weakSelf.value7 floatValue]*10000):@"",
                @"procure_price":weakSelf.value8?@([weakSelf.value8 floatValue]*10000):@"",
                // 过户次数
                @"transfer_times":weakSelf.value9?weakSelf.value9:@"",
                @"transmission_case":weakSelf.speedBox[weakSelf.resultModelArr[0].index],
                @"body_color":weakSelf.colorBox[weakSelf.resultModelArr[1].index],
                @"car_type":@(weakSelf.resultModelArr[2].index),
                @"emission_standard":weakSelf.enviBox[weakSelf.resultModelArr[3].index],
                @"displacement":weakSelf.value11?weakSelf.value11:@"",
                @"mot_date":weakSelf.value12?weakSelf.value12:@"",
                @"insure_date":weakSelf.value13?weakSelf.value13:@"",
                @"belonger":EncodeStringFromDic(weakSelf.belongDic, @"personnel_id"),
                
                @"belonger_type":[weakSelf.value9 integerValue] > 1?@"1":@"2",
                @"seller_id":[QLUserInfoModel getLocalInfo].account.account_id,
                @"business_id":[QLUserInfoModel getLocalInfo].business.business_id,
                @"temporary_state":@"1"
            };
        
            [QLNetworkingManager postWithUrl:CarPath params:para success:^(id response) {
                [MBProgressHUD showSuccess:@"发布成功！"];
                
                if ([[QLUserInfoModel getLocalInfo].account.flag isEqualToString:@"2"] || [[QLUserInfoModel getLocalInfo].account.flag isEqualToString:@"3"]) {
                    // 弹个弹窗
                    [MBProgressHUD immediatelyRemoveHUD];
                    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, weakSelf.view.width, weakSelf.view.height)];
                    backView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
                    backView.userInteractionEnabled = YES;
                    QLAddCarPopWIndow* window = [[QLAddCarPopWIndow alloc]init];
                    window.frame = CGRectMake(30, 25, backView.width - 60, backView.height*0.6);
                    window.priceLabel.text = [weakSelf.value7 stringByAppendingString:@"万元"];
                    window.detailDesc.text = [weakSelf.value2 stringByAppendingString:[NSString stringWithFormat:@" %@",weakSelf.value10]];
                    
                    window.sureBlock = ^(NSString * _Nonnull price, NSString * _Nonnull detail) {
                        if (window.reSetPriceTextField.text.length > 0) {
                            NSDictionary *result_info = [response objectForKey:@"result_info"];
                            // 重新设置价格
                            [MBProgressHUD showLoading:@"正在上传"];
                            [QLNetworkingManager postWithUrl:BusinessPath params:@{
                                Operation_type:@"add_car_flag",
                                @"account_id":[QLUserInfoModel getLocalInfo].account.account_id,
                                @"car_id":EncodeStringFromDic(result_info, @"car_id"),
                                @"business_car_id":EncodeStringFromDic(result_info, @"business_car_id"),
                                @"flag":@"1",
                                @"explain":detail,
                                @"wholesale_price_old":@([weakSelf.value7 floatValue]*10000),
                                @"wholesale_price":@([price floatValue]*10000)
                            } success:^(id response) {
                                [MBProgressHUD immediatelyRemoveHUD];
                                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                // 删除缓存
                                [[NSUserDefaults standardUserDefaults] setValue:@{} forKey:@"QLAddCarTempData"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    QLNavigationController *vc = (QLNavigationController*)[weakSelf getCurrentVC];
                                    UITabBarController*tabvc = (UITabBarController*)vc.viewControllers[0];
                                    [tabvc setSelectedIndex:2];
                                    
                                    UIViewController *vc3 = tabvc.viewControllers[2];
                                    QLMyCarDetailViewController *detailVc = [[QLMyCarDetailViewController alloc]initWithUserid:[QLUserInfoModel getLocalInfo].account.account_id carID:EncodeStringFromDic(result_info, @"car_id") businessCarID:EncodeStringFromDic(result_info, @"business_car_id")];
                                    [vc3.navigationController pushViewController:detailVc animated:YES];
                                });
                                
                                
                            } fail:^(NSError *error) {
                                [MBProgressHUD showError:error.domain];
                            }];
                        } else {
                            return;
                        }
                    };
                    
                    window.cancleBlock = ^{
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                        NSDictionary *result_info = [response objectForKey:@"result_info"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            QLNavigationController *vc = (QLNavigationController*)[weakSelf getCurrentVC];
                            UITabBarController*tabvc = (UITabBarController*)vc.viewControllers[0];
                            [tabvc setSelectedIndex:2];
                            
                            UIViewController *vc3 = tabvc.viewControllers[2];
                            QLMyCarDetailViewController *detailVc = [[QLMyCarDetailViewController alloc]initWithUserid:[QLUserInfoModel getLocalInfo].account.account_id carID:EncodeStringFromDic(result_info, @"car_id") businessCarID:EncodeStringFromDic(result_info, @"business_car_id")];
                            [vc3.navigationController pushViewController:detailVc animated:YES];
                        });
                    };
                    
                    window.userInteractionEnabled = YES;
                    [backView addSubview:window];
                    [weakSelf.view addSubview:backView];
                    
                } else {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
                
                
            } fail:^(NSError *error) {
                [MBProgressHUD showError:error.domain];
            }];
        }];
    }];
}
 
- (void)scanImg{
    // 点了之后选图片
    WEAKSELF
    [[QLToolsManager share] getPhotoAlbum:self resultBack:^(UIImagePickerController *picker, NSDictionary *info) {
        
        UIImage *img = info[UIImagePickerControllerOriginalImage];
        // 退出一个vc 把这个img带过去
        VinCodeIdenfitViewController *vc = [[VinCodeIdenfitViewController alloc]init];
        vc.idBlock = ^(UIImage * _Nonnull image, NSString * _Nonnull vinCode, NSString * _Nonnull register_date) {
            if ([vinCode isKindOfClass:[NSString class]] && vinCode.length == 17) {
                // vin码
                weakSelf.value1 = vinCode;
                QLSubmitTextCell*cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                cell.titleLB.text = [NSString stringWithFormat:@"VIN码(%lu/17)",vinCode.length];
                cell.textView.placeholder = @"";
                cell.textView.text = vinCode;
                // 图片
                QLReleaseImagesCell *cell1 = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
                [weakSelf.imgsArr1 insertObject:img atIndex:0];
                cell1.setImgArr = weakSelf.imgsArr1;
                
                // 日期
                weakSelf.value3 = register_date;
                QLSubmitTextCell* cell2 = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
                cell2.textView.placeholder = @"";
                cell2.textView.text = register_date;
                
            }
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
        vc.selectImg = img;
    }];
}

- (NSMutableArray *)imgsArr1 {
    if (!_imgsArr1) {
        _imgsArr1 = [NSMutableArray array];
    }
    return _imgsArr1;
}

- (NSMutableArray *)imgsArr {
    if (!_imgsArr) {
        _imgsArr = [NSMutableArray array];
    }
    return _imgsArr;
}

- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    return result;
}

- (QLAddCarPageModel *)carPageModel {
    if (!_carPageModel) {
        _carPageModel = [[QLAddCarPageModel alloc]init];
    }
    return _carPageModel;
}

@end
