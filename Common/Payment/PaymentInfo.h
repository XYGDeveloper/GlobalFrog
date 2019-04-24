//
//  PaymentInfo.h
//  Qqw
//
//  Created by zagger on 16/8/20.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentInfo : NSObject

/**
 *  支付方式
 */
@property (nonatomic, copy) NSString *pay_id;

/**
 *  支付参数，目前只做微信支付
 */
@property (nonatomic, strong) NSString *pay_parmas;

@end
