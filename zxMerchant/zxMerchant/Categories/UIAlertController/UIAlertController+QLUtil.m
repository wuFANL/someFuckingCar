//
//  UIAlertController+QLUtil.m
//  MoneyTree
//
//  Created by 乔磊 on 2017/12/27.
//  Copyright © 2017年 gengjf. All rights reserved.
//

#import "UIAlertController+QLUtil.h"

@implementation UIAlertController (QLUtil)
+ (UIAlertController *)showAlertController:(UIAlertControllerStyle)style Title:(NSString *)title DetailTitle:(NSString *)detail DefaultTitle:(NSArray <NSString *>*)defaultTitle CancelTitle:(NSString *)cancelTitle Delegate:(id)vc DefaultAction:(void(^)(NSString *selectedTitle))defaultAction CancelAction:(void (^)(void))cancelAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:detail preferredStyle:style];
    for (NSString *title in defaultTitle) {
        UIAlertAction *YESAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            defaultAction(action.title);
        }];
        [alert addAction:YESAction];
    }
    UIAlertAction *NOAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancelAction();
    }];
    [alert addAction:NOAction];
    if (vc != nil) {
        if ([vc isKindOfClass:[UIViewController class]]) {
            [vc presentViewController:alert animated:YES completion:nil];
        } else {
            QLLog(@"无法推出提示框");
        }
        
    } else {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    
    
    return alert;
}

- (void)setActionTextColor:(UIColor *)textColor {
    if (textColor) {
        for (UIAlertAction *action in self.actions) {
            [action setValue:textColor forKey:@"titleTextColor"];
        }
    }
}
@end
