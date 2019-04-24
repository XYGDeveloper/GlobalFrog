//
//  NSString+Attribute.m
//  Zhuzhu
//
//  Created by zagger on 16/1/6.
//  Copyright © 2016年 www.globex.cn. All rights reserved.
//

#import "NSString+Attribute.h"

@implementation NSString (Attribute)

- (NSMutableAttributedString *)attributedStringByMarkNumericCharacterWithFont:(UIFont *)font color:(UIColor *)color {
    return [self attributedStringByMarkPattern:@"[\\d{1,}]" withFont:font color:color];
}

- (NSMutableAttributedString *)attributedStringByMarkPattern:(NSString *)regularPattern withFont:(UIFont *)font color:(UIColor *)color {
    if (self.length <= 0) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularPattern options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *array = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    for (NSTextCheckingResult *result in array) {
        NSRange range = result.range;
        if (range.location != NSNotFound) {
            if (font) {
                [attributedString addAttribute:NSFontAttributeName value:font range:range];
            }
            if (color) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
            }
        }
    }
    return attributedString;
}


#pragma mark - 中划线
- (NSMutableAttributedString *)strikeAttributedString {
    
    return [self strikeAttributedStringWithRange:NSMakeRange(0, self.length)];
}

- (NSMutableAttributedString *)strikeAttributedStringWithRange:(NSRange)range{
    
    if (!(range.length + range.location <= self.length && range.location < self.length)) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
    return attributedString;
}

@end
