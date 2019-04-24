//
//  Utils.h
//  Qqw
//
//  Created by zagger on 16/8/17.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

#pragma mark - loading
/** 向parentView添加一个loading视图 */
+ (void)addHudOnView:(UIView *)parentView;
+ (void)addHudOnView:(UIView *)parentView withTitle:(NSString *)title;

/** 移除parentView上最上层一个loading视图 */
+ (void)removeHudFromView:(UIView *)parentView;

/** 移除parentView上所以的loading视图 */
+ (void)removeAllHudFromView:(UIView *)parentView;

#pragma mark - 常用操作
/** 拨打电话 */
+ (void)callPhoneNumber:(NSString *)phoneNumber;
/** 添加电话号码到通讯录 */
+ (void)addPhoneNumberToAddressBook:(NSString *)phoneNumber;
+ (void)refreshHomeViewController;


#pragma mark - 提示文案
/** 弹出一个提示视图，并自动消失，message为提示文案 */
+ (void)postMessage:(NSString *)message onView:(UIView *)parentView;

#pragma mark - json
/** 将一个json字符串转换为json对象 */
+ (id)jsonObjectFromString:(NSString *)jsonString;
/** 将一个json对象转换为字符串 */
+ (NSString *)stringFromJsonObject:(id)jsonObject;

#pragma mark - 商品价格显示问题
/** 根据商品价格字符串，返回需要显示的价格信息，主要控制小数位数以及是否添加人民币符号等 */
+ (NSString *)priceDisplayStringFromPrice:(NSString *)price;
/** 根据商品价格浮点数值，返回需要显示的价格信息，主要控制小数位数以及是否添加人民币符号等 */
+ (NSString *)priceDisplayStringFromPriceValue:(CGFloat)priceValue;
/** 根据商品价格字符串，返回价格浮点数值 */
+ (CGFloat)priceValueFromString:(NSString *)price;


#pragma mark - 全局跳转
+ (void)jumpToHomepage;
+ (void)jumpToTabbarControllerAtIndex:(NSUInteger)index;

#pragma 引导页控制
/** 是否需要显示引导页 */
+ (BOOL)shouldShowGuidePage;
/** 更新本地缓存的app版权 */
+ (void)updateCachedAppVersion;

//如果用户已登陆，返回NO；如果未登陆返回YES，并弹出登陆界面
+ (BOOL)showLoginPageIfNeeded;

#pragma mark - Cookies
+ (void)addCookiesForURL:(NSURL *)url;
+ (void)clearCookiesForURL:(NSURL *)url;

#pragma mark -
/** 解析xml字条串，得到中国行政区的json数组 */
+ (NSArray *)addressInfoFromXml:(NSString *)xmlString;

 /** 时间戳转换为不同格式时间 */
+ (NSString *)stringWithDate:(NSDate *)date;
 /** 高度自适应 */
+(CGFloat)getSpaceLabelHeight:(NSString*)str  withWidth:(CGFloat)width ;

+(void)showErrorMsg:(UIView*)view type:(int)type msg:(NSString*)msg;


+(void)popBackFreshWithObj:(id)obj view:(UIView*)view;
+(UIImage*) imageWithColor:( UIColor*)color1;

@end


@interface UIColor (extension)

+ (UIColor *)rgb:(NSString *)rgbHex;

@end


