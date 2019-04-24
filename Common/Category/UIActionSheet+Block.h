//
//  UIActionSheet+Block.h
//  Qqw
//
//  Created by zagger on 16/9/6.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIActionSheetDismissBlock)(UIActionSheet *zg_actionSheet, NSInteger buttonIndex);

@interface UIActionSheet (Block)<UIActionSheetDelegate>

+ (instancetype)actionSheetWithTitle:(NSString *)title
                   cancelButtonTitle:(NSString *)cancelButtonTitle
              destructiveButtonTitle:(NSString *)destructiveButtonTitle
                   otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
                        dismissBlock:(UIActionSheetDismissBlock)dismissBlock;

@property (nonatomic, copy) UIActionSheetDismissBlock dismissBlock;

@end
