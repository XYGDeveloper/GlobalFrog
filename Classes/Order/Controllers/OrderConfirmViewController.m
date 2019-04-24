//
//  OrderConfirmViewController.m
//  Qqw
//
//  Created by zagger on 16/8/18.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "OrderConfirmViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "AddressModel.h"
#import "ConponModel.h"
#import "OrderAddressView.h"
#import "OrderGoodsView.h"
#import "OrderFreightView.h"
#import "OrderMessageView.h"
#import "OrderCouponView.h"
#import "RealNameView.h"
#import "OrderConfirmBar.h"
#import "OrderApi.h"
#import "CZCountDownView.h"
#import "OrderPayHelper.h"
#import "OrderGoodsListViewController.h"
#import "PayModeViewController.h"
#import "AddressViewController.h"
#import "BecomeVipViewController.h"
#import "IsRealNameAuthApi.h"
#import "RealListModel.h"
#import "RealNameAuthViewController.h"
#import "RealNameAuthenticationViewController.h"
typedef void(^TimerStopBlock)();
@interface OrderConfirmViewController ()<ApiRequestDelegate>
@property (nonatomic,copy)TimerStopBlock timerStopBlock;
@property (nonatomic,assign)NSInteger timestamp;
@property (nonatomic, strong) UIImageView *adView;

@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;

@property (nonatomic, strong) OrderAddressView *addressView;

@property (nonatomic, strong) OrderGoodsView *goodsView;

@property (nonatomic, strong) OrderFreightView *freightView;

@property (nonatomic, strong) OrderMessageView *msgView;

@property (nonatomic, strong) OrderCouponView *couponView;

@property (nonatomic, strong) RealNameView *realNameAuthoView;

@property (nonatomic, strong) OrderConfirmBar *confirmBar;

@property (nonatomic, strong) OrderApi *api;

@property (nonatomic, strong) OrderCreateApi *createApi;

@property (nonatomic, strong) OrderConfirmItem *confirmItem;

@property (nonatomic,assign)NSInteger result;

/**
 *  选中的优惠券
 */
@property (nonatomic, strong) ConponModel *selectedCoupon;
/**
 *  选中的地址
 */
@property (nonatomic, strong) AddressModel *selectedAddress;

/*
 *  选中的实名认证信息
 */

@property (nonatomic, strong) RealListModel *model;


@property (nonatomic,strong)CZCountDownView *countView;

//验证是否通过实名认证
@property (nonatomic,strong)IsRealNameAuthApi *isRealNameAuthApi;

@end

@implementation OrderConfirmViewController

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    __weak typeof(self) wself = self;
    self.confirmBar.createBlock = ^{
        __strong typeof(wself) sself = wself;
        [sself createOrder];
    };
    
    self.addressView.selectAddressBlock = ^ {
        __strong typeof(wself) sself = wself;
        [sself selectAddress];
    };
    
    self.goodsView.checkGoodsListBlock = ^{
        __strong typeof(wself) sself = wself;
        OrderGoodsListViewController *vc = [[OrderGoodsListViewController alloc] initWithGoods:sself.confirmItem.orderForm.goodsList];
        vc.hidesBottomBarWhenPushed = YES;
        vc.isLimit = sself.isLimit;
        [sself.navigationController pushViewController:vc animated:YES];
    };
    
    self.couponView.selectCouponBlock = ^ {
        __strong typeof(wself) sself = wself;
        [sself selectCoupon];
    };
    
    self.realNameAuthoView.selectRealNameAuthoBlock = ^{
    
        __strong typeof(wself) sself = wself;
        [sself selectRealNameAutho];
    
    };
    
    
    [self confirmOrder];
}


#pragma Events
//确认订单
- (void)confirmOrder {
    [Utils addHudOnView:self.view];
    
    if (self.oType == OrderTypeNormal) {
        [self.api confirmOrderWithGoods:self.cartGoodsArray type:self.oType address:self.selectedAddress.address_id coupon:self.selectedCoupon.coupon_id];
    }
//    else if (self.oType == orderTypeCrowdfunding) {
//        [self.api confirmOrderWithGoods:self.crowdfundingArray type:self.oType];
//    }
}
 
- (void)refreshUI {
    _isLimit = NO;
  
    [self.addressView refreshWithAddress:self.confirmItem.address];

    if (self.oType == OrderTypeNormal) {
        [self.goodsView refreshWithCartGoods:self.confirmItem.orderForm.goodsList];
    } else if (self.oType == orderTypeCrowdfunding) {
        [self.goodsView refreshWithCartGoods:@[self.confirmItem.orderForm.cfsList ?: [CrowdfundingModel new]]];
    }
    
    [self.freightView refreshWithFreight:self.confirmItem.shippingFee showFreeTag:NO freeReason:@"银行客户专享，首单免邮"];
    [self.couponView refreshWithCouponTips:self.confirmItem.couponTips];
    [self.confirmBar refreshWithPrice:self.confirmItem.orderPayAmount];
    
    [self.realNameAuthoView refreshWithRealNameAuthoTips:self.model];
    
    int count = 0;
    for (CartGoodsModel *goods in self.confirmItem.orderForm.goodsList) {
        if (goods.is_limit) {
            _isLimit = goods.is_limit;
            count++;
        }
    }
    
    if (count == self.confirmItem.orderForm.goodsList.count) {
        notCanOrder = YES;
    }else{
        notCanOrder = NO;
    }
    
    if (_isLimit) {
         NSString * s = [NSString stringWithFormat:@"您有%i件商品\n因配送范围、库存原因导致失效",count];
        PromptView * p = [PromptView new];
        [p showWithMsg:s];
    }
}

//创建订单
- (void)createOrder {
    
    if (!self.selectedAddress.address_id || self.selectedAddress.address_id.length <= 0) {
        [Utils postMessage:@"请选择收货地址" onView:self.view];
        return;
    }
    
    NSLog(@"%@",self.realNameAuthoView.nameLabel.text);
    
    if (self.realNameAuthoView.nameLabel.text.length <=0 && self.result == 1) {
        
        UIAlertView *alertView = [UIAlertView alertViewWithTitle:nil message:@"你添加的是保税区商品，需要去填写认证信息" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] dismissBlock:^(UIAlertView *zg_alertView, NSInteger buttonIndex) {
            if (buttonIndex != zg_alertView.cancelButtonIndex) {
                RealNameAuthViewController *real = [RealNameAuthViewController new];
                [self.navigationController pushViewController:real animated:YES];
                
            }
        }];
        
        [alertView show];
        
        return;
    }

    if (notCanOrder) {
        [Utils showErrorMsg:[AppDelegate APP].window type:0 msg:@"商品无法购买，因配送范围、库存原因导致失效"];
        return;
    }
    
    [Utils addHudOnView:self.view];
    [self.createApi createOrderWithConfirmItem:self.confirmItem type:self.oType address:self.selectedAddress.address_id coupon:self.selectedCoupon.coupon_id card_id:self.model.rID leaveMessage:self.msgView.leaveMessage];
    
    [MobClick event:kEventOrderConfirm];
    
}

//选择认证信息

- (void)selectRealNameAutho{

     RealNameAuthViewController*vc = [[RealNameAuthViewController alloc] init];
    __weak typeof(self) wself = self;
    
    vc.selectblock = ^(RealListModel *model){
        __strong typeof(wself) sself = wself;
        sself.model = model;
        [sself.realNameAuthoView refreshWithRealNameAuthoTips:model];
        sself.confirmItem.realModel = model;
        [sself confirmOrder];
    };
    
    [self.navigationController pushViewController:vc animated:YES];

}

//选择收货地址
- (void)selectAddress {
    AddressViewController *vc = [[AddressViewController alloc] init];
    __weak typeof(self) wself = self;
    vc.selectblock = ^(AddressModel *address) {
        __strong typeof(wself) sself = wself;
        sself.selectedAddress = address;
        sself.confirmItem.address = address;
        [sself.addressView refreshWithAddress:address];
        [sself confirmOrder];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//选择优惠惠券
- (void)selectCoupon {
//    if (self.confirmItem.couponList.count == 0) {
//        return;
//    }
    CouponTableViewController * vc = [CouponTableViewController new];
    vc.conponType = CouponType_Unused;
    [vc.dataArray addObjectsFromArray:self.confirmItem.couponList];
    vc.selectUseConpon = ^(ConponModel *model) {
        self.selectedCoupon = model;
        [self confirmOrder];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ApiRequestDelegate
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    [Utils removeHudFromView:self.view];
    
    if (api == self.isRealNameAuthApi) {
        
        NSLog(@"需不需要实名认证%@",responsObject);
        NSString *authostring = responsObject[@"result"];
        if ([authostring integerValue] == 0) {
            self.realNameAuthoView.hidden = YES;
        }
        
        if ([authostring integerValue] == 1) {
            self.result = [authostring integerValue];
            self.realNameAuthoView.hidden = NO;
        }
        
    }
    
    
    if (api == self.api) {
        self.confirmItem = responsObject;
        self.selectedAddress = self.confirmItem.address;
        [self initUI];
        [self refreshUI];
    }
    if (api == self.createApi) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kOrderCreateSuccessNotify object:nil];
        NSLog(@"创建订单：%@",responsObject);
        
        PayModeViewController *vc = [[PayModeViewController alloc] initWithOrder:responsObject];
        
        NSInteger count = self.navigationController.viewControllers.count;
        vc.payCancelJumpViewController = [self.navigationController.viewControllers safeObjectAtIndex:count - 2];
        vc.paySuccessJumpViewController = [self.navigationController.viewControllers safeObjectAtIndex:count - 2];
        [self setNavigationTitleViewWithView:@"订单确认" timerWithTimer:@""];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [Utils removeHudFromView:self.view];
    [Utils postMessage:command.response.msg onView:self.view];
    if (api == self.api) {
        if ([command.response.code isEqualToString:kCodeNotVip]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                BecomeVipViewController *vc = [[BecomeVipViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:NO];
                
                NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                [array safeRemoveObjectAtIndex:array.count - 2];
                self.navigationController.viewControllers = array;
            });
        } else {
            weakify(self)
            [[EmptyManager sharedManager] showNetErrorOnView:self.view response:command.response operationBlock:^{
                strongify(self)
                [self confirmOrder];
            }];
        }
    }
    else if (api == self.createApi) {
        
    }
}


#pragma mark - Layout
- (void)initUI {
    if (!self.scrollView.superview) {
        NSLog(@"%@",self.parameter);
        [self.isRealNameAuthApi toJudgeIsRealNameAuthWithGoods_id_list:self.parameter];
        [self.view addSubview:self.adView];
        [self.view addSubview:self.scrollView];
        [self.view addSubview:self.confirmBar];
        [self.scrollView addSubview:self.addressView];
        [self.scrollView addSubview:self.goodsView];
        [self.scrollView addSubview:self.freightView];
        [self.scrollView addSubview:self.msgView];
        [self.scrollView addSubview:self.couponView];
        [self.scrollView addSubview:self.realNameAuthoView];
        
        [self configLayout];
    }
}

- (void)configLayout {
    [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
    }];
    
    [self.confirmBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@45);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adView.mas_bottom);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.confirmBar.mas_top);
    }];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@50);
    }];
    
    [self.goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.left.right.equalTo(@0);
        make.height.equalTo(@84);
        make.top.equalTo(self.addressView.mas_bottom).offset(10);
    }];
    
    [self.freightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.left.right.equalTo(@0);
        make.height.equalTo(@50);
        make.top.equalTo(self.goodsView.mas_bottom).offset(10);
    }];
    
    [self.msgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.left.right.equalTo(@0);
        make.height.equalTo(@85);
        make.top.equalTo(self.freightView.mas_bottom).offset(10);
    }];
    
    [self.couponView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.left.right.equalTo(@0);
        make.height.equalTo(@50);
        make.top.equalTo(self.msgView.mas_bottom).offset(10);
    }];
    
    [self.realNameAuthoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.left.right.equalTo(@0);
        make.height.equalTo(@50);
        make.top.equalTo(self.couponView.mas_bottom).offset(10);
        make.bottom.equalTo(@100);
        
    }];
}

#pragma mark - Properties
- (UIImageView *)adView {
    if (!_adView) {
        _adView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_adBg"]];
    }
    return _adView;
}

- (TPKeyboardAvoidingScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[TPKeyboardAvoidingScrollView alloc] init];
        _scrollView.backgroundColor = DefaultBackgroundColor;
        _scrollView.alwaysBounceVertical = YES;
    }
    return _scrollView;
}

- (OrderAddressView *)addressView {
    if (!_addressView) {
        _addressView = [[OrderAddressView alloc] initWithFrame:CGRectZero];
    }
    return _addressView;
}

- (OrderGoodsView *)goodsView {
    if (!_goodsView) {
        _goodsView = [[OrderGoodsView alloc] init];
    }
    return _goodsView;
}

- (OrderFreightView *)freightView {
    if (!_freightView) {
        _freightView = [[OrderFreightView alloc] initWithFrame:CGRectZero];
    }
    return _freightView;
}

- (OrderMessageView *)msgView {
    if (!_msgView) {
        _msgView = [[OrderMessageView alloc] init];
    }
    return _msgView;
}

- (OrderCouponView *)couponView {
    if (!_couponView) {
        _couponView = [[OrderCouponView alloc] init];
    }
    return _couponView;
}

- (RealNameView *)realNameAuthoView
{

    if (!_realNameAuthoView) {
        _realNameAuthoView = [[RealNameView alloc]init];
    }
    return _realNameAuthoView;
    
}

- (OrderConfirmBar *)confirmBar {
    if (!_confirmBar) {
        _confirmBar = [[OrderConfirmBar alloc] init];
    }
    return _confirmBar;
}

- (OrderApi *)api {
    if (!_api) {
        _api = [[OrderApi alloc] init];
        _api.delegate = self;
    }
    return _api;
}

- (OrderCreateApi *)createApi {
    if (!_createApi) {
        _createApi = [[OrderCreateApi alloc] init];
        _createApi.delegate = self;
    }
    return _createApi;
}

- (IsRealNameAuthApi *)isRealNameAuthApi
{

    if (!_isRealNameAuthApi) {
        _isRealNameAuthApi = [[IsRealNameAuthApi alloc]init];
        _isRealNameAuthApi.delegate = self;
        
    }
    return _isRealNameAuthApi;
}




@end
