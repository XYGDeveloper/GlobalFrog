//
//  ShareManager.h
//  Qqw
//
//  Created by zagger on 16/8/30.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareManager : NSObject

+ (void)shareWithType:(NSString *)type
           identifier:(NSString *)identifier
     inViewController:(UIViewController *)viewController;


+ (void)shareWithUrl:(NSString*)url img:(UIImage*)img viewController:(UIViewController *)viewController;

@end
