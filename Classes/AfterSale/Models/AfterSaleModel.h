//
//  AfterSaleModel.h
//  Qqw
//
//  Created by zagger on 16/9/18.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AfterSaleDetailList, AfterSaleDetail;
@interface AfterSaleModel : NSObject

@property (nonatomic, strong) AfterSaleDetail *detail;
@property (nonatomic, strong) NSArray *list;

@end

@interface AfterSaleDetailList : NSObject

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *dateline;

@end

@interface AfterSaleDetail : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *return_sn;
@property (nonatomic, copy) NSString *order_sn;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *product_id;
@property (nonatomic, copy) NSString *return_shipping_status;
@property (nonatomic, copy) NSString *order_ispass;
@property (nonatomic, copy) NSString *pass_status;
@property (nonatomic, copy) NSString *action_user;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *return_goods_amount;
@property (nonatomic, copy) NSString *return_goods_count;
@property (nonatomic, copy) NSString *is_good_received;
@property (nonatomic, copy) NSString *is_goods_return;
@property (nonatomic, copy) NSString *return_user;
@property (nonatomic, copy) NSString *return_address;
@property (nonatomic, copy) NSString *return_mobile;
@property (nonatomic, copy) NSString *total_fee;
@property (nonatomic, copy) NSString *goods_money;
@property (nonatomic, copy) NSString *return_shipping;
@property (nonatomic, copy) NSString *fresh_Order_sn;//新的订单号
@property (nonatomic, copy) NSString *return_fee;
@property (nonatomic, copy) NSString *return_pay_status;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *return_status;
@property (nonatomic, copy) NSString *return_type;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *is_delete;
@property (nonatomic, copy) NSString *is_confirm;
@property (nonatomic, copy) NSString *business_type;
@property (nonatomic, copy) NSString *re_pay_time;
@property (nonatomic, copy) NSString *shop_id;
@property (nonatomic, copy) NSString *bill_status;
@property (nonatomic, copy) NSString *bill_time;
@property (nonatomic, copy) NSString *bill_id;
@property (nonatomic, copy) NSString *audit_time;
@property (nonatomic, copy) NSString *coin;
@property (nonatomic, copy) NSString *return_txt;

@end
