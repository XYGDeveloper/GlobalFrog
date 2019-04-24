//
//  QQLoginApi.h
//  Qqw
//
//  Created by 全球蛙 on 2016/11/22.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BaseApi.h"

@interface QQLoginApi : BaseApi

- (void)QQLoginWithNikeName:(NSString *)nickname openId:(NSString *)openid sex:(NSString *)sex face:(NSString *)face type:(NSString *)type;

@end
