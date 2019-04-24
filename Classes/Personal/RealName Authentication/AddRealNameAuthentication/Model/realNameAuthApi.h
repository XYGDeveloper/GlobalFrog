//
//  realNameAuthApi.h
//  Qqw
//
//  Created by 全球蛙 on 2017/1/5.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "BaseApi.h"

@interface realNameAuthApi : BaseApi

- (void)upRealNameAuthInfoWithName:(NSString *)name
                         isDefault:(NSString *)is_default
                            number:(NSString *)number
                              face:(NSString *)face
                              back:(NSString *)back;


@end
