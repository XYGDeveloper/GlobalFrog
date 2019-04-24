//
//  StarView.h
//  Qqw
//
//  Created by zagger on 16/8/29.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  评价时的五颗星
 */
@interface StarView : UIView

@property (nonatomic, assign) NSInteger star;

@property (nonatomic, copy) void(^starDidChangeBlock)(NSInteger star);

+ (instancetype)generalStarView;

@end
