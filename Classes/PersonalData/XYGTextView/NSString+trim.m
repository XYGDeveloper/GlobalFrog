//
//  NSString+trim.m
//  Odds
//
//  Created by innovane on 14-2-8.
//  Copyright (c) 2014年 chenkailong. All rights reserved.
//

#import "NSString+trim.h"

@implementation NSString (trim)

- (NSString *) trimText
{
    if ([self isKindOfClass:[NSString class]]) {
        if (self == nil || [@"" isEqualToString:self] || [self isKindOfClass:[NSNull class]]) {
            return @"";
        }
        return  [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return @"";
}

@end
