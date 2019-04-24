//
//  WXloginApi.h
//  Qqw
//
//  Created by XYG on 16/8/28.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BaseApi.h"

@interface WXloginApi : BaseApi

- (void)wxLoginWithNikeName:(NSString *)nickname openId:(NSString *)openid sex:(NSString *)sex face:(NSString *)face type:(NSString *)type;




@end
