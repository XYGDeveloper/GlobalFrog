//
//  WXPayService.m
//  Qqw
//
//  Created by zagger on 16/8/20.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "WXPayService.h"

@interface WXPayService ()

@property (nonatomic, copy) LocalPayResultBlock resultBlock;

@end

@implementation WXPayService

+ (instancetype)defaultService {
    static WXPayService *__service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __service = [[WXPayService alloc] init];
    });
    return __service;
}

+ (BOOL)isWXAppInstalled {
    
    return [WXApi isWXAppInstalled];
    
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        
        NSString *localResult = PayResultTypeFailed;
        if (resp.errCode == WXSuccess) {
            localResult = PayResultTypeSuccess;
            exit(0);
        } else if (resp.errCode == WXErrCodeUserCancel) {
            localResult = PayResultTypeCancel;
            
        }
        
        if (self.resultBlock) {
            self.resultBlock(localResult);
            
            NSLog(@"%@",localResult);
        }
    }
}

- (void)payOrderWithInfo:(WXPayReq *)wxPayInfo comletionBlock:(LocalPayResultBlock)comletionBlock {
    if (![wxPayInfo isKindOfClass:[WXPayReq class]] || ![WXApi isWXAppSupportApi]) {
        return;
    }
    
    self.resultBlock = comletionBlock;
    PayReq *req =[[PayReq alloc] init];
    req.partnerId = wxPayInfo.partnerid;
    req.prepayId = wxPayInfo.prepayid;
    req.nonceStr = wxPayInfo.noncestr;
    req.timeStamp = [wxPayInfo.timestamp intValue];
    req.package = wxPayInfo.packageValue;
    req.sign = wxPayInfo.sign;
    [WXApi sendReq:req];
    
}

@end
