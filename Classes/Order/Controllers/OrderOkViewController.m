//
//  OrderOkViewController.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/7.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "OrderOkViewController.h"
#import "GoodsOrderTableViewCell.h"
#import "OrderConfirmBar.h"
#import "OrderAddressTableViewCell.h"
#import "OrderSelectTableViewCell.h"
#import "AddressViewController.h"
#import "RealNameAuthViewController.h"
#import "OrderConfirmItem.h"
#import "CartGoodsModel.h"
#import "PayModeViewController.h"
#import "CreateOrderInfo.h"
#import "BecomeVipViewController.h"

@interface OrderOkViewController ()<UITableViewDataSource,UITableViewDelegate>{
//    UITextView * currentTextView;
         NSInteger currentTextViewtag;
    UILabel * rezLabel;
}

@property (nonatomic, strong) OrderConfirmBar *confirmBar;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) AddressModel *selectedAddress;
@property (nonatomic, strong) ConponModel *selectedCoupon;
@property (nonatomic, strong) OrderConfirmItem *confirmItem;

@property (nonatomic, strong) MyTimers * myTimers;
@end

static NSString * addressCell = @"addressCell";
static NSString * goodsCell = @"goodsCell";
static NSString * goodsSelectCell = @"goodsSelectCell";
@implementation OrderOkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView * imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_adBg"]];
    [self.view addSubview:imgView];
    [imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
    }];
    
     _confirmBar = [[OrderConfirmBar alloc] init];
    [self.view addSubview:_confirmBar];
    [_confirmBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@45);
    }];
    
    __weak typeof(self) wself = self;
    self.confirmBar.createBlock = ^{
        __strong typeof(wself) sself = wself;
        [sself createOrder];
    };
   
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(imgView.mas_bottom);
        make.bottom.equalTo(_confirmBar.mas_top);
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderAddressTableViewCell" bundle:nil] forCellReuseIdentifier:addressCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodsOrderTableViewCell" bundle:nil] forCellReuseIdentifier:goodsCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderSelectTableViewCell" bundle:nil] forCellReuseIdentifier:goodsSelectCell];
    
    _myTimers = [MyTimers new];
    [_myTimers startTimersWithTime:_timeValue block:^(NSString *time) {
        [self setNavigationTitleViewWithView:@"订单确认" timerWithTimer:time];
    }];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:(UIBarButtonItemStylePlain) target:nil action:nil];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chooseHome) name:KNotification_Select_Housekeeper object:nil];
    [CartGoodsInfo requestIsRealNameAuthWithGoods:self.parameter superView:self.view finshBlock:^(id obj, NSError *error) {
        if (!error) {
            NSString * type = obj[@"result"];
            self.result = type.intValue;
//            self.result = YES;
            [_tableView reloadData];
        }else{
        }
    }];
    
    [self request];
}

#pragma mark ================== wode =================
-(void)request{
    [OrderConfirmItem requestOrderOkWithData:_goodsArray type:_oType address:_selectedAddress.address_id coupon:self.selectedCoupon.coupon_id superView:self.view finshBlock:^(OrderConfirmItem * obj, NSError * error) {
        if (!error) {
            NSLog(@"%@",obj.mj_JSONObject);
            self.confirmItem = obj;
            
            self.selectedAddress = self.confirmItem.address;
            [self.confirmBar refreshWithPrice:self.confirmItem.orderPayAmount];

            [self.tableView reloadData];
        }
    }];
}

-(void)createOrder{
    if (!self.selectedAddress.address_id || self.selectedAddress.address_id.length <= 0) {
        [Utils postMessage:@"请选择收货地址" onView:self.view];
        return;
    }
    
    NSLog(@"选择认证者   =%@=",self.confirmItem.realModel);
    if (!self.confirmItem.realModel.realname && self.result == 1) {
        UIAlertView *alertView = [UIAlertView alertViewWithTitle:nil message:@"你添加的是保税区商品，需要去填写认证信息" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] dismissBlock:^(UIAlertView *zg_alertView, NSInteger buttonIndex) {
            if (buttonIndex != zg_alertView.cancelButtonIndex) {
                [self selectRealNameAutho];
            }
        }];
        
        [alertView show];
        
        return;
    }
    
    [CreateOrderInfo requestCreateOrderWithInfo:self.confirmItem superView:self.view finshBlock:^(id obj, NSError * error) {
        if (!error) {
            
            NSDictionary *dic =[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"kShoppintCartSelectStatus"];
            NSMutableDictionary * mdic = [[NSMutableDictionary alloc]initWithDictionary:dic];
            for (CartGoodsModel * g in self.goodsArray) {
                [mdic removeObjectForKey:g.cart_id];
                [mdic removeObjectForKey:[NSString stringWithFormat:@"Type_%@",g.rtype]];
            }
            [[NSUserDefaults standardUserDefaults] setObject:mdic forKey:@"kShoppintCartSelectStatus"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kOrderCreateSuccessNotify object:nil];
             [_myTimers canceTime];
            PayModeViewController *vc = [[PayModeViewController alloc] initWithOrder:obj];
            
            NSInteger count = self.navigationController.viewControllers.count;
            vc.payCancelJumpViewController = [self.navigationController.viewControllers safeObjectAtIndex:count - 2];
            vc.paySuccessJumpViewController = [self.navigationController.viewControllers safeObjectAtIndex:count - 2];
            [self setNavigationTitleViewWithView:@"订单确认" timerWithTimer:@""];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
}

#pragma mark ================== noty =================
-(void)chooseHome{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BecomeVipViewController *vc = [[BecomeVipViewController alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [array safeRemoveObjectAtIndex:array.count - 2];
        self.navigationController.viewControllers = array;
    });
}

- (void)keyboardWillShow:(NSNotification *)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, height, 0);
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:currentTextViewtag] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)aNotification{
   _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
}

#pragma mark ================== Table view data source =================
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return 55;
    }
    if (indexPath.section >self.confirmItem.newgoods.count ) {
        return 45;
    }
    return [GoodsOrderTableViewCell cellHeightWithCarInfo:self.confirmItem.newgoods[indexPath.section-1]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3+self.confirmItem.newgoods.count + self.result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        OrderAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCell forIndexPath:indexPath];
        cell.addressInfo = self.selectedAddress;
        return cell;
    }
    if (indexPath.section == self.confirmItem.newgoods.count +1) {
        
        static NSString * celliden = @"seachCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:celliden];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:celliden];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.text = @"运费";
        if (self.confirmItem.shippingFee.intValue>0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"¥ %@",self.confirmItem.shippingFee];
        }else{
            cell.detailTextLabel.text = @"免运费";
        }
        return cell;
    }
    
    if (indexPath.section > self.confirmItem.newgoods.count+1 ) {
        OrderSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsSelectCell forIndexPath:indexPath];
        if (indexPath.section == self.confirmItem.newgoods.count +2) {
            cell.nameLabel.text = @"优惠券";
            cell.msgLabel.text = self.confirmItem.couponList.count==0?@"无可用优惠券":[NSString stringWithFormat:@"有%lu张可用优惠券",(unsigned long)self.confirmItem.couponList.count];
        }else{
            cell.model = self.confirmItem.realModel;
            rezLabel = cell.msgLabel;
        }
        
        return cell;
    }
    
    GoodsOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCell forIndexPath:indexPath];

    cell.desTextView.tag  = 10000 + indexPath.section;
    cell.car = self.confirmItem.newgoods[indexPath.section-1];

    cell.editTextViewBlock = ^(UITextView * textView){
        currentTextViewtag = textView.tag-10000;
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self selectAddress];
    }else if (indexPath.section == self.confirmItem.newgoods.count + 2){
        [self selectCoupon];
    }else if (indexPath.section == self.confirmItem.newgoods.count + 3){
        [self selectRealNameAutho];
    }
}

#pragma mark ================== jiaohu =================
- (void)selectAddress {
    AddressViewController *vc = [[AddressViewController alloc] init];
    __weak typeof(self) wself = self;
    vc.selectblock = ^(AddressModel *address) {
        __strong typeof(wself) sself = wself;
        sself.selectedAddress = address;
        sself.confirmItem.address = address;
        [sself.tableView reloadData];
        [sself request];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)selectCoupon {
    if (self.confirmItem.couponList.count != 0) {
        CouponTableViewController * vc = [CouponTableViewController new];
        vc.conponType = CouponType_Unused;
        [vc.dataArray addObjectsFromArray:self.confirmItem.couponList];
        vc.selectUseConpon = ^(ConponModel *model) {
            self.selectedCoupon = model;
            [self request];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)selectRealNameAutho{
    
    RealNameAuthViewController*vc = [[RealNameAuthViewController alloc] init];
    __weak typeof(self) wself = self;
    
    vc.selectblock = ^(RealListModel *model){
        __strong typeof(wself) sself = wself;
        sself.confirmItem.realModel = model;
        [sself.tableView reloadData];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark ================== super =================
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
//    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"kShoppintCartSelectStatus"]);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_myTimers canceTime];
}

@end
