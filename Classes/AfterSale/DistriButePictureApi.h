//
//  DistriButePictureApi.h
//  Qqw
//
//  Created by 全球蛙 on 2017/1/10.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "BaseApi.h"

@interface DistriButePictureApi : BaseApi

- (void)toDistubuteWithTid:(NSString *)tid
                   content:(NSString *)content;
- (void)toDistributePicWithCid:(NSString *)Cid content:(NSString *)content picture:(NSString *)picture;

- (void)toDistributePicWithTid:(NSString *)tid content:(NSString *)content picture:(NSString *)picture;

@end
