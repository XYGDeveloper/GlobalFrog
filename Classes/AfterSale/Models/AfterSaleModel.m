//
//  AfterSaleModel.m
//  Qqw
//
//  Created by zagger on 16/9/18.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "AfterSaleModel.h"

@implementation AfterSaleModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list": @"AfterSaleDetailList"};
}

@end

@implementation AfterSaleDetailList

@end


@implementation AfterSaleDetail

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"identifier": @"id", @"fresh_Order_sn":@"new_order_sn"};
}

@end
