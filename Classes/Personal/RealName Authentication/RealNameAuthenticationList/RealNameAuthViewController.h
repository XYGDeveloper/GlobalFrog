//
//  RealNameAuthViewController.h
//  Qqw
//
//  Created by 全球蛙 on 2017/1/5.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RealListModel;

@interface RealNameAuthViewController : MyViewController

@property (nonatomic, copy) void(^selectblock)(RealListModel *model);
//添加一个参数，用于判断是从下单入口进入，还是从个人中心入口进入
@property (nonatomic,assign)BOOL flage;

@end
