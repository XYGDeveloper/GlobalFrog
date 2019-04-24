//
//  SearchGoodsCell.h
//  Qqw
//
//  Created by zagger on 16/8/31.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsModel;
@interface SearchGoodsCell : UITableViewCell

- (void)refreshWithSearchGoodsModel:(GoodsModel *)goodsModel;

@end
