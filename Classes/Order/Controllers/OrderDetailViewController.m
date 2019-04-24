//
//  OrderDetailViewController.m
//  Qqw
//
//  Created by zagger on 16/8/22.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderModel.h"
#import "UIImage+Common.h"

#import "OrderApi.h"
#import "QQWRefreshHeader.h"
#import "OrderOperationManager.h"
#import "OrderListViewController.h"
#import "OrderDetailAddressCell.h"
#import "OrderDetailTrackCell.h"
#import "OrderDetailGoodsCell.h"
#import "OrderDetailFoldCell.h"
#import "OrderDetailAmountView.h"
#import "OrderDetailTimeView.h"
#import "OrderDetailServiceView.h"
#import "OrderListViewController.h"
#import "GoodsDetailViewController.h"
#import "ApplyAfterSaleViewController.h"
#import "AfterSaleDetailViewController.h"
#import "WebViewController.h"
typedef void(^TimerStopBlock)();
static NSInteger kDefaultShowGoodsCount = 3;//默认显示的商品个数

@interface OrderDetailViewController ()<ApiRequestDelegate, UITableViewDelegate, UITableViewDataSource>
{
    // 定时器
    NSTimer *timer;
}

@property (nonatomic,copy)TimerStopBlock timerStopBlock;
@property (nonatomic,assign)NSInteger timestamp;
@property (nonatomic,strong)NSString *timeValue;
@property (nonatomic,assign)long timerValue;
@property (nonatomic, strong) OrderDetailApi *api;

@property (nonatomic, strong) OrderOperationManager *opManager;

@property (nonatomic, strong) UITableView *contentView;

@property (nonatomic, strong) OrderDetailAmountView *amountView;

@property (nonatomic, strong) OrderDetailTimeView *timeView;

@property (nonatomic, strong) OrderDetailServiceView *serviceView;

@property (nonatomic, strong) UIButton *operationButton;

/**
 *  是否折叠商品列表，商品超过3个时默认折叠，可点击展开
 */
@property (nonatomic, assign) BOOL foldGoodsList;

@end

@implementation OrderDetailViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kOrderPaySuccessNotify object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kOrderStatusChangedNotify object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:kOrderPaySuccessNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:kOrderStatusChangedNotify object:nil];
    
    self.timestamp =[self.order.endtime intValue];
    
    weakify(self);
    self.timerStopBlock = ^{
        strongify(self);
        [self.operationButton setTitle:@"立即付款" forState:UIControlStateNormal];
        
        //跳转到关闭订单
        
        [self.navigationController pushViewController:[[OrderListViewController alloc]initWithOrderStatus:OrderReqStatusAll] animated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:kCounttimeEndRefreshList object:nil];
        
        
    };
    self.title = @"订单详情";
    self.foldGoodsList = YES;
    
    self.serviceView.callPhoneBlock = ^ {
        strongify(self)
        [self callService];
    };
    
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.operationButton];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(self.operationButton.mas_top);
    }];
    [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0);
    }];
    
    self.contentView.mj_header = [QQWRefreshHeader headerWithRefreshingBlock:^{
        strongify(self)
        [self.api getOrderDetailWithNumber:self.order.order_sn];
    }];
    
    //初始化配置，列表传入的订单信息将售后状态改为隐藏
    if (self.order) {
        for (OrderGoodsModel *model in self.order.goods_list) {
            model.is_after_sales = kAfterSaleStateNone;
        }
        [self refreshUI];
    }
    
    [self.contentView.mj_header beginRefreshing];
}

- (void)requestOrderDetail {
    [Utils addHudOnView:self.view];
    [self.api getOrderDetailWithNumber:self.order.order_sn];
}

- (void)notificationRecieved:(NSNotification *)note {
    if ([note.name isEqualToString:kOrderPaySuccessNotify] ||
        [note.name isEqualToString:kOrderStatusChangedNotify]) {
        [self requestOrderDetail];
    }
}

#pragma mark - ApiRequestDelegate
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    [self.contentView.mj_header endRefreshing];
    [Utils removeHudFromView:self.view];
    [[EmptyManager sharedManager] removeEmptyFromView:self.view];
    
    self.order = responsObject;
    [self refreshUI];
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.contentView.mj_header endRefreshing];
    [Utils removeHudFromView:self.view];
    [Utils postMessage:command.response.msg onView:self.view];
    
    weakify(self)
    [[EmptyManager sharedManager] showNetErrorOnView:self.view response:command.response operationBlock:^{
        strongify(self)
        [self.contentView.mj_header beginRefreshing];
    }];
}

#pragma mark - 
- (void)refreshUI {
    [self.amountView refreshWithOrder:self.order];
    [self.timeView refreshWithOrder:self.order];
    
    self.contentView.tableFooterView = [self footerView];
    [self.contentView reloadData];
    
    NSString *operationTitle = [self currentOrderOperation].title;
    [self.operationButton setTitle:operationTitle forState:UIControlStateNormal];
    if (operationTitle.length <= 0) {
        [self.operationButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
            make.height.equalTo(@0);
        }];
    } else {
        [self.operationButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
            make.height.equalTo(@44);
        }];
    }
}

#pragma mark - Events
//拨打服务电话
- (void)callService {
    [Utils callPhoneNumber:kServicePhoneNumber];
}

- (void)afterSaleForGoodsAtIndexPath:(NSIndexPath *)indexPath {
    OrderGoodsModel *goods = [self.order.goods_list safeObjectAtIndex:indexPath.row];
    
    if ([goods.is_after_sales isEqualToString:kAfterSaleStateNot]) {
        ApplyAfterSaleViewController *vc = [[ApplyAfterSaleViewController alloc] init];
        vc.afterSaleOrderId = self.order.order_sn;
        vc.afterSaleGoods = goods;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([goods.is_after_sales isEqualToString:kAfterSaleStateAlready]) {
        AfterSaleDetailViewController *vc = [[AfterSaleDetailViewController alloc] init];
        vc.afterSaleGoods = goods;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//订单相关操作
- (void)operationButtonClicked:(id)sender {
    
    weakify(self)
    OrderOperation *op = [self currentOrderOperation];
    [self.opManager doOperation:op forOrder:self.order withCompletion:^(ApiCommand *cmd, BOOL success) {
        strongify(self)
        if ([op.code isEqualToString:kOrderOperationDelete]) { //删除订单
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.order.goods_list.count > kDefaultShowGoodsCount) {
        return 3;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        OrderTrack *track = [self.order.track firstObject];
        return track ? 2 : 1;
    }
    else if (section == 1) {
        return self.foldGoodsList ? MIN(kDefaultShowGoodsCount, self.order.goods_list.count) : self.order.goods_list.count;
    }
    else if (section == 2) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70.0;
    } else if (indexPath.section == 1) {
        return 90.0;
    } else if (indexPath.section == 2) {
        return 30 + 19;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 10.0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//收货地址
            OrderDetailAddressCell *cell = (OrderDetailAddressCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDetailAddressCell class])];
            [cell refreshWithAddress:self.order.user_address];
            return cell;
        } else if (indexPath.row == 1) {//物流跟踪
            OrderDetailTrackCell *cell = (OrderDetailTrackCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDetailTrackCell class])];
            OrderTrack *track = [self.order.track lastObject];
            [cell refreshWithTrack:track];
            return cell;
        }
    }
    else if (indexPath.section == 1) {
        OrderDetailGoodsCell *cell = (OrderDetailGoodsCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDetailGoodsCell class])];
        OrderGoodsModel *goods = [self.order.goods_list safeObjectAtIndex:indexPath.row];
        weakify(self)
        cell.afterSaleBlock = ^{
            strongify(self)
            [self afterSaleForGoodsAtIndexPath:indexPath];
        };
        [cell refreshWithOrderGoods:goods];
        return cell;
    }
    else if (indexPath.section == 2) {
        OrderDetailFoldCell *cell = (OrderDetailFoldCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDetailFoldCell class])];
        __weak typeof(self) wself = self;
        cell.foldBlock = ^{
            __strong typeof(wself) sself = wself;
            [sself foldDisplayGoodsList];
        };
        
        [cell refreshWithFold:self.foldGoodsList foldCount:self.order.goods_list.count - kDefaultShowGoodsCount];
        
        return cell;
    }
    
    
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 1) {//查看物流
        if (self.order.trackurl.length > 0) {
            WebViewController *vc = [[WebViewController alloc] initWithURLString:self.order.trackurl];
            NSLog(@"查看物流：%@",self.order.trackurl);
            vc.useHtmlTitle = YES;
            vc.openURLInNewController = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (indexPath.section == 1) {//跳转到商品详情
        OrderGoodsModel *goods = [self.order.goods_list safeObjectAtIndex:indexPath.row];
        GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] initWithGoodsIdentifier:goods.goods_id];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//折叠或展开商品列表
- (void)foldDisplayGoodsList {
    self.foldGoodsList = !self.foldGoodsList;
    [self.contentView reloadData];
}


#pragma mark - Private Methods
- (OrderOperation *)currentOrderOperation {
    NSArray *array = self.order.status_code;
    return [array firstObject];
}

- (UIView *)footerView {
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    
    [footView addSubview:self.amountView];
    [footView addSubview:self.timeView];
    [footView addSubview:self.serviceView];
    
    CGFloat padding = 10;
    
    [self.amountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@120);
    }];
    
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.amountView.mas_bottom).offset(padding);
    }];

    [self.serviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.timeView.mas_bottom).offset(padding);
        make.height.equalTo(@40);
        make.bottom.equalTo(@-10);
    }];
    
    CGSize size = [footView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    footView.height = size.height;
    
    return footView;
}

#pragma mark - Properties
- (OrderDetailApi *)api {
    if (!_api) {
        _api = [[OrderDetailApi alloc] init];
        _api.delegate = self;
    }
    return _api;
}

- (OrderOperationManager *)opManager {
    if (!_opManager) {
        _opManager = [[OrderOperationManager alloc] initWithParentViewController:self];
    }
    return _opManager;
}

- (UITableView *)contentView {
    if (!_contentView) {
        _contentView = [[[UITableView alloc] init] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.backgroundColor = DefaultBackgroundColor;
//        _contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_contentView registerClass:[OrderDetailAddressCell class] forCellReuseIdentifier:NSStringFromClass([OrderDetailAddressCell class])];
        [_contentView registerClass:[OrderDetailTrackCell class] forCellReuseIdentifier:NSStringFromClass([OrderDetailTrackCell class])];
        [_contentView registerClass:[OrderDetailGoodsCell class] forCellReuseIdentifier:NSStringFromClass([OrderDetailGoodsCell class])];
        [_contentView registerClass:[OrderDetailFoldCell class] forCellReuseIdentifier:NSStringFromClass([OrderDetailFoldCell class])];
    }
    return _contentView;
}

- (OrderDetailAmountView *)amountView {
    if (!_amountView) {
        _amountView = [[OrderDetailAmountView alloc] init];
    }
    return _amountView;
}

- (OrderDetailTimeView *)timeView {
    if (!_timeView) {
        _timeView = [[OrderDetailTimeView alloc] init];
    }
    return _timeView;
}

- (OrderDetailServiceView *)serviceView {
    if (!_serviceView) {
        _serviceView = [[OrderDetailServiceView alloc] init];
    }
    return _serviceView;
}

- (UIButton *)operationButton {
    if (!_operationButton) {
        _operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _operationButton.titleLabel.font = Font(14);
        [_operationButton setBackgroundImage:[UIImage imageWithColor:AppStyleColor] forState:UIControlStateNormal];
        [_operationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_operationButton addTarget:self action:@selector(operationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _operationButton;
}




#pragma mark - 计时器方法
- (void)getDetailTimeWithTimestamp:(NSInteger)timestamp{
    NSInteger ms = timestamp;
    NSInteger ss = 1;
    NSInteger mi = ss * 60;
    NSInteger hh = mi * 60;
    NSInteger dd = hh * 24;
    
    // 剩余的
    NSInteger day = ms / dd;// 天
    NSInteger hour = (ms - day * dd) / hh;// 时
    NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
    NSInteger second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
    NSLog(@"------------------%ld:%ld",(long)minute,(long)second);
    
    
    NSString *min;
    NSString *se;
    
    if (minute<10) {
        min = [NSString stringWithFormat:@"0%ld",(long)minute];
    }else{
        min = [NSString stringWithFormat:@"%ld",(long)minute];
    }
    if (second<10) {
        se = [NSString stringWithFormat:@"0%ld",(long)second];
    }else{
        se = [NSString stringWithFormat:@"%ld",(long)second];
    }
    
    self.timeValue = [NSString stringWithFormat:@"立即付款%@:%@",min,se];
    
     [self.operationButton setTitle:_timeValue forState:UIControlStateNormal];
    self.timerValue = second + minute * 60;
    
    NSLog(@"%ld",self.timerValue);
    
    
}


// 拿到外界传来的时间戳
- (void)setTimestamp:(NSInteger)timestamp{
    _timestamp = timestamp;
    if (_timestamp != 0) {
        timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
        
    }
}


// 初始化timer

-(void)timer:(NSTimer*)timerr{
    _timestamp--;
    [self getDetailTimeWithTimestamp:_timestamp];
    if (_timestamp == 0) {
        [timer invalidate];
        timer = nil;
        // 执行block回调
        self.timerStopBlock();
    }
}


@end
