//
//  GetPersonInfoApi.h
//  Qqw
//
//  Created by XYG on 16/10/25.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BaseApi.h"

@interface GetPersonInfoApi : BaseApi

- (void)userInfoWithNikeName:(NSString *)nikeName sex:(NSString *)sex face:(NSString *)face province:(NSString *)province city:(NSString *)city distrction:(NSString *)district registerId:(NSString *)registerId;



@end
