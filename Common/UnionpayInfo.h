//
//  UnionpayInfo.h
//  Qqw
//
//  Created by 全球蛙 on 2017/3/22.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WXPayReq.h"

@interface UnionpayInfo : NSObject

@property(nonatomic,assign) int pay_id;
@property(nonatomic,strong) NSString * pay_parmas;

+(void)requestPayInfoWithOrderNumber:(NSString *)orderNo payMode:(NSString *)payMode superView:(UIView*)superView finshBlock:(void (^)(UnionpayInfo * obj,NSError * error))finshBlock;

@end
