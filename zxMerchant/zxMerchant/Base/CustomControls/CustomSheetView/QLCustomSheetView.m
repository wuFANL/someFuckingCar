//
//  QLCustomSheetView.m
//  PopularUsedCarManagement
//
//  Created by lei qiao on 2020/6/22.
//  Copyright © 2020 EmbellishJiao. All rights reserved.
//

#import "QLCustomSheetView.h"

@interface QLCustomSheetView()<QLBaseViewDelegate,UITableViewDelegate,UITableViewDataSource>


@end
@implementation QLCustomSheetView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLCustomSheetView viewFromXib];
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.viewDelegate = self;
        //tableView
        self.tableView.backgroundColor = WhiteColor;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        //默认值
        self.selectIndex = -1;
    }
    return self;
}
#pragma mark - setter
- (void)setListArr:(NSArray *)listArr {
    _listArr = listArr;
    [self.tableView reloadData];
}
- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    [self.tableView reloadData];
}
#pragma mark - action
- (IBAction)closeBtnClick:(id)sender {
    [self hidden];
}
- (void)show {
    [self.tableView reloadData];
    [KeyWindow addSubview:self];
}
- (void)hidden {
    if (self.clickHandler) {
        self.clickHandler(@(self.selectIndex), nil);
    }
    [self removeFromSuperview];
}
- (void)hiddenViewEvent {
    [self hidden];
}
#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }

    id obj = self.listArr[indexPath.row];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(sheetCell:indexPath:model:)]) {
        [self.delegate sheetCell:cell indexPath:indexPath model:obj];
    } else {
        UILabel *lb = [UILabel new];
        lb.tag = indexPath.row+100;
        lb.font = [UIFont systemFontOfSize:18];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.textColor = self.selectIndex == indexPath.row?GreenColor:[UIColor darkTextColor];
        NSString *title = @"";
        if ([obj isKindOfClass:[NSString class]]) {
            title = obj;
        }
        lb.text = title;
        [cell.contentView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectIndex = indexPath.row;
    [self hidden];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
@end
