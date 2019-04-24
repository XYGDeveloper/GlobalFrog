//
//  OrderCommentCell.h
//  Qqw
//
//  Created by zagger on 16/8/29.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "OrderDetailGoodsCell.h"
#import "SZTextView.h"
#import "GoodsOrderTableViewCell.h"
@class OrderGoodsModel, OrderCmtBuildModel;
@interface OrderCommentCell : OrderDetailGoodsCell

@property (nonatomic, strong) SZTextView *textView;

@property(nonatomic,copy) EditTextViewBlock  editTextViewBlock;

- (void)refreshWithCommentInfo:(OrderCmtBuildModel *)cmtModel;

@end




/**
 *  创建订单评论时的模型
 */
@interface OrderCmtBuildModel : NSObject

/**
 *  被评论的商品信息
 */
@property (nonatomic, strong) OrderGoodsModel *goodsModel;

/**
 *  评分
 */
@property (nonatomic, assign) NSInteger star;

/**
 *  评论内容
 */
@property (nonatomic, copy) NSString *content;

@end
