//
//  SMSInfo.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/1.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "SMSInfo.h"

@implementation SMSInfo

+(void)requestSMSWithPhone:(NSString *)phone type:(int)type superView:(UIView *)superView finshBlock:(void (^)(id, NSError *))finshBlock{
 
    [MyRequestApiClient requestPOSTUrl:SEND_CODE_URL parameters:@{@"mobile":phone,@"type":@(type)} superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            finshBlock(nil,nil);
        }
    }];
    
}

+(void)requestChangePwdWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword surePassword:(NSString *)sureaPassword type:(int)type superView:(UIView *)superView finshBlock:(void (^)(id, NSError *))finshBlock{
    
    [MyRequestApiClient requestPOSTUrl:CHANGE_PWD_URL parameters:@{@"opass": oldPassword ?:@"",
                                                                  @"npass": newPassword ?:@"",
                                                                  @"npass2": sureaPassword ?:@"",
                                                                  } superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            finshBlock(nil,nil);
        }
    }];
    
}

+(void)requestCheckCodeWithPhone:(NSString *)mobile smscode:(NSString *)smscode superView:(UIView *)superView finshBlock:(void (^)(id, NSError *))finshBlock{
    [MyRequestApiClient requestPOSTUrl:FIND_CODE_URL parameters:@{@"mobile":mobile,@"smscode":smscode} superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            finshBlock(nil,nil);
        }
    }];
}

+(void)requestRestPwdWithPhone:(NSString*)mobile smscode:(NSString*)smscode password:(NSString*)password  superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock{
    [MyRequestApiClient requestPOSTUrl:FIND_PWD_URL parameters:@{@"mobile":mobile,@"smscode":smscode,@"password": password} superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            finshBlock(nil,nil);
        }
    }];
}

@end




