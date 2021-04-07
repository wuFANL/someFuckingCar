//
//  QLContactsPageViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/4.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLContactsPageViewController.h"
#import "QLListSectionIndexView.h"
#import "QLContactsInfoViewController.h"
#import "QLRemarksSetViewController.h"

@interface QLContactsPageViewController ()<UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,PopViewControlDelegate>
@property (nonatomic, strong) QLListSectionIndexView *indexView;

@end

@implementation QLContactsPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    //长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [longPress setMinimumPressDuration:1.5];
    [self.view addGestureRecognizer:longPress];
}
#pragma mark - action
//pop的cell设置
- (void)cell:(UITableViewCell *)baseCell IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    baseCell.textLabel.font = [UIFont systemFontOfSize:13];
    baseCell.textLabel.textAlignment = NSTextAlignmentCenter;
    baseCell.textLabel.textColor = [UIColor colorWithHexString:@"#797D81"];
    baseCell.textLabel.text = dataArr[indexPath.row];
}
//pop的cell点击
- (void)popClickCall:(NSInteger)index {
    if (index == 0) {
        //设置备注
        QLRemarksSetViewController *rsVC = [QLRemarksSetViewController new];
        [self.navigationController pushViewController:rsVC animated:YES];
    }
}
//pop样式
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}
//长按
- (void)longPressAction:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint longPressPoint = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:longPressPoint];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [QLPopoverShowManager showPopover:@[@"设置备注"] areaView:cell direction:UIPopoverArrowDirectionUp backgroundColor:WhiteColor delegate:self];
    }
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 78, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = @"车友昵称";
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QLContactsInfoViewController *ciVC = [QLContactsInfoViewController new];
    ciVC.contactRelation = Friend;
    [self.navigationController pushViewController:ciVC animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    
    UILabel *sectionLB = [UILabel new];
    sectionLB.font = [UIFont systemFontOfSize:11];
    sectionLB.textColor = [UIColor colorWithHexString:@"666666"];
    sectionLB.text = @"A";
    [headerView addSubview:sectionLB];
    [sectionLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.left.equalTo(headerView).offset(18);
    }];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
#pragma mark -Lazy
- (QLListSectionIndexView *)indexView {
    if (!_indexView) {
        _indexView = [[QLListSectionIndexView alloc]init];
        _indexView.defaultColor = GreenColor;
        _indexView.relevanceView = self.tableView;
    }
    return _indexView;
}
@end
