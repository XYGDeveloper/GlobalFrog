//
//  SuccessViewController.h
//  Qqw
//
//  Created by zagger on 16/9/6.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuccessViewController : UIViewController

/**
 *  点击返回按钮时，要跳转到的vc
 */
@property (nonatomic, weak) UIViewController *popBackViewController;

/**
 *  提示支付成功的视图vc
 *
 *  @param toViewController 在支付成功页，点击返回时跳转的目的vc
 *
 *  @return return value description
 */
+ (instancetype)paySuccessViewControllerWithJumpBack:(UIViewController *)toViewController;

/**
 *  订单评论成功的提示视图
 *
 *  @return return value description
 */
+ (instancetype)orderCommentSuccessViewController;

/**
 *  订单取消成功的提示视图
 *
 *  @param cancelReason 取消订单的原因
 *  @param orderId      被取消订单的id
 *
 *  @return return value description
 */
+ (instancetype)orderCancelSuccessViewControllerWithReason:(NSString *)cancelReason order:(NSString *)orderId;

/**
 *  订单售后申请成功的提示视图
 *
 *  @param orderId 申请售后的订单号
 *
 *  @return return value description
 */
+ (instancetype)afterSaleApplySuccessViewControllerWithOrder:(NSString *)orderId;

@end
