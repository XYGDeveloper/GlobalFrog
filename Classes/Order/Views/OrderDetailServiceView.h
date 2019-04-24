//
//  OrderDetailServiceView.h
//  Qqw
//
//  Created by zagger on 16/8/22.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  订单详情页，显示服务信息的视图
 */
@interface OrderDetailServiceView : UIView

@property (nonatomic, copy) void(^callPhoneBlock)(void);

@end
