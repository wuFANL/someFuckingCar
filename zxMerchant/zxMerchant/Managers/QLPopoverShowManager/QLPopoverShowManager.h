//
//  QLPopoverShowManager.h
//  QLKit
//
//  Created by 乔磊 on 2018/1/9.
//  Copyright © 2018年 NineZero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QLBasePopViewControl.h"
@interface QLPopoverShowManager : NSObject
/*
 *显示 QLBasePopViewControl
 *重点：必须重写adaptivePresentationStyleForPresentationController方法返回UIModalPresentationNone，不然无法使用
 *@param    dataArr:数据
 *@param    sourceView:内容区域
 *@param    arrowDirection:方向
 *@param    backgroundColor:背景色
 *@param    delegate:UIPopoverPresentationControllerDelegate
 */
+ (QLBasePopViewControl *)showPopover:(NSArray *)dataArr areaView:(UIView *)sourceView direction:(UIPopoverArrowDirection)arrowDirection backgroundColor:(UIColor *)backgroundColor delegate:(id <UIPopoverPresentationControllerDelegate,PopViewControlDelegate>)object;
@end
