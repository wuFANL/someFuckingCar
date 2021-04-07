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
