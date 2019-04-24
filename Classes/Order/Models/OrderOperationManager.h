//
//  OrderOperationManager.h
//  Qqw
//
//  Created by zagger on 16/9/1.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderModel, OrderOperation, ApiCommand;
@interface OrderOperationManager : NSObject

- (id)initWithParentViewController:(UIViewController *)parentViewController;

- (void)doOperation:(OrderOperation *)op
           forOrder:(OrderModel *)order
     withCompletion:(void(^)(ApiCommand *cmd, BOOL success))completionBlock;



@end
