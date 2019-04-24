//
//  UIAlertView+Block.m
//  Qqw
//
//  Created by zagger on 16/9/1.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "UIAlertView+Block.h"

@implementation UIAlertView (Block)

+ (id)alertViewWithTitle:(NSString *)title
                 message:(NSString *)message
       cancelButtonTitle:(NSString *)cancelButtonTitle
       otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
            dismissBlock:(UIAlertViewDismissBlock)dismissBlock {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:nil];
    
    for (NSString *str in otherButtonTitles) {
        [alertView addButtonWithTitle:str];
    }
    
    alertView.delegate = alertView;
    alertView.dismissBlock = dismissBlock;
    
    return alertView;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.dismissBlock) {
        __weak UIAlertView *weakAlertView = alertView;
        self.dismissBlock(weakAlertView, buttonIndex);
    }
}


static char const kAlertViewBlockKey = '\0';
- (UIAlertViewDismissBlock)dismissBlock {
    return objc_getAssociatedObject(self, &kAlertViewBlockKey);
}

- (void)setDismissBlock:(UIAlertViewDismissBlock)dismissBlock {
    [self willChangeValueForKey:@"dismissBlock"];
    objc_setAssociatedObject(self, &kAlertViewBlockKey, dismissBlock, OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:@"dismissBlock"];
}

@end
