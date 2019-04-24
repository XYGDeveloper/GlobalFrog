//
//  PayModeViewController.h
//  Qqw
//
//  Created by zagger on 16/8/24.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

@class OrderModel;
/**
 *  收银台，选择支付方式
 */
@interface PayModeViewController : UIViewController

/**
 *  支付成功后，跳转到的页面
 */
@property (nonatomic, weak) UIViewController *paySuccessJumpViewController;

/**
 *  支付取消后，跳转的页面
 */
@property (nonatomic, weak) UIViewController *payCancelJumpViewController;

/**
 *  支付成功后，是否跳转到支付成功提示页面，默认为YES
 */
@property (nonatomic, assign) BOOL shouldJumpToSuccessPage;

/**
 *  支付成功后，需要进行的回调操作. 支付成功后若有额外操作，可以通过该参数进行
 */
@property (nonatomic, copy) void(^paySuccessCallBack)(void);

- (id)initWithOrder:(OrderModel *)order;

@end
