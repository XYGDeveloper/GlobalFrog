//
//  AfterSaleDetailApi.m
//  Qqw
//
//  Created by zagger on 16/9/8.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "AfterSaleDetailApi.h"

@implementation AfterSaleDetailApi

- (void)getAfterSaleDetailWithIdentifier:(NSString *)return_sn {
    [self startRequestWithParams:@{@"return_sn": return_sn?:@""}];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"/user-order/serviceDetail");
    return command;
}

- (id)reformData:(id)responseObject {
    return [AfterSaleModel mj_objectWithKeyValues:responseObject];
}

@end
