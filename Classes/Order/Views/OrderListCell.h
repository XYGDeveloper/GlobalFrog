//
//  OrderListCell.h
//  Qqw
//
//  Created by zagger on 16/8/20.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^refreshOrderList)();
@class OrderModel, OrderOperation;
@interface OrderListCell : UITableViewCell

@property (nonatomic, copy) void(^operationBlock)(OrderOperation *op);
@property (nonatomic,assign)NSInteger timestamp;
@property (nonatomic, strong) UILabel *statusLabel;//订单状态
@property (nonatomic,strong)OrderModel *model;
@property (nonatomic,copy)refreshOrderList freshList;


@end



@interface UIButton (OrderOperation)

@property (nonatomic, strong) OrderOperation *operation;

@end
