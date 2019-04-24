//
//  OrderGoodsView.h
//  Qqw
//
//  Created by zagger on 16/8/18.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  订单确认面显示商品的视图
 */
@interface OrderGoodsView : UIView

@property (nonatomic, copy) void(^checkGoodsListBlock)(void);

- (void)refreshWithCartGoods:(NSArray *)cartGoods;

@end
