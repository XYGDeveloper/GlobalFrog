//
//  OrderModel.h
//  Qqw
//
//  Created by zagger on 16/8/19.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressModel.h"

#pragma mark - 订单操作类型
//status_code对应码【100立即付款btnPayment；200取消订单btnCancel；300删除订单btnDelete；400评价btnComment；500追加评价btnAppendComment；600订单跟踪btnTrack；700确认收货btnConfirmReceipt；800申请退货btnRefund】
static NSString * const kOrderOperationPayment = @"100";
static NSString * const kOrderOperationCancel = @"200";
static NSString * const kOrderOperationDelete = @"300";
static NSString * const kOrderOperationComment = @"400";
static NSString * const kOrderOperationAppendCmt = @"500";
static NSString * const kOrderOperationTrack = @"600";
static NSString * const kOrderOperationConfirmRecieved = @"700";
static NSString * const kOrderOperationAskRefund = @"800";

//order_status订单状态:0-未确认 1-已确认 2-已取消 3-无效 4-退换货 5-已结算（完成）6-拒收 7-已合并 8-已拆分 9-退换货申请'
static NSString * const kOrderStatusNotConfirm = @"0";
static NSString * const kOrderStatusConfrimed = @"1";
static NSString * const kOrderStatusCanceled = @"2";
static NSString * const kOrderStatusInvalid = @"3";
static NSString * const kOrderStatusAfterSale = @"4";//退换货，即是售后
static NSString * const kOrderStatusSettled = @"5";
static NSString * const kOrderStatusRejection = @"6";
static NSString * const kOrderStatusMerged = @"7";
static NSString * const kOrderStatusSplited = @"8";
static NSString * const kOrderStatusAskAf = @"9";

//pay_status支付状态；0-未付款 1-已付款 2-已结算
//comment_status订单评论状态 0-未评论 1-部分评论 2-已评论 3-部分追评 4-已追评
//is_allot推送状态： 0-未推送 1-已推送 2-推送失败'
//shipping_type配送类型 1-物流配送 2-管家配送 3-自提'
//订单类型  1-仓储直配  2-海外直邮  3-保税区发货 4-第三方发货 5-礼品订单,6秒杀订单，8众筹',
//返回值中的 order_type 如果为8 是众筹

@interface OrderModel : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *order_id;

@property (nonatomic, copy) NSString *order_sn;

@property (nonatomic, copy) NSString *order_price;

@property (nonatomic, copy) NSString *parent_id;

@property (nonatomic, copy) NSString *is_child;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *order_type;

@property (nonatomic, copy) NSString *order_status;

@property (nonatomic, copy) NSString *shipping_type;

@property (nonatomic, copy) NSString *shipping_status;

@property (nonatomic, copy) NSString *pay_status;

@property (nonatomic, copy) NSString *comment_status;

@property (nonatomic, copy) NSString *shipping_fee;

@property (nonatomic, copy) NSString *discount;

@property (nonatomic, copy) NSString *pay_id;

@property (nonatomic, copy) NSString *goods_amount;

@property (nonatomic, copy) NSString *order_amount;

@property (nonatomic, copy) NSString *pay_fee;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *receipt_time;

@property (nonatomic, copy) NSString *confirm_time;

@property (nonatomic, copy) NSString *pay_time;

@property (nonatomic, copy) NSString *shipping_time;

@property (nonatomic, copy) NSString *comment_time;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *is_delete;

@property (nonatomic, copy) NSString *partner_id;

@property (nonatomic, copy) NSString *butler_id;

@property (nonatomic, copy) NSString *company_id;

@property (nonatomic, copy) NSString *invite_id;

@property (nonatomic, copy) NSString *is_visable;

@property (nonatomic, strong) NSArray *track;

@property (nonatomic, copy) NSString *trackurl;//快递100的url

@property (nonatomic ,copy) NSString *endtime;

@property (nonatomic, copy) NSString *format_create_time;

@property (nonatomic, strong) NSArray *goods_list;

@property (nonatomic, strong) AddressModel *user_address;

@property (nonatomic, strong) NSArray *favorable;

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *status_style;

@property (nonatomic, strong) NSArray *status_code;

@property (nonatomic, copy) NSString *order_type_name;


@end


@interface OrderTrack : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *dateline;

@end

static NSString *const kAfterSaleStateNone = @"-1";
static NSString *const kAfterSaleStateNot = @"0";
static NSString *const kAfterSaleStateAlready = @"1";

@interface OrderGoodsModel : NSObject

@property (nonatomic, copy) NSString *return_sn;//售后单号
@property (nonatomic, copy) NSString *rec_id;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *order_sn;
@property (nonatomic, copy) NSString *sku_id;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *product_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_number;
@property (nonatomic, copy) NSString *shop_price;
@property (nonatomic, copy) NSString *goods_attr;
@property (nonatomic, copy) NSString *goods_thumb;
@property (nonatomic, copy) NSString *package_id;
@property (nonatomic, copy) NSString *is_gift;
@property (nonatomic, copy) NSString *activity_id;
@property (nonatomic, copy) NSString *activity_price;
@property (nonatomic, copy) NSString *fav_price;
@property (nonatomic, copy) NSString *fav_type;

@property(nonatomic,assign) int rtype; //0-平台直供 1-工厂 2-保税区 4-生鲜

/**
 *  售后状态  -1 不显示  0-未申请售后  1-已申请售后
 */
@property (nonatomic, copy) NSString *is_after_sales;

@end


@interface OrderOperation : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *btnClass;

@end

