//
//  OrderCountModel.h
//  Qqw
//
//  Created by 全球蛙 on 16/10/14.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderCountModel : NSObject

@property (nonatomic,copy)NSString *total;   //全部
@property (nonatomic,copy)NSString *unpay;   //未付款
@property (nonatomic,copy)NSString *unsend;  //未发货
@property (nonatomic,copy)NSString *sended;  //待接收
@property (nonatomic,copy)NSString *unevaluate;  //未评价

@property (nonatomic,copy)NSString *collections;  //
@property (nonatomic,copy)NSString *follows;  //

@property (nonatomic,copy)NSString *msgs;  //
@property (nonatomic,copy)NSString *systmes;  //
@property (nonatomic,copy)NSString *comments;  //

+(void)requestOrderCountWithSuperView:(UIView*)superView finshBlock:(void (^)(OrderCountModel *  obj,NSError * error))finshBlock;

+(void)requestInfoWithSuperView:(UIView*)superView finshBlock:(void (^)(OrderCountModel * obj,NSError * error))finshBlock;

@end
