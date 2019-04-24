//
//  LoadingView.h
//  Qqw
//
//  Created by zagger on 16/9/1.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

+ (instancetype)generalLoadingView;

- (void)setAnimationDuration:(NSTimeInterval)duration;
- (void)setGifImages:(NSArray<UIImage *> *)images;

@end
