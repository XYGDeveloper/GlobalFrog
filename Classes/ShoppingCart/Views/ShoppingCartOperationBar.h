//
//  ShoppingCartOperationBar.h
//  Qqw
//
//  Created by zagger on 16/8/16.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShoppingCartOperationBarDelegate;
@interface ShoppingCartOperationBar : UIView

@property (nonatomic, weak) id<ShoppingCartOperationBarDelegate> delegate;

/**
 *  是否全选
 */
@property (nonatomic, assign) BOOL fullSelected;

/**
 *  当前选中商品的总价
 */
@property (nonatomic, assign, readonly) CGFloat totalPrice;

/**
 *  当前选中的商品件数
 */
@property (nonatomic, assign, readonly) NSInteger selectCount;

/**
 *  是否处于编辑状态
 */
@property (nonatomic, assign, getter=isEdit) BOOL edit;

- (void)refreshWithSelectCount:(NSInteger)selectCount totalPrice:(CGFloat)totalPrcie;

@end




@protocol ShoppingCartOperationBarDelegate <NSObject>

@optional
- (void)operationBarDidSelect:(ShoppingCartOperationBar *)operationBar;
- (void)operationBarDidSettle:(ShoppingCartOperationBar *)operationBar;
- (void)operationBarDidFaverate:(ShoppingCartOperationBar *)operationBar;
- (void)operationBarDidDelete:(ShoppingCartOperationBar *)operationBar;

@end
