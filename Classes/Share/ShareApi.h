//
//  ShareApi.h
//  Qqw
//
//  Created by zagger on 16/8/26.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BaseApi.h"
#import "ShareModel.h"

@interface ShareApi : BaseApi

- (void)getShareInfoWithType:(NSString *)shareType
                     shareTo:(NSString *)shareTo
                  identifier:(NSString *)shareId;

@end
