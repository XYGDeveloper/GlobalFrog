//
//  UIViewController+ViewCtr.m
//  Qqw
//
//  Created by 全球蛙 on 2017/4/5.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "UIViewController+ViewCtr.h"
#import <objc/runtime.h>
#import "UINavigationController+NAV.h"
@implementation UIViewController (ViewCtr)

static char * NavBarAlphaKey = "NavBarAlphaKey";

-(void)setNavBarAlpha:(NSString*)navBarAlpha{
    objc_setAssociatedObject(self, NavBarAlphaKey, navBarAlpha, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self.navigationController setNeedsNavigationBackground:navBarAlpha.floatValue];
}

-(NSString *)navBarAlpha{
    return objc_getAssociatedObject(self, NavBarAlphaKey);
}

@end
