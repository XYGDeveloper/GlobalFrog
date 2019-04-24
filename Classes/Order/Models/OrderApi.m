//
//  OrderApi.m
//  Qqw
//
//  Created by zagger on 16/8/19.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "OrderApi.h"
#import "CartGoodsModel.h"
#import "CrowdFundingModel.h"

@interface OrderApi ()

@end

@implementation OrderApi

- (void)confirmOrderWithGoods:(NSArray *)goodsArray
                         type:(OrderType)type
                      address:(NSString *)addressId
                       coupon:(NSString *)couponId {
    
    NSMutableDictionary *orderFormParams = [self confirmOrderParamsFromGoods:goodsArray type:type];
    [orderFormParams safeSetObject:addressId forKey:@"address_id"];
    [orderFormParams safeSetObject:couponId forKey:@"coupon_id"];
    
    NSString *orderForm = [Utils stringFromJsonObject:orderFormParams];
    NSDictionary *params = @{@"orderForm":orderForm ?: @""};
                           
    [self startRequestWithParams:params];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = CONFIRM_URL;//APIURL(@"/user-order/confirm");
    return command;
}

- (id)reformData:(id)responseObject {
    OrderConfirmItem *item = [OrderConfirmItem mj_objectWithKeyValues:responseObject];
    return item;
}


#pragma mark - Helper 
- (NSMutableDictionary *)confirmOrderParamsFromGoods:(NSArray *)goodsArray type:(OrderType)type {
    if (goodsArray.count <= 0) {
        return [NSMutableDictionary dictionary];
    }
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:goodsArray.count];
    if (type == OrderTypeNormal) {
        for (CartGoodsModel *model in goodsArray) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
            [dic safeSetObject:model.goods_id forKey:@"goods_id"];
            [dic safeSetObject:model.goods_number forKey:@"goods_number"];
            [dic safeSetObject:model.sku_id forKey:@"sku_id"];
            
            [resultArray addObject:dic];
        }
    }
    else if (type == orderTypeCrowdfunding) {
        for (CrowdfundingModel *model in goodsArray) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
            [dic safeSetObject:model.cf_num forKey:@"goods_number"];
            [dic safeSetObject:model.sku_id forKey:@"sku_id"];
            [dic safeSetObject:model.cf_id forKey:@"cf_id"];
            
            [resultArray addObject:dic];
        }
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
    [dic safeSetObject:resultArray forKey:@"goods"];
    
    return dic;
}



@end


@implementation OrderCreateApi

- (void)createOrderWithConfirmItem:(OrderConfirmItem *)confirmItem
                              type:(OrderType)type
                           address:(NSString *)addressId
                            coupon:(NSString *)couponId
                           card_id:(NSString *)card_id
                      leaveMessage:(NSString *)msg {
    
    NSMutableDictionary *orderFormParams = [self createOrderParamsFromItem:confirmItem type:type];
  
    [orderFormParams safeSetObject:addressId forKey:@"address_id"];
    [orderFormParams safeSetObject:couponId forKey:@"coupon_id"];
    [orderFormParams safeSetObject:card_id forKey:@"card_id"];
    [orderFormParams safeSetObject:msg forKey:@"remark"];
    NSString *orderForm = [Utils stringFromJsonObject:orderFormParams];
    NSDictionary *params = @{@"orderForm": orderForm ?: @""};
    
    [self startRequestWithParams:params];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = CREATE_ORDE_URL;//APIURL(@"/user-order/create");
    return command;
    
}

- (id)reformData:(id)responseObject {
    OrderModel *item = [OrderModel mj_objectWithKeyValues:responseObject];
    return item;
    
}


#pragma mark - Helper
- (NSMutableDictionary *)createOrderParamsFromItem:(OrderConfirmItem *)confirmItem type:(OrderType)type {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    if (type == OrderTypeNormal) {
        for (CartGoodsModel *model in confirmItem.orderForm.goodsList) {
            if (!model.is_limit) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
                [dic safeSetObject:model.goods_id forKey:@"goods_id"];
                [dic safeSetObject:model.goods_number forKey:@"goods_number"];
                [dic safeSetObject:model.sku_id forKey:@"sku_id"];
                [resultArray addObject:dic];
            }
        }
        
        [params safeSetObject:resultArray forKey:@"goods"];
    }
    else if (type == orderTypeCrowdfunding) {
        CrowdfundingModel *model = confirmItem.orderForm.cfsList;
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
        [dic safeSetObject:model.cf_num forKey:@"goods_number"];
        [dic safeSetObject:model.sku_id forKey:@"sku_id"];
        [dic safeSetObject:model.cf_id forKey:@"cf_id"];
        
        [resultArray addObject:dic];
        
        [params safeSetObject:resultArray forKey:@"goods"];
    }
    
    return params;
}

@end


@implementation OrderDetailApi

- (void)getOrderDetailWithNumber:(NSString *)orderNumber {
    NSDictionary *parameters = @{@"order_sn": orderNumber ?: @""};
    [self startRequestWithParams:parameters];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString =ORDE_INFO_URL;// APIURL(@"/user-order/detail");
    return command;
}

- (id)reformData:(id)responseObject {
    OrderModel *item = [OrderModel mj_objectWithKeyValues:responseObject];
    return item;
}

@end




@implementation OrderDeleteApi

- (void)deleteOrder:(OrderModel *)Order {
    NSDictionary *params = @{@"order_sn" : Order.order_sn ?: @""};
    [self startRequestWithParams:params];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = DELT_ORDE_URL;//APIURL(@"/user-order/del");
    return command;
}

@end



@implementation OrderCancelApi

- (void)cancelOrder:(OrderModel *)Order withReason:(NSString *)reason {
    NSDictionary *params = @{@"order_sn" : Order.order_sn ?: @"", @"reason" : reason ?: @""};
    [self startRequestWithParams:params];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = CANCEl_ORDE_URL;//APIURL(@"/user-order/cancel");
    return command;
}

@end




@implementation OrderConfirmRecievedApi

- (void)confirmRecievedWithOrder:(OrderModel *)order {
    [self startRequestWithParams:@{@"order_sn": order.order_sn ?: @""}];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = DOGET_ORDE_URL;//APIURL(@"user-order/doget");
    return command;
}

@end
