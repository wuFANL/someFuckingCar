//
//  QLLoginViewController.m
//  PopularUsedCar
//
//  Created by 乔磊 on 2018/5/31.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLLoginViewController.h"
#import "QLForgetPwdViewController.h"
#import "QLSetPwdViewController.h"
#import "QLCreatStoreViewController.h"
#import "QLAgreementDetailViewController.h"

@interface QLLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLB;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getCodeBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getCodeBtnLeft;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeWayBtn;

@end

@implementation QLLoginViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    //检查输入框
    [self textFieldChange:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showBackgroundView = NO;
    //页面设置
    [self.phoneView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    [self.codeView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    [self textFieldSet:self.phoneTF];
    [self textFieldSet:self.codeTF];
    [self changeWayBtnClick:self.changeWayBtn];
    //获取倒计时时间
    [[QLToolsManager share] codeBtnCountdown:self.getCodeBtn Pattern:2];
    
    self.phoneTF.text = @"15859359999";//15066655192
    self.codeTF.text = @"123456";
}
#pragma mark- network
//验证码登录
- (void)codeLoginRequest {
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:UserPath params:@{@"operation_type":@"login_code",@"mobile":self.phoneTF.text,@"code":self.codeTF.text} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        //数据本地保存
        [QLUserInfoModel saveUserInfo:response[@"result_info"]];
        //成功登录
        [self loginSuccess];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
//密码登录请求
- (void)pwdLoginRequest {
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:UserPath params:@{@"operation_type":@"login_password",@"mobile":self.phoneTF.text,@"password":[self.codeTF.text md5Str]} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        //数据本地保存
        [QLUserInfoModel saveUserInfo:response[@"result_info"]];
        //成功登录
        [self loginSuccess];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
#pragma mark- action
- (void)loginSuccess {
    //注册极光
    [JPUSHService setAlias:[QLUserInfoModel getLocalInfo].account.account_id completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        QLLog(@"别名注册成功-%@",iAlias);
        
    } seq:VersionId.integerValue];

    //显示逻辑
    if ([QLUserInfoModel getLocalInfo].account.pwd_flag.integerValue == 0) {
        //未设置密码
        QLSetPwdViewController *spVC = [QLSetPwdViewController new];
        spVC.account_id = [QLUserInfoModel getLocalInfo].account.account_id;
        spVC.backToTab = YES;
        [self.navigationController pushViewController:spVC animated:YES];
    } else if ([QLUserInfoModel getLocalInfo].business.flag.integerValue == 0) {
        //未绑定店铺
        QLCreatStoreViewController *csVC = [QLCreatStoreViewController new];
        csVC.account_id = [QLUserInfoModel getLocalInfo].account.account_id;
        csVC.backToTab = YES;
        [self.navigationController pushViewController:csVC animated:YES];
    } else {
        //进入首页
        [[QLToolsManager share] getFunData:^(id result, NSError *error) {
            [MBProgressHUD immediatelyRemoveHUD];
            [AppDelegateShare initTabBarVC];
        }];
    }

}
//输入框设置
- (void)textFieldSet:(UITextField *)TF {
    TF.delegate = self;
    TF.borderStyle = UITextBorderStyleNone;
    [TF addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.phoneTF) {
        [self.phoneView roundRectCornerRadius:2 borderWidth:0.5 borderColor:GreenColor];
        [self.codeView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    } else {
        [self.phoneView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
        [self.codeView roundRectCornerRadius:2 borderWidth:0.5 borderColor:GreenColor];
    }
    return YES;
}
- (void)textFieldChange:(UITextField *)textField {
    //登录按钮变化
    if (self.phoneTF.text.length!=0&&self.codeTF.text.length!=0) {
        self.loginBtn.selected = YES;
    } else {
        self.loginBtn.selected = NO;
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == self.phoneTF) {
        [self.phoneView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    } else {
        [self.codeView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    }
    return YES;
}
//忘记密码
- (IBAction)forgetPwdBtnClick:(id)sender {
    QLForgetPwdViewController *fpVC = [QLForgetPwdViewController new];
    [self.navigationController pushViewController:fpVC animated:YES];
    
}
//登录
- (IBAction)loginBtnClick:(UIButton *)sender {
    if (sender.selected == NO) {
        return;
    } else if (self.phoneTF.text.length == 0) {
        [MBProgressHUD showError:self.changeWayBtn.selected?@"请输入账号":@"请输入手机号"];
        return;
    } else if (self.codeTF.text.length == 0) {
        [MBProgressHUD showError:self.changeWayBtn.selected?@"请输入密码":@"请输入验证码"];
        return;
    }
    [self.view endEditing:YES];
    //登录请求
    if (self.changeWayBtn.selected) {
        //账户密码登录
        [self pwdLoginRequest];
    } else {
        //验证码登录
        [self codeLoginRequest];
    }
    
}
- (IBAction)getCodeBtnClick:(UIButton *)sender {
    if (self.phoneTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    } else if ([NSString phoneNumAuthentication:self.phoneTF.text] == NO) {
        [MBProgressHUD showError:@"请输入正确手机号"];
        return;
    }
    [[QLToolsManager share] getCodeByMobile:self.phoneTF.text handler:^(id result, NSError *error) {
        if (!error) {
            [[QLToolsManager share] codeBtnCountdown:sender Pattern:1];
        } else {
            [MBProgressHUD showError:error.domain];
        }
    }];
}
- (IBAction)changeWayBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        self.titleLB.text = @"账号登录";
        self.placeholderLB.text = @"若您要加入一个门店,请联系门店管理员添加账号";
        self.getCodeBtn.hidden = YES;
        self.getCodeBtnWidth.constant = 0;
        self.getCodeBtnLeft.constant = 0;
        self.phoneTF.placeholder = @"手机号/账号";
        self.codeTF.placeholder = @"密码";
        self.codeTF.secureTextEntry = YES;
    } else {
        self.titleLB.text = @"验证码登录";
        self.placeholderLB.text = @"无需注册,输入验证码通过后自动注册";
        self.getCodeBtn.hidden = NO;
        self.getCodeBtnWidth.constant = 95;
        self.getCodeBtnLeft.constant = 10;
        self.phoneTF.placeholder = @"手机号/账号";
        self.codeTF.placeholder = @"验证码";
        self.codeTF.secureTextEntry = NO;
    }
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
- (IBAction)closeBtnClick:(id)sender {
    
    [AppDelegateShare initTabBarVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
