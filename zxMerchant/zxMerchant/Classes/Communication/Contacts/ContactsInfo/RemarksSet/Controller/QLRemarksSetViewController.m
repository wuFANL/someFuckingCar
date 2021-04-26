//
//  QLRemarksSetViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/12.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLRemarksSetViewController.h"

@interface QLRemarksSetViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *tfView;
@property (weak, nonatomic) IBOutlet UITextField *remarksTF;
@property (weak, nonatomic) IBOutlet QLBaseButton *finishBtn;

@end

@implementation QLRemarksSetViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tfView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    
    self.remarksTF.delegate = self;
    self.remarksTF.borderStyle = UITextBorderStyleNone;
    [self.remarksTF addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}
#pragma mark - action
//完成
- (IBAction)finishBtnClick:(id)sender {
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:FirendPath params:@{@"operation_type":@"remark",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"to_account_id":self.firendId,@"remark":self.remarksTF.text} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        [MBProgressHUD showSuccess:@"设置成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
    
}
//输入框开始编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.tfView roundRectCornerRadius:2 borderWidth:0.5 borderColor:GreenColor];
    return YES;
}
////输入框正在编辑
- (void)textFieldChange:(UITextField *)textField {
    if (self.remarksTF.text.length != 0) {
        self.finishBtn.selected = YES;
    } else {
        self.finishBtn.selected = NO;
    }
}
//输入框结束编辑
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self.tfView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    return YES;
}


@end
