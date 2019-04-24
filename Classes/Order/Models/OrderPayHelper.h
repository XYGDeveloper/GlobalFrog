//
//  OrderPayHelper.h
//  Qqw
//
//  Created by zagger on 16/8/20.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApi.h"
#import "Payment.h"

@class OrderModel;

/**
 *  支付订单后的回调
 *
 *  @param resultType 支付结果
 *  @param order      支付成功后和服务端同步对应订单的状态信息，以order结构提供，order中只有order_id和status两个属性有值
 */
typedef void(^OrderPayCallback)(NSString *resultType, OrderModel *order);

@interface OrderPayHelper : NSObject

+ (instancetype)sharedInstance;

- (void)payOrder:(OrderModel *)order withPayMode:(NSString *)payMode callBack:(OrderPayCallback)callback;

@end


@interface OrderPayApi : BaseApi

- (void)getPayInfoWithOrderNumber:(NSString *)orderNo payMode:(NSString *)payMode;

@end