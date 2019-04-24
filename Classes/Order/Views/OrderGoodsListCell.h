//
//  OrderGoodsListCell.h
//  Qqw
//
//  Created by zagger on 16/9/5.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CartGoodsModel;
@interface OrderGoodsListCell : UITableViewCell

- (void)refreshWithGoods:(CartGoodsModel *)goodsModel;

@end
