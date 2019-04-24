//
//  NSString+Attribute.h
//  Zhuzhu
//
//  Created by zagger on 16/1/6.
//  Copyright © 2016年 www.globex.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Attribute)

/** 将字符串中的数字字符标记为对应的字号和颜色 */
- (NSMutableAttributedString *)attributedStringByMarkNumericCharacterWithFont:(UIFont *)font color:(UIColor *)color;

/**
 *  将字符串中特定字符串标记为指定的字体和颜色
 *
 *  @param regularPattern 正则表达式，用于匹配字符串中的特定字符
 *  @param font           指定字体
 *  @param color          指定颜色
 *
 *  @return return value description
 */
- (NSMutableAttributedString *)attributedStringByMarkPattern:(NSString *)regularPattern withFont:(UIFont *)font color:(UIColor *)color;

/** 为字符串加上中划线，如：商品原价等情况 */
- (NSMutableAttributedString *)strikeAttributedString;
/** 为字符串加上中划线,range为指定区域，如：商品原价等情况 */
- (NSMutableAttributedString *)strikeAttributedStringWithRange:(NSRange)range;

@end
