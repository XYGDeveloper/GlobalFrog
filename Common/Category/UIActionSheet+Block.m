//
//  UIActionSheet+Block.m
//  Qqw
//
//  Created by zagger on 16/9/6.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "UIActionSheet+Block.h"

@implementation UIActionSheet (Block)

+ (instancetype)actionSheetWithTitle:(NSString *)title
                   cancelButtonTitle:(NSString *)cancelButtonTitle
              destructiveButtonTitle:(NSString *)destructiveButtonTitle
                   otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
                        dismissBlock:(UIActionSheetDismissBlock)dismissBlock {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:nil
                                                    cancelButtonTitle:cancelButtonTitle
                                               destructiveButtonTitle:destructiveButtonTitle
                                                    otherButtonTitles:nil];
    
    for (NSString *str in otherButtonTitles) {
        [actionSheet addButtonWithTitle:str];
    }
    
    actionSheet.delegate = actionSheet;
    actionSheet.dismissBlock = dismissBlock;
    
    return actionSheet;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.dismissBlock) {
        __weak UIActionSheet *weakActionSheet = actionSheet;
        self.dismissBlock(weakActionSheet,buttonIndex);
    }
}


static char const kActionSheetBlockKey = '\0';
- (UIActionSheetDismissBlock)dismissBlock {
    return objc_getAssociatedObject(self, &kActionSheetBlockKey);
}

- (void)setDismissBlock:(UIActionSheetDismissBlock)dismissBlock {
    [self willChangeValueForKey:@"dismissBlock"];
    objc_setAssociatedObject(self, &kActionSheetBlockKey, dismissBlock, OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:@"dismissBlock"];
}

@end
