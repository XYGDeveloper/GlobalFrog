//
//  DoyenListCell.h
//  Qqw
//
//  Created by zagger on 16/8/30.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@class DoyenItem;

typedef void (^toAttention)(DoyenItem *item);

@interface DoyenListCell : BaseCollectionViewCell

@property (nonatomic, strong) UIButton *attentionButton;

//关注状态和关注人数
@property (nonatomic, strong)UILabel *attentionCount;

@property (nonatomic, strong)UIButton *attentionState;

@property (nonatomic,strong)toAttention attention;

@property (nonatomic,strong)DoyenItem *item;
- (void)refreshWithListItem:(DoyenItem *)dayenItem;

@end
