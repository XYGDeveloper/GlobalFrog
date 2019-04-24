//
//  OrderCommentViewController.h
//  Qqw
//
//  Created by zagger on 16/8/29.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderModel;
@interface OrderCommentViewController : UIViewController



- (id)initWithOrder:(OrderModel *)order;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CommentSubmitBar : UIView

/**
 *  点击发布评论按钮的回调方法
 */
@property (nonatomic, copy) void(^submitBlock)(void);

/**
 *  是否匿名评价
 */
@property (nonatomic, assign, readonly) BOOL isAnonymity;

@end
