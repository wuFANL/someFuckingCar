//
//  QLCarCircleCommentCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/28.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCarCircleCommentCell.h"
#import "QLCarCircleCommentContentCell.h"

@interface QLCarCircleCommentCell()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLBaseTableView *tableView;
@property (nonatomic, assign) CGFloat tableViewHeight;
@end
@implementation QLCarCircleCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.bjView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bjView);
    }];
}

- (void)setListArr:(NSArray *)listArr {
    if (![_listArr isEqualToArray:listArr]) {
        _listArr = listArr;
        
        self.tableViewHeight = 0;
        [self.tableView reloadData];
    }
}
#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QLCarCircleCommentContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentContentCell" forIndexPath:indexPath];
    cell.backgroundColor = ClearColor;
    if (indexPath.row < self.listArr.count) {
        cell.model = self.listArr[indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.clickHandler) {
        self.clickHandler(self.listArr[indexPath.row],nil);
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}
//属性监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]&&[object isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)object;
        CGFloat heigth  = tableView.contentSize.height;
        
        if (self.tableViewHeight != heigth) {
            self.tableViewHeight = heigth;
            self.bjViewHeight.constant = self.tableViewHeight;
            [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                [((UITableView *)self.superview) reloadData];
            }];
            [CATransaction commit];
        }
        
        
    }
}
- (void)dealloc {
    //移除监听
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
}
#pragma mark - Lazy
- (QLBaseTableView *)tableView {
    if(!_tableView) {
        _tableView = [[QLBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"eaeaea"];
        [_tableView hideTableEmptyDataSeparatorLine];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"QLCarCircleCommentContentCell" bundle:nil] forCellReuseIdentifier:@"commentContentCell"];
        [_tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _tableView;
}

@end
