//
//  QLChooseBuyerViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/12/18.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLChooseBuyerViewController.h"
#import "QLSearchContactsViewController.h"

@interface QLChooseBuyerViewController ()<QLBaseSearchBarDelegate>
@property (nonatomic, strong) QLBaseSearchBar *searchBar;
@property (nonatomic, assign) BOOL isFromCarManager;
@end

@implementation QLChooseBuyerViewController

-(id)initFromCarManager:(BOOL)isFromCarManager
{
    self = [super init];
    if(self) {
        self.isFromCarManager = isFromCarManager;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    [self naviSet];
}
#pragma mark - 导航栏
- (void)noEditClick {
    
}
- (void)rightItemClick {
    QLSearchContactsViewController *scVC = [QLSearchContactsViewController new];
    [self.navigationController pushViewController:scVC animated:YES];
}
- (void)naviSet {
    if(!self.isFromCarManager)
    {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"addressAdd"] originalImage] style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width-100, 30)];
    self.searchBar.frame = titleView.bounds;
    [titleView addSubview:self.searchBar];
    self.navigationItem.titleView = titleView;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FriendDetailModel *friendModel = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if(self.cfBlock)
    {
        self.cfBlock(friendModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Lazy
- (QLBaseSearchBar *)searchBar {
    if(!_searchBar) {
        _searchBar = [QLBaseSearchBar new];
        _searchBar.noEditClick = YES;
        _searchBar.isRound = YES;
        [_searchBar setImage:[UIImage imageNamed:@"newFriendSearchIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        [_searchBar setBjColor:[UIColor groupTableViewBackgroundColor]];
        _searchBar.placeholder = @"搜索";
        _searchBar.extenDelegate = self;
        
    }
    return _searchBar;
}
@end
