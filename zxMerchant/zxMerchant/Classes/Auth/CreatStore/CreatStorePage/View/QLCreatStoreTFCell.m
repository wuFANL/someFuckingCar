//
//  QLCreatStoreTFCell.m
//  PopularUsedCarMerchant
//
//  Created by lei qiao on 2020/9/21.
//  Copyright © 2020 EmbellishJiao. All rights reserved.
//

#import "QLCreatStoreTFCell.h"
@interface QLCreatStoreTFCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *tfView;

@end
@implementation QLCreatStoreTFCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.tfView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    self.tf.delegate = self;
    self.tf.borderStyle = UITextBorderStyleNone;

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.tfView roundRectCornerRadius:2 borderWidth:0.5 borderColor:GreenColor];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self.tfView roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
