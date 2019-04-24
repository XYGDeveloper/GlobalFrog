//
//  OrderDetailGoodsCell.h
//  Qqw
//
//  Created by zagger on 16/8/23.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderGoodsModel;

/**
 *  订单详情页，显示商品信息
 */
@interface OrderDetailGoodsCell : UITableViewCell

@property (nonatomic, copy) void(^afterSaleBlock)(void);

/** 隐藏售后按钮，默认为NO */
@property (nonatomic, assign) BOOL hideAfterSale;

@property (nonatomic, strong, readonly) UIImageView *goodsImgView;

@property (nonatomic, strong, readonly) UILabel *goodsNameLabel;

@property (nonatomic, strong, readonly) UILabel *goodsAttrLabel;

@property (nonatomic, strong, readonly) UILabel *goodsPriceLabel;

- (void)refreshWithOrderGoods:(OrderGoodsModel *)goods;

@end
