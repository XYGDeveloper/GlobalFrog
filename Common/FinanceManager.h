//
//  FinanceManager.h
//  YunGou
//
//  Created by Sean on 16/5/30.
//  Copyright © 2016年 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXPayReq.h"
#import "WXApi.h"
#import "UnionpayInfo.h"
#import <AlipaySDK/AlipaySDK.h>

typedef void (^FinancePayCallback)(BOOL success, NSString *err);


@interface FinanceManager : NSObject{
    FinancePayCallback _callback;
}

+ (instancetype)sharedFInanceManager;

- (void)alipay:(NSString *)params callback:(FinancePayCallback)callback;

-(void)Unionpay:(id )orde viewCtr:(UIViewController*)viewCtr callback:(FinancePayCallback)callback;

-(void)wxpay:(WXPayReq*)orde viewCtr:(UIViewController*)viewCtr callback:(FinancePayCallback)callback;


@end
