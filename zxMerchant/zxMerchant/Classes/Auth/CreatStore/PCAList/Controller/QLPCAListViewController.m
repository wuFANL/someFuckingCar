//
//  QLPCAListViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2021/4/22.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLPCAListViewController.h"
#import "QLListSectionIndexView.h"
#import "QLBrandCell.h"

@interface QLPCAListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLListSectionIndexView *indexView;
@property (nonatomic, strong) QLBaseTableView *aTableView;
@property (nonatomic, strong) QLBaseTableView *bTableView;
@property (nonatomic, strong) QLBaseTableView *cTableView;
@property (nonatomic, strong) UIControl *bHeadView;
@property (nonatomic, strong) UIControl *cHeadView;
@property (nonatomic, strong) NSIndexPath *aIndex;
@property (nonatomic, strong) NSIndexPath *bIndex;
@property (nonatomic, strong) NSIndexPath *cIndex;
@property (nonatomic, strong) NSMutableArray *aArr;
@property (nonatomic, strong) NSMutableArray *bArr;
@property (nonatomic, strong) NSMutableArray *cArr;
@end

@implementation QLPCAListViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择城市";
    
    //品牌tableView
    [self.view addSubview:self.aTableView];
    [self.aTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //品牌导航
    [self.view addSubview:self.indexView];
    [self.indexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(35);
        make.bottom.equalTo(self.view).offset(-65);
        make.right.equalTo(self.view).offset(-5);
        make.width.mas_equalTo(35);
    }];
    //系列tableView
    [self.view addSubview:self.bTableView];
    [self.bTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.view);
        make.left.equalTo(self.view).offset(self.view.width);
    }];
    //车型tableView
    [self.view addSubview:self.cTableView];
    [self.cTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.view);
        make.left.equalTo(self.view).offset(self.view.width);
    }];
    //列表头部
    [self addHeadControl:self.bHeadView];
    [self.view insertSubview:self.bHeadView belowSubview:self.cTableView];
    [self.bHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.bTableView);
        make.height.mas_equalTo(44);
    }];
    [self addHeadControl:self.cHeadView];
    [self.view addSubview:self.cHeadView];
    [self.cHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.cTableView);
        make.height.mas_equalTo(44);
    }];
    
    self.aArr = @[@"1",@"2",@"3"];
    self.bArr = @[@"1",@"2",@"3"];
    self.cArr = @[@"1",@"2",@"3"];
}
#pragma mark -action
//增加头部控件
- (void)addHeadControl:(UIControl *)control {
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"reportAcc_selected"]];
    imgView.contentMode = UIViewContentModeCenter;
    [control addSubview:imgView];
    UILabel *textLB = [UILabel new];
    textLB.font = [UIFont systemFontOfSize:15];
    textLB.text = @"收起";
    [control addSubview:textLB];
    //布局
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(control);
        make.width.equalTo(imgView.mas_height);
    }];
    [textLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(control);
        make.left.equalTo(imgView.mas_right);
    }];
    
    [control addTarget:self action:@selector(headViewClick:) forControlEvents:UIControlEventTouchUpInside];
}
//头部点击
- (void)headViewClick:(UIControl *)control {
    if (control == self.bHeadView) {
        [self tableView:self.bTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    } else {
        [self tableView:self.cTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
}
#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.aTableView) {
        return self.aArr.count;
    } else if (tableView == self.bTableView) {
        return 2;
    } else {
        return 2;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.aTableView) {
        return 4;
    } else if (tableView == self.bTableView) {
        if (section == 0) {
            return 1;
        } else {
            return self.bArr.count;
        }
    } else {
        if (section == 0) {
            return 1;
        } else {
            return self.cArr.count;
        }
        
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLBrandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.imageView.image = nil;
    cell.textLabel.textColor = BlackColor;
    cell.backgroundColor = WhiteColor;
    cell.textLabel.numberOfLines = 2;
    //数据
    if (tableView == self.aTableView) {
       
        cell.textLabel.text = @"名称1";
       
        //选中颜色
        if (indexPath == self.aIndex) {
            cell.textLabel.textColor = WhiteColor;
            cell.backgroundColor = GreenColor;
        }
    } else if (tableView == self.bTableView) {
        if (indexPath.section == 0) {
            cell.textLabel.text = @"收起";
            cell.imageView.image = [UIImage imageNamed:@"reportAcc_selected"];
        } else {
            cell.textLabel.text = @"名称2";
            //选中颜色
            if (indexPath == self.bIndex) {
                cell.textLabel.textColor = WhiteColor;
                cell.backgroundColor = GreenColor;
            }
        }
    } else {
        if (indexPath.section == 0) {
            cell.textLabel.text = @"收起";
            cell.imageView.image = [UIImage imageNamed:@"reportAcc_selected"];
        } else {
            cell.textLabel.text = @"名称3";
            //选中颜色
            if (indexPath == self.cIndex) {
                cell.textLabel.textColor = WhiteColor;
                cell.backgroundColor = GreenColor;
            }
        }
        
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat space = 65.0;
    if (tableView == self.aTableView) {
        if (self.aIndex != indexPath) {
          
            self.aIndex = indexPath;
            self.bIndex = nil;
            self.cIndex = nil;
//            [self.bArr removeAllObjects];
//            [self.cArr removeAllObjects];
        }
        //打开列表
        [self.bTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(space);
        }];
    
    } else if (tableView == self.bTableView) {
        if (indexPath.row == 0) {
            [self.bTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).offset(self.view.width);
            }];
            [self.cTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).offset(self.view.width);
            }];
        } else {
            if (self.bIndex != indexPath) {
                self.bIndex = indexPath;
                self.cIndex = nil;
//                [self.cArr removeAllObjects];
            }
            [self.cTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).offset(space*2);
            }];
            
        }
        
    } else {
        
        if (indexPath.section == 0) {
            [self.cTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).offset(self.view.width);
            }];
        } else {
            if (self.cIndex != indexPath) {
                self.cIndex = indexPath;
               
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
    [self.aTableView reloadData];
    [self.bTableView reloadData];
    [self.cTableView reloadData];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.aTableView) {
        return @"省";
    } else if (tableView == self.bTableView) {
        if (section != 0) {
            return @"市";
        }
        
    } else if (tableView == self.cTableView) {
        if (section != 0) {
            return @"区";
        }
        
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.aTableView) {
        return 30;
    } else if (tableView == self.bTableView) {
        return section==0?0.01:30;
    } else {
        return section==0?0.01:30;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offY = scrollView.contentOffset.y;
    if (scrollView == self.bTableView) {
        [UIView animateWithDuration:0.1 animations:^{
            if (offY>=44) {
                self.bHeadView.hidden = NO;
            } else {
                self.bHeadView.hidden = YES;
            }
        }];
    } else {
        [UIView animateWithDuration:0.1 animations:^{
            if (offY>=44) {
                self.cHeadView.hidden = NO;
            } else {
                self.cHeadView.hidden = YES;
            }
        }];
        
    }
}
#pragma mark - Lazy
- (QLListSectionIndexView *)indexView {
    if (!_indexView) {
        _indexView = [[QLListSectionIndexView alloc]init];
        _indexView.defaultColor = GreenColor;
        _indexView.relevanceView = self.aTableView;
    }
    return _indexView;
}
- (QLBaseTableView *)aTableView {
    if (!_aTableView) {
        _aTableView = [[QLBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _aTableView.delegate = self;
        _aTableView.dataSource = self;
        [_aTableView registerClass:[QLBrandCell class] forCellReuseIdentifier:@"cell"];
    }
    return _aTableView;
}
- (QLBaseTableView *)bTableView {
    if (!_bTableView) {
        _bTableView = [[QLBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _bTableView.delegate = self;
        _bTableView.dataSource = self;
        [_bTableView registerClass:[QLBrandCell class] forCellReuseIdentifier:@"cell"];
    }
    return _bTableView;
}
- (QLBaseTableView *)cTableView {
    if (!_cTableView) {
        _cTableView = [[QLBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _cTableView.delegate = self;
        _cTableView.dataSource = self;
        [_cTableView registerClass:[QLBrandCell class] forCellReuseIdentifier:@"cell"];
    }
    return _cTableView;
}
- (UIControl *)bHeadView {
    if (!_bHeadView) {
        _bHeadView = [UIControl new];
        _bHeadView.backgroundColor = WhiteColor;
        _bHeadView.hidden = YES;
    }
    return _bHeadView;
}
- (UIControl *)cHeadView {
    if (!_cHeadView) {
        _cHeadView = [UIControl new];
        _cHeadView.backgroundColor = WhiteColor;
        _cHeadView.hidden = YES;
    }
    return _cHeadView;
}

@end
