//
//  QLEditAccountViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/12/24.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLEditAccountViewController.h"

@interface QLEditAccountViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *accountLB;
@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UIView *reAccountView;
@property (weak, nonatomic) IBOutlet UITextField *reAccountTF;
@property (weak, nonatomic) IBOutlet QLBaseButton *submitBtn;

@end

@implementation QLEditAccountViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.accountView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    [self.reAccountView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
   
    [self textFieldSet:self.accountTF];
    [self textFieldSet:self.reAccountTF];
    
}
#pragma mark - textField
//输入框设置
- (void)textFieldSet:(UITextField *)TF {
    TF.delegate = self;
    TF.borderStyle = UITextBorderStyleNone;
    [TF addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.accountTF) {
        [self.accountView roundRectCornerRadius:2 borderWidth:0.5 borderColor:GreenColor];
        
        [self.reAccountView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
       
    } else if (textField == self.reAccountTF) {
        [self.reAccountView roundRectCornerRadius:2 borderWidth:0.5 borderColor:GreenColor];
        
        [self.accountView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
        
    }
    return YES;
}
- (void)textFieldChange:(UITextField *)textField {
    //登录按钮变化
    if (self.accountTF.text.length!=0&&self.reAccountTF.text.length!=0) {
        self.submitBtn.selected = YES;
    } else {
        self.submitBtn.selected = NO;
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == self.accountTF) {
        [self.accountView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    } else if (textField == self.reAccountTF) {
        [self.reAccountView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    }
    return YES;
}
#pragma mark - action
- (IBAction)submitBtnClick:(id)sender {
    
    
}

- (IBAction)closeBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
