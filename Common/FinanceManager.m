//
//  FinanceManager.m
//  YunGou
//
//  Created by Sean on 16/5/30.
//  Copyright © 2016年 Sean. All rights reserved.
//

#import "FinanceManager.h"


@interface FinanceManager (){
    
}

@end

@implementation FinanceManager

+(instancetype)sharedFInanceManager{
    static FinanceManager * _fin;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _fin = [FinanceManager new];
    });
    return _fin;
}

- (NSString *)urlSchema{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *bundle = info[@"CFBundleIdentifier"];
    return [bundle stringByAppendingString:@".pay"];
}

#pragma mark ================== ali pay =================
- (void)alipay:(NSString *)params callback:(FinancePayCallback)callback{
    [[AlipaySDK defaultService] payOrder:params fromScheme:@"quanqiuwa" callback:^(NSDictionary *resultDic) {
        NSString *statusKey = @"resultStatus";
        NSInteger type = [[resultDic objectForKey:statusKey]integerValue];
        if (type == 9000) {
            callback(YES,@"支付成功");
            [[NSNotificationCenter defaultCenter] postNotificationName:kOrderPaySuccessNotify object:nil];
        } else  {
            callback(NO,@"支付失败");
            
        }
    }];
}

#pragma mark ================== Unionpay =================
-(void)Unionpay:(id)orde viewCtr:(UIViewController*)viewCtr callback:(FinancePayCallback)callback{
//    MoneyInfo * mone = [MoneyInfo new];
//    mone.orderId = orde.orderId;
//    mone.orderCode = orde.orderCode;
//    mone.orderMoney = orde.orderMoney;
    
//    [UnionpayInfo requestUnionpayInfoWithorderCode:mone url:orde.payList.yn.call_url superView:viewCtr.view finshBlock:^(UnionpayInfo *obj, NSError *error) {
//        if (!error) {
//            [[UPPaymentControl defaultControl] startPay:obj.tn fromScheme:@"YunGouYun" mode:obj.model viewController:viewCtr];
//        }
//    }];
    
}

#pragma mark ================== wx Pay =================
-(void)wxpay:(WXPayReq*)wxPayInfo viewCtr:(UIViewController *)viewCtr callback:(FinancePayCallback)callback{
    if (![WXApi isWXAppInstalled]) {
        [Utils showErrorMsg:viewCtr.view type:0 msg:@"您还没有安装微信"];
    }else{
        PayReq *req =[[PayReq alloc] init];
        req.partnerId = wxPayInfo.partnerid;
        req.prepayId = wxPayInfo.prepayid;
        req.nonceStr = wxPayInfo.noncestr;
        req.timeStamp = [wxPayInfo.timestamp intValue];
        req.package = wxPayInfo.packageValue;
        req.sign = wxPayInfo.sign;
        [WXApi sendReq:req];
    }
}


@end

