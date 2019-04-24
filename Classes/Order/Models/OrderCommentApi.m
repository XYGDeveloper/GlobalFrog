//
//  OrderCommentApi.m
//  Qqw
//
//  Created by zagger on 16/9/3.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "OrderCommentApi.h"
#import "OrderCommentCell.h"
#import "OrderModel.h"

@implementation OrderCommentApi

- (void)submitComment:(NSArray *)goodsCmtArray forOrder:(NSString *)orderId anonymity:(BOOL)anonymity {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:goodsCmtArray.count];
    for (OrderCmtBuildModel *cmtModel in goodsCmtArray) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
        [dic safeSetObject:cmtModel.goodsModel.goods_id forKey:@"goods_id"];
        [dic safeSetObject:@(cmtModel.star) forKey:@"level"];
        [dic safeSetObject:cmtModel.content forKey:@"content"];
        [dic safeSetObject:@(anonymity) forKey:@"ishide"];
        
        [array safeAddObject:dic];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];
    [params safeSetObject:array forKey:@"data"];
    [params safeSetObject:orderId forKey:@"order_num"];
    
    [self startRequestWithParams:@{@"data" : [Utils stringFromJsonObject:params] ?: @""}];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = ORDER_COMMENT_URL;//APIURL(@"/user-order/goodsComment");
    return command;
}

@end
