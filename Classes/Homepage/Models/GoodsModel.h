//
//  GoodsModel.h
//  Qqw
//
//  Created by zagger on 16/8/31.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject

@property (nonatomic, copy) NSString *goods_id;

@property (nonatomic, copy) NSString *goods_name;

@property (nonatomic, copy) NSString *shop_price;

@property (nonatomic, copy) NSString *goods_thumb;

@property (nonatomic, copy) NSString *favorite_number;

@property (nonatomic, assign) BOOL isfav;

+(void)requestHotTagWithType:(int)type superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock;

+(void)requestSearchWithString:(NSString*)str type:(int)type page:(int)p lat:(float)lat lng:(float)lng superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock;


@end
