//
//  PayModeViewController.m
//  Qqw
//
//  Created by zagger on 16/8/24.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "PayModeViewController.h"
#import "OrderModel.h"
#import "OrderPayHelper.h"
#import "SuccessViewController.h"
#import "OrderListViewController.h"
#import "UnionpayInfo.h"


typedef void(^TimerStopBlock)();
@interface PayModeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,copy)TimerStopBlock timerStopBlock;
@property (nonatomic,assign)NSInteger timestamp;
@property (nonatomic, strong) OrderModel *order;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *payModeArray;

@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UIImageView *wechatArrowView;
@property (nonatomic, strong) UIImageView *alipayArrowView;

@property (nonatomic, strong) UIView *dividerView;

@property (nonatomic, strong) MyTimers * myTimers;

@end

@implementation PayModeViewController

- (id)initWithOrder:(OrderModel *)order {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.order = order;
        self.shouldJumpToSuccessPage = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _myTimers = [MyTimers new];
    [_myTimers startTimersWithTime: [self.order.endtime integerValue] block:^(NSString *time) {
        [self setNavigationTitleViewWithView:@"全球蛙收银台" timerWithTimer:@""];
    }];
//    [self setNavigationTitleViewWithView:@"全球蛙收银台" timerWithTimer:@""];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:(UIBarButtonItemStylePlain) target:nil action:nil];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor clearColor];
    
    if ([WXPayService isWXAppInstalled]) {
        self.payModeArray = @[PayModeWechat, PayModeAliPay];
    } else {
        self.payModeArray = @[PayModeAliPay];
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccess) name:kOrderPaySuccessNotify object:nil];
    
}

#pragma mark ================== noty =================
-(void)paySuccess{
    [MobClick event:kEventOrderPay];
     [_myTimers canceTime];
    
    SuccessViewController *vc = [SuccessViewController paySuccessViewControllerWithJumpBack:self.paySuccessJumpViewController];
    vc.popBackViewController = self.paySuccessJumpViewController;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)popButtonClicked:(id)sender {
    weakify(self)
    UIAlertView *alertView = [UIAlertView alertViewWithTitle:@"" message:@"您还未支付成功，确认要离开吗？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] dismissBlock:^(UIAlertView *zg_alertView, NSInteger buttonIndex) {
        strongify(self)
        if (buttonIndex != alertView.cancelButtonIndex) {
            if (self.payCancelJumpViewController && [self.navigationController.viewControllers containsObject:self.payCancelJumpViewController]) {
                [self.navigationController popToViewController:self.payCancelJumpViewController animated:YES];
                
            } else {
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
    }];
    
    [alertView show];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.payModeArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0
    ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    cell.textLabel.textColor = TextColor2;
    cell.textLabel.font = Font(14);
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"订单金额";
        cell.imageView.image = [UIImage imageNamed:@"payMode_orderIcon"];
        
        self.amountLabel.text = [Utils priceDisplayStringFromPrice:self.order.order_amount];
        if (self.amountLabel.superview) {
            [self.amountLabel removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.amountLabel];
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.centerY.equalTo(cell.contentView);
        }];
        
    } else if (indexPath.section == 1) {
        NSString *payMode = [self.payModeArray safeObjectAtIndex:indexPath.row];
        if ([payMode isEqualToString:PayModeWechat]) {
            cell.textLabel.text = @"微信支付";
            cell.imageView.image = [UIImage imageNamed:@"payMode_wechat"];
            
            if (self.wechatArrowView.superview) {
                [self.wechatArrowView removeFromSuperview];
            }
            [cell.contentView addSubview:self.wechatArrowView];
            [self.wechatArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@-10);
                make.centerY.equalTo(cell.contentView);
            }];
            
        } else if ([payMode isEqualToString:PayModeAliPay]) {
            cell.textLabel.text = @"支付宝支付";
            cell.imageView.image = [UIImage imageNamed:@"payMode_alipay"];
            
            if (self.alipayArrowView.superview) {
                [self.alipayArrowView removeFromSuperview];
            }
            [cell.contentView addSubview:self.alipayArrowView];
            [self.alipayArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@-10);
                make.centerY.equalTo(cell.contentView);
            }];
        }
        
        if (indexPath.row > 0) {
            if (self.dividerView.superview) {
                [self.dividerView removeFromSuperview];
            }
            
            [cell.contentView addSubview:self.dividerView];
            [self.dividerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@10);
                make.right.equalTo(@-10);
                make.top.equalTo(@0);
                make.height.equalTo(@0.5);
            }];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *payMode = [self.payModeArray safeObjectAtIndex:indexPath.row];
    [UnionpayInfo requestPayInfoWithOrderNumber:self.order.order_sn  payMode:payMode superView:self.view finshBlock:^(UnionpayInfo *obj, NSError *error) {
        
    }];
    
    return;
//    [Utils addHudOnView:self.view];
//    
//    __weak typeof(self) wself = self;
//    [[OrderPayHelper sharedInstance] payOrder:self.order withPayMode:payMode callBack:^(NSString *resultType, OrderModel *order) {
//        __weak typeof(wself) sself = wself;
//        [Utils removeHudFromView:sself.view];
//        
//        if ([resultType isEqualToString:PayResultTypeSuccess]) {//支付成功
//            [[NSNotificationCenter defaultCenter] postNotificationName:kOrderPaySuccessNotify object:nil];
//            
//            [CATransaction begin];
//            weakify(self)
//            [CATransaction setCompletionBlock:^{
//                strongify(self)
//                if (self.paySuccessCallBack) {
//                    self.paySuccessCallBack();
//                }
//            }];
// 
//            if (self.shouldJumpToSuccessPage) {
//                SuccessViewController *vc = [SuccessViewController paySuccessViewControllerWithJumpBack:self.paySuccessJumpViewController];
//                vc.popBackViewController = self.paySuccessJumpViewController;
//                
//                //支付成功,推送通知
//                 [[NSNotificationCenter defaultCenter] postNotificationName:kRewardSuccessNotify object:nil];
//                
//                [self.navigationController pushViewController:vc animated:YES];
//                
//            } else {
//                if (self.paySuccessJumpViewController && [self.navigationController.viewControllers containsObject:self.paySuccessJumpViewController]) {
//                    [self.navigationController popToViewController:self.paySuccessJumpViewController animated:YES];
//                    
//                } else {
//                    [self.navigationController popViewControllerAnimated:YES];
//                }
//            }
//            
//            [CATransaction commit];
//        } else {
//
//            
//        }
//    }];
//    
   
}

#pragma mark - Properties
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = DefaultBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

- (UIImageView *)wechatArrowView {
    if (!_wechatArrowView) {
        _wechatArrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Order_rightArrow"]];
    }
    return _wechatArrowView;
}

- (UIImageView *)alipayArrowView {
    if (!_alipayArrowView) {
        _alipayArrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Order_rightArrow"]];
    }
    return _alipayArrowView;
}

- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = GeneralLabelA(BFont(16), TextColor2, NSTextAlignmentRight);
        
    }
    return _amountLabel;
}

- (UIView *)dividerView {
    if (!_dividerView) {
        _dividerView = [[UIView alloc] init];
        _dividerView.backgroundColor = DividerGrayColor;
    }
    return _dividerView;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_myTimers canceTime];
}


@end
