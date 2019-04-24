//
//  User.m
//  Qqw
//
//  Created by zagger on 16/8/25.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "User.h"
#import <TMCache.h>
#import "ApiManager.h"

static User *_localUser = nil;
static NSString *const kLocalUserSaveKey = @"kLocalUserSaveKey";

@implementation User

MJExtensionCodingImplementation


+ (instancetype)LocalUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _localUser = [[TMCache sharedCache] objectForKey:kLocalUserSaveKey];
        if (!_localUser) {
            _localUser = [[User alloc] init];
        }
    });
    return _localUser;
}

- (BOOL)hasSteward {
    return self.butler_mobile && self.butler_mobile.length > 0;
}

+ (void)setLocalUser:(User *)user {
    if (user) {
        _localUser = nil;
        _localUser = user;
    } else {
        _localUser = [[User alloc] init];
    }
    
    [self saveToDisk];
    
}

+ (void)saveToDisk {
    
    [[TMCache sharedCache] setObject:[User LocalUser] forKey:kLocalUserSaveKey];
}

+ (void)clearLocalUser {
    [self setLocalUser:nil];
}

+ (BOOL)hasLogin {
    return [User LocalUser].token.length > 0;
}

+(void)requestUserInfoWithuperView:(UIView *)superView finshBlock:(void (^)(User *, NSError *))finshBlock{
    
    [MyRequestApiClient requestPOSTUrl:USER_INFO_URL parameters:nil superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            User *currentUser = [User mj_objectWithKeyValues:obj];
            [User LocalUser].uid = currentUser.uid;
            [User LocalUser].sex = currentUser.sex;
            [User LocalUser].mobile = currentUser.mobile;
            [User LocalUser].province = currentUser.province;
            [User LocalUser].ismobile = currentUser.ismobile;
            [User LocalUser].ismember = currentUser.ismember;
            [User LocalUser].isweixin = currentUser.isweixin;
            [User LocalUser].city = currentUser.city;
            [User LocalUser].butler_name = currentUser.butler_name;
            [User LocalUser].district = currentUser.district;
            [User LocalUser].butler_mobile = currentUser.butler_mobile;
            
            [User LocalUser].nickname = currentUser.nickname;
            [User LocalUser].role = currentUser.role;
            [User LocalUser].face = currentUser.face;
            [User LocalUser].isbus = currentUser.isbus;
            [User saveToDisk];
            
            finshBlock(currentUser,nil);
        }else{
            finshBlock(nil,[NSError new]);
        }
        
    }];
}

+(void)requestBindWithOpenID:(NSString *)openid type:(NSString *)type sperView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock{
    [MyRequestApiClient requestPOSTUrl:BIND_USER_URL parameters:@{
                                                                  @"openid": openid ?:@"",
                                                                  @"type": type ?:@"",
                                                                  } superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
         finshBlock(obj,error);
     }];
    
}


@end
