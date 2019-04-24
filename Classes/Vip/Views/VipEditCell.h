//
//  VipEditCell.h
//  Qqw
//
//  Created by zagger on 16/8/27.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VipEditCell : UITableViewCell

@property (nonatomic, strong, readonly) UIImage *normalImage;
@property (nonatomic, strong, readonly) UIImage *editedImage;
@property (nonatomic, strong, readonly) UIImageView *iconView;
@property (nonatomic, strong, readonly) UITextField *textField;

@property (nonatomic, assign) NSInteger maxEditCount;

@property (nonatomic, copy) void(^contentChangedBlock)();

@property (nonatomic, copy) NSString *text;

//设置是否可以编辑，默认为YES
- (void)setEditAble:(BOOL)editAble;

- (void)setIcon:(UIImage *)image editedIcon:(UIImage *)editedImage placeholder:(NSString *)placeholder;

@end
