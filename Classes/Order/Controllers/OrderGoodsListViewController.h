//
//  OrderGoodsListViewController.h
//  Qqw
//
//  Created by zagger on 16/9/5.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  确认订单时，查看订单中的商品列表
 */
@interface OrderGoodsListViewController : UIViewController

- (id)initWithGoods:(NSArray *)goodsArray;

@property (nonatomic,assign)BOOL isLimit;

@end
