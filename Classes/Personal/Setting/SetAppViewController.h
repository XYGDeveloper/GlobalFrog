//
//  SetAppViewController.h
//  Qqw
//
//  Created by XYG on 16/8/15.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserRequestApi.h"
typedef void(^dismissBlock)();

@interface SetAppViewController : MyViewController<UIGestureRecognizerDelegate>
@property (nonatomic,copy)dismissBlock block;

@end
