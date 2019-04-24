//
//  Macro.h
//  Qqw
//
//  Created by zagger on 16/8/27.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#ifndef Macro_h
#define Macro_h
//字体、颜色
#define Font(a) [UIFont systemFontOfSize:a]
#define BFont(a) [UIFont boldSystemFontOfSize:a]
#define IAIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define RGB(r,g,b)    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define HexColor(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
                                           green:((float)((hexValue & 0xFF00) >> 8))/255.0 \
                                            blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

#define HexColorA(hexValue, a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
                                               green:((float)((hexValue & 0xFF00) >> 8))/255.0 \
                                                blue:((float)(hexValue & 0xFF))/255.0 \
                                               alpha:a]

//weak, strong操作
#define weakify(var) __weak typeof(var) ZGWeak_##var = var;

#define strongify(var) \
_Pragma("clang  diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(var) var = ZGWeak_##var; \
_Pragma("clang diagnostic pop")



#define ALERT_MSG(msg) static UIAlertView *alert; alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];\
[alert show];\

#endif /* Macro_h */
