//
//  OrderOperationManager.m
//  Qqw
//
//  Created by zagger on 16/9/1.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "OrderOperationManager.h"
#import "OrderApi.h"
#import "PayModeViewController.h"
#import "OrderCommentViewController.h"
#import "SuccessViewController.h"
#import "WebViewController.h"

@interface OrderOperationManager ()<ApiRequestDelegate>

@property (nonatomic, weak) UIViewController *parentVC;

@property (nonatomic, copy) void(^completionBlock)(ApiCommand *cmd, BOOL success);

@property (nonatomic, strong) OrderDeleteApi *deleteApi;

@property (nonatomic, strong) OrderCancelApi *cancelApi;

@property (nonatomic, strong) OrderConfirmRecievedApi *recievedApi;

@end

@implementation OrderOperationManager

- (id)initWithParentViewController:(UIViewController *)parentViewController {
    if (self = [super init]) {
        self.parentVC = parentViewController;
    }
    
    return self;
}

#pragma mark - Public Methods
- (void)doOperation:(OrderOperation *)op
           forOrder:(OrderModel *)order
     withCompletion:(void(^)(ApiCommand *cmd, BOOL success))completionBlock {
    
    if ([op.code isEqualToString:kOrderOperationPayment]) { //去支付
        PayModeViewController *vc = [[PayModeViewController alloc] initWithOrder:order];
        vc.paySuccessJumpViewController = self.parentVC.navigationController.topViewController;
        [self.parentVC.navigationController pushViewController:vc animated:YES];
    }
    else if ([op.code isEqualToString:kOrderOperationCancel]) { //取消订单
        weakify(self)
        UIActionSheet *actionSheet = [UIActionSheet actionSheetWithTitle:@"请选择取消的理由"
                                                       cancelButtonTitle:@"取消"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:@[@"我不想买", @"信息填写错误，重新下单", @"下错单了", @"其他原因"] dismissBlock:^(UIActionSheet *zg_actionSheet, NSInteger buttonIndex) {
                                                           strongify(self)
                                                           if (buttonIndex != zg_actionSheet.cancelButtonIndex) {
                                                               [Utils addHudOnView:self.parentVC.view];
                                                               
                                                               NSString *reason = [zg_actionSheet buttonTitleAtIndex:buttonIndex];
                                                               [self.cancelApi cancelOrder:order withReason:reason];
                                                           }
                                                       }];
        
        [actionSheet showInView:self.parentVC.view];
    }
    else if ([op.code isEqualToString:kOrderOperationDelete]) { //删除订单
        
        weakify(self)
        UIAlertView *alertView = [UIAlertView alertViewWithTitle:@"" message:@"您确认要删除该订单吗？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] dismissBlock:^(UIAlertView *zg_alertView, NSInteger buttonIndex) {
            strongify(self)
            if (buttonIndex != zg_alertView.cancelButtonIndex) {
                [Utils addHudOnView:self.parentVC.view];
                [self.deleteApi deleteOrder:order];
            }
        }];
        
        [alertView show];
    }
    else if ([op.code isEqualToString:kOrderOperationComment]) { //去评论
        OrderCommentViewController *vc = [[OrderCommentViewController alloc] initWithOrder:order];
        [self.parentVC.navigationController pushViewController:vc animated:YES];
    }
    else if ([op.code isEqualToString:kOrderOperationAppendCmt]) { //追加评论
        OrderCommentViewController *vc = [[OrderCommentViewController alloc] initWithOrder:order];
        [self.parentVC.navigationController pushViewController:vc animated:YES];
    }
    else if ([op.code isEqualToString:kOrderOperationTrack]) { //查看物流
        WebViewController *vc = [[WebViewController alloc] initWithURLString:order.trackurl];
        
        NSLog(@"查看物流%@",order.trackurl);
        vc.useHtmlTitle = YES;
        vc.openURLInNewController = NO;
        [self.parentVC.navigationController pushViewController:vc animated:YES];
    }
    else if ([op.code isEqualToString:kOrderOperationConfirmRecieved]) { //确认收货
        weakify(self)
        UIAlertView *alertView = [UIAlertView alertViewWithTitle:@"" message:@"确认收货" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] dismissBlock:^(UIAlertView *zg_alertView, NSInteger buttonIndex) {
            strongify(self)
            if (buttonIndex != zg_alertView.cancelButtonIndex) {
                [Utils addHudOnView:self.parentVC.view];
                [self.recievedApi confirmRecievedWithOrder:order];
            }
        }];
        
        [alertView show];
    }
}


#pragma mark - ApiRequestDelegate
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    [Utils removeHudFromView:self.parentVC.view];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kOrderStatusChangedNotify object:nil];
    if (self.completionBlock) {
        self.completionBlock(command, YES);
    }
    if (api == self.cancelApi) {
        NSString *orderId = [command.parameters objectForKey:@"order_sn"];
        NSString *cancelReason = [command.parameters objectForKey:@"reason"];
        SuccessViewController *vc = [SuccessViewController orderCancelSuccessViewControllerWithReason:cancelReason order:orderId];
        [self.parentVC.navigationController pushViewController:vc animated:YES];
    }
    else if (api == self.deleteApi) {
        
    }
    else if (api == self.recievedApi) {
        
    }
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [Utils removeHudFromView:self.parentVC.view];
    [Utils postMessage:command.response.msg onView:self.parentVC.view];
    
    if (self.completionBlock) {
        self.completionBlock(command, NO);
    }
    if (api == self.cancelApi) {
        
    }
    else if (api == self.deleteApi) {
        
    }
    else if (api == self.recievedApi) {
        
    }
}

#pragma mark - Properties
- (OrderDeleteApi *)deleteApi {
    if (!_deleteApi) {
        _deleteApi = [[OrderDeleteApi alloc] init];
        _deleteApi.delegate = self;
    }
    return _deleteApi;
}

- (OrderCancelApi *)cancelApi {
    if (!_cancelApi) {
        _cancelApi = [[OrderCancelApi alloc] init];
        _cancelApi.delegate = self;
    }
    return _cancelApi;
}

- (OrderConfirmRecievedApi *)recievedApi {
    if (!_recievedApi) {
        _recievedApi = [[OrderConfirmRecievedApi alloc] init];
        _recievedApi.delegate = self;
    }
    return _recievedApi;
}

@end
