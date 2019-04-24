//
//  GoodsModel.m
//  Qqw
//
//  Created by zagger on 16/8/31.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel

+(void)requestHotTagWithType:(int)type superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock{
    [MyRequestApiClient requestPOSTUrl:HOT_GOODS_URL parameters:@{@"type":@(type)} superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            finshBlock(obj[@"list"],nil);
        }
    }];
}

+(void)requestSearchWithString:(NSString*)str type:(int)type page:(int)p lat:(float)lat lng:(float)lng superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock{
    [MyRequestApiClient requestPOSTUrl:SEARCH_GOODS_URL parameters:@{@"name": str ?: @"",@"type":@(type),@"lat":@(lat),@"lng":@(lng)}
                             superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            finshBlock([GoodsModel mj_objectArrayWithKeyValuesArray:obj],nil);
        }
    }];
}

@end
