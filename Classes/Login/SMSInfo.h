//
//  SMSInfo.h
//  Qqw
//
//  Created by 全球蛙 on 2017/3/1.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSInfo : NSObject

+(void)requestSMSWithPhone:(NSString*)phone type:(int)type  superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock;

+(void)requestChangePwdWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword surePassword:(NSString *)sureaPassword type:(int)type  superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock;

+(void)requestCheckCodeWithPhone:(NSString*)mobile smscode:(NSString*)smscode  superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock;

+(void)requestRestPwdWithPhone:(NSString*)mobile smscode:(NSString*)smscode password:(NSString*)password  superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock;

@end


