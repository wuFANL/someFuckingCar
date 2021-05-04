//
//  QLTabBarViewController.m
//  PopularUsedCar
//
//  Created by 乔磊 on 2018/4/13.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLTabBarController.h"
#import "QLHomePageViewController.h"
#import "QLCarSourcePageViewController.h"
#import "QLCarManagerPageViewController.h"
#import "QLCommunicationPageViewController.h"
#import "QLMePageViewController.h"

@interface QLTabBarController ()

@end

@implementation QLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *vcArr = [NSMutableArray array];
    NSMutableArray *titleArr = [NSMutableArray array];
    NSMutableArray *defaultImgArr = [NSMutableArray array];
    NSMutableArray *selectedImgArr = [NSMutableArray array];
    
    //首页
    QLHomePageViewController *homeVC = [QLHomePageViewController new];
    [vcArr addObject:homeVC];
    [titleArr addObject:@"首页"];
    [defaultImgArr addObject:@"home"];
    [selectedImgArr addObject:@"homeSelected"];
    
    //找车源
    if ([[QLToolsManager share].homePageModel getFun:CarSource] != nil) {
        QLCarSourcePageViewController *cspVC = [QLCarSourcePageViewController new];
        [vcArr addObject:cspVC];
        [titleArr addObject:@"找车源"];
        [defaultImgArr addObject:@"carSource"];
        [selectedImgArr addObject:@"carSourceSelected"];
        
    }

    //车辆管理
    if ([[QLToolsManager share].homePageModel getFun:CarManager] != nil) {
        QLCarManagerPageViewController *cmVC = [QLCarManagerPageViewController new];
        [vcArr addObject:cmVC];
        [titleArr addObject:@"车辆管理"];
        [defaultImgArr addObject:@"carManage"];
        [selectedImgArr addObject:@"carManageSelected"];
        
    }
    
    //通讯
    QLCommunicationPageViewController *cpVC = [QLCommunicationPageViewController new];
    [vcArr addObject:cpVC];
    [titleArr addObject:@"通讯"];
    [defaultImgArr addObject:@"message"];
    [selectedImgArr addObject:@"messageSelected"];
    
    //个人中心
    QLMePageViewController *meVC = [QLMePageViewController new];
    [meVC getInfo];
    [vcArr addObject:meVC];
    [titleArr addObject:@"我的"];
    [defaultImgArr addObject:@"me"];
    [selectedImgArr addObject:@"meSelected"];
    
    //设置tabBarItem
    [self setChildControllers:vcArr titles:titleArr defaultImages:defaultImgArr selectedImages:selectedImgArr];
    //点击颜色
    self.itemSelectedColor = GreenColor;
    //阴影
    [self.mainTabBar setShadowPathWith:[UIColor groupTableViewBackgroundColor] shadowOpacity:1 shadowRadius:1 shadowSide:QLShadowPathTop shadowPathWidth:1];
    //tabBar改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarSelected:) name:TabBarChangeKey object:nil];
    
}

#pragma mark -action
- (void)tabBarSelected:(NSNotification *)noti {
    NSDictionary *param = noti.userInfo;
    self.selectedIndex = [param[@"index"] integerValue];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
