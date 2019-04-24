//
//  OrderConfirmBar.h
//  Qqw
//
//  Created by zagger on 16/8/19.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  确认订单底部操作栏
 */
@interface OrderConfirmBar : UIView

@property (nonatomic, copy) void(^createBlock)(void);

- (void)refreshWithPrice:(NSString *)price;

@end
