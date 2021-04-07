//
//  QLChooseTimeView.m
//  TheOneCampus
//
//  Created by 乔磊 on 2017/8/23.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import "QLChooseTimeView.h"

#define defaultDayCount 31
@interface QLChooseTimeView()<UIPickerViewDelegate,UIPickerViewDataSource,QLBaseViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertWidth;
@property (nonatomic, strong) NSMutableArray *dataDArr;

@property (nonatomic, strong) NSString *yStr;
@property (nonatomic, strong) NSString *MStr;
@property (nonatomic, strong) NSString *dStr;
@property (nonatomic, strong) NSString *HStr;
@property (nonatomic, strong) NSString *mStr;
@property (nonatomic, strong) NSString *sStr;

@property (nonatomic, assign) NSInteger yIndex;
@property (nonatomic, assign) NSInteger MIndex;
@property (nonatomic, assign) NSInteger dIndex;
@property (nonatomic, assign) NSInteger HIndex;
@property (nonatomic, assign) NSInteger mIndex;
@property (nonatomic, assign) NSInteger sIndex;

@property (nonatomic, strong) UILabel *yLb;
@property (nonatomic, strong) UILabel *MLb;
@property (nonatomic, strong) UILabel *dLb;
@property (nonatomic, strong) UILabel *HLb;
@property (nonatomic, strong) UILabel *MinLb;
@property (nonatomic, strong) UILabel *sLb;

@end
@implementation QLChooseTimeView
//初始化
- (instancetype)init {
    if (self == [super init]) {
        self = [QLChooseTimeView viewFromXib];
        self.frame = [UIScreen mainScreen].bounds;
        self.alertWidth.constant = ScreenWidth;
        //遮罩
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.viewDelegate = self;
    }
    return self;
}
- (void)setMaxDate:(NSDate *)maxDate {
    _maxDate = maxDate;
    [_dataDArr removeAllObjects];
    //当前时间
    NSDateFormatter *maxDateFormatter = [[NSDateFormatter alloc]init];
    maxDateFormatter.dateFormat = @"yyyy,MM,dd,HH,mm,ss";
    NSString *maxTimeStr = [maxDateFormatter stringFromDate:maxDate];
    NSArray *timeArr = [maxTimeStr componentsSeparatedByString:@","];
    _yStr = timeArr[0];
    _MStr = timeArr[1];
    _dStr = timeArr[2];
    _HStr = timeArr[3];
    _mStr = timeArr[4];
    _sStr = timeArr[5];
    
    /*年月日数据*/
    for (int j = [_dStr intValue]; j <= [self getNumberOfDaysInMonth:[_yStr intValue] Month:[_MStr intValue]]; j++) {
        [self.dataDArr addObject:@(j)];
    }
    [self.pickerView reloadAllComponents];
    
}
- (void)setCurrentDate:(NSDate *)currentDate {
    _currentDate = currentDate;
    if (self.maxDate == nil) {
        self.maxDate = self.currentDate;
    }
    [self.pickerView reloadAllComponents];
}
- (void)setShowUnit:(BOOL)showUnit {
    _showUnit = showUnit;
    [self.pickerView reloadAllComponents];
}
- (void)setColumns:(NSInteger)columns {
    _columns = columns;
    [self.pickerView reloadAllComponents];
}
- (IBAction)cancelBtnClick:(id)sender {
    //消失
    [self disappearTimeView];
}
- (IBAction)confirmBtnClick:(id)sender {
    //消失
    [self disappearTimeView];
    //返回数据
    NSString *timeStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",_yLb.text,_MLb.text,_dLb.text,_HLb.text,_MinLb.text,_sLb.text];
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"年" withString:@""];
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"月" withString:@""];
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"日" withString:@""];
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"时" withString:@""];
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"分" withString:@""];
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"秒" withString:@""];
    do {
        timeStr = [timeStr substringToIndex:timeStr.length-1];
    } while ([timeStr hasSuffix:@":"]||[timeStr hasSuffix:@"-"]||[timeStr hasSuffix:@" "]);
    self.resultBackBlock(timeStr);
    
}
//显示数据选择器
- (void)showTimeView {

    if (!self.currentDate) {
        self.currentDate = [NSDate date];
    }
    [KeyWindow addSubview:self];
    [UIView animateWithDuration:animationDuration animations:^{
        self.alertViewBottom.constant = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        NSInteger row = [self.maxDate year] - [self.currentDate year];
        [self.pickerView selectRow:row inComponent:0 animated:NO];
    }];
    
}
//消失数据选择器
- (void)disappearTimeView {
    [UIView animateWithDuration:animationDuration animations:^{
        self.alertViewBottom.constant = -225;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
//遮罩代理
- (void)hideMaskViewEvent {
    [self disappearTimeView];
}
#pragma mark -- UIPickerView
//1.有几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.columns==0?6:self.columns;
}
//2.每一列有几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:{
            NSInteger minYear = self.minDate==nil?1900:[self.minDate year];
            NSInteger maxYear = self.maxDate==nil?[[NSDate date] year]:[self.maxDate year];
            return  maxYear - minYear +1;
        }
            break;
        case 1:{
            return _yIndex == 0?(12-[_MStr intValue]+1):12;
        }
            break;
        case 2:{
            return _yIndex == 0&&_MIndex == 0?self.dataDArr.count:[self getNumberOfDaysInMonth:[_yStr intValue] Month:_MIndex+1];
        }
            break;
        case 3:
            return _yIndex == 0&&_MIndex == 0&&_dIndex == 0?24 - [_HStr intValue]:24;
            break;
        case 4:{
            return _yIndex == 0&&_MIndex == 0&&_dIndex == 0&&_HIndex == 0?60-[_mStr intValue]:60;
        }
            break;
        default:{
            return _yIndex == 0&&_MIndex == 0&&_dIndex == 0&&_HIndex == 0&&_mIndex == 0?60-[_sStr intValue]:60;
        }
            break;
    }
    
}
//3.每一列显示什么内容
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lblDate = [[UILabel alloc] init];
    [lblDate setFont:[UIFont systemFontOfSize:14.0]];
    [lblDate setTextColor:[UIColor blackColor]];
    [lblDate setBackgroundColor:[UIColor clearColor]];
    [lblDate setTextAlignment:NSTextAlignmentCenter];
    lblDate.tag = component*100+row;
    switch (component) {
        case 0:{
            NSString *content = [NSString stringWithFormat:@"%ld",(long)([_yStr intValue]-row)];
            if (self.showUnit) {
                content = [NSString stringWithFormat:@"%@年",content];
            }
            lblDate.text = content;
            self.yLb = lblDate;
        }
            break;
        case 1:{
            NSString *content = [NSString stringWithFormat:@"%02ld",(long)(_yIndex == 0?[_MStr intValue]+row:row+1)];
            if (self.showUnit) {
                content = [NSString stringWithFormat:@"%@月",content];
            }
            lblDate.text = content;
            self.MLb = lblDate;
        }
            break;
        case 2:{
            NSString *content = [NSString stringWithFormat:@"%02ld",(long)(_yIndex == 0&&_MIndex == 0?[_dataDArr[row] intValue]:row+1)];
            if (self.showUnit) {
                content = [NSString stringWithFormat:@"%@日",content];
            }
            lblDate.text = content;
            self.dLb = lblDate;
        }
            break;
        case 3:{
            NSString *content = [NSString stringWithFormat:@"%02ld",(long)(_yIndex == 0&&_MIndex == 0&&_dIndex == 0?row+[_HStr integerValue]:row)];
            if (self.showUnit) {
                content = [NSString stringWithFormat:@"%@时",content];
            }
            lblDate.text = content;
            self.HLb = lblDate;
        }
            break;
        case 4:{
            NSString *content = [NSString stringWithFormat:@"%02ld",(long)(_yIndex == 0&&_MIndex == 0&&_dIndex == 0&&_HIndex == 0?row+[_mStr integerValue]:row)];
            if (self.showUnit) {
                content = [NSString stringWithFormat:@"%@分",content];
            }
            lblDate.text = content;
            self.MinLb = lblDate;
        }
            break;
        default:{
            NSString *content = [NSString stringWithFormat:@"%02ld",(long)(_yIndex == 0&&_MIndex == 0&&_dIndex == 0&&_HIndex == 0&&_mIndex == 0?row+[_sStr integerValue]:row)];
            if (self.showUnit) {
                content = [NSString stringWithFormat:@"%@秒",content];
            }
            lblDate.text = content;
            self.sLb = lblDate;
        }
            break;
    }
    return lblDate;
}
//选中
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
            _yIndex = row;
            _MIndex = 0;
            _dIndex = 0;
            _HIndex = 0;
            _mIndex = 0;
            _sIndex = 0;
            break;
        case 1:
            _MIndex = row;
            _dIndex = 0;
            _HIndex = 0;
            _mIndex = 0;
            _sIndex = 0;
            break;
        case 2:
            _dIndex = row;
            _HIndex = 0;
            _mIndex = 0;
            _sIndex = 0;
            break;
        case 3:
            _HIndex = row;
            _mIndex = 0;
            _sIndex = 0;
            break;
        case 4:
            _mIndex = row;
            _sIndex = 0;
            break;
        default:
            _sIndex = row;
            break;

    }
    for (NSInteger i = component+1; i < _columns; i++) {
        if (i < _columns) {
            [pickerView selectRow:0 inComponent:i animated:YES];
        }
    }
    [pickerView reloadAllComponents];
}

//高度
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35;
}
//获取月份天数
- (NSInteger)getNumberOfDaysInMonth:(NSInteger)year Month:(NSInteger)month {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM";
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld",(long)year,(long)month]];
    // 只要个时间给日历,就会帮你计算出来。这里的时间取当前的时间。
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
                                   inUnit: NSCalendarUnitMonth
                                  forDate:date];
    return range.length;
}
#pragma mark - Lazy
- (NSMutableArray *)dataDArr {
    if (!_dataDArr) {
        _dataDArr = [NSMutableArray array];
    }
    return _dataDArr;
}


@end
