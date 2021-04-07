//
//  QLLoginViewController.m
//  PopularUsedCar
//
//  Created by 乔磊 on 2018/5/31.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLForgetPwdViewController.h"
#import "QLAgreementDetailViewController.h"

@interface QLForgetPwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation QLForgetPwdViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showBackgroundView = NO;
    //页面设置
    [self.phoneView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    [self.codeView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    [self.codeBtn roundRectCornerRadius:2 borderWidth:1 borderColor:ClearColor];
    [self.pwdView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    [self textFieldSet:self.phoneTF];
    [self textFieldSet:self.codeTF];
    [self textFieldSet:self.pwdTF];
    //获取倒计时时间
    [[QLToolsManager share] codeBtnCountdown:self.codeBtn Pattern:2];
}
#pragma mark -network
//修改密码
- (void)changePwd {
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithParams:@{@"operation_type":@"do_update_merchant_password",@"mobile":self.phoneTF.text,@"password":[self.pwdTF.text md5Str],@"code":self.codeTF.text} success:^(id response) {
        //去登录
        [self goLogin];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
//登录
- (void)goLogin {
    [MBProgressHUD showCustomLoading:@"正在登录中..."];
    [QLNetworkingManager postWithParams:@{@"operation_type":@"do_merchant_login",@"mobile":self.phoneTF.text,@"password":[self.pwdTF.text md5Str]} success:^(id response) {
        //本地保存数据
        [QLUserInfoModel saveUserInfo:response[@"result_info"]];
        //进入首页
        [[QLToolsManager share] getFunData:^(id result, NSError *error) {
            [MBProgressHUD immediatelyRemoveHUD];
            [AppDelegateShare initTabBarVC];
        }];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
#pragma mark -UITextField设置
- (void)textFieldSet:(UITextField *)TF {
    TF.delegate = self;
    TF.borderStyle = UITextBorderStyleNone;
    [TF addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.phoneTF) {
        [self.phoneView roundRectCornerRadius:2 borderWidth:0.5 borderColor:GreenColor];
        [self.codeView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
        [self.pwdView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    } else if (textField == self.codeTF) {
        [self.phoneView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
        [self.codeView roundRectCornerRadius:2 borderWidth:0.5 borderColor:GreenColor];
        [self.pwdView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    } else {
        [self.phoneView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
        [self.codeView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
        [self.pwdView roundRectCornerRadius:2 borderWidth:0.5 borderColor:GreenColor];
    }
    return YES;
}
- (void)textFieldChange:(UITextField *)textField {
    //登录按钮变化
    if (self.phoneTF.text.length!=0&&self.codeTF.text.length!=0&&self.pwdTF.text.length!=0) {
        self.loginBtn.selected = YES;
    } else {
        self.loginBtn.selected = NO;
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == self.phoneTF) {
        [self.phoneView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    } else if (textField == self.codeTF) {
        [self.codeView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    } else {
        [self.pwdView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    }
    return YES;
}
- (IBAction)codeBtnClick:(UIButton *)sender {
    if (self.phoneTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    } else if ([NSString phoneNumAuthentication:self.phoneTF.text] == NO) {
        [MBProgressHUD showError:@"请输入正确手机号"];
        return;
    }
    [QLNetworkingManager postWithParams:@{@"operation_type":@"send_verification_code",@"mobile":self.phoneTF.text} success:^(id response) {
        [[QLToolsManager share] codeBtnCountdown:sender Pattern:1];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
    
}
- (IBAction)loginBtnClick:(UIButton *)sender {
    if (sender.selected == NO) {
        return;
    } else if (self.phoneTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    } else if ([NSString phoneNumAuthentication:self.phoneTF.text] == NO) {
        [MBProgressHUD showError:@"请输入正确手机号"];
        return;
    } else if (self.codeTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    } else if (self.pwdTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入新密码"];
        return;
    } else if (self.pwdTF.text.length < passwordLeastLength) {
        [MBProgressHUD showError:StringWithFormat(@"密码至少%d位", passwordLeastLength)];
        return;
    }
    [self.view endEditing:YES];
    //修改密码
    [self changePwd];
    
}
- (IBAction)agreementBtnClick:(id)sender {
    QLAgreementDetailViewController *adVC = [QLAgreementDetailViewController new];
    adVC.naviTitle = @"用户使用协议";
    adVC.serialNum = @"501";
    [self.navigationController pushViewController:adVC animated:YES];
}
- (IBAction)privacyBtnClick:(id)sender {
    QLAgreementDetailViewController *adVC = [QLAgreementDetailViewController new];
    adVC.naviTitle = @"隐私权条款";
    adVC.serialNum = @"504";
    [self.navigationController pushViewController:adVC animated:YES];
}
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
