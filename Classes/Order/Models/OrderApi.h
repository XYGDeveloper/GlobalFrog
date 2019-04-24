//
//  OrderApi.h
//  Qqw
//
//  Created by zagger on 16/8/19.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApi.h"
#import "OrderModel.h"
#import "OrderConfirmItem.h"

@interface OrderApi : BaseApi


/** 确认订单接口 */
- (void)confirmOrderWithGoods:(NSArray *)goodsArray
                         type:(OrderType)type
                      address:(NSString *)addressId
                       coupon:(NSString *)couponId;


@end

@interface OrderCreateApi : BaseApi

/** 创建订单 */
- (void)createOrderWithConfirmItem:(OrderConfirmItem *)confirmItem
                              type:(OrderType)type
                           address:(NSString *)addressId
                            coupon:(NSString *)couponId
                           card_id:(NSString *)card_id
                      leaveMessage:(NSString *)msg;
@end


@interface OrderDetailApi : BaseApi

/** 获取订单详情 */
- (void)getOrderDetailWithNumber:(NSString *)orderNumber;

@end


/** 删除订单 */
@interface OrderDeleteApi : BaseApi

- (void)deleteOrder:(OrderModel *)Order;

@end


/** 取消订单 */
@interface OrderCancelApi : BaseApi

- (void)cancelOrder:(OrderModel *)Order withReason:(NSString *)reason;

@end



/** 确认收货 */
@interface OrderConfirmRecievedApi : BaseApi

- (void)confirmRecievedWithOrder:(OrderModel *)order;

@end

