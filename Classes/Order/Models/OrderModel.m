//
//  OrderModel.m
//  Qqw
//
//  Created by zagger on 16/8/19.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"track": @"OrderTrack",
             @"goods_list": @"OrderGoodsModel",
             @"status_code": @"OrderOperation"};
}
@end


@implementation OrderTrack

@end

@implementation OrderGoodsModel

@end

@implementation OrderOperation

@end
