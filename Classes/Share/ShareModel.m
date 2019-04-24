//
//  ShareModel.m
//  Qqw
//
//  Created by zagger on 16/8/26.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "ShareModel.h"

@implementation ShareModel

- (NSString *)shareContent {
    if (self.content.length <= 140) {
        return self.content;
    } else {
        return [self.content substringToIndex:140];
    }
}

@end
