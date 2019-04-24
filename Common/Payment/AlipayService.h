//
//  AlipayService.h
//  Qqw
//
//  Created by zagger on 16/8/24.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>

@interface AlipayService : NSObject

+ (instancetype)defaultService;

//支付宝app是支付安装
+ (BOOL)isAlipayAppInstalled;

- (void)payOrderWithInfo:(NSString *)payInfo withCompletionBlock:(LocalPayResultBlock)completionBlock;

- (void)payOrderDidFinishedWithInfo:(NSDictionary *)resultDic;

@end
