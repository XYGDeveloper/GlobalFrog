//
//  OrderFreightView.h
//  Qqw
//
//  Created by zagger on 16/8/19.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  订单确认页面，显示运费信息的视图
 */
@interface OrderFreightView : UIView

- (void)refreshWithFreight:(NSString *)freight showFreeTag:(BOOL)showFreeTag freeReason:(NSString *)freeReason;

@end
