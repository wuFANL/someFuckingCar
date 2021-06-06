//
//  QLSysMsgListViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/11.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLSysMsgListViewController.h"
#import "QLSysMsgListCell.h"
#import "QLContactsInfoViewController.h"
#import "QLMyCarDetailViewController.h"

@interface QLSysMsgListViewController ()<UITableViewDelegate,UITableViewDataSource,QLBaseTableViewDelegate>
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@end

@implementation QLSysMsgListViewController

-(id)initWithTitle:(NSString *)titleStr
{
    self = [super init];
    if (self) {
        self.titleString = titleStr;
        self.sourceArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)dataRequest
{
    [self requestForNotifi];
}

-(void)requestForNotifi
{
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:BasePath params:@{@"operation_type":@"get_msg_list",@"user_id":[QLUserInfoModel getLocalInfo].account.account_id,@"user_type":@"3",@"title":self.titleString,@"page_no":@(self.tableView.page),@"page_size":@"20"} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];

        if (self.tableView.page == 1) {
            [self.sourceArr removeAllObjects];
        }
        NSArray *temArr = [NSArray arrayWithArray:[[response objectForKey:@"result_info"] objectForKey:@"msgList"]];
        [self.sourceArr addObjectsFromArray:temArr];
        //无数据设置
        if (self.sourceArr.count == 0) {
            self.tableView.hidden = YES;
            self.showNoDataView = YES;
        } else {
            self.tableView.hidden = NO;
            self.showNoDataView = NO;
        }
        //刷新设置
        [self.tableView.mj_header endRefreshing];
        if (temArr.count == 20) {
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:error.domain];
    }];
}

-(void)requestForReadMsg:(NSString *)msgId
{
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:UserPath params:@{@"operation_type":@"read_msg_detail",@"id_s":msgId} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];

    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self requestForNotifi];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    [self naviSet];
    //tableView
    [self tableViewSet];
}
#pragma mark - action
//全部已读按钮点击
- (void)rightItemClick {
    
}
//导航栏
- (void)naviSet {
    self.navigationItem.title = self.titleString;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"全部已读" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark -tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.extendDelegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLSysMsgListCell" bundle:nil] forCellReuseIdentifier:@"msgListCell"];
    self.tableView.showHeadRefreshControl = YES;
    self.tableView.showFootRefreshControl = YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sourceArr count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLSysMsgListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"msgListCell" forIndexPath:indexPath];
    NSDictionary *dic = [self.sourceArr objectAtIndex:indexPath.section];
    cell.contentLB.text = [dic objectForKey:@"content"];
    cell.titleLB.text = [dic objectForKey:@"from_user_name"];
    [cell.headBtn sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"from_user_head"]] forState:UIControlStateNormal];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [self.sourceArr objectAtIndex:indexPath.section];
    [self requestForReadMsg:[dic objectForKey:@"id"]];
    if ([self.titleString isEqualToString:@"关注通知"])
    {
        QLContactsInfoViewController *ciVC = [[QLContactsInfoViewController alloc] initWithFirendID:[dic objectForKey:@"from_user_id"]];
        ciVC.contactRelation = Friend;
        [self.navigationController pushViewController:ciVC animated:YES];
    }
    else
    {
        NSString *fromUserID = [dic objectForKey:@"from_user_id"];
        NSString *carid = [dic objectForKey:@"params"];
        NSArray *ar = [carid componentsSeparatedByString:@"&"];
        carid = [[[ar firstObject] componentsSeparatedByString:@"="] lastObject];
        //上架通知 + 交易通知 + 出售通知
        QLMyCarDetailViewController *vcdVC = [[QLMyCarDetailViewController alloc] initWithUserid:fromUserID carID:carid];
        [self.navigationController pushViewController:vcdVC animated:YES];
        
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = [self.sourceArr objectAtIndex:section];
    UIView *headerView = [UIView new];
    //时间
    UILabel *timeLB = [UILabel new];
    timeLB.backgroundColor = [UIColor colorWithHexString:@"D4D4D4"];
    timeLB.textColor = WhiteColor;
    timeLB.font = [UIFont systemFontOfSize:13];
    timeLB.textAlignment = NSTextAlignmentCenter;
    timeLB.text = [dic objectForKey:@"create_time"];
    [headerView addSubview:timeLB];
    [timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(10);
        make.centerX.equalTo(headerView);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo([timeLB.text widthWithFont:timeLB.font]+10);
    }];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 108;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

@end
