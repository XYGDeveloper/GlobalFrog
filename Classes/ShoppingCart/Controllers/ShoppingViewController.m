//
//  ShoppingViewController.m
//  Qqw
//
//  Created by XYG on 16/7/31.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "ShoppingViewController.h"
#import "ShoppingCartCell.h"
#import "ShoppingCartOperationBar.h"
#import "QQWRefreshHeader.h"
#import "OrderConfirmViewController.h"
#import "User.h"
#import "GoodsDetailViewController.h"
#import "CZCountDownView.h"
#import <objc/runtime.h>
#import "RealNameAuthViewController.h"
#define tempToken [[NSUserDefaults standardUserDefaults] stringForKey:@"token"]
#define UID @"100"

static NSString * TypeButName = @"typeButName";

static NSString * const kEditedCartId = @"cart_id";
static NSString * const kEditedNumber = @"number";

typedef void (^getTime)(NSInteger time);
@interface ShoppingViewController ()<UITableViewDelegate,UITableViewDataSource,ShoppingCartOperationBarDelegate>{
}

@property (nonatomic,copy)getTime time;
@property (nonatomic,assign)NSInteger timestamp;
@property (nonatomic,strong)NSString *timeValue;
@property (nonatomic,assign)long timerValue;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *editButton;

@property (nonatomic, strong) CartGoodsInfo *cartInfo;

@property (nonatomic, strong) ShoppingCartOperationBar *operationBar;

@property (nonatomic, strong) NSMutableDictionary *selectDic;//保存购物车选中状态

//购买数量被编辑时，临时保存编辑前的数量，如果请求失败，恢复到该数量
@property (nonatomic, copy) NSString *editOriginCount;
//正在编辑数量的商品对应的indexPath
@property (nonatomic, strong) NSIndexPath *editIndexPath;

@property (nonatomic, strong) NSMutableArray *goodListerArray;

@property (nonatomic, strong) NSString *goodString;

@property (nonatomic, strong) MyTimers * myTimers;

@end

@implementation ShoppingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:kOrderCreateSuccessNotify object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receNoti:) name:kPauseCountRobot object:nil];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    _myTimers = [MyTimers new];
//    [self setNavigationTitleViewWithView:@"购物车" timerWithTimer:@""];

  self.title = @"购物车";
    
    self.editButton = [self setRightNavigationItemWithTitle:@"编辑" action:@selector(editButtonClicked:)];
    __weak typeof(self) wself = self;
    self.tableView.mj_header = [QQWRefreshHeader headerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
          [sself getList];
    }];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.operationBar];
    [self configLayout];
}

#pragma mark ================== wode =================
- (void)getList {
    [CartGoodsInfo requestCarListWithSuperView:nil finshBlock:^(CartGoodsInfo *obj, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        if ([MyRequestApiClient sharedClient].networkStatus == AFNetworkReachabilityStatusNotReachable) {
            [[EmptyManager sharedManager] showNetErrorOnView:self.view response:nil operationBlock:^{
                [self getList];
            }];
            return ;
        }
        if (obj.goods.count==0) {
            [_myTimers canceTime];
//            [self setNavigationTitleViewWithView:@"购物车" timerWithTimer:nil];
            [[EmptyManager sharedManager] showEmptyOnView:self.view
                                                withImage:[UIImage imageNamed:@"cart_empty"]
                                                  explain:@"购物车空空如也~~~"
                                            operationText:@"赶紧去抢购吧！"
                                           operationBlock:^{
                                               [Utils jumpToHomepage];
                                           }];

        }else{
            self.cartInfo = obj;
            [[EmptyManager sharedManager] removeEmptyFromView:self.view];
            [self refreshSelectState];
            [self refreshOperationBar];
            
//            [_myTimers startTimersWithTime: [self.cartInfo.endtime integerValue] block:^(NSString *time) {
//                if ([time isEqualToString:@"00:00"]) {
//                    self.cartInfo = nil;
//                    [self.tableView reloadData];
//                }
//                [self setNavigationTitleViewWithView:@"购物车" timerWithTimer:time];
//            }];
//
//            if ([self.cartInfo.endtime isEqualToString:@"0"] && self.cartInfo.goods.count <= 0) {
//                [_myTimers canceTime];
//                [self setNavigationTitleViewWithView:@"购物车" timerWithTimer:@""];
//            }else{
//                [self setNavigationTitleViewWithView:@"购物车" timerWithTimer:@""];
//            }
        }
    }];
}

-(void)refreshSelectState{
    for (CartGroupItem *groupItem in self.cartInfo.goods) {
        BOOL  state =  [self.selectDic safeObjectForKey:[NSString stringWithFormat:@"Type_%i",groupItem.rtype]];
        int typeCount = 0;
        for (CartGoodsModel *goods in groupItem.list) {
            if ([goods isKindOfClass:[CartGoodsModel class]]) {
                BOOL selected = [self isCartGoodsSelected:goods];
                if (selected) {
                    typeCount ++;
                }
                if (state) {
                    [self.selectDic safeSetObject:@(YES) forKey:goods.cart_id];
                }
            }
        }

        if (typeCount == groupItem.list.count) {
            [self.selectDic safeSetObject:@(YES) forKey:[NSString stringWithFormat:@"Type_%i",groupItem.rtype]];
        }
        
    }

    [self refreshOperationBar];
}

#pragma mark - Events
- (void)editButtonClicked:(id)sender {
    self.operationBar.edit = !self.operationBar.edit;
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        [btn setTitle:self.operationBar.edit ? @"完成" : @"编辑" forState:UIControlStateNormal];
    }
}

- (void)notificationRecieved:(NSNotification *)note {
    if ([note.name isEqualToString:kOrderCreateSuccessNotify] ||
        [note.name isEqualToString:kAddToCartSuccessNotify]) {//订单创建成功或加入商品到购物车成功后，刷新购物车列表
        [self getList];
    }
}

- (void)receNoti:(NSNotification *)noti{
    if ([noti.name isEqualToString:kPauseCountRobot]) {//逆向返回计时器指nil
//        [self setNavigationTitleViewWithView:@"购物车" timerWithTimer:@""];
    }
}

-(void)goCouoreder:(UITapGestureRecognizer*)tap{
    UILabel * labe = (UILabel*)tap.view;
    if ([labe.text isEqualToString:@"去凑单"]) {
        [Utils jumpToHomepage];
    }
}

-(void)showFreight{
    [[MyAlertView new] showWithShoppingCar];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CartGroupItem *groupItem = self.cartInfo.goods[section];
    float topHeght = 0;
    if (groupItem.rtype == 0 &&(groupItem.nowMoney < self.cartInfo.shipping_fee)) {
        topHeght = 20;
    }
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30+topHeght)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel * labe = [UILabel new];
    labe.backgroundColor = [UIColor rgb:MSG_color];
    NSString * tmpstr = [self.cartInfo.shipping_msg stringByReplacingOccurrencesOfString:@"%s" withString:[NSString stringWithFormat:@"%0.2f",self.cartInfo.shipping_fee - groupItem.nowMoney]];
    labe.text = [NSString stringWithFormat:@"    %@",tmpstr];
    labe.font = [UIFont systemFontOfSize:13];
    [view addSubview:labe];
    [labe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
        make.height.equalTo(@(topHeght));
    }];
  
    UIView * backView = [UIView new];
    [view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(labe.mas_bottom);
    }];
    
    UIButton * b = [UIButton new];
    [b setImage:[UIImage imageNamed:@"cart_unselect"] forState:UIControlStateNormal];
    [b setImage:[UIImage imageNamed:@"cart_selected"] forState:UIControlStateSelected];
    [b addTarget:self action:@selector(clickTypeBut:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(b, &TypeButName, groupItem, OBJC_ASSOCIATION_RETAIN);
    NSString * type = [self.selectDic objectForKey:[NSString stringWithFormat:@"Type_%i",groupItem.rtype]];
    b.selected = type.boolValue;
    [backView addSubview:b];
    [b mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.centerY.equalTo(@0);
        make.width.equalTo(@35);
    }];
 
    UILabel * label = [UILabel new];
    label.text = [NSString stringWithFormat:@"%@ >",groupItem.name];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor grayColor];
    [backView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(b.mas_centerY);
        make.left.equalTo(b.mas_right).offset(10);
    }];
    
    UILabel * cdMsgLabel = [UILabel new];
    cdMsgLabel.textColor = AppStyleColor;
    cdMsgLabel.font = [UIFont systemFontOfSize:12];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goCouoreder:)];
    [cdMsgLabel addGestureRecognizer:tap];
    [cdMsgLabel removeFromSuperview];
    [backView addSubview:cdMsgLabel];
    [cdMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-25);
        make.centerY.equalTo(b.mas_centerY);
    }];
    
    if (groupItem.rtype == 0 ) {
        if (groupItem.nowMoney < self.cartInfo.shipping_fee) {
            cdMsgLabel.text = groupItem.shipping;
            cdMsgLabel.userInteractionEnabled = YES;
        }else{
            cdMsgLabel.userInteractionEnabled = NO;
            cdMsgLabel.text = @"已免运费";
            
            UIButton * but = [UIButton buttonWithType:UIButtonTypeSystem];
            [but setImage:[UIImage imageNamed:@"icon_tip"] forState:NO];
            but.tintColor = [UIColor darkGrayColor];
            [but addTarget:self action:@selector(showFreight) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:but];
            [but mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@-8);
                make.width.equalTo(@15);
                make.centerY.equalTo(b.mas_centerY);
            }];
        }
    }else{
        cdMsgLabel.text = groupItem.shipping;
    }


  

    UIView * linview = [UIView new];
    linview.backgroundColor = [UIColor lightGrayColor];
    linview.alpha = 0.6;
    [backView addSubview:linview];
    [linview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
 
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CartGroupItem *groupItem = self.cartInfo.goods[section];
    float topHeght = 0;
    if (groupItem.rtype == 0 &&(groupItem.nowMoney < self.cartInfo.shipping_fee)) {
        topHeght = 20;
    }
    return 30 + topHeght;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cartInfo.goods.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CartGroupItem *groupItem = self.cartInfo.goods[section];
    return groupItem.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCartCell *cell = (ShoppingCartCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ShoppingCartCell class])];
    CartGroupItem *groupItem = self.cartInfo.goods[indexPath.section];
    CartGoodsModel *goods = groupItem.list[indexPath.row];
 
    
    [cell refreshSelectStatus:[self isCartGoodsSelected:goods]];
    [cell setDataWithGoods:goods];
    weakify(self)
    cell.selectBlock = ^(BOOL selected) {
        strongify(self)
        [self goodsAtIndexPath:indexPath selected:selected];
    };
    
    cell.countEditBlock = ^(NSInteger count) {
        strongify(self)
        [self goodsAtIndexPath:indexPath changeBuyCount:count];
    };
    
    cell.imageClickBlock = ^{
        strongify(self)
        CartGoodsModel *goods = [self cartGoodsAtIndexPath:indexPath];
        GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] initWithGoodsIdentifier:goods.goods_id];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    };
  
    //隐藏最后一条分隔线
    if (indexPath.section == self.cartInfo.cartGoodsList.count - 1 && indexPath.row == groupItem.goodsList.count - 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
    } else {
        cell.separatorInset = UIEdgeInsetsMake(0, 46.0, 0, 0);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CartGoodsModel *goods = [self cartGoodsAtIndexPath:indexPath];
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] initWithGoodsIdentifier:goods.goods_id];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        ShoppingCartCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [CartGoodsInfo requestDeletCarWithGoods:@[cell.goods] superView:self.view finshBlock:^(id obj, NSError *error) {
            if (!error) {
                [self.selectDic safeRemoveObjectForKey:cell.goods.cart_id];
                [self.selectDic safeRemoveObjectForKey:[NSString stringWithFormat:@"Type_%@",cell.goods.rtype]];
                [_myTimers canceTime];
//                [self setNavigationTitleViewWithView:@"购物车" timerWithTimer:@""];
                [self getList];
            }
        }];
       
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
       
    }
}

#pragma mark - 选择状态相关
//全选，或全不选
- (void)fullSelectOperation:(BOOL)selected {
    for (CartGroupItem *groupItem in self.cartInfo.goods) {
        if (selected) {
            [self.selectDic safeSetObject:@(selected) forKey:[NSString stringWithFormat:@"Type_%i",groupItem.rtype]];
        }else{
            [self.selectDic safeRemoveObjectForKey:[NSString stringWithFormat:@"Type_%i",groupItem.rtype]];
        }

        for (CartGoodsModel *goods in groupItem.list) {
            if ([goods isKindOfClass:[CartGoodsModel class]]) {
                if (selected) {
                    [self.selectDic safeSetObject:@(YES) forKey:goods.cart_id];
                } else {
                    [self.selectDic safeRemoveObjectForKey:goods.cart_id];
                }
            }
        }
    }
    
    [self refreshOperationBar];

}

- (void)refreshOperationBar {
    NSInteger totalCartCount = 0;//购物车总条数
    NSInteger selectedCartCount = 0;//选中的购物车条数
    NSInteger selectedGoodsCount = 0;//选中商品的总件数
    CGFloat totalPrice = 0;//选中商品的总价格
    
    for (CartGroupItem *groupItem in self.cartInfo.goods) {
        groupItem.nowMoney = 0;
        for (CartGoodsModel *goods in groupItem.list) {
            if ([goods isKindOfClass:[CartGoodsModel class]]) {
                totalCartCount ++;
                BOOL selected = [self isCartGoodsSelected:goods];
                if (selected) {
                    selectedCartCount ++;
                    selectedGoodsCount += goods.goods_number.integerValue;
                    totalPrice += [goods goodsTotalAmount];
                    
                    groupItem.nowMoney += [goods goodsTotalAmount];
                }
            }
        }
    }
    [self.tableView reloadData];
    self.operationBar.fullSelected = selectedCartCount == totalCartCount;
    [self.operationBar refreshWithSelectCount:selectedGoodsCount totalPrice:totalPrice];
}


#pragma mark ================== edit info =================
-(void)clickTypeBut:(UIButton*)but{
    but.selected = !but.selected;

    CartGroupItem *groupItem = objc_getAssociatedObject(but, &TypeButName);
    NSArray * a = groupItem.list;
    for ( CartGoodsModel *goods in a) {
        if (but.selected) {
            [self.selectDic safeSetObject:@(YES) forKey:goods.cart_id];
        }else{
            [self.selectDic safeSetObject:@(NO) forKey:goods.cart_id];
        }
    }
    [self.selectDic safeSetObject:@(but.selected) forKey:[NSString stringWithFormat:@"Type_%i",groupItem.rtype]];
    
    [self refreshOperationBar];
}

//一个商品被选中，或取消选中状态
- (void)goodsAtIndexPath:(NSIndexPath *)indexPath selected:(BOOL)selected {
    CartGoodsModel *goods = [self cartGoodsAtIndexPath:indexPath];
    if (selected) {
        [self.selectDic safeSetObject:@(YES) forKey:goods.cart_id];
    } else {
        [self.selectDic safeRemoveObjectForKey:goods.cart_id];
    }
    [self selectTypeWithindexPath:indexPath];
    [self refreshOperationBar];
}

-(void)selectTypeWithindexPath:(NSIndexPath *)indexPath{
    CartGroupItem *groupItem = self.cartInfo.goods[indexPath.section];
    int selectCount = 0;
    for (CartGoodsModel *goods in groupItem.list) {
        BOOL selected = [self isCartGoodsSelected:goods];
        if (selected) {
            selectCount++;
        }
    }
    if (selectCount == groupItem.list.count) {
        [self.selectDic safeSetObject:@(YES) forKey:[NSString stringWithFormat:@"Type_%i",groupItem.rtype]];
    }else{
        [self.selectDic safeRemoveObjectForKey:[NSString stringWithFormat:@"Type_%i",groupItem.rtype]];

    }
}

//一个商品的购买数量被编辑
- (void)goodsAtIndexPath:(NSIndexPath *)indexPath changeBuyCount:(NSInteger)count {
    CartGoodsModel *goods = [self cartGoodsAtIndexPath:indexPath];
    self.editOriginCount = goods.goods_number;
    self.editIndexPath = indexPath;
    
    goods.goods_number = [NSString stringWithFormat:@"%ld",(long)count];
    BOOL selected = [self isCartGoodsSelected:goods];
    if (selected) {
        [self refreshOperationBar];
    }
    [CartGoodsInfo requestEditCarWithCarId:goods.cart_id number:(int)count superView:self.view finshBlock:^(id obj, NSError *error) {
        if (!error) {
            [self refreshGoodsAtIndexPath:self.editIndexPath buyCount:obj[kEditedNumber]];
        }else{
            [self refreshGoodsAtIndexPath:self.editIndexPath buyCount:self.editOriginCount];
        }
    }];
}

- (void)refreshGoodsAtIndexPath:(NSIndexPath *)indexPath buyCount:(NSString *)countString {
    CartGoodsModel *goods = [self cartGoodsAtIndexPath:indexPath];
    
    goods.goods_number = countString;
    BOOL selected = [self isCartGoodsSelected:goods];
    if (selected) {
        [self refreshOperationBar];
     
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - ShoppingCartOperationBarDelegate
- (void)operationBarDidSelect:(ShoppingCartOperationBar *)operationBar {
    [self fullSelectOperation:operationBar.fullSelected];
}

- (void)operationBarDidSettle:(ShoppingCartOperationBar *)operationBar {
    if (self.operationBar.selectCount <= 0) {
        [Utils postMessage:@"请至少选择一个商品" onView:self.view];
        return;
    }
    
    self.goodListerArray = [[NSMutableArray alloc]init];
    for (CartGroupItem *groupItem in self.cartInfo.cartGoodsList) {
        for (CartGoodsModel *goods in groupItem.goodsList) {
            
            [self.goodListerArray safeAddObject:goods.goods_id];
            
        }
    }
    
    NSMutableArray * a = [NSMutableArray new];
    for (CartGoodsModel *goods  in [self currentSelectedCartGoods]) {
        [a addObject:goods.goods_id];
    }
    
    OrderOkViewController * vc = [OrderOkViewController new];
    vc.goodsArray = [self currentSelectedCartGoods];
    vc.oType = OrderTypeNormal;
    vc.timeValue = self.cartInfo.endtime.longLongValue;
    
    vc.parameter = [a componentsJoinedByString:@","];
    [self.navigationController pushViewController:vc animated:YES];

//    OrderConfirmViewController *vc = [[OrderConfirmViewController alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    vc.timeValue = self.timerValue;
//    vc.oType = OrderTypeNormal;
//    vc.parameter = [a componentsJoinedByString:@","];
//    vc.cartGoodsArray = [self currentSelectedCartGoods];
//    [self.navigationController pushViewController:vc animated:YES];
//    
//    [MobClick endEvent:kEventOrderSettle];
    
}

- (void)operationBarDidFaverate:(ShoppingCartOperationBar *)operationBar {
    if (self.operationBar.selectCount <= 0) {
        [Utils postMessage:@"请至少选择一个商品" onView:self.view];
        return;
    }
    
    NSArray *selectedGoodsArray = [self currentSelectedCartGoods];
    NSMutableArray *goodsIdArray = [[NSMutableArray alloc] initWithCapacity:selectedGoodsArray.count];
    for (CartGoodsModel *goods in selectedGoodsArray) {
        [goodsIdArray safeAddObject:goods.goods_id];
        
    }
     __weak typeof(self) wself = self;
    [ShopModel requestShopWithGoodsId:[goodsIdArray componentsJoinedByString:@","] type:0 superView:self.view finshBlock:^(id obj, NSError *error) {
         __strong typeof(wself) sself = wself;
        if (!error) {
             [Utils postMessage:@"收藏成功" onView:sself.view];
        }
    }];
}

- (void)operationBarDidDelete:(ShoppingCartOperationBar *)operationBar {
    
    if (self.operationBar.selectCount <= 0) {
        [Utils postMessage:@"请至少选择一个商品" onView:self.view];
        return;
    }
    
    [CartGoodsInfo requestDeletCarWithGoods:[self currentSelectedCartGoods] superView:self.view finshBlock:^(id obj, NSError *error) {
        if (!error) {
            [Utils postMessage:@"删除成功" onView:self.view];
            [_myTimers canceTime];
//            [self setNavigationTitleViewWithView:@"购物车" timerWithTimer:@""];
            [self getList];
        }
    }];

}

#pragma mark - Helper
- (CartGoodsModel *)cartGoodsAtIndexPath:(NSIndexPath *)indexPath {
    CartGroupItem *groupItem = [self.cartInfo.goods safeObjectAtIndex:indexPath.section];
    return [groupItem.list safeObjectAtIndex:indexPath.row];
}

- (NSMutableArray *)currentSelectedCartGoods {
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    for (CartGroupItem *groupItem in self.cartInfo.goods) {
        for (CartGoodsModel *goods in groupItem.list) {
            if ([goods isKindOfClass:[CartGoodsModel class]]) {
                BOOL selected = [self isCartGoodsSelected:goods];
                if (selected) {
                    [resultArray safeAddObject:goods];
                }
            }
        }
    }
    
    return resultArray;
}

- (BOOL)isCartGoodsSelected:(CartGoodsModel *)goodsModel {
    return [[self.selectDic safeObjectForKey:goodsModel.cart_id] boolValue];
}


#pragma mark - Layout
- (void)configLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@-45);
    }];
    
    [self.operationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(self.tableView.mas_bottom);
    }];
}

#pragma mark - Properties
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = DefaultBackgroundColor;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = NO;
        [_tableView registerClass:[ShoppingCartCell class] forCellReuseIdentifier:NSStringFromClass([ShoppingCartCell class])];
    }
    return _tableView;
}

- (ShoppingCartOperationBar *)operationBar {
    if (!_operationBar) {
        _operationBar = [[ShoppingCartOperationBar alloc] initWithFrame:CGRectZero];
        _operationBar.delegate = self;
    }
    return _operationBar;
}

- (NSMutableDictionary *)selectDic {
    if (!_selectDic) {
        NSDictionary *dic =[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"kShoppintCartSelectStatus"];
        if (dic) {
            _selectDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        } else {
            _selectDic = [[NSMutableDictionary alloc] init];
        }
    }
    return _selectDic;
}


- (void)refresh:(NSNotification *)noti{
    if ([noti.name isEqualToString:krefreshCartNotify]) {
        [self getList];
    }
}

#pragma mark ================== super =================
-(void)viewDidDisappear:(BOOL)animated{
//    UIView * tmpview =   [self setNavigationTitleViewWithView:@"购物车" timerWithTimer:0];
//    [tmpview removeAllSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getList];
    if (self.operationBar.edit) {
        [self.editButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//每次离开购物车时，保存选择状态到UD
    
    [[NSUserDefaults standardUserDefaults] setObject:self.selectDic forKey:@"kShoppintCartSelectStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
