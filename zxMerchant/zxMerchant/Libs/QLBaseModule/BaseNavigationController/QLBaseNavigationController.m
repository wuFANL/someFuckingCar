//
//  QLBaseNavigationController.m
//  TakeTaxi
//
//  Created by jgs on 17/2/17.
//  Copyright © 2017年 JGS. All rights reserved.
//

#import "QLBaseNavigationController.h"
#import "UIImage+QLUtil.h"


@interface QLBaseNavigationController ()

@end

@implementation QLBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //navigationBar全局设定
    //去掉模糊效果
    [[UINavigationBar appearance] setTranslucent:NO];
    //NavigationBar颜色
    [[UINavigationBar appearance] setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage createImageWithColor:[UIColor clearColor]]];
    //渲染颜色
    [[UINavigationBar appearance] setTintColor:[UIColor darkTextColor]];
    //标题文本颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkTextColor] ,NSFontAttributeName: [UIFont systemFontOfSize:18]}];
    //全局UIBarButtonItem字体大小
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkTextColor] ,NSFontAttributeName: [UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    
    //全局返回无文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1500, 0) forBarMetrics:UIBarMetricsDefault];
}

@end
