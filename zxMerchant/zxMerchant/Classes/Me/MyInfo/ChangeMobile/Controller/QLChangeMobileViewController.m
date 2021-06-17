//
//  QLChangeMobileViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/12/23.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLChangeMobileViewController.h"

@interface QLChangeMobileViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *oldAccountView;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIView *mobileView;
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet QLBaseButton *confirmBtn;

@end

@implementation QLChangeMobileViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //页面设置
    [self.oldAccountView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    [self.pwdView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    [self.mobileView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    [self.codeView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    [self textFieldSet:self.accountTF];
    [self textFieldSet:self.pwdTF];
    [self textFieldSet:self.mobileTF];
    [self textFieldSet:self.codeTF];
    
    
}
#pragma mark - action
//确认
- (IBAction)confirmBtnClick:(id)sender {
    [MBProgressHUD showLoading:nil];
    WEAKSELF
    [QLNetworkingManager postWithUrl:UserPath params:@{
        Operation_type:@"change_mobile",
        @"account_id":[QLUserInfoModel getLocalInfo].account.account_id,
        @"account_number":[QLUserInfoModel getLocalInfo].account.account_number,
        @"password":[self.pwdTF.text md5Str],
        @"mobile":self.mobileTF.text,
        @"code":self.codeTF.text
    } success:^(id response) {
        [MBProgressHUD showSuccess:@"更换成功"];
        // 更新
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QLMyInfoPageViewControllerRefresh" object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
//获取验证码
- (IBAction)getCodeBtnClick:(UIButton *)sender {
    WEAKSELF
    [[QLToolsManager share] getCodeByMobile:self.mobileTF.text handler:^(id result, NSError *error) {
        if (!error) {
            [[QLToolsManager share] codeBtnCountdown:weakSelf.getCodeBtn Pattern:1];
        } else {
            [MBProgressHUD showError:error.domain];
        }
    }];
}
//退出
- (IBAction)closeBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
//输入框设置
- (void)textFieldSet:(UITextField *)TF {
    TF.delegate = self;
    TF.borderStyle = UITextBorderStyleNone;
    [TF addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.accountTF) {
        [self.oldAccountView roundRectCornerRadius:2 borderWidth:0.5 borderColor:GreenColor];
        
        [self.pwdView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
        [self.mobileView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
        [self.codeView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    } else if (textField == self.pwdTF) {
        [self.pwdView roundRectCornerRadius:2 borderWidth:0.5 borderColor:GreenColor];
        
        [self.oldAccountView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
        [self.mobileView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
        [self.codeView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    } else if (textField == self.mobileTF) {
        [self.mobileView roundRectCornerRadius:2 borderWidth:0.5 borderColor:GreenColor];
        
        [self.oldAccountView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
        [self.pwdView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
        [self.codeView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    } else {
        [self.codeView roundRectCornerRadius:2 borderWidth:0.5 borderColor:GreenColor];
        
        [self.oldAccountView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
        [self.pwdView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
        [self.mobileView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    }
    return YES;
}
- (void)textFieldChange:(UITextField *)textField {
    //登录按钮变化
    if (self.accountTF.text.length!=0&&self.pwdTF.text.length!=0&&self.mobileTF.text.length!=0&&self.codeTF.text.length!=0) {
        self.confirmBtn.selected = YES;
    } else {
        self.confirmBtn.selected = NO;
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == self.accountTF) {
        [self.oldAccountView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    } else if (textField == self.pwdTF) {
        [self.pwdView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    } else if (textField == self.mobileTF) {
        [self.mobileView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    } else {
        [self.codeView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    }
    return YES;
}

@end
