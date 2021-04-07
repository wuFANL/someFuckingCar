//
//  QLContactsStoreViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/13.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLContactsStoreViewController.h"
#import "QLContactsDescCell.h"
#import "QLContactsStoreFilterItemsCell.h"
#import "QLContactsStoreCarCell.h"
#import "QLContactsStoreBottomView.h"

@interface QLContactsStoreViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLContactsStoreBottomView *bottomView;

@end

@implementation QLContactsStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.naviTitle;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"callIcon"] style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    //底部
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.view).offset(BottomOffset?-34:0);
    }];
    //tableView
    [self tableViewSet];
}

#pragma mark - action

//全选
- (void)allBtnClick {
    self.bottomView.allBtn.selected = !self.bottomView.allBtn.selected;
    [self.tableView reloadData];
}
//选车
- (void)funBtnClick {
    if (self.bottomView.isEditing == NO) {
        //选择车辆
        self.bottomView.isEditing = YES;
    } else {
        //确定
        
    }
}
//电话
- (void)rightItemClick {
    
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLContactsDescCell" bundle:nil] forCellReuseIdentifier:@"contactsDescCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLContactsStoreFilterItemsCell" bundle:nil] forCellReuseIdentifier:@"filterItemsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLContactsStoreCarCell" bundle:nil] forCellReuseIdentifier:@"contactsStoreCarCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0?2:5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            QLContactsDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactsDescCell" forIndexPath:indexPath];
            cell.collectionBtn.hidden = NO;
            
            return cell;
        } else {
            QLContactsStoreFilterItemsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filterItemsCell" forIndexPath:indexPath];
            
            return cell;
        }
        
    } else {
        QLContactsStoreCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactsStoreCarCell" forIndexPath:indexPath];
        cell.isEditing = self.bottomView.allBtn.selected;
        
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 85;
        } else {
            return 140;
        }
    } else {
        return 120;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
#pragma mark - Lazy
- (QLContactsStoreBottomView *)bottomView {
    if(!_bottomView) {
        _bottomView = [QLContactsStoreBottomView new];
        _bottomView.allBtn.hidden = YES;
        _bottomView.allBtnWidth.constant = 0;
        
        [_bottomView.allBtn addTarget:self action:@selector(allBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.funBtn addTarget:self action:@selector(funBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}
@end
