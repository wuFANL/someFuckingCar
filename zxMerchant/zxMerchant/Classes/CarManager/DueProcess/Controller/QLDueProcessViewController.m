//
//  QLDueProcessViewController.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/10.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLDueProcessViewController.h"
#import "QLDueProcessCell.h"
#import "QLChooseTimeView.h"

@interface QLDueProcessViewController ()<UITableViewDelegate,UITableViewDataSource,QLBaseTableViewDelegate>
@property (nonatomic, strong) QLBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArr;
@end

@implementation QLDueProcessViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.viewType == 0?@"年检到期":@"强制险到期";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.listArr = [@[@"1",@"2",@"3"] mutableCopy];
}
#pragma mark -network
//列表数据
- (void)dataRequest {
    
    
}
//处理数据
- (void)doTimeRequest:(NSDictionary *)param {
 
}
#pragma mark -action
//处理事件
- (void)doBtnClick:(UIButton *)sender {
    NSInteger row = sender.tag;
   
    QLChooseTimeView *ctView = [QLChooseTimeView new];
    ctView.columns = 3;
    ctView.showUnit = YES;
    ctView.titleLB.text = @"确认处理时间";
    ctView.currentDate = [NSDate date];
    ctView.resultBackBlock = ^(NSString *time) {
        //处理请求
       
    };
    [ctView showTimeView];
}
#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLDueProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dueCell" forIndexPath:indexPath];
    cell.doBtn.tag = indexPath.row;
    [cell.doBtn setTitle:@"待处理" forState:UIControlStateNormal];
    [cell.doBtn addTarget:self action:@selector(doBtnClick:) forControlEvents:UIControlEventTouchUpInside];
  
    cell.titleLB.text = @"别克 凯越 2011款 1.6自动款 1.6自舒...";
    cell.priceLB.text = @"0.0";
    cell.accLB.text = self.viewType == 0?@"年检到期日":@"强制险到期日";
    NSString *time = self.viewType == 0?@"2019.02":@"2019.02.10";
    cell.timeLB.text = time;
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}
#pragma mark -lazyLoading
- (QLBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[QLBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.extendDelegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"QLDueProcessCell" bundle:nil] forCellReuseIdentifier:@"dueCell"];
    }
    return _tableView;
}
- (NSMutableArray *)listArr {
    if (!_listArr) {
        _listArr = [NSMutableArray array];
    }
    return _listArr;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
