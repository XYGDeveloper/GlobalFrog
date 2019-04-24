//
//  User.h
//  Qqw
//
//  Created by zagger on 16/8/25.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kUserRoleNormal = @"0";//普通用户
static NSString *const kUserRoleVip = @"1";//会员用户
static NSString *const kUserRoleSteward = @"2";//管家
static NSString *const kUserRoleSteward1 = @"3";//管家

@interface User : NSObject<NSCoding>

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *face;

@property (nonatomic, copy) NSString *open_id;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *district;

@property (nonatomic,copy)NSString *cacaheInfo;

@property (nonatomic, assign) BOOL ismember;//是否是会员

@property (nonatomic, assign) BOOL isweixin;//是否绑定微信

@property (nonatomic, assign) BOOL ismobile;//是否绑定手机
//管家助手
@property (nonatomic, copy) NSString *butler_name;

@property (nonatomic, copy) NSString *butler_mobile;

@property (nonatomic, copy) NSString *role;

@property (nonatomic,copy)NSString *cookieString;

@property (nonatomic,copy)NSString *__TAG;

@property (nonatomic,copy)NSString *isbus;

//推送注册id
@property (nonatomic,copy)NSString *registerId;

/** 判断用户是否有管家 */
- (BOOL)hasSteward;

/** 本地登陆的用户信息 */
+ (instancetype)LocalUser;

/** 设置本地登陆用户信息，并保存到沙盒 */
+ (void)setLocalUser:(User *)user;

/** 修改用户名，头像等后，将信息保存到沙盒的方法 */
+ (void)saveToDisk;

/** 退出登陆后，调用该方法清理本地用户信息*/
+ (void)clearLocalUser;

/** 返回当前是否有用户登陆 */
+ (BOOL)hasLogin;

#pragma mark - 更新用户信息
/** 是否需要更新用户信息 */
@property (nonatomic, assign) BOOL shouldRefreshUserInfo;

+(void)requestUserInfoWithuperView:(UIView*)superView finshBlock:(void (^)(User *  obj,NSError * error))finshBlock;

+(void)requestBindWithOpenID:(NSString *)openid type:(NSString *)type sperView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock;

@end
