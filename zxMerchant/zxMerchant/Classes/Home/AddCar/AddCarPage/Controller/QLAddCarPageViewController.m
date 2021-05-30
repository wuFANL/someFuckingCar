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
// 归属人
@property (nonatomic, strong) NSDictionary *belongDic;
@end

@implementation QLAddCarPageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新增车辆";
    //底部
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-34);
        make.height.mas_equalTo(50);
    }];
    //tableView
    [self tableViewSet];
    
//    [self.view addSubview:self.pickerView];
    [self prepareData];
}
- (void)prepareData {
    self.speedBox = @[@"自动",@"手动"];
    self.colorBox = @[@"银灰色",@"深灰色",@"黑色",@"白色",@"红色",@"蓝色",@"咖啡色",@"香槟色",@"黄色",@"紫色",@"绿色",@"橙色",@"粉红色",@"彩色"];
    //车型：1两厢轿车2三厢轿车3跑车4suv 5MPV 6面包车 7皮卡
    self.typeBox = @[@"两厢",@"三厢",@"跑车",@"SUV",@"MPV",@"面包车",@"皮卡"];
    self.enviBox = @[@"国六",@"国五",@"国四",@"国三"];
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
            }
                break;
            case 1:{
                
                if (self.brandModel) {
                    NSString *carName = [NSString stringWithFormat:@"%@%@",self.brandModel.brand_name,self.seriesModel.series_name];
                    cell.textView.text = carName;
                } else {
                    cell.titleLB.text = @"品牌/车系";
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
            }
                break;
            case 9:{
                
                if (self.value10.length > 0) {
                    cell.titleLB.text = self.value10;
                } else {
                    cell.titleLB.text = @"变速箱/车身颜色/车辆类型/环保标准";
                }
                
                cell.textView.userInteractionEnabled = NO;
                cell.titleWidth.constant = 250;
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
                
                cell.titleLB.text = @"排量";
                
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
        model.itemSize = CGSizeMake(itemWidth, 53);
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
        model.itemSize = CGSizeMake(itemWidth, 53);
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
       [MBProgressHUD showCustomLoading:nil];
       [QLNetworkingManager postWithUrl:BusinessPath params:para success:^(id response) {
           [MBProgressHUD immediatelyRemoveHUD];
           NSArray *dataArr = [[response objectForKey:@"result_info"] objectForKey:@"at_work_personnel_list"];
           if ([dataArr isKindOfClass:[NSArray class]]) {
               NSMutableArray* nameArr = [NSMutableArray array];
               for (NSDictionary* dic in dataArr) {
                   [nameArr addObject:EncodeStringFromDic(dic, @"personnel_nickname")];
               }
               
               [BRStringPickerView showPickerWithTitle:@"选择销售归属人" dataSourceArr:nameArr selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
                  // 选中了销售归属人
                   QLSubmitTextCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                   cell.textView.text = resultModel.value;
                   weakSelf.belongDic = dataArr[resultModel.index];
               }];
           }
       } fail:^(NSError *error) {
           [MBProgressHUD showError:error.domain];
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
    }
    return _bottomView;
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
                @"transfer_times":weakSelf.value9?weakSelf.value9:@"",
                @"transmission_case":weakSelf.speedBox[weakSelf.resultModelArr[0].index],
                @"body_color":weakSelf.colorBox[weakSelf.resultModelArr[1].index],
                @"car_type":@(weakSelf.resultModelArr[2].index),
                @"emission_standard":weakSelf.enviBox[weakSelf.resultModelArr[3].index],
                @"displacement":weakSelf.value11?weakSelf.value11:@"",
                @"mot_date":weakSelf.value12?weakSelf.value12:@"",
                @"insure_date":weakSelf.value13?weakSelf.value13:@"",
                @"belonger":EncodeStringFromDic(weakSelf.belongDic, @"personnel_id"),
                @"belonger_type":@"1",
                @"seller_id":[QLUserInfoModel getLocalInfo].account.account_id,
                @"business_id":[QLUserInfoModel getLocalInfo].business.business_id,
                @"temporary_state":@"1"
            };
            
            [QLNetworkingManager postWithUrl:CarPath params:para success:^(id response) {
                [MBProgressHUD showSuccess:@""];
            } fail:^(NSError *error) {
                [MBProgressHUD showError:error.domain];
            }];
        }];
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

@end
