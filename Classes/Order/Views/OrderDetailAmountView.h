//
//  OrderDetailAmountView.h
//  Qqw
//
//  Created by zagger on 16/8/23.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderModel;

/**
 *  订单详情页，显示商品金额、运费、实付款信息的视图
 */
@interface OrderDetailAmountView : UIView

- (void)refreshWithOrder:(OrderModel *)order;

@end
