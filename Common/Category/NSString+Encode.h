//
//  NSString+Encode.h
//  Zhuzhu
//
//  Created by zagger on 15/12/15.
//  Copyright © 2015年 www.globex.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encode)

/** 返回对字符串进行url encode后的字符串 */
- (NSString *)encodedString;

/** 返回对字符串进行url decode后的字符串 */
- (NSString *)decodedString;

@end
