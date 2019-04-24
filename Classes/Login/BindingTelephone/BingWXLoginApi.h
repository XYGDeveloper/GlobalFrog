//
//  ResigterApi.h
//  Qqw
//
//  Created by 全球蛙 on 16/8/27.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BaseApi.h"

@interface BingWXLoginApi : BaseApi

- (void)getVerifyCodeWithPhone:(NSString *)phone password:(NSString *)password varCode:(NSString *)varCode;

@end
