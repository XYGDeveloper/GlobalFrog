//
//  OrderOkViewController.h
//  Qqw
//
//  Created by 全球蛙 on 2017/3/7.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderOkViewController : UIViewController

@property(nonatomic,strong) NSArray * goodsArray;
@property (nonatomic, assign) OrderType oType;
@property (nonatomic,assign)long timeValue;
@property (nonatomic, strong)NSString *parameter;

@property (nonatomic,assign)BOOL result;



@end
