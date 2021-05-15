//
//  QLAddCustomerViewController.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/22.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLAddCustomerViewController.h"
#import "QLContentTFCell.h"
#import "QLSubListTitleCell.h"
#import "QLChooseBrandViewController.h"
#import "QLChooseTimeView.h"

@interface QLAddCustomerViewController ()<UITableViewDelegate,UITableViewDataSource,QLIrregularLayoutDataSource,UICollectionViewDelegate,UICollectionViewDataSource,QLBaseTextViewDelegate>
@property (nonatomic, strong) QLBaseTableView *tableView;
@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation QLAddCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.isAdd?@"新建客户":@"修改客户";
    //提交按钮
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(BottomOffset?-34:0);
        make.height.mas_equalTo(44);
    }];
    //tableView
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.equalTo(self.view);
        make.bottom.equalTo(self.submitBtn.mas_top);
    }];
    
   
}
#pragma mark- network

#pragma mark- action
//输入框变化
- (void)textChange:(UITextField *)tf {
    NSInteger section = tf.tag/100;
    NSInteger row = tf.tag%100;
  
    
}
//输入栏
- (void)textViewTextChange:(UITextView *)textView {
 
}

//提交
- (void)submitBtnClick {
   
    
    
}

//客户需求
- (void)accBtnClick:(UIButton *)sender {
    
}
#pragma mark- tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section==0?4:1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row != 3) {
            QLContentTFCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tfCell" forIndexPath:indexPath];
            cell.contentTF.keyboardType = UIKeyboardTypeDefault;
            cell.contentTF.tag = indexPath.section*100+indexPath.row;
            if (indexPath.row == 0) {
                cell.titleLB.text = @"手机号";
                cell.contentTF.placeholder = @"请输入手机号";
                cell.contentTF.keyboardType = UIKeyboardTypePhonePad;
               
            } else if (indexPath.row == 1) {
                cell.titleLB.text = @"微信号";
                cell.contentTF.placeholder = @"请输入微信号";
               
            } else {
                cell.titleLB.text = @"姓名";
                cell.contentTF.placeholder = @"请输入姓名";
                
            }
            [cell.contentTF addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
            return cell;
        } else {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            
            QLBaseTextView *tv = [cell.contentView viewWithTag:100+indexPath.row];
            if (!tv) {
                tv = [QLBaseTextView new];
                tv.tag = 100+indexPath.row;
                tv.placeholder = @"备注";
                tv.countLimit = 200;
                tv.constraintLB.text = @"(0/200)";
                tv.tvDelegate = self;
            }

            [cell.contentView addSubview:tv];
            [tv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(5, 10, 5, 10));
                make.height.mas_equalTo(145);
            }];
            return cell;
        }
        
    } else {
        QLSubListTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subListTitleCell" forIndexPath:indexPath];
        cell.iconArr = [@[@"1",@"2",@"3"] mutableCopy];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *titleLB = [UILabel new];
    titleLB.font = [UIFont systemFontOfSize:14];
    titleLB.textColor = [UIColor lightGrayColor];
    titleLB.text = section==0?@"客户基本资料":@"客户需求";
    [headerView addSubview:titleLB];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(15);
        make.centerY.equalTo(headerView);
    }];
    
    UIButton *accBtn = [UIButton new];
    accBtn.hidden = section==0?YES:NO;
    [accBtn setImage:[UIImage imageNamed:@"reportAcc_selected"] forState:UIControlStateNormal];
    [accBtn addTarget:self action:@selector(accBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:accBtn];
    [accBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-15);
        make.width.height.mas_equalTo(30);
        make.centerY.equalTo(headerView);
    }];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row == 3) {
            return 120;
        } else {
            return 45;
        }
    } else {
        return  90;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

#pragma mark- lazyLoading
- (QLBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[QLBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource= self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"QLContentTFCell" bundle:nil] forCellReuseIdentifier:@"tfCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"QLSubListTitleCell" bundle:nil] forCellReuseIdentifier:@"subListTitleCell"];
    }
    return _tableView;
}
- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton new];
        [_submitBtn setBackgroundColor:GreenColor];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_submitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
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
