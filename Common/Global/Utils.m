//
//  Utils.m
//  Qqw
//
//  Created by zagger on 16/8/17.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "Utils.h"
#import <KissXML.h>
#import "LoadingView.h"
#import "RootManager.h"
#import "User.h"
#import "LoginViewControll.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "HomepageViewController.h"
@implementation Utils

#pragma mark - loading
+ (void)addHudOnView:(UIView *)parentView {
    if (parentView) {
        [self removeHudFromView:parentView];
        LoadingView *view = [LoadingView generalLoadingView];
        [parentView addSubview:view];
        parentView.userInteractionEnabled = NO;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(parentView).sizeOffset(CGSizeMake(0, -20));
            make.width.height.equalTo(@100);
        }];
    }
    
}

+ (void)addHudOnView:(UIView *)parentView withTitle:(NSString *)title {
    
    [self addHudOnView:parentView];
    
}

+ (void)removeHudFromView:(UIView *)parentView {
    if (parentView) {
        for (UIView *subView in parentView.subviews) {
            if ([subView isKindOfClass:[LoadingView class]]) {
                [subView removeFromSuperview];
            }
        }
        
        parentView.userInteractionEnabled = YES;
        
    }
    
}

+ (void)removeAllHudFromView:(UIView *)parentView {
    [self removeHudFromView:parentView];
}

#pragma mark - 提示文案
+ (void)postMessage:(NSString *)message onView:(UIView *)parentView{
    if (!parentView) {
        parentView = [UIApplication sharedApplication].keyWindow;
    }
    [Utils showErrorMsg:parentView type:0 msg:message];
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:parentView];
//    hud.labelText = message;
//    hud.mode = MBProgressHUDModeText;
//    hud.removeFromSuperViewOnHide = YES;
//    [parentView addSubview:hud];
//    [hud show:YES];
//    [hud hide:YES afterDelay:2];
    
}


#pragma mark - 常用操作
+ (void)callPhoneNumber:(NSString *)phoneNumber {
    UIAlertView *alertView = [UIAlertView alertViewWithTitle:nil message:[NSString stringWithFormat:@"拨打电话：%@",phoneNumber] cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] dismissBlock:^(UIAlertView *zg_alertView, NSInteger buttonIndex) {
        if (buttonIndex != zg_alertView.cancelButtonIndex) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]]];
        }
    }];
    [alertView show];
}

//添加电话号码到通讯录
+ (void)addPhoneNumberToAddressBook:(NSString *)phoneNumber {
    
    ABRecordRef person = ABPersonCreate();
    
    ABRecordSetValue(person, kABPersonOrganizationProperty, (__bridge CFStringRef) @"", NULL);
    
    if (phoneNumber) {
        ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        NSArray *venuePhoneNumbers = [phoneNumber componentsSeparatedByString:@" or "];
        for (NSString *venuePhoneNumberString in venuePhoneNumbers)
            ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFStringRef) venuePhoneNumberString, kABPersonPhoneMainLabel, NULL);
        ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
        CFRelease(phoneNumberMultiValue);
    }
    
    ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    
    ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFDictionaryRef) addressDictionary, kABWorkLabel, NULL);
    ABRecordSetValue(person, kABPersonAddressProperty, multiAddress, NULL);
    CFRelease(multiAddress);
    
    ABUnknownPersonViewController *controller = [[ABUnknownPersonViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    
    controller.displayedPerson = person;
    controller.allowsAddingToAddressBook = YES;
    
    UINavigationController *nav = [RootManager sharedManager].tabbarController.selectedViewController;
    if ([nav isKindOfClass:[UINavigationController class]]) {
        [nav pushViewController:controller animated:YES];
    }
    
    CFRelease(person);
}


#pragma mark - json
+ (id)jsonObjectFromString:(NSString *)jsonString {
    if (!jsonString || ![jsonString isKindOfClass:[NSString class]] || jsonString.length <= 0) {
        return nil;
    }
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:NULL];
        return object;
    } else {
        return nil;
    }
}

+ (NSString *)stringFromJsonObject:(id)jsonObject {
    if (!jsonObject || ![NSJSONSerialization isValidJSONObject:jsonObject]) {
        return nil;
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:NULL];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}


#pragma mark - 商品价格显示问题
+ (NSString *)priceDisplayStringFromPrice:(NSString *)price {
    
//    CGFloat priceValue = [price floatValue];
//    return [self priceDisplayStringFromPriceValue:priceValue];
    return [NSString stringWithFormat:@"¥%@",price];
}

+ (NSString *)priceDisplayStringFromPriceValue:(CGFloat)priceValue {
    return [NSString stringWithFormat:@"¥%.2f",priceValue];
    
}

+ (CGFloat)priceValueFromString:(NSString *)price {
    CGFloat priceValue = [price floatValue];
    NSString *priceString = [NSString stringWithFormat:@"%.2f",priceValue];
    
    return [priceString floatValue];
}

#pragma mark - 全局跳转
+ (void)jumpToHomepage {
    [self jumpToTabbarControllerAtIndex:0];
}

+ (void)jumpToTabbarControllerAtIndex:(NSUInteger)index {
    if (index == 2 && [self showLoginPageIfNeeded]) {
        return;
    }
    
    if (index == [RootManager sharedManager].tabbarController.selectedIndex) {
        UIViewController *vc = [RootManager sharedManager].tabbarController.selectedViewController;
       
        if ([vc isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)vc;
            [nav popToRootViewControllerAnimated:YES];
        }
        
    }
    else if (index < [RootManager sharedManager].tabbarController.viewControllers.count) {
        [RootManager sharedManager].tabbarController.selectedIndex = index;
    }
}


+ (BOOL)showLoginPageIfNeeded {
    if ([User hasLogin]) {
        return NO;
    }
    
    LoginViewControll *loginVC = [[LoginViewControll alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    [[RootManager sharedManager].tabbarController presentViewController:nav animated:YES completion:nil];
    
    return YES;
}

+ (BOOL)shouldShowGuidePage {
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        return NO;
    }
    
    NSString *appverstion = [UIDevice AppVersion];
    NSString *cachedVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"kCachedAppVersionKey"];
    
    if (!cachedVersion || [appverstion compare:cachedVersion] == NSOrderedDescending) {
        return YES;
    }
    return NO;
}

+ (void)updateCachedAppVersion {
    NSString *appverstion = [UIDevice AppVersion];
    [[NSUserDefaults standardUserDefaults] setObject:appverstion forKey:@"kCachedAppVersionKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)refreshHomeViewController
{

    HomepageViewController *home = [HomepageViewController new];
    [home.myWebView reload];

}
#pragma mark - Cookies
+ (void)addCookiesForURL:(NSURL *)url {
    if (!url) {
        return;
    }
    
    [self clearCookiesForURL:url];
    
    NSString *domain = url.host;
    
#warning 添加cookie
    NSString * str = [NSString stringWithFormat:@"%f,%f",[AppDelegate APP].locationCoordinate.latitude,[AppDelegate APP].locationCoordinate.longitude];
    NSLog(@"%@",str);
    [self addCookieForDomain:domain withName:@"__LOCATION" value:str];
    
    [self addCookieForDomain:domain withName:@"__TAG" value:[[NSUserDefaults standardUserDefaults] objectForKey:@"__TAG"]];
    [self addCookieForDomain:domain withName:@"os" value:@"ios"];
    [self addCookieForDomain:domain withName:@"version" value:[[UIDevice currentDevice]systemVersion]];
    if ([User LocalUser].token) {
        [self addCookieForDomain:domain withName:@"__TOKEN" value:[User LocalUser].token];
    }
}

+ (void)addCookieForDomain:(NSString *)domain withName:(NSString *)name value:(NSString *)value {
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    
    [cookieProperties setObject:name ?: @"" forKey:NSHTTPCookieName];
    [cookieProperties setObject:value ?: @"" forKey:NSHTTPCookieValue];
    [cookieProperties setObject:domain ?: @"" forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:24 * 60 * 60] forKey:NSHTTPCookieExpires];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
}

+ (void)clearCookiesForURL:(NSURL *)url {
    if (!url) {
        return;
    }
    
    NSArray *cookieArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
    for (NSHTTPCookie *cookie in cookieArray) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

#pragma mark -
+ (NSArray *)addressInfoFromXml:(NSString *)xmlString {
//    <province name="河北省" postcode="130000" >
//    <city name="石家庄市" postcode="130100" >
//    <area name="长安区" postcode="130102" />
//    <area name="桥东区" postcode="130103" />
    
    DDXMLElement *element = [[DDXMLElement alloc] initWithXMLString:xmlString error:nil];
    NSArray *array = [element elementsForName:@"province"];
    
    NSMutableArray *provinceArray = [[NSMutableArray alloc] init];
    
    for (DDXMLElement *provinceElement in array) {
        NSMutableDictionary *provinceDic = [[NSMutableDictionary alloc] init];
        
        NSString *provinceName = [[provinceElement attributeForName:@"name"] stringValue];
        NSString *provinceCode = [[provinceElement attributeForName:@"postcode"] stringValue];
        NSMutableArray *cityArray = [[NSMutableArray alloc] init];
        
//        [provinceDic safeSetObject:provinceName forKey:@"name"];
//        [provinceDic safeSetObject:provinceCode forKey:@"postcode"];
//        [provinceDic safeSetObject:cityArray forKey:@"cities"];
        
        [provinceDic setValue:provinceName forKey:@"name"];
        [provinceDic setValue:provinceCode forKey:@"postcode"];
        [provinceDic setValue:cityArray forKey:@"cities"];
        
        
        NSArray *xmlCityArray = [provinceElement elementsForName:@"city"];
        for (DDXMLElement *cityElement in xmlCityArray) {
            NSMutableDictionary *cityDic = [[NSMutableDictionary alloc] init];
            
            NSString *cityName = [[cityElement attributeForName:@"name"] stringValue];
            NSString *cityCode = [[cityElement attributeForName:@"postcode"] stringValue];
            NSMutableArray *areaArray = [[NSMutableArray alloc] init];
            
//            [cityDic safeSetObject:cityName forKey:@"name"];
//            [cityDic safeSetObject:cityCode forKey:@"postcode"];
//            [cityDic safeSetObject:areaArray forKey:@"areas"];
            [cityDic setValue:cityName forKey:@"name"];
            [cityDic setValue:cityCode forKey:@"postcode"];
            [cityDic setValue:areaArray forKey:@"areas"];
            
            
            NSArray *xmlAreaArray = [cityElement elementsForName:@"area"];
            for (DDXMLElement *areaElement in xmlAreaArray) {
                NSMutableDictionary *areaDic = [[NSMutableDictionary alloc] init];
                
                NSString *areaName = [[areaElement attributeForName:@"name"] stringValue];
                NSString *areaCode = [[areaElement attributeForName:@"postcode"] stringValue];
        
//                [areaDic safeSetObject:areaName forKey:@"name"];
//                [areaDic safeSetObject:areaCode forKey:@"postcode"];
                
                [areaDic setValue:areaName forKey:@"name"];
                [areaDic setValue:areaCode forKey:@"postcode"];
                
//                [areaArray safeAddObject:areaDic];
                [areaArray addObject:areaDic];
                
            
            }
            
         //   [cityArray safeAddObject:cityDic];
            [cityArray addObject:cityDic];
            
        }
        
     //   [provinceArray safeAddObject:provinceDic];
        [provinceArray addObject:provinceDic];
        
        
    }
    
    return provinceArray;
    
//    NSData *data = [NSJSONSerialization dataWithJSONObject:provinceArray options:0 error:NULL];
//    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//    NSLog(@"%@", string);
}
    

+ (NSString *)stringWithDate:(NSDate *)date {
    
    float different = [date timeIntervalSinceNow];
    //    NSLog(@"%f", different);
    
    if (different > 0) {
        return @"Time Error!";
    } else {
        
        // 当前时间
        NSDate *currentDate = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *currentComps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:currentDate];
        NSInteger currentYear = [currentComps year];
        NSInteger currentMonth = [currentComps month];
        NSInteger currentDay = [currentComps day];
        
        // 传入时间
        NSDateComponents *comps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:date];
        NSInteger year = [comps year];
        NSInteger month = [comps month];
        NSInteger day = [comps day];
        NSInteger weekday = [comps weekday];
        //        NSLog(@"year:%ld month: %ld, day: %ld", year, month, day);
        
        // 传入时间的时分
        comps =[calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute)
                           fromDate:date];
        NSInteger hour = [comps hour];
        NSInteger minute = [comps minute];
        //        NSLog(@"hour:%ld minute: %ld", hour, minute);
        
        NSString *todayStr = [NSString stringWithFormat:@"%ld-%ld-%ld 23:59:59", (long)currentYear, (long)currentMonth, (long)currentDay];
        different = - [date timeIntervalSinceDate:[self dateFromString:todayStr]];
        float dayDifferent = floor(different / 86400);
        
        if (dayDifferent < 1) {
            return [NSString stringWithFormat:@"%.2ld:%.2ld", (long)hour, (long)minute];
        } else if (dayDifferent < 2) {
            return [NSString stringWithFormat:@"昨天 %.2ld:%.2ld", (long)hour, (long)minute];
        } else if (dayDifferent < 7) {
            NSString *weekdayStr = [NSString string];
            switch (weekday) {
                case 1:
                    weekdayStr = @"星期日";
                    break;
                    
                case 2:
                    weekdayStr = @"星期一";
                    break;
                    
                case 3:
                    weekdayStr = @"星期二";
                    break;
                    
                case 4:
                    weekdayStr = @"星期三";
                    break;
                    
                case 5:
                    weekdayStr = @"星期四";
                    break;
                    
                case 6:
                    weekdayStr = @"星期五";
                    break;
                    
                case 7:
                    weekdayStr = @"星期六";
                    break;
                    
                default:
                    break;
            }
            return [NSString stringWithFormat:@"%@ %.2ld:%.2ld", weekdayStr, (long)hour, (long)minute];
        } else if (year == currentYear) {
            return [NSString stringWithFormat:@"%ld-%ld %.2ld:%.2ld", (long)month, (long)day, (long)hour, (long)minute];
        } else {
            return [NSString stringWithFormat:@"%ld-%ld-%ld %.2ld:%.2ld", (long)year, (long)month, (long)day,  (long)hour,  (long)minute];
        }
    }
    
    
}

+ (NSDate *)dateFromString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}

#pragma Mark 计算富文本的高度
+(CGFloat)getSpaceLabelHeight:(NSString*)str  withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 0;//行间距 默认为0
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.0f
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, kScreenHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

+(void)showErrorMsg:(UIView *)view type:(int)type msg:(NSString *)msg{
    if (msg == nil ) {
        [view makeToast:@"服务器异常" duration:2.0 position:CSToastPositionCenter style:[[CSToastStyle alloc] initWithDefaultStyle]];
        return;
    }
    switch (type) {
//        case 100001:
//             [view makeToast:msg duration:2.0 position:CSToastPositionCenter style:[[CSToastStyle alloc] initWithDefaultStyle]];
//            [User clearLocalUser];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutSuccessNotify object:nil];
//            break;
        case 1102: //您还没有成为VIP会员，请先选择管家！
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_Select_Housekeeper object:nil];
            [view makeToast:msg duration:2.0 position:CSToastPositionCenter style:[[CSToastStyle alloc] initWithDefaultStyle]];
            break;
        default:
            [view makeToast:msg duration:2.0 position:CSToastPositionCenter style:[[CSToastStyle alloc] initWithDefaultStyle]];
            break;
    }
    
}

+(void)popBackFreshWithObj:(id)obj view:(UIView*)view{
    UITabBarController *tabBarController = (UITabBarController *)view.window.rootViewController;
    UINavigationController *viewController = tabBarController.selectedViewController;
    [viewController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:KNotification_Select_Address object:obj];
}

+(UIImage*) imageWithColor:( UIColor*)color1{
    CGRect rect = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color1 CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end


@implementation UIColor (extension)

+ (UIColor *)rgb:(NSString *)rgbHex{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != rgbHex)
    {
        NSScanner *scanner = [NSScanner scannerWithString:rgbHex];
        (void) [scanner scanHexInt:&colorCode];
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode);
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}


@end

