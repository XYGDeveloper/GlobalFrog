//
//  OrderListContainerViewController.m
//  Qqw
//
//  Created by zagger on 16/8/20.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "OrderListContainerViewController.h"
#import "SegmentContainer.h"
#import "LoginViewControll.h"
#import "OrderListViewController.h"
#import "OrderDetailViewController.h"
#import "OrderModel.h"

static NSString const * statusKey = @"status";
static NSString const * statusNameKey = @"name";

@interface OrderListContainerViewController ()<SegmentContainerDelegate>

@property (nonatomic, strong) SegmentContainer *container;

@property (nonatomic, strong) NSArray *orderStatusArray;

@end

@implementation OrderListContainerViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的订单";
    [self configOrderStatus];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:kJumpToOrderDetailPageNotify object:nil];
    
    [self.view addSubview:self.container];
    [self selectOrderStatus];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:[UINavigationBar appearance].shadowImage];
}

#pragma mark - Events
- (void)notificationRecieved:(NSNotification *)note {
    if ([note.name isEqualToString:kJumpToOrderDetailPageNotify]) {
        [self.navigationController popToViewController:self animated:NO];
        
        NSString *orderId = [note object];
        OrderModel *order = [[OrderModel alloc] init];
        order.order_sn = orderId;
        OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
        vc.order = order;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - SegmentContainerDelegate
- (NSUInteger)numberOfItemsInSegmentContainer:(SegmentContainer *)segmentContainer {
    return self.orderStatusArray.count;
}

- (NSString *)segmentContainer:(SegmentContainer *)segmentContainer titleForItemAtIndex:(NSUInteger)index {
    NSDictionary *dic = [self.orderStatusArray safeObjectAtIndex:index];
    return [dic objectForKey:statusNameKey];
}

- (id)segmentContainer:(SegmentContainer *)segmentContainer contentForIndex:(NSUInteger)index {
    NSDictionary *dic = [self.orderStatusArray safeObjectAtIndex:index];
    OrderListViewController *listVC = [[OrderListViewController alloc] initWithOrderStatus:[dic objectForKey:statusKey]];
    return listVC;
}

- (void)segmentContainer:(SegmentContainer *)segmentContainer didSelectedItemAtIndex:(NSUInteger)index {
    
}


#pragma mark - Helper 
- (void)configOrderStatus {
    self.orderStatusArray = @[@{statusKey:OrderReqStatusAll, statusNameKey:@"全部"},
                              @{statusKey:OrderReqStatusWaitPay, statusNameKey:@"待付款"},
                              @{statusKey:OrderReqStatusWaitSend, statusNameKey:@"待发货"},
                              @{statusKey:OrderReqStatusWaitRecieve, statusNameKey:@"待收货"},
                              @{statusKey:OrderReqStatusWaitComment, statusNameKey:@"待评价"}];
}

- (void)selectOrderStatus {
    if (!self.orderStatus || self.orderStatus.length <= 0) {
        self.orderStatus = OrderReqStatusAll;
    }
    
    for (NSDictionary *dic in self.orderStatusArray) {
        NSString *status = [dic objectForKey:statusKey];
        if ([status isEqualToString:self.orderStatus]) {
            NSUInteger index = [self.orderStatusArray indexOfObject:dic];
            [self.container setSelectedIndex:index withAnimated:YES];
        }
    }
}


#pragma mark - Properties
- (SegmentContainer *)container {
    if (!_container) {
        _container = [[SegmentContainer alloc] initWithFrame:self.view.bounds];
        _container.parentVC = self;
        _container.delegate = self;
        _container.titleFont = Font(13);
        _container.titleNormalColor = TextColor2;
        _container.titleSelectedColor = TextColor1;
        _container.containerBackgroundColor = DefaultBackgroundColor;
        _container.indicatorColor = AppStyleColor;
    }
    return _container;
}

@end
