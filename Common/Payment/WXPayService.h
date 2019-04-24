//
//  WXPayService.h
//  Qqw
//
//  Created by zagger on 16/8/20.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WXApi.h"
#import "WXPayReq.h"

@interface WXPayService : NSObject<WXApiDelegate>

+ (instancetype)defaultService;

/** 检查微信app是否安装 */
+ (BOOL)isWXAppInstalled;

- (void)payOrderWithInfo:(WXPayReq *)wxPayInfo comletionBlock:(LocalPayResultBlock)comletionBlock;

@end
