//
//  UIViewController+Base.h
//  Qqw
//
//  Created by zagger on 16/8/25.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Base)

- (void)hiddenNavigationControllerBar;
/**
 *  以下三个方法功能为添加导航栏左边的操作按钮
 */
- (UIButton *)setLeftNavigationItemWithTitle:(NSString *)title action:(SEL)action;
- (UIButton *)setLeftNavigationItemWithImage:(UIImage *)image highligthtedImage:(UIImage *)highlightedImage action:(SEL)action;
- (void)setLeftNavigationItems:(NSArray<UIView *> *)items;

/**
 *  以下三个方法功能为添加导航栏右边的操作按钮
 */
- (UIButton *)setRightNavigationItemWithTitle:(NSString *)title action:(SEL)action;
- (UIButton *)setRightNavigationItemWithImage:(UIImage *)image highligthtedImage:(UIImage *)highlightedImage action:(SEL)action;
- (void)setRightNavigationItems:(NSArray<UIView *> *)items;

- (UIView *)setTitleViewWithImage:(UIImage *)image;

/**
 *  倒计时导航按钮（中间按钮）
 */
- (UIView *)setNavigationTitleViewWithView:(NSString *)title  timerWithTimer:(NSString *)timer;


- (UIView *)setNavigationtitleView:(UIView *)titleView;

/**
 *  以下两个方法功能为通过题或图片自定义导航栏操作按钮
 */
- (UIButton *)navigationButtonWithTitle:(NSString *)title action:(SEL)action;
- (UIButton *)navigationButtonWithImage:(UIImage *)image highligthtedImage:(UIImage *)highlightedImage action:(SEL)action;

/**
 *  点击返回按钮时的响应方法，默认执行pop操作，子类可以覆盖修改实现
 *
 *  @param sender sender description
 */
- (void)popButtonClicked:(id)sender;

/**
 *  统计事件名称
 */
@property (nonatomic, copy) NSString *eventStatisticsId;

@end
