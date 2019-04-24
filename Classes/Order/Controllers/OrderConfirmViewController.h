//
//  OrderConfirmViewController.h
//  Qqw
//
//  Created by zagger on 16/8/18.
//  Copyright © 2016年 gao.jian. All rights reserved.
//
#import "CartGoodsModel.h"
#import "PromptView.h"
#import "CouponTableViewController.h"
@interface OrderConfirmViewController : UIViewController{
    BOOL notCanOrder;
    
}

@property (nonatomic, assign) OrderType oType;

@property (nonatomic, strong)NSString *parameter;

@property (nonatomic, strong) NSArray *cartGoodsArray;

@property (nonatomic, strong) NSArray *crowdfundingArray;

@property (nonatomic,assign)long timeValue;

@property(nonatomic,assign)BOOL isLimit;

@end
