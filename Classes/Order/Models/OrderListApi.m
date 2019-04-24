//
//  OrderListApi.m
//  Qqw
//
//  Created by zagger on 16/8/20.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "OrderListApi.h"

@interface OrderListApi ()

@property (nonatomic, copy) NSString *orderStatus;

@end

@implementation OrderListApi

- (id)initWithOrderStatus:(NSString *)orderStatus {
    if (self = [super init]) {
        self.orderStatus = orderStatus;
    }
    return self;
}



- (void)refresh {
    NSDictionary *params = @{@"type": self.orderStatus ?: OrderReqStatusAll};
    [self refreshWithParams:params];
}

- (void)loadNextPage {
    NSDictionary *params = @{@"type": self.orderStatus ?: OrderReqStatusAll};
    [self loadNextPageWithParams:params];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = ORDER_LIST_URL;//APIURL(@"/user-order/list");
    return command;
}

- (id)reformData:(id)responseObject {
    NSLog(@"订单列表：%@",responseObject);
    NSArray *array = [OrderModel mj_objectArrayWithKeyValuesArray:responseObject];
    
    return array;
}

@end
