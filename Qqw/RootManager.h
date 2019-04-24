//
//  RootManager.h
//  Qqw
//
//  Created by zagger on 16/8/24.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QqwPersonalViewController.h"
@interface RootManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong, readonly) UITabBarController *tabbarController;

@end

@interface MyNavigationController : UINavigationController<UINavigationControllerDelegate>

@property (nonatomic, weak) id PopDelegate;

@end
