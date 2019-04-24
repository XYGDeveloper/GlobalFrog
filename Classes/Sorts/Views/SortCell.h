//
//  SortCell.h
//  Qqw
//
//  Created by zagger on 16/8/31.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SortListItem;
@interface SortCell : UITableViewCell

@property (nonatomic, copy) void(^sortJumpBlock)(SortListItem *sortItem);

- (void)refreshWithSortItem:(SortListItem *)sortItem;

+ (CGFloat)heithForSortItem:(SortListItem *)sortItem;

@end




@interface UIButton (Sort)

@property (nonatomic, strong) SortListItem *sortItem;

@end