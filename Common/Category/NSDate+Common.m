//
//  NSDate+Common.m
//  Qqw
//
//  Created by zagger on 16/9/14.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "NSDate+Common.h"

@implementation NSDate (Common)

+ (NSString *)fullTimeStringWithInterval:(NSTimeInterval)interval {
    return [self stringWithInterval:interval formatter:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)stringWithInterval:(NSTimeInterval)interval formatter:(NSString *)formatter {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    
    return [dateFormatter stringFromDate:date];
}

@end
