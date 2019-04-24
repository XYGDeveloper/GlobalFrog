//
//  UserRequestApi.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/4.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "UserRequestApi.h"

@implementation UserRequestApi

+(void)requestRegisterWithPhone:(NSString *)phone password:(NSString *)password varCode:(NSString *)varCode superView:(UIView *)superView finshBlock:(void (^)(id, NSError *))finshBlock{
    [MyRequestApiClient requestPOSTUrl:REGISTER_URL parameters:@{@"mobile":phone,@"smscode":varCode,@"password": password} superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            finshBlock(nil,nil);
        }
    }];
}

+(void)requestSaveUserInfoWithUserInfo:(User*)user superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock{
    [MyRequestApiClient requestPOSTUrl:CHANGE_USER_INFO_URL parameters:user.mj_keyValues superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            User * u = [User mj_objectWithKeyValues:obj];
            finshBlock(u,nil);
        }
    }];
}

+(void)requestSaveLogOutWithSuperView:(UIView *)superView finshBlock:(void (^)(id, NSError *))finshBlock{
    [MyRequestApiClient requestPOSTUrl:LOGOUT_URL parameters:nil superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            finshBlock(nil,nil);
        }
    }];
}

+(void)requestFeedBackWithContent:(NSString *)content superView:(UIView *)superView finshBlock:(void (^)(id, NSError *))finshBlock{
    [MyRequestApiClient requestPOSTUrl:FEEDBACK_URL parameters:@{@"content": content ?:@"",} superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            finshBlock(nil,nil);
        }
    }];
    
}

@end




