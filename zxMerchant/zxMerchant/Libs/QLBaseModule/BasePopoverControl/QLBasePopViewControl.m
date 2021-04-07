//
//  QLCustomPopViewController.m
//  luluzhuan
//
//  Created by 乔磊 on 2017/10/18.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import "QLBasePopViewControl.h"
#import "UIColor+QLUtil.h"
#import "UITableView+QLUtil.h"
//即限定作用域，又限定常量
static const CGFloat buttonWidth = 100;
static const CGFloat buttonHeight = 35;
static const CGFloat inset = 0.01;//上下间隔

@interface QLBasePopViewControl ()
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation QLBasePopViewControl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    //增加tableView
    [self addTableView];
    //view的size
    [self viewSizeChange];
}
- (void)viewSizeChange {
    //设置view的宽高
    if ((2*inset+buttonHeight)*self.dataArray.count <= self.view.frame.size.height*2/3) {
        self.preferredContentSize = CGSizeMake(2*inset+buttonWidth, self.dataArray.count*+(2*inset+buttonHeight));
    } else {
        self.preferredContentSize = CGSizeMake(2*inset+buttonWidth, self.view.frame.size.height*2/3);
    }
}
#pragma mark- - UITableView相关的方法
- (void)addTableView {
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    //设置tableView属性
    self.tableView.dataSource = self;
    self.tableView.delegate =self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView hideTableEmptyDataSeparatorLine];
    self.view = self.tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:_cellName];
    }
    
    if ([self.delegate respondsToSelector:@selector(cell:
                                                    IndexPath:Data:)]) {
        [self.delegate cell:cell IndexPath:indexPath Data:[self.dataArray mutableCopy]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(popClickCall:)]) {
        [self.delegate popClickCall:indexPath.row];
    }
    //收回控制器
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    });
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return buttonHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return inset;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return inset;
}
//cell名设置
- (void)setCellName:(NSString *)cellName {
    _cellName = cellName;
    if (_registerType) {
        [self setRegisterType:_registerType];
    }
}
//注册类型
- (void)setRegisterType:(CELL_REGISTER_TYPE)registerType {
    _registerType = registerType;
    if (_cellName.length > 0) {
        if (registerType == CellNibRegisterType) {
            [self.tableView registerNib:[UINib nibWithNibName:self.cellName bundle:nil] forCellReuseIdentifier:self.cellName];
        } else {
            [self.tableView registerClass:NSClassFromString(_cellName) forCellReuseIdentifier:_cellName];
        }
    }
    
}
//设置颜色
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.view.backgroundColor = backgroundColor;
}
//设置尺寸
- (void)setViewSize:(CGSize)viewSize {
    self.preferredContentSize = viewSize;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark-  Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
