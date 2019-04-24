//
//  PayModeItem.h
//  Qqw
//
//  Created by zagger on 16/8/20.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const PayModeAliPay = @"1";
static NSString * const PayModeAliUnionpay = @"4";//支付宝银联支付
static NSString * const PayModeWechat = @"5";
static NSString * const PayModeUnionpay = @"6";

@interface PayModeItem : NSObject

@property (nonatomic, copy) NSString *pay_id;

@property (nonatomic, copy) NSString *pay_name;

@property (nonatomic, copy) NSString *pay_icon;

@end
