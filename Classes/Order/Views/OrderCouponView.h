//
//  OrderCouponView.h
//  Qqw
//
//  Created by zagger on 16/8/19.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  订单确认页面，选择优惠券视图
 */
@interface OrderCouponView : UIView

@property (nonatomic, copy) void(^selectCouponBlock)(void);

- (void)refreshWithCouponTips:(NSString *)tips;

@end
