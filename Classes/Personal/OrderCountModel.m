//
//  OrderCountModel.m
//  Qqw
//
//  Created by 全球蛙 on 16/10/14.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "OrderCountModel.h"

@implementation OrderCountModel
+(void)requestOrderCountWithSuperView:(UIView *)superView finshBlock:(void (^)(OrderCountModel * obj, NSError *))finshBlock{
    [MyRequestApiClient requestPOSTUrl:ALLTYPE_COUNT_URL parameters:nil superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            OrderCountModel * ord = [OrderCountModel mj_objectWithKeyValues:obj];
            finshBlock(ord,nil);
        }
    }];
}

+(void)requestInfoWithSuperView:(UIView*)superView finshBlock:(void (^)(OrderCountModel * obj,NSError * error))finshBlock{
    [MyRequestApiClient requestGETUrl:MSG_CENTER_URL parameters:nil superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        OrderCountModel * ord = nil;
        if (!error) {
            ord = [OrderCountModel mj_objectWithKeyValues:obj];
        }
        finshBlock(ord,error);
    }];
    
}

@end
