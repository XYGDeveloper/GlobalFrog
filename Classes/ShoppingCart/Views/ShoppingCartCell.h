//
//  ShoppingCartCell.h
//  Qqw
//
//  Created by zagger on 16/8/16.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartGoodsModel.h"

@interface ShoppingCartCell : UITableViewCell

- (void)refreshSelectStatus:(BOOL)selected;

- (void)refreshWithGoods:(CartGoodsModel *)goods;

@property (nonatomic, copy) void(^selectBlock)(BOOL);

@property (nonatomic, copy) void(^countEditBlock)(NSInteger);

@property (nonatomic, copy) void(^imageClickBlock)(void);

@property (nonatomic, strong) CartGoodsModel *goods;

-(void)setDataWithGoods:(CartGoodsModel*)model;

@end
