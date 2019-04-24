//
//  NSString+Encryption.h
//  Zhuzhu
//
//  Created by zagger on 15/12/15.
//  Copyright © 2015年 www.globex.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encryption)

/** 返回对self进行32位md5加密的字符串 */
- (NSString *)MD5String;

@end
