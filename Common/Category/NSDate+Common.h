//
//  NSDate+Common.h
//  Qqw
//
//  Created by zagger on 16/9/14.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Common)

/** 返回“2016-09-02 17:42:11”格式的字符串 */
+ (NSString *)fullTimeStringWithInterval:(NSTimeInterval)interval;

/**
 * 根据秒级时间戳，和时间格式，返回时间描述字符串
 */
+ (NSString *)stringWithInterval:(NSTimeInterval)interval formatter:(NSString *)formatter;

@end
