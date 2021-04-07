//
//  QLPopoverShowManager.m
//  QLKit
//
//  Created by 乔磊 on 2018/1/9.
//  Copyright © 2018年 NineZero. All rights reserved.
//

#import "QLPopoverShowManager.h"
@interface QLPopoverShowManager()
@end
@implementation QLPopoverShowManager
+ (QLBasePopViewControl *)showPopover:(NSArray *)dataArr areaView:(UIView *)sourceView direction:(UIPopoverArrowDirection)arrowDirection backgroundColor:(UIColor *)backgroundColor delegate:(id <UIPopoverPresentationControllerDelegate,PopViewControlDelegate>)object {
    //1.获取要弹出的控制器
    QLBasePopViewControl *pop = [QLBasePopViewControl new];
    pop.dataArray = dataArr;
    //2.设置一些属性
    pop.modalPresentationStyle = UIModalPresentationPopover;//带anchor锚点的样式
    //指向相对显示区域
    pop.popoverPresentationController.sourceView = sourceView;
    //指定相对于Button具体位置
    pop.popoverPresentationController.sourceRect = sourceView.bounds;
    //箭头的显示方向（默认指定Any枚举值：自动找最优的方向）
    if (arrowDirection) {
        pop.popoverPresentationController.permittedArrowDirections = arrowDirection;
    }
    pop.popoverPresentationController.backgroundColor = backgroundColor;
    if ([object isKindOfClass:[UIViewController class]]) {
        UIViewController <UIPopoverPresentationControllerDelegate,PopViewControlDelegate>*vc = (UIViewController <UIPopoverPresentationControllerDelegate,PopViewControlDelegate>*)object;
        //设置代理（iPhone需要；iPad不需要）
        pop.popoverPresentationController.delegate = vc;
        
        //代理
        pop.delegate = vc;
        //3.显示弹出控制器
        [vc presentViewController:pop animated:YES completion:nil];
    }
    
    
    return pop;
}

@end
