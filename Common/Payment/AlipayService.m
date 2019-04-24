//
//  AlipayService.m
//  Qqw
//
//  Created by zagger on 16/8/24.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "AlipayService.h"

//支付返回字典信息见：https://doc.open.alipay.com/doc2/detail.htm?treeId=204&articleId=105302&docType=1

typedef NS_ENUM(NSInteger, AlipayResultType) {
    AlipayResultTypeSuccess = 9000,//订单支付成功
    AlipayResultTypeProcessing = 8000,//正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
    AlipayResultTypeFailed = 4000,//订单支付失败
    AlipayResultTypeRepeat = 5000,//重复请求
    AlipayResultTypeCancel = 6001,//用户中途取消
    AlipayResultTypeNetworkError = 6002,//网络连接出错
    AlipayResultTypeUnknow = 6004 //支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
};


@interface AlipayService ()

@property (nonatomic, copy) LocalPayResultBlock completionBlock;

@end

@implementation AlipayService

+ (instancetype)defaultService {
    static AlipayService *__service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __service = [[AlipayService alloc] init];
    });
    return __service;
}

+ (BOOL)isAlipayAppInstalled {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
        return YES;
    }
    return NO;
}

- (void)payOrderWithInfo:(NSString *)payInfo withCompletionBlock:(LocalPayResultBlock)completionBlock {
    self.completionBlock = completionBlock;
    
    __weak typeof(self) wself = self;
    [[AlipaySDK defaultService] payOrder:payInfo fromScheme:@"quanqiuwa" callback:^(NSDictionary *resultDic) {
        __strong typeof(wself) sself = wself;
        [sself payOrderDidFinishedWithInfo:resultDic];
    }];
}

- (void)payOrderDidFinishedWithInfo:(NSDictionary *)resultDic {
    
    NSString *localResult = PayResultTypeFailed;
    if ([resultDic isKindOfClass:[NSDictionary class]]) {
        NSString *statusKey = @"resultStatus";
        AlipayResultType resultType = [[resultDic objectForKey:statusKey] integerValue];
        
        if (resultType == AlipayResultTypeSuccess) {
            localResult = PayResultTypeSuccess;
            exit(0);
        }
        else if (resultType == AlipayResultTypeCancel) {
            localResult = PayResultTypeCancel;
        }
    }
    
    if (self.completionBlock) {
        self.completionBlock(localResult);
    }
}

@end
