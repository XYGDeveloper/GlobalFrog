//
//  LoginApi.h
//  Qqw
//
//  Created by XYG on 16/8/28.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BaseApi.h"

@interface LoginApi : BaseApi

//登录api
- (void)loginWithPhone:(NSString *)phone password:(NSString *)password;

@end
