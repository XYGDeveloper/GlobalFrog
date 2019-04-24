//
//  CartGoodsModel.m
//  Qqw
//
//  Created by zagger on 16/8/17.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "CartGoodsModel.h"

@implementation CartGoodsModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"attr_value":@"CartAttrValue"};
}



- (CGFloat)goodsTotalAmount {
    return [self.goods_number integerValue] * [self.sale_price floatValue];
}



@end


@implementation CartAttrValue

@end

@implementation CartGroupItem

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"goodsList":[CartGoodsModel class],
             @"list":[CartGoodsModel class],
             @"timelist":[ShowTimeInfo class]};
}

@end

@implementation CartGoodsInfo

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"cartGoodsList":@"CartGroupItem",
            @"goods":[CartGroupItem class] };
}

+(void)requestCarListWithSuperView:(UIView *)superView finshBlock:(void (^)(CartGoodsInfo * obj, NSError *))finshBlock{
    [MyRequestApiClient requestPOSTUrl:CART_NEW_URL parameters:nil superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            CartGoodsInfo * ord = [CartGoodsInfo mj_objectWithKeyValues:obj];
            finshBlock(ord,nil);
        }else{
            finshBlock(nil,[NSError new]);
        }
    }];
}

+(void)requestEditCarWithCarId:(NSString *)carid number:(int)num superView:(UIView *)superView finshBlock:(void (^)(id, NSError *))finshBlock{
    [MyRequestApiClient requestPOSTUrl:CART_UPDATE_URL parameters:@{@"cart_id": carid,@"number":@(num)} superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            finshBlock(obj,nil);
        }else{
            finshBlock(obj,[NSError new]);
        }
    }];
}

+(void)requestDeletCarWithGoods:(NSArray *)goodsArray superView:(UIView *)superView finshBlock:(void (^)(id, NSError *))finshBlock{
    NSString * s = @"";
    NSMutableArray *cartIdArray = [[NSMutableArray alloc] initWithCapacity:goodsArray.count];
    for (CartGoodsModel *goods in goodsArray) {
        [cartIdArray safeAddObject:goods.cart_id];
    }
    s = [cartIdArray componentsJoinedByString:@","];
    
    [MyRequestApiClient requestPOSTUrl:CART_DEL_URL parameters:@{@"cart_id": s} superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            finshBlock(obj,nil);
        }else{
            finshBlock(obj,[NSError new]);
        }
    }];
}

+(void)requestIsRealNameAuthWithGoods:(NSString *)goodsArray superView:(UIView*)superView finshBlock:(void (^)(id obj,NSError * error))finshBlock{
    [MyRequestApiClient requestPOSTUrl:USER_IDCARD_URL parameters:@{@"goods_id_list": goodsArray} superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            finshBlock(obj,nil);
        }else{
            finshBlock(obj,[NSError new]);
        }
    }];
}

@end
