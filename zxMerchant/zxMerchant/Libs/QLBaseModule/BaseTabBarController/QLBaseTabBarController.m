//
//  QLBaseTabBarController.m
//  Template
//
//  Created by jgs on 2017/5/27.
//  Copyright © 2017年 QL. All rights reserved.
//

#import "QLBaseTabBarController.h"
#import "QLBaseNavigationController.h"


@interface QLBaseTabBarController ()<QLBaseTabBarDelegate>

@end

@implementation QLBaseTabBarController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    for (UIView *child in self.tabBar.subviews) {
        if (![child isKindOfClass:[QLBaseTabBar class]]) {
            [child removeFromSuperview];
        }
    }
    //导航栏设置
    [self setNavi];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    for (UIView *child in self.tabBar.subviews) {
        if (![child isKindOfClass:[QLBaseTabBar class]]) {
            [child removeFromSuperview];
        }
    }
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    for (UIView *child in self.tabBar.subviews) {
        if (![child isKindOfClass:[QLBaseTabBar class]]) {
            [child removeFromSuperview];
        }
    }
    for (UIViewController *childVC in self.childViewControllers) {
        childVC.view.frame = CGRectMake(0, 0, self.view.width, BottomOffset?self.view.height-44-34:self.view.height-44);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    //解决偏移问题
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //tabBar渲染色
    [self.tabBar setTintColor:[UIColor clearColor]];
    //增加TabBar
    [self setTabBar];
    //监听
    [self addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew context:nil];
    
    
   
}
- (void)setTabBar {
    if (!self.mainTabBar) {
        QLBaseTabBar *tabBar = [[QLBaseTabBar alloc]initWithFrame:self.tabBar.bounds];
        tabBar.itemSelectedColor = _itemSelectedColor;
        tabBar.tbDelegate =self;
        [self.tabBar addSubview:tabBar];
        _mainTabBar = tabBar;
    }
}
- (void)setItemColor:(UIColor *)itemColor {
    _itemColor = itemColor;
    _mainTabBar.itemColor = _itemColor;
}
- (void)setItemSelectedColor:(UIColor *)itemSelectedColor {
    _itemSelectedColor = itemSelectedColor;
    _mainTabBar.itemSelectedColor = _itemSelectedColor;
}
- (void)setShowCenterBtn:(BOOL)showCenterBtn {
    _showCenterBtn = showCenterBtn;
    _mainTabBar.showCenterBtn = _showCenterBtn;
}
- (void)setCenterBtnImageNmae:(NSString *)centerBtnImageNmae {
    _centerBtnImageNmae = centerBtnImageNmae;
    _mainTabBar.centerBtnImageNmae = _centerBtnImageNmae;
}
#pragma mark-  设置子页面
- (void)setChildControllers:(NSArray <UIViewController *> *)childs titles:(NSArray <NSString *> *)titles defaultImages:(NSArray <NSString *> *)imageNames selectedImages:(NSArray <NSString *> *)selectedImageNames {
    
    for (int i = 0; i < childs.count; i++) {
        UIViewController *childVc = childs[i];
        NSString *title = @"";
        NSString *defaultImage = @"";
        NSString *selectedImage = @"";
        if (i < titles.count) {
            title = titles[i];
        }
        if (i < imageNames.count) {
            defaultImage = imageNames[i];
        }
        if (i < selectedImageNames.count) {
            selectedImage = selectedImageNames[i];
        }
        [self setChildVc:childVc title:title image:defaultImage selectedImage:selectedImage];
    }
}

#pragma mark- 增加子页面
- (void)setChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName {
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    childVc.tabBarItem.title = title;
    [self addChildViewController:childVc];
    [self.mainTabBar addTabBarButtonWithTabBarItem:childVc.tabBarItem];

}
#pragma mark- mainTabBar delegate
- (void)tabBar:(QLBaseTabBar *)tabBar didSelectedButtonFrom:(long)fromBtnTag to:(long)toBtnTag{
    if (toBtnTag >= 10) {
        self.selectedIndex = toBtnTag-10;
        
    }
    
}
//监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selectedIndex"]) {
        id newValue = change[NSKeyValueChangeNewKey];
        NSInteger index = [newValue integerValue];
        index = index< self.mainTabBar.tabbarBtnArray.count?index:0;
        [self.mainTabBar btnChange:self.mainTabBar.tabbarBtnArray[index]];
        
        //动态设置导航栏
        [self setNavi];
    }
}
#pragma mark- 设置导航栏
- (void)setNavi {
    //设置导航栏
    if (self.childViewControllers.count>0) {
        self.navigationItem.title = self.childViewControllers[self.selectedIndex].navigationItem.title;
        self.navigationItem.leftBarButtonItems = self.childViewControllers[self.selectedIndex].navigationItem.leftBarButtonItems;
        self.navigationItem.rightBarButtonItems = self.childViewControllers[self.selectedIndex].navigationItem.rightBarButtonItems;
        self.navigationItem.titleView = self.childViewControllers[self.selectedIndex].navigationItem.titleView;
    }
}
- (void)dealloc {
    [self removeObserver:self forKeyPath:@"selectedIndex"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark-  Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
