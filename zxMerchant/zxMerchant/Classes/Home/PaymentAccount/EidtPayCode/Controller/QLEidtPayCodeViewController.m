//
//  QLEidtPayCodeViewController.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/28.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLEidtPayCodeViewController.h"
#import "QLEidtPayCodeCell.h"

@interface QLEidtPayCodeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLBaseTableView *tableView;

@end

@implementation QLEidtPayCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑二维码";
    //tableView
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark- network
//保存图片
- (void)saveRequest:(NSInteger)type image:(UIImage *)img {
//    [MBProgressHUD showCustomLoading:nil];
//    [[QLOSSManager shared] asyncUploadImage:img complete:^(NSArray *names, UploadImageState state) {
//        if (state == UploadImageSuccess) {
//            [QLNetworkingManager postWithUrl:LoanPath params:@{@"operation_type":@"save_pay_url",@"pay_url":names.firstObject,@"type":@(type),@"sub_id":[QLUserInfoModel getLocalInfo].merchant_staff.sub_id,@"member_id":[QLUserInfoModel getLocalInfo].merchant_staff.member_id} success:^(id response) {
//                [MBProgressHUD immediatelyRemoveHUD];
//                if (type == 1) {
//                    self.model.merchant_account.alipay_url = names.firstObject;
//                } else {
//                    self.model.merchant_account.weixpay_url = names.firstObject;
//                }
//                [self.tableView reloadData];
//            } fail:^(NSError *error) {
//                [MBProgressHUD showError:error.domain];
//            }];
//        } else {
//            [MBProgressHUD showError:@"图片上传失败"];
//        }
//    }];
}
//删除图片
- (void)deleteRequest:(NSInteger)type {
//    [MBProgressHUD showCustomLoading:nil];
//    [QLNetworkingManager postWithUrl:LoanPath params:@{@"operation_type":@"remove_pay_url",@"type":@(type),@"sub_id":[QLUserInfoModel getLocalInfo].merchant_staff.sub_id,@"member_id":[QLUserInfoModel getLocalInfo].merchant_staff.member_id} success:^(id response) {
//        [MBProgressHUD immediatelyRemoveHUD];
//        if (type == 1) {
//            self.model.merchant_account.alipay_url = @"";
//        } else {
//            self.model.merchant_account.weixpay_url = @"";
//        }
//        [self.tableView reloadData];
//    } fail:^(NSError *error) {
//        [MBProgressHUD showError:error.domain];
//    }];
}
#pragma mark- action
//选择图片
- (void)chooseImg:(UIControl *)sender {
    NSInteger row = sender.tag;
    [self openPhoto:row+1];
}
//编辑
- (void)editBtnClick:(UIButton *)sender {
    NSInteger row = sender.tag;
    [self openPhoto:row+1];
}
//打开图片选择器
- (void)openPhoto:(NSInteger)type {
    [[QLToolsManager share] getPhotoAlbum:self resultBack:^(UIImagePickerController *picker, NSDictionary *info) {
        UIImage *img = info[UIImagePickerControllerOriginalImage];
        [self saveRequest:type image:img];
    }];
}
//删除
- (void)deleteBtnClick:(UIButton *)sender {
    NSInteger row = sender.tag;
    [[QLToolsManager share] alert:@"确认删除？" handler:^(NSError *error) {
        if (!error) {
            [self deleteRequest:(row+1)];
        }
    }];
}
#pragma mark- tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLEidtPayCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editCell" forIndexPath:indexPath];
    cell.editBtn.tag = indexPath.row;
    cell.deleteBtn.tag = indexPath.row;
    cell.imgControl.tag = indexPath.row;
    cell.titleLB.text = indexPath.row==0?@"支付宝收款码":@"微信收款码";
    [cell.imgControl addTarget:self action:@selector(chooseImg:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row == 0) {
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.model.merchant_account.alipay_url] placeholderImage:[UIImage imageNamed:@"addImg"]];
    } else {
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.model.merchant_account.weixpay_url] placeholderImage:[UIImage imageNamed:@"addImg"]];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 195;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
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
        [_tableView registerNib:[UINib nibWithNibName:@"QLEidtPayCodeCell" bundle:nil] forCellReuseIdentifier:@"editCell"];

    }
    return _tableView;
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
