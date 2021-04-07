//
//  QLSetPwdViewController.m
//  PopularUsedCarMerchant
//
//  Created by lei qiao on 2020/9/2.
//  Copyright © 2020 EmbellishJiao. All rights reserved.
//

#import "QLSetPwdViewController.h"
#import "QLCreatStoreViewController.h"

@interface QLSetPwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *pwdEyeBtn;
@property (weak, nonatomic) IBOutlet UIView *repwdView;
@property (weak, nonatomic) IBOutlet UITextField *repwdTF;
@property (weak, nonatomic) IBOutlet UIButton *repwdEyeBtn;
@property (weak, nonatomic) IBOutlet QLBaseButton *submitBtn;

@end

@implementation QLSetPwdViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0, 0, 15,26);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"grayBack"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];;
    //创建UIBarButtonSystemItemFixedSpace
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width = -15;
    //将两个BarButtonItem都返回给NavigationItem
    self.navigationItem.leftBarButtonItems = @[spaceItem,leftBarBtn];
    
    self.showBackgroundView = NO;
    [self.pwdView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    [self.repwdView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    [self textFieldSet:self.pwdTF];
    [self textFieldSet:self.repwdTF];
    
   
}
#pragma mark- network
- (void)setPwdRequest {
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:UserPath params:@{@"operation_type":@"set_password",@"account_id":self.account_id,@"password":[self.pwdTF.text md5Str]} success:^(id response) {
        [MBProgressHUD showSuccess:@"设置成功"];
        if ([QLUserInfoModel getLocalInfo].business.flag.integerValue == 0) {
            //未绑定店铺
            QLCreatStoreViewController *csVC = [QLCreatStoreViewController new];
            csVC.account_id = self.account_id;
            csVC.backToTab = YES;
            [self.navigationController pushViewController:csVC animated:YES];
        } else {
            //进入首页
            [[QLToolsManager share] getFunData:^(id result, NSError *error) {
                [AppDelegateShare initTabBarVC];
            }];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
#pragma mark- action
- (void)textFieldSet:(UITextField *)TF {
    TF.delegate = self;
    TF.borderStyle = UITextBorderStyleNone;
    [TF addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.pwdTF) {
        [self.pwdView roundRectCornerRadius:2 borderWidth:0.5 borderColor:GreenColor];
        [self.repwdView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    } else {
        [self.pwdView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
        [self.repwdView roundRectCornerRadius:2 borderWidth:0.5 borderColor:GreenColor];
    }
    return YES;
}
- (void)textFieldChange:(UITextField *)textField {
    //登录按钮变化
    if (self.pwdTF.text.length!=0&&self.repwdTF.text.length!=0) {
        self.submitBtn.selected = YES;
    } else {
        self.submitBtn.selected = NO;
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == self.pwdTF) {
        [self.pwdView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    } else {
        [self.repwdView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    }
    return YES;
}
- (IBAction)submitBtnClick:(UIButton *)sender {
    if (self.pwdTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    } else if (self.repwdTF.text.length == 0) {
        [MBProgressHUD showError:@"请再次输入密码"];
        return;
    } else if (![self.pwdTF.text isEqualToString:self.repwdTF.text]) {
        [MBProgressHUD showError:@"两次密码不一致"];
        return;
    } else if (self.account_id.length == 0) {
        [MBProgressHUD showError:@"账户信息缺失"];
        return;
    }
    //设置密码
    [self setPwdRequest];

    
}
//返回
- (void)leftBarBtnClicked {
    if (self.backToTab) {
        [AppDelegateShare initTabBarVC];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
