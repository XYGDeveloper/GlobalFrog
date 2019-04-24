//
//  OrderConfirmItem.m
//  Qqw
//
//  Created by zagger on 16/8/19.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "OrderConfirmItem.h"

@implementation OrderConfirmItem

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"couponList": [ConponModel class],
             //@"CouponModel",
             @"payWayMap":[PayModeItem class],
             @"newgoods":[CartGroupItem class]
             };
}


+(void)requestOrderOkWithData:(NSArray *)data type:(OrderType)type  address:(NSString *)addressId coupon:(NSString *)couponId  superView:(UIView *)superView finshBlock:(void (^)(OrderConfirmItem *, NSError *))finshBlock{
    NSMutableDictionary *orderFormParams = [OrderConfirmItem confirmOrderParamsFromGoods:data type:type];
    [orderFormParams safeSetObject:addressId forKey:@"address_id"];
    [orderFormParams safeSetObject:couponId forKey:@"coupon_id"];
    
    NSString *orderForm = [Utils stringFromJsonObject:orderFormParams];
    NSDictionary *params = @{@"orderForm":orderForm ?: @"",@"version":@(2.0)};
    NSLog(@"%@",params);
    [MyRequestApiClient requestPOSTUrl:CONFIRM_URL parameters:params superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            OrderConfirmItem *order = [OrderConfirmItem mj_objectWithKeyValues:obj];
            finshBlock(order,nil);
        }else{
            finshBlock(nil,[NSError new]);
        }
    }];
}



+ (NSMutableDictionary *)confirmOrderParamsFromGoods:(NSArray *)goodsArray type:(OrderType)type {
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

@implementation ConfirmOrderForm

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"goodsList":@"CartGoodsModel"};
}

@end


@implementation VIPConditoin

@end
