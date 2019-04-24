//
//  AgeBracketPicker.h
//  Qqw
//
//  Created by zagger on 16/8/27.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AgeBracketPicker : NSObject

+ (void)showOnView:(UIView *)parentView withSelectBlock:(void(^)(NSString *ageBracket))selectBlock;

@end
