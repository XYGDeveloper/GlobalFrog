//
//  GoodsListCell.h
//  Qqw
//
//  Created by zagger on 16/8/31.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@class GoodsModel;
@interface GoodsListCell : BaseCollectionViewCell

@property (nonatomic, copy) void(^favBlock)(void);

- (void)refreshWithGoods:(GoodsModel *)goods;

@end
