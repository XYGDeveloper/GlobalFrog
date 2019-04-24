//
//  NSString+Encode.m
//  Zhuzhu
//
//  Created by zagger on 15/12/15.
//  Copyright © 2015年 www.globex.cn. All rights reserved.
//

#import "NSString+Encode.h"

@implementation NSString (Encode)

- (NSString *)encodedString {
    if (self.length <= 0) {
        return @"";
    }
    
    NSString *encodedString = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return encodedString;
}

- (NSString *)decodedString {
    if (self.length <= 0) {
        return @"";
    }
    
    NSString *decodedString = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return decodedString;
}

@end
