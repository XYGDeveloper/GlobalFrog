//
//  UserRequestApi.h
//  Qqw
//
//  Created by 全球蛙 on 2017/3/4.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserRequestApi : NSObject

+(void)requestRegisterWithPhone:(NSString*)phone password:(NSString *)password varCode:(NSString *)varCode  superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock;

+(void)requestSaveUserInfoWithUserInfo:(User*)user superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock;

+(void)requestSaveLogOutWithSuperView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock;

+(void)requestFeedBackWithContent:(NSString*)content superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock;


@end
