//
//  OrderListViewController.m
//  Qqw
//
//  Created by zagger on 16/8/20.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderApi.h"
#import "OrderListApi.h"
#import "OrderListCell.h"
#import "OrderDetailViewController.h"
#import "OrderOperationManager.h"
#import "OrderModel.h"
#import "QQWRefreshHeader.h"
#import "QQWRefreshFooter.h"

@interface OrderListViewController ()<UITableViewDelegate, UITableViewDataSource, ApiRequestDelegate>

@property (nonatomic, copy) NSString *orderStatus;

@property (nonatomic, strong) OrderListApi *listApi;

@property (nonatomic, strong) OrderOperationManager *opManager;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *orderArray;


@property (nonatomic,strong)OrderModel *order;

@end

@implementation OrderListViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithOrderStatus:(NSString *)orderStatus {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.orderStatus = orderStatus;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:kOrderPaySuccessNotify object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:kOrderStatusChangedNotify object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationRecieved:) name:kCounttimeEndRefreshList object:nil];
//         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccess) name:kOrderPaySuccessNotify object:nil];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.listApi = [[OrderListApi alloc] initWithOrderStatus:self.orderStatus];
    self.listApi.delegate = self;
    self.orderArray = [[NSMutableArray alloc] init];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    __weak typeof(self) wself = self;
    self.tableView.mj_header = [QQWRefreshHeader headerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.listApi refresh];
    }];
    
    self.tableView.mj_footer = [QQWRefreshFooter footerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.listApi loadNextPage];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}


#pragma mark - Events
- (void)notificationRecieved:(NSNotification *)note {
    if ([note.name isEqualToString:kOrderStatusChangedNotify] || [note.name isEqualToString:kCounttimeEndRefreshList]) {
        
        [self.tableView.mj_header beginRefreshing];
        
    }else if([note.name isEqualToString:kOrderPaySuccessNotify]){
          [self.tableView.mj_header beginRefreshing];
    }
    
}

- (void)operateOrderAtIndexPath:(NSIndexPath *)indexPath withOperation:(OrderOperation *)op {
    
    _order = [self.orderArray safeObjectAtIndex:indexPath.section];
    
    __weak typeof(self) wself = self;
    [self.opManager doOperation:op forOrder:_order withCompletion:^(ApiCommand *cmd, BOOL success) {
        __strong typeof(wself) sself = wself;
        if ([op.code isEqualToString:kOrderOperationDelete]) { //删除订单
            [sself.orderArray safeRemoveObjectAtIndex:indexPath.section];
            
            [sself.tableView beginUpdates];
            [sself.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationTop];
            [sself.tableView endUpdates];
            
        }
    }];
}


#pragma mark - ApiRequestDelegate
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    
    NSLog(@"订单列表%@",responsObject);
    [self.tableView.mj_footer resetNoMoreData];
    [self.tableView.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.tableView];
    
    NSArray *array = (NSArray *)responsObject;
    if (array.count <= 0) {
        [[EmptyManager sharedManager] showEmptyOnView:self.tableView withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"列表还是空的" operationText:nil operationBlock:nil];
    } else {
        
        [self.orderArray removeAllObjects];
        [self.orderArray addObjectsFromArray:responsObject];
        
        [self.tableView reloadData];
    }
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [Utils postMessage:command.response.msg onView:self.view];
    [self.tableView.mj_header endRefreshing];
    
    if (self.orderArray.count <= 0) {
        weakify(self)
        [[EmptyManager sharedManager] showNetErrorOnView:self.tableView response:command.response operationBlock:^{
            strongify(self)
            [self.tableView.mj_header beginRefreshing];
        }];
    }
}

- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    [self.tableView.mj_footer endRefreshing];
    
    [self.orderArray addObjectsFromArray:responsObject];
    [self.tableView reloadData];
}

- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.tableView.mj_footer endRefreshing];
    [Utils postMessage:command.response.msg onView:self.view];
}

- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 154;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.orderArray.count - 1) {
        return 0.1;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListCell *cell = (OrderListCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderListCell class])];
    
    OrderModel *order = [self.orderArray safeObjectAtIndex:indexPath.section];
    
    cell.model = order;
    
    __weak typeof(self) wself = self;
    cell.operationBlock = ^(OrderOperation *op) {
        __strong typeof(wself) sself = wself;
        [sself operateOrderAtIndexPath:indexPath withOperation:op];
    };
    
    weakify(cell);
    cell.freshList = ^{
        strongify(cell);
        cell.statusLabel.text = @"交易关闭";
        NSLog(@"开始刷新列表");
        [self.listApi refresh];
        [self.tableView reloadData];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderModel *order = [self.orderArray safeObjectAtIndex:indexPath.section];
    OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc] init];
    orderDetailVC.order = order;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
    
}


#pragma mark -
- (void)setShouldScrollToTop:(BOOL)scrollToTop {
    self.tableView.scrollsToTop = scrollToTop;
}

#pragma mark - Properties
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = DefaultBackgroundColor;
        [_tableView registerClass:[OrderListCell class] forCellReuseIdentifier:NSStringFromClass([OrderListCell class])];
    }
    return _tableView;
}

- (OrderOperationManager *)opManager {
    if (!_opManager) {
        _opManager = [[OrderOperationManager alloc] initWithParentViewController:self];
    }
    return _opManager;
}

@end
