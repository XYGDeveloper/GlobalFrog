//
//  UIAlertView+Block.h
//  Qqw
//
//  Created by zagger on 16/9/1.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIAlertViewDismissBlock)(UIAlertView *zg_alertView, NSInteger buttonIndex);

@interface UIAlertView (Block)<UIAlertViewDelegate>

+ (id)alertViewWithTitle:(NSString *)title
                 message:(NSString *)message
       cancelButtonTitle:(NSString *)cancelButtonTitle
       otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
            dismissBlock:(UIAlertViewDismissBlock)dismissBlock;

@property (nonatomic, copy) UIAlertViewDismissBlock dismissBlock;

@end
