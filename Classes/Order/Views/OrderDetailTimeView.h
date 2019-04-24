//
//  OrderDetailTimeView.h
//  Qqw
//
//  Created by zagger on 16/8/22.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderModel;

/**
 *  订单详情中，显示订单各种操作时间的视图
 */
@interface OrderDetailTimeView : UIView

- (void)refreshWithOrder:(OrderModel *)order;

@end
