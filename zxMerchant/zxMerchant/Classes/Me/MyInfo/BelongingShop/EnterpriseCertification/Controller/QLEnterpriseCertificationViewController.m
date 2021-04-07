//
//  QLEnterpriseCertificationViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/12/30.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLEnterpriseCertificationViewController.h"
#import "QLSubmitBottomView.h"
#import "QLSubmitTextCell.h"
#import "QLSubmitImgConfigCell.h"

@interface QLEnterpriseCertificationViewController ()<UITableViewDelegate,UITableViewDataSource,QLBaseTextViewDelegate>
@property (nonatomic, strong) QLSubmitBottomView *bottomView;

@end

@implementation QLEnterpriseCertificationViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"企业认证";
    //底部
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(BottomOffset?-34:0);
        make.height.mas_equalTo(50);
    }];
    //tableView
    [self tableViewSet];
    
}
#pragma mark - action

- (void)bControlClick:(UIControl *)control {
    [[QLToolsManager share] getPhotoAlbum:self resultBack:^(UIImagePickerController *picker, NSDictionary *info) {
        
    }];
}
- (void)aControlClick:(UIControl *)control {
    [[QLToolsManager share] getPhotoAlbum:self resultBack:^(UIImagePickerController *picker, NSDictionary *info) {
        
    }];
}
//提交审核
- (void)funBtnClick {
    
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLSubmitTextCell" bundle:nil] forCellReuseIdentifier:@"textCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLSubmitImgConfigCell" bundle:nil] forCellReuseIdentifier:@"submitImgConfigCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 1||indexPath.section == 2)&&indexPath.row == 2) {
        QLSubmitImgConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"submitImgConfigCell" forIndexPath:indexPath];
        cell.aControl.tag = indexPath.section;
        cell.bControl.tag = indexPath.section;
        [cell.aControl addTarget:self action:@selector(aControlClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.bControl addTarget:self action:@selector(bControlClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    } else {
        QLSubmitTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        cell.unitLB.text = @"";
        cell.actionBtn.hidden = YES;
        cell.showLine = YES;
        cell.textView.editable = YES;
        cell.textView.userInteractionEnabled = YES;
        cell.textView.showCenterPlaceholder = YES;
        cell.textView.placeholder = @"请输入";
        cell.textView.tag = indexPath.row;
        cell.textView.keyboardType = UIKeyboardTypeDefault;
        cell.textView.tvDelegate = self;
        NSArray *sectionTitles = @[@[@"公司名称",@"所在地区",@"详情地址"],@[@"执照公司名",@"信用代码"],@[@"姓名",@"身份证号"],@[@"银行名称",@"银行卡号",@"持卡人"]];
        NSArray *titles = sectionTitles[indexPath.section];
        cell.titleLB.text = titles[indexPath.row];
        return cell;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [UIView new];
    
    NSArray *titles = @[@"基本信息",@"企业资料",@"法人资料认证",@"收款信息"];
    UILabel *lb = [UILabel new];
    lb.font = [UIFont systemFontOfSize:13];
    lb.textColor = [UIColor darkGrayColor];
    lb.text = titles[section];
    [header addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header).offset(16);
        make.centerY.equalTo(header);
    }];
    
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
#pragma mark - Lazy
- (QLSubmitBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [QLSubmitBottomView new];
        [_bottomView.funBtn setTitle:@"提交审核" forState:UIControlStateNormal];
        [_bottomView.funBtn addTarget:self action:@selector(funBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}

@end
