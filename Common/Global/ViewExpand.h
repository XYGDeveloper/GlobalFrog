//
//  ViewExpand.h
//  Qqw
//
//  Created by 全球蛙 on 2017/3/15.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (Tags)

- (CGFloat)addTagLabels:(NSArray *)tags target:(id)target action:(SEL)action;

- (void)removeAllTagLabels;

@end
