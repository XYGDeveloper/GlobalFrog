//
//  AfterSaleTypeApi.m
//  Qqw
//
//  Created by zagger on 16/9/8.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "AfterSaleTypeApi.h"

@implementation AfterSaleTypeApi

- (void)getAfteSaleType {
    [self startRequestWithParams:nil];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.method = QQWRequestMethodGet;
    command.requestURLString = APIURL(@"/user-order/getservice");
    return command;
}

- (id)reformData:(id)responseObject {
    NSArray *jsonArray = responseObject[@"list"];
    return [AfterSaleType mj_objectArrayWithKeyValuesArray:jsonArray];
}

@end



@implementation AfterSaleType

@end