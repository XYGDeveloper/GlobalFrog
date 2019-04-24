//
//  OrderPayHelper.m
//  Qqw
//
//  Created by zagger on 16/8/20.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "OrderPayHelper.h"
#import "OrderModel.h"
#import "PaymentInfo.h"

@interface OrderPayHelper ()<ApiRequestDelegate>

@property (nonatomic, strong) OrderModel *order;

@property (nonatomic, copy) OrderPayCallback callback;

@property (nonatomic, strong) OrderPayApi *api;

@end

@implementation OrderPayHelper

+ (instancetype)sharedInstance {
    static OrderPayHelper *__payHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __payHelper = [[OrderPayHelper alloc] init];
    });
    return __payHelper;
}

- (void)payOrder:(OrderModel *)order withPayMode:(NSString *)payMode callBack:(OrderPayCallback)callback {
    if (!order || !order.order_sn) {
        if (callback) {
            callback(PayResultTypeFailed, order);
        }
        return;
    }
    
    self.order = order;
    self.callback = callback;
    
    [self.api getPayInfoWithOrderNumber:order.order_sn payMode:payMode];
}

#pragma mark - ApiRequestDelegate
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    [self getPayInfoSuccess:responsObject];
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self getPayInfoFailed];
}



#pragma mark -
- (void)getPayInfoSuccess:(PaymentInfo *)payInfo {
    __weak typeof(self) wself = self;
    if ([payInfo.pay_id isEqualToString:PayModeWechat]) {//微信支付
        
        NSDictionary *wxPayDic = [Utils jsonObjectFromString:payInfo.pay_parmas];
        WXPayReq *payReq = [WXPayReq mj_objectWithKeyValues:wxPayDic];
        
        [[WXPayService defaultService] payOrderWithInfo:payReq comletionBlock:^(NSString *result) {
            __strong typeof(wself) sself = wself;
            [sself dealWithPayResult:result];
        }];
    }
    else if ([payInfo.pay_id isEqualToString:PayModeAliPay]) {//支付宝支付
        [[AlipayService defaultService] payOrderWithInfo:payInfo.pay_parmas withCompletionBlock:^(NSString *result) {
            NSLog(@"%@",payInfo.pay_parmas);
            __strong typeof(wself) sself = wself;
            [sself dealWithPayResult:result];
        }];
    }
}

- (void)dealWithPayResult:(NSString *)result {
    
    NSString *msg = nil;
    
    if ([result isEqualToString:PayResultTypeCancel]) {
        msg = @"您取消了支付";
    } else if ([result isEqualToString:PayResultTypeFailed]) {
        msg = @"支付失败";
    } else if ([result isEqualToString:PayResultTypeSuccess]) {
        msg = @"支付成功";
    }
    
    [Utils postMessage:msg onView:nil];
    if (self.callback) {
        self.callback(result, self.order);
    }
}

- (void)getPayInfoFailed {
    [Utils postMessage:@"获取支付信息失败" onView:nil];
    if (self.callback) {
        self.callback(PayResultTypeFailed, self.order);
    }
}


#pragma mark - Properties
- (OrderPayApi *)api {
    if (!_api) {
        _api = [[OrderPayApi alloc] init];
        _api.delegate = self;
    }
    return _api;
}

@end


@implementation OrderPayApi

- (void)getPayInfoWithOrderNumber:(NSString *)orderNo payMode:(NSString *)payMode {
    NSDictionary *params = @{@"pay_id": (payMode ?: PayModeWechat),//支付方式
                             @"order_sn": orderNo ?: @"",//订单号
                             @"bank_code": @"",//客户端
                             @"type":@"0" //类型为8为众筹，0为普通
                             };
    
    [self startRequestWithParams:params];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"/payment-pay/paySubmit");
    return command;
}

- (id)reformData:(id)responseObject {
    PaymentInfo *payInfo = [PaymentInfo mj_objectWithKeyValues:responseObject];
    return payInfo;
}

@end
