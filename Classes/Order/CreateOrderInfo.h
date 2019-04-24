//
//  CreateOrderInfo.h
//  Qqw
//
//  Created by 全球蛙 on 2017/3/23.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderConfirmItem.h"
#import "OrderModel.h"
@interface CreateOrderInfo : NSObject

@property(nonatomic,strong) NSString * s;

@property(nonatomic,strong) NSMutableArray * goods;

@property(nonatomic,strong) NSString *  address_id;
@property(nonatomic,strong) NSString * coupon_id;
@property(nonatomic,strong) NSString * invite_id;
@property(nonatomic,strong) NSString * iswechat;

@property(nonatomic,strong) NSString * gettime;

@property(nonatomic,strong) NSMutableArray * remarklist;


+(void)requestCreateOrderWithInfo:(OrderConfirmItem *)info superView:(UIView *)superView finshBlock:(void (^)(id obj,  NSError * error))finshBlock;

@end

@interface OrderOkInfo : NSObject

@property(nonatomic,strong) NSString * sku_id;
@property(nonatomic,strong) NSString * goods_number;

@end


@interface RemarkInfo : NSObject

@property(nonatomic,assign) int rtype;
@property(nonatomic,strong) NSString * value;

@end

