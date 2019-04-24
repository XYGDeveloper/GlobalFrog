//
//  ApplyAfterSaleViewController.h
//  Qqw
//
//  Created by zagger on 16/9/7.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderGoodsModel;
/**
 *  申请售后
 */
@interface ApplyAfterSaleViewController : UIViewController

@property (nonatomic, copy) NSString *afterSaleOrderId;

@property (nonatomic, strong) OrderGoodsModel *afterSaleGoods;

@end
