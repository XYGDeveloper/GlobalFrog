//
//  AddressViewController.h
//  Qqw
//
//  Created by XYG on 16/8/16.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressModel;
@interface AddressViewController : MyViewController

@property (nonatomic, copy) void(^selectblock)(AddressModel *address);
//添加一个参数，用于判断是从下单入口进入，还是从个人中心入口进入
@property (nonatomic,assign)BOOL flage;

@end
