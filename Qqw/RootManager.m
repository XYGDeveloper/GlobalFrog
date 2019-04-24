//
//  RootManager.m
//  Qqw
//
//  Created by zagger on 16/8/24.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "RootManager.h"

#import "HomepageViewController.h"
#import "DoyenListViewController.h"
#import "QqwPersonalViewController.h"
#import "ShoppingViewController.h"
#import "QqwPersonalDataEditController.h"
#import "AddressViewController.h"
#import "FindViewController.h"
#import "FreshViewController.h"

@interface RootManager ()<UITabBarControllerDelegate>

@property (nonatomic, strong, readwrite) UITabBarController *tabbarController;

@end

@implementation RootManager

+ (instancetype)sharedManager {
    
    static RootManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[RootManager alloc] init];
    });
    return __manager;
    
}

- (void)dealloc {
    [self.tabbarController removeObserver:self forKeyPath:@"selectedIndex"];
}

- (id)init {
    if (self = [super init]) {
        [self initTabbarController];
        
        [self.tabbarController addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selectedIndex"]) {
        NSUInteger oldIndex = [[change objectForKey:NSKeyValueChangeOldKey] integerValue];
        UIViewController *vc = [self.tabbarController.viewControllers safeObjectAtIndex:oldIndex];
        UINavigationController *nav = (UINavigationController *)vc;
        if (nav.viewControllers.count > 1) {
            nav.viewControllers = @[nav.viewControllers.firstObject];
        }
    }
}

- (void)initTabbarController {
    //首页
    HomepageViewController *homepageVC = [[HomepageViewController alloc] initWithURLString:@""];
    [self addTabWithController:homepageVC title:@"首页" image:[UIImage imageNamed:@"tab_homepage_normal"] selectedImage:[UIImage imageNamed:@"tab_homepage_selected"] bageValue:nil];
    
//    DoyenListViewController *findVC = [[DoyenListViewController alloc] init];
//    FindViewController * findVC = [[FindViewController alloc]init];
    
     FreshViewController * findVC = [[FreshViewController alloc]init];
    [self addTabWithController:findVC title:@"蛙鲜生" image:[UIImage imageNamed:@"tab_2"] selectedImage:[UIImage imageNamed:@"tab_1"] bageValue:nil];
    
    ShoppingViewController *cartVC = [[ShoppingViewController alloc] init];
    [self addTabWithController:cartVC title:@"购物车" image:[UIImage imageNamed:@"tab_cart_normal"] selectedImage:[UIImage imageNamed:@"tab_cart_selected"] bageValue:nil];
    
    QqwPersonalViewController *myVC = [[QqwPersonalViewController alloc] init];
    [self addTabWithController:myVC title:@"我的" image:[UIImage imageNamed:@"tab_mine_normal"] selectedImage:[UIImage imageNamed:@"tab_mine_selected"] bageValue:nil];
    
}

- (void)addTabWithController:(UIViewController *)controller
                       title:(NSString *)title
                       image:(UIImage *)image
               selectedImage:(UIImage *)selectedImage
                   bageValue:(NSString *)bageValue{
    
    MyNavigationController *nav = [[MyNavigationController alloc] initWithRootViewController:controller];
    nav.tabBarItem.title = title;
    nav.tabBarItem.badgeValue = bageValue;
    nav.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic safeSetObject:HexColor(0x5e972b) forKey:NSForegroundColorAttributeName];
    [nav.tabBarItem setTitleTextAttributes:dic forState:UIControlStateSelected];
    [self.tabbarController addChildViewController:nav];
    
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *nav = (UINavigationController *)viewController;
        UIViewController *rootVC = [nav.viewControllers firstObject];
        if ([rootVC isKindOfClass:[ShoppingViewController class]]) {//购物车
            return ![Utils showLoginPageIfNeeded];
        }
        
    }
    
    return YES;
}

#pragma mark - Properties
- (UITabBarController *)tabbarController {
    if (!_tabbarController ) {
        _tabbarController = [[UITabBarController alloc] init];
        _tabbarController.delegate = self;
    }
    return _tabbarController;
}


@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.PopDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    NSLog(@"hhhhhhhhhhhhhhhhhhhhhhhhhhhh   %@",[self.viewControllers lastObject]);
//    if ([[self.viewControllers lastObject] isMemberOfClass:[QqwPersonalViewController class]]) {
//        [self setNavigationBarHidden:YES animated:animated];
//    }else{
//        [self setNavigationBarHidden:NO];
//    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = self.PopDelegate;
    }else{
        self.interactivePopGestureRecognizer.delegate = nil;
    }

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
