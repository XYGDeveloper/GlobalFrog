//
//  FilterSheet.h
//  Qqw
//
//  Created by zagger on 16/9/9.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterSheet : UIView

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign, readonly) BOOL isShowing;

@property (nonatomic, copy) void(^selectedChangedBlock)(NSInteger selectedIndex);

- (void)showOnView:(UIView *)parentView;

- (void)dismiss;

@end






@interface FilterSheetCell : UITableViewCell

- (void)refreshWithName:(NSString *)name selected:(BOOL)selected;

@end