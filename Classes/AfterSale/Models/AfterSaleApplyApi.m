//
//  AfterSaleApplyApi.m
//  Qqw
//
//  Created by zagger on 16/9/8.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "AfterSaleApplyApi.h"

@implementation AfterSaleApplyApi

- (void)applyWithOrder:(NSString *)orderId
                 goods:(NSArray *)goodsIdArray
               product:(NSArray *)productIdArray
                  type:(NSString *)type
               explain:(NSString *)explain {
    
    NSString *goodsIdString = [goodsIdArray componentsJoinedByString:@","];
    NSString *productIdString = [productIdArray componentsJoinedByString:@","];
    
    NSDictionary *params = @{@"order_sn": orderId ?: @"",
                             @"goods_id": goodsIdString ?: @"",
                             @"product_id": productIdString ?: @"",
                             @"type": type ?: @"0",
                             @"remark": explain ?: @""};
    
    [self startRequestWithParams:params];
}


- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"/user-order/service");
    return command;
}

@end
