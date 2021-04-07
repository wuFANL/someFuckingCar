//
//  QLReleaseCarCircleViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/3.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLReleaseCarCircleViewController.h"
#import "QLCreatStoreTVCell.h"
#import "QLReleaseImagesCell.h"
#import "QLReleaseCarCircleStatusCell.h"

@interface QLReleaseCarCircleViewController ()<UITableViewDelegate,UITableViewDataSource,QLReleaseImagesCellDelegate>
@property (nonatomic, strong) QLBaseButton *rightBtn;
@property (nonatomic, strong) NSMutableArray *imgsArr;

@end

@implementation QLReleaseCarCircleViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    self.navigationItem.title = @"发布动态";
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    self.rightBtn.frame = rightView.frame;
    [rightView addSubview:self.rightBtn];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //tableView
    [self tableViewSet];
}
#pragma mark - action
//发布
- (void)releaseBtnClick {
    
}
//图片变化
- (void)imgChange:(NSMutableArray *)images {
    [self.tableView beginUpdates];
    self.imgsArr = images;
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
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCreatStoreTVCell" bundle:nil] forCellReuseIdentifier:@"tvCell"];
    [self.tableView registerClass:[QLReleaseImagesCell class] forCellReuseIdentifier:@"imgCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLReleaseCarCircleStatusCell" bundle:nil] forCellReuseIdentifier:@"releaseCarCircleStatusCell"];
    
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QLCreatStoreTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tvCell" forIndexPath:indexPath];
        cell.tv.backgroundColor = WhiteColor;
        cell.tv.constraintLB.hidden = YES;
        cell.tv.placeholder = @"积极发动态活跃分发出去的店铺气氛";
    
        return cell;
    } else if (indexPath.section == 1) {
        QLReleaseImagesCell *cell = [[QLReleaseImagesCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"imgCell"];
        cell.canMultipleChoice = YES;
        cell.maxImgCount = 9;
        cell.setImgArr = self.imgsArr;
        cell.delegate = self;
        return cell;
    } else {
        QLReleaseCarCircleStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"releaseCarCircleStatusCell" forIndexPath:indexPath];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
#pragma mark - Lazy
- (QLBaseButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[QLBaseButton alloc] init];
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"greenBj_332"] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(releaseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
- (NSMutableArray *)imgsArr {
    if (!_imgsArr) {
        _imgsArr = [NSMutableArray array];
    }
    return _imgsArr;
}
@end
