//
//  SearchViewController.h
//  Qqw
//
//  Created by zagger on 16/8/31.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SearchType) {
    SearchType_qqw = 1,
    SearchType_wsx
};


@interface SearchViewController : UIViewController

@property(nonatomic,assign) SearchType searchType;

@property(nonatomic,strong) CLLocation * currentLocation;

@end
