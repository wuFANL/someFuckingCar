//
//  QLSubmitSuccessViewController.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2018/11/2.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLSubmitSuccessViewController.h"

@interface QLSubmitSuccessViewController ()
@property (weak, nonatomic) IBOutlet UILabel *successLB;
@property (weak, nonatomic) IBOutlet UILabel *centerLB;
@property (weak, nonatomic) IBOutlet UILabel *detailLB;
@end

@implementation QLSubmitSuccessViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    if (self.topText != nil) {
        self.successLB.text = self.topText;
    }
    if (self.centerText != nil) {
        self.centerLB.text = self.centerText;
    }
    if (self.bottomText != nil) {
        self.detailLB.text = self.bottomText;
    }
}
#pragma mark- action
//返回
- (BOOL)navigationShouldPopOnBackButton {
   
    return YES;
}

@end
