//
//  UINavigationController+Base.m
//  Qqw
//
//  Created by zagger on 16/8/25.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "UINavigationController+Base.h"
#import <Aspects.h>

@implementation UINavigationController (Base)

- (void)hookViewDidLoad {
    if ([NSStringFromClass([self class]) isEqualToString:@"UINavigationController"]) {
        //配置navigationBar字体颜色和大小
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithCapacity:2];
        [attributes setObject:Font(18) forKey:NSFontAttributeName];
        [attributes setObject:HexColor(0x333333) forKey:NSForegroundColorAttributeName];
        self.navigationBar.titleTextAttributes = attributes;
        //配置navigationBar背景
        [self.navigationBar setTranslucent:YES];
        [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
        
        //配置滑动返回
        self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
}



#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.viewControllers.count > 1;
}
@end
