//
//  OrderAddressView.h
//  Qqw
//
//  Created by zagger on 16/8/18.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressModel;

/**
 *  订单确认时显示收货地址的视图
 */
@interface OrderAddressView : UIView

@property (nonatomic, copy) void(^selectAddressBlock)(void);

- (void)refreshWithAddress:(AddressModel *)address;

@end
