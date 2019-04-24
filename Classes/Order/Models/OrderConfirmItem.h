//
//  OrderConfirmItem.h
//  Qqw
//
//  Created by zagger on 16/8/19.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressModel.h"
#import "CrowdfundingModel.h"
#import "RealListModel.h"
#import "ConponModel.h"
#import "PayModeItem.h"
#import "CartGoodsModel.h"
@class ConfirmOrderForm, VIPConditoin;
@interface OrderConfirmItem : NSObject

@property (nonatomic, strong)RealListModel *realModel;

@property (nonatomic, strong) AddressModel *address;

@property (nonatomic, strong) ConfirmOrderForm *orderForm;

@property (nonatomic, strong) NSArray *couponList;

@property (nonatomic, copy) NSString *couponTips;

@property (nonatomic, copy) NSString *card_id;

@property (nonatomic, copy) NSString *couponId;

@property (nonatomic, strong) NSArray *payWayMap;

@property (nonatomic, copy) NSString *freight;

@property (nonatomic, strong) VIPConditoin *vipCondition;

@property (nonatomic, copy) NSString *activityAmount;

@property (nonatomic, copy) NSString *couponAmount;

@property (nonatomic, copy) NSString *totalAmount;

@property (nonatomic, copy) NSString *vipAmount;

@property (nonatomic, copy) NSString *orderPayAmount;

@property (nonatomic, copy) NSString *shippingFee;

@property (nonatomic, copy) NSString *goodsNumbers;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) NSArray * newgoods;

@property (nonatomic, copy) NSString *packingFee; //包装费

//@property(nonatomic,strong) NSString * gettime;

+(void)requestOrderOkWithData:(NSArray *)data type:(OrderType)type  address:(NSString *)addressId coupon:(NSString *)couponId  superView:(UIView *)superView finshBlock:(void (^)(OrderConfirmItem *, NSError *))finshBlock;

@end


@interface ConfirmOrderForm : NSObject

@property (nonatomic, strong) NSArray *goodsList;

@property (nonatomic, strong) CrowdfundingModel *cfsList;

@end


@interface VIPConditoin : NSObject

@property (nonatomic, copy) NSString *tips;

@property (nonatomic, copy) NSString *vipAmount;

@end



