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

@interface QLAddCarPageViewController ()<UITableViewDelegate,UITableViewDataSource,QLReleaseImagesCellDelegate>
@property (nonatomic, strong) QLAddCarBottomView *bottomView;
@property (nonatomic, strong) NSMutableArray *imgsArr;

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
    
}
#pragma mark - action
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
        
        switch (indexPath.row) {
            case 0:{
                cell.titleLB.text = @"VIN码(0/17)";
            }
                break;
            case 1:{
                cell.titleLB.text = @"品牌/车系";
            }
                break;
            case 2:{
                cell.titleLB.text = @"首次上牌";
            }
                break;
            case 3:{
                cell.titleLB.text = @"表显里程";
            }
                break;
            case 4:{
                cell.titleLB.text = @"在线标价";
            }
                break;
            case 5:{
                cell.titleLB.text = @"销售低价";
            }
                break;
            case 6:{
                cell.titleLB.text = @"批发价";
            }
                break;
            case 7:{
                cell.titleLB.text = @"采购价";
            }
                break;
            case 8:{
                cell.titleLB.text = @"过户次数";
            }
                break;
            case 9:{
                cell.titleLB.text = @"";
            }
                break;
            case 10:{
                cell.titleLB.text = @"排量";
            }
                break;
            case 11:{
                cell.titleLB.text = @"年检到期";
            }
                break;
            case 12:{
                cell.titleLB.text = @"强制险到期";
            }
                break;
            default:
                cell.titleLB.text = @"销售归属人";
                break;
        }

        return cell;
    } else {
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
        cell.setImgArr = self.imgsArr;
        cell.delegate = self;
        
        return cell;
    }
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
#pragma mark - Lazy
- (QLAddCarBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [QLAddCarBottomView new];
    }
    return _bottomView;
}

@end
