//
//  OrderGoodsListViewController.m
//  Qqw
//
//  Created by zagger on 16/9/5.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "OrderGoodsListViewController.h"
#import "CartGoodsModel.h"
#import "OrderGoodsListCell.h"
#import "GoodsDetailViewController.h"

@interface OrderGoodsListViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray * okArray;
    NSMutableArray * noArray;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation OrderGoodsListViewController

- (id)initWithGoods:(NSArray *)goodsArray {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.dataArray = goodsArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品清单";
    
    okArray = [NSMutableArray new];
    noArray = [NSMutableArray new];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    
    for (CartGoodsModel *goodsModel  in self.dataArray) {
        if (goodsModel.is_limit) {
            [noArray addObject:goodsModel];
        }else{
            [okArray addObject:goodsModel];
        }
    }
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 28;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 28)];
    view.backgroundColor = RGB(248, 249, 250);
    
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 8, self.view.width, 20)];
    v.backgroundColor = [UIColor rgb:@"5cb531"];
    v.alpha = 0.3;
    [view addSubview:v];
    
    UILabel * l = [[UILabel alloc]initWithFrame:v.frame];
    l.text = @"因配送范围、库存原因导致失效的商品";
    l.textAlignment = NSTextAlignmentCenter;
    l.font = [UIFont systemFontOfSize:13];
    l.textColor = [UIColor blackColor];
    [view addSubview:l];
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _isLimit?2:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return  okArray.count;
    }
    return noArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderGoodsListCell *cell = (OrderGoodsListCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderGoodsListCell class])];
    if (indexPath.section==0) {
        CartGoodsModel *goodsModel = [okArray safeObjectAtIndex:indexPath.row];
        [cell refreshWithGoods:goodsModel];
    }else{
        CartGoodsModel *goodsModel = [noArray safeObjectAtIndex:indexPath.row];
        [cell refreshWithGoods:goodsModel];
        UIView * v = [cell viewWithTag:10000];
        if (v==nil) {
            v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 85)];
            v.backgroundColor = [UIColor blackColor];
            v.alpha = 0.5;
            v.tag = 10000;
            [cell addSubview:v];
        }
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CartGoodsModel *goodsModel = [self.dataArray safeObjectAtIndex:indexPath.row];
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] initWithGoodsIdentifier:goodsModel.goods_id];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Properties
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = DefaultBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[OrderGoodsListCell class] forCellReuseIdentifier:NSStringFromClass([OrderGoodsListCell class])];
    }
    return _tableView;
}

@end
